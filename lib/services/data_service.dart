class DataService {
  String calcularDuracaoEventoEmHoras(
      DateTime dataInicio, DateTime dataParametro) {
    int horas = dataParametro.difference(dataInicio).inHours;

    if (horas == 0) {
      return 'Este evento iniciou há menos de 1 hora.';
    } else if (horas == 1) {
      return 'Este evento iniciou há 1 hora.';
    } else {
      return 'Este evento iniciou há $horas horas.';
    }
  }
}
