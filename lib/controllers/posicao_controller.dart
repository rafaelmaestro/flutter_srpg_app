import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/repositories/postos_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PosicaoController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = <Marker>{};
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadAulas();
  }

  loadAulas() {
    final aulas = AulasRepository().aulas;
    aulas.forEach((aula) async {
      markers.add(Marker(
        markerId: MarkerId(aula.nome),
        position: LatLng(aula.latitude, aula.longitude),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'lib/assets/app/aulas_icon.png'),
        onTap: () => {},
        infoWindow: InfoWindow(
          title: aula.nome,
          snippet: aula.descricao,
        ),
      ));
    });

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
