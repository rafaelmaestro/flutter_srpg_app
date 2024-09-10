class Evento {
  final String id;
  final String nome;
  final String status;
  final String descricao;
  final DateTime dataHora;
  final DateTime? dtInicio;
  final DateTime? dtFim;
  final double? latitude;
  final double? longitude;
  final String local;
  final String cpfOrganizador;
  final DateTime dtCriacao;
  final DateTime dtUltAtualizacao;
  final Convidados convidados;
  final CheckIns checkIns;
  final CheckOuts checkOuts;

  Evento({
    required this.id,
    required this.nome,
    required this.status,
    required this.descricao,
    required this.dataHora,
    this.dtInicio,
    this.dtFim,
    this.latitude,
    this.longitude,
    required this.local,
    required this.cpfOrganizador,
    required this.dtCriacao,
    required this.dtUltAtualizacao,
    required this.convidados,
    required this.checkIns,
    required this.checkOuts,
  });

  adicionarConvidado(String email) {
    convidados.emails.add(email);
    convidados.total++;
  }

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nome: json['nome'],
      status: json['status'],
      descricao: json['descricao'],
      dataHora: DateTime.parse(json['data_hora']),
      local: json['local'],
      latitude:
          json['latitude'] != null ? double.tryParse(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? double.tryParse(json['longitude']) : null,
      cpfOrganizador: json['cpf_organizador'],
      dtCriacao: DateTime.parse(json['dt_criacao']),
      dtUltAtualizacao: DateTime.parse(json['dt_ult_atualizacao']),
      convidados: Convidados.fromJson(json['convidados']),
      checkIns: CheckIns.fromJson(json['check_ins']),
      checkOuts: CheckOuts.fromJson(json['check_outs']),
    );
  }
}

class Convidados {
  var total;
  final List<String> emails;

  Convidados({
    required this.total,
    required this.emails,
  });

  factory Convidados.fromJson(Map<String, dynamic> json) {
    return Convidados(
      total: json['total'],
      emails: List<String>.from(json['emails']),
    );
  }
}

class CheckIns {
  final int total;
  final List<String> emails;

  CheckIns({
    required this.total,
    required this.emails,
  });

  factory CheckIns.fromJson(Map<String, dynamic> json) {
    return CheckIns(
      total: json['total'],
      emails: List<String>.from(json['emails']),
    );
  }
}

class CheckOuts {
  final int total;
  final List<String> emails;

  CheckOuts({
    required this.total,
    required this.emails,
  });

  factory CheckOuts.fromJson(Map<String, dynamic> json) {
    return CheckOuts(
      total: json['total'],
      emails: List<String>.from(json['emails']),
    );
  }
}

class Paginacao {
  final int pagina;
  final int limite;
  final int total;

  Paginacao({
    required this.pagina,
    required this.limite,
    required this.total,
  });

  factory Paginacao.fromJson(Map<String, dynamic> json) {
    return Paginacao(
      pagina: json['pagina'],
      limite: json['limite'],
      total: json['total'],
    );
  }
}
