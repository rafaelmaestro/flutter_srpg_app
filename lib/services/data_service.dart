class DataService {
  String calcularDuracaoEventoEmHoras(
      DateTime dtInicio, DateTime dataParametro) {
    int horas = dataParametro.difference(dtInicio).inHours;

    if (horas == 0) {
      return 'Este evento iniciou há menos de 1 hora.';
    } else if (horas == 1) {
      return 'Este evento iniciou há 1 hora.';
    } else if (horas >= 24) {
      return 'Este evento iniciou há ${horas ~/ 24} dias.';
    } else {
      return 'Este evento iniciou há $horas horas.';
    }
  }

  String calcularTerminoEventoEmHoras(DateTime dtFim, DateTime dataParametro) {
    int horas = dataParametro.difference(dtFim).inHours;

    if (horas == 0) {
      return 'Este evento terminará em menos de 1 hora.';
    } else if (horas * -1 == 1) {
      return 'Este evento terminará em 1 hora.';
    } else if (horas > 0) {
      return 'Este evento terminará em (...) horas.';
    } else if (horas * -1 >= 24) {
      return 'Este evento terminará em ${horas * -1 ~/ 24} dias.';
    } else {
      return 'Este evento terminará em ${horas * -1} horas.';
    }
  }
}
