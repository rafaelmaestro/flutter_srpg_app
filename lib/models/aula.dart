class Evento {
  String nome;
  StatusAula status;
  String descricao;
  DateTime dataInicio;
  DateTime dataFim;
  String local;
  double? latitude;
  double? longitude;
  String cpfOrganizador;
  List<String> convidados;

  Evento({
    required this.nome,
    required this.status,
    required this.descricao,
    this.latitude = 0.0,
    this.longitude = 0.0,
    List<String>? convidados, // Change the default value to a constant
    required this.dataInicio,
    required this.dataFim,
    required this.local,
    required this.cpfOrganizador,
  }) : convidados = convidados ?? [];

  adicionarConvidado(String email) {
    convidados.add(email);
  }
}

enum StatusAula {
  emAndamento,
  finalizado,
  pendente,
}
