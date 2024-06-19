import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/aula.dart';

final eventosMock = [
  {
    'organizador': true,
    'nome': 'Aula de Gestão de TI',
    'status': StatusAula.emAndamento,
    'convidados': ['rafael.maestro@unesp.br'],
    'descricao': 'Turma 0004729A / 19h - 23h',
    'latitude': -22.350808540575265,
    'longitude': -49.03217930003996,
    'dataInicio': DateTime.now().subtract(const Duration(hours: 2)),
    'dataFim': DateTime.now().add(const Duration(hours: 4)),
    'local': 'Bloco A - Sala 4',
    'cpfOrganizador': '12345678909',
  },
  {
    'organizador': false,
    'nome': 'Aula de Engenharia de Software',
    'status': StatusAula.emAndamento,
    'convidados': ['rafael.maestro@unesp.br'],
    'descricao': 'Turma 0004729A / 19h - 23h',
    'latitude': -22.350808540575270,
    'longitude': -49.03217930003903,
    'dataInicio': DateTime.now().subtract(const Duration(hours: 2)),
    'dataFim': DateTime.now().add(const Duration(hours: 4)),
    'local': 'Bloco A - Sala 5',
    'cpfOrganizador': '12345678909',
  }
];

class EventoRepository extends ChangeNotifier {
  // requisição para o backend para obter as aulas paginadas
  final List<Evento> _eventos = [
    Evento(
      nome: 'Aula de Gestão de TI',
      status: StatusAula.emAndamento,
      convidados: ['rafael.maestro@unesp.br'],
      descricao: 'Turma 0004729A / 19h - 23h',
      latitude: -22.350808540575265,
      longitude: -49.03217930003996,
      dataInicio: DateTime.now().subtract(const Duration(hours: 4)),
      dataFim: DateTime.now().add(const Duration(hours: 4)),
      local: 'Bloco A - Sala 4',
      cpfOrganizador: '12345678909',
    )
  ];

  getEventosConvidadosEOrganizados(int pagina, int limite, String? filtro) {
    // TODO: lógica para obter as aulas de forma paginada
    return eventosMock;
  }

  List<Evento> get aulas => _eventos;
}
