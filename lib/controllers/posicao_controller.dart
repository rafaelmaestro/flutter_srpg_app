import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PosicaoController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = <Marker>{};
  bool loadEventosBool;
  late GoogleMapController _mapsController;
  Position? _currentPosition;

  PosicaoController({this.loadEventosBool = false}) {
    _iniciarStreamPosicao();
  }

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosicao();
    loadEventosBool == true ? loadAulas() : null;
    loadEventosBool == false ? addEventoMarker(LatLng(lat, long)) : null;
  }

  @override
  void dispose() {
    _mapsController.dispose();
    super.dispose();
  }

  void _updatePosition(Position position) {
    lat = position.latitude;
    long = position.longitude;
    notifyListeners();
  }

  loadAulas() async {
    try {
      final aulas = await EventoRepository().getAulas();

      aulas.forEach((aula) async {
        if (aula.latitude != null &&
            aula.longitude != null &&
            aula.status != 'FINALIZADO') {
          markers.add(Marker(
            markerId: MarkerId(aula.nome),
            position: LatLng(aula.latitude!, aula.longitude!),
            icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(), 'lib/assets/app/aulas_icon.png'),
            onTap: () => {
              showModalBottomSheet(
                  context: Get.context!,
                  builder: (context) => EventoCheckInBottomSheet(evento: aula))
            },
          ));
        }
      });

      notifyListeners();
    } catch (err) {
      Get.snackbar(
        'Falha ao buscar seus eventos! 😢',
        'Por favor, tente novamente mais tarde.\nCaso o erro persista, entre em contato com o suporte em 📞 4002-8922 e informe o seguinte código: \n\n${err.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        isDismissible: true,
      );
      return;
    }
  }

  addEventoMarker(LatLng posicao) async {
    final marker = Marker(markerId: const MarkerId('1'), position: posicao);

    if (markers.isNotEmpty) markers.clear();

    markers.add(marker);

    notifyListeners();
  }

  getPosicao() async {
    try {
      _currentPosition = await _posicaoAtual();
      lat = _currentPosition!.latitude;
      long = _currentPosition!.longitude;
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

  void _iniciarStreamPosicao() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      // Notifique o usuário para habilitar a localização
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

    // Obter a posição inicial
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updatePosition(position);

    // Configurar o fluxo de posição
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Atualiza a cada 10 metros
      ),
    ).listen((Position position) {
      _currentPosition = position;

      lat = _currentPosition!.latitude;
      long = _currentPosition!.longitude;

      print('---------------- ATUALIZOU A POSIÇÃO ----------------');
      print('Latitude: $lat');
      print('Longitude: $long');
      print('-----------------------------------------------------');

      if (lat != 0.0 && long != 0.0) {
        _updatePosition(position);

        try {
          _mapsController.animateCamera(
            CameraUpdate.newLatLng(LatLng(lat, long)),
          ); // Atualiza a câmera do mapa conforme atualiza a posição
        } catch (err) {
          print('Erro ao atualizar a câmera do mapa: $err');
        }
      }
    });
  }
}
