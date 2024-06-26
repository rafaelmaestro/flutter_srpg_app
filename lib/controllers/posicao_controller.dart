import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PosicaoController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = <Marker>{};
  bool loadAulasBool;
  late GoogleMapController _mapsController;

  PosicaoController({this.loadAulasBool = false});

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosicao();
    loadAulasBool == true ? loadAulas() : null;
    loadAulasBool == false ? addEventoMarker(LatLng(lat, long)) : null;
  }

  loadAulas() {
    final aulas = EventoRepository().aulas;
    aulas.forEach((aula) async {
      if (aula.latitude != 0.0 && aula.longitude != 0.0) {
        markers.add(Marker(
          markerId: MarkerId(aula.nome),
          position: LatLng(aula.latitude!, aula.longitude!),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), 'lib/assets/app/aulas_icon.png'),
          onTap: () => {
            showModalBottomSheet(
                context: appKey.currentState!.context,
                builder: (context) => EventoCheckInBottomSheet(aula: aula))
          },
        ));
      }
    });

    notifyListeners();
  }

  addEventoMarker(LatLng posicao) async {
    final marker = Marker(markerId: const MarkerId('1'), position: posicao);

    if (markers.isNotEmpty) markers.clear();

    markers.add(marker);

    notifyListeners();
  }

  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      erro = e.toString();
    }

    notifyListeners();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização no dispositivo');
    }

    permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error(
            'Não foi possível obter a permissão para acessar a localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error(
          'A permissão para acessar a localização foi negada permanentemente, por favor, habilite a localização manualmente');
    }

    var currentLocation = await Geolocator.getCurrentPosition();
    return currentLocation;
  }
}
