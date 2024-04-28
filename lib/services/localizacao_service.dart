import 'dart:math';

class Localizacao {
  final double latitude;
  final double longitude;
  final double elevacao;

  Localizacao(
      {required this.latitude,
      required this.longitude,
      required this.elevacao});
}

class LocalizacaoService {
  double calcularDistancia(Map<String, double> dadosLocalizacao1,
      Map<String, double> dadosLocalizacao2) {
    Localizacao localizacao1 = Localizacao(
      latitude: dadosLocalizacao1['latitude']!,
      longitude: dadosLocalizacao1['longitude']!,
      elevacao: dadosLocalizacao1['elevacao']!,
    );

    Localizacao localizacao2 = Localizacao(
      latitude: dadosLocalizacao2['latitude']!,
      longitude: dadosLocalizacao2['longitude']!,
      elevacao: dadosLocalizacao2['elevacao']!,
    );

    var p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 -
        c((localizacao2.latitude - localizacao1.latitude) * p) / 2 +
        c(localizacao1.latitude * p) *
            c(localizacao2.latitude * p) *
            (1 - c((localizacao2.longitude - localizacao1.longitude) * p)) /
            2;

    double distancia = 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km

    // Arredonda para 2 casas decimais e converte de volta para double
    return double.parse(distancia.toStringAsFixed(2));
  }
}
