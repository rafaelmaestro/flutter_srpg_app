import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final eventosMock = [
//   {
//     'organizador': true,
//     'nome': 'Aula de Gestão de TI',
//     'status': StatusAula.pendente,
//     'convidados': ['rafael.maestro@unesp.br'],
//     'descricao': 'Turma 0004729A / 19h - 23h',
//     'latitude': -22.350808540575265,
//     'longitude': -49.03217930003996,
//     'dtInicio': DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0),
//     'dtFim': DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 0),
//     'local': 'Bloco A - Sala 4',
//     'cpfOrganizador': '12345678909',
//   },
//   {
//     'organizador': false,
//     'nome': 'Aula de Engenharia de Software',
//     'status': StatusAula.emAndamento,
//     'convidados': ['rafael.maestro@unesp.br'],
//     'descricao': 'Turma 0004729A / 19h - 23h',
//     'latitude': -22.350808540575270,
//     'longitude': -49.03217930003903,
//     'dtInicio': DateTime.now().subtract(const Duration(hours: 2)),
//     'dtFim': DateTime.now().add(const Duration(hours: 4)),
//     'local': 'Bloco A - Sala 5',
//     'cpfOrganizador': '12345678909',
//   }
// ];

class EventosResponse {
  final int code;
  final String? error;
  final List<Evento>? eventos;

  EventosResponse({
    required this.code,
    this.error,
    this.eventos,
  });

  factory EventosResponse.fromJson(Map<String, dynamic> json) {
    return EventosResponse(
      code: json['code'] ?? 200,
      error: json['error'] as String?,
      eventos: (json['eventos'] as List<dynamic>?)
          ?.expand((e) => (e as List<dynamic>)
              .map((evento) => Evento.fromJson(evento as Map<String, dynamic>)))
          .toList(),
    );
  }
}

class EventoRepository extends ChangeNotifier {
  // requisição para o backend para obter as aulas paginadas
  // final List<Evento> _eventos = [
  //   Evento(
  //     nome: 'Aula de Gestão de TI',
  //     status: StatusAula.emAndamento,
  //     convidados: ['rafael.maestro@unesp.br'],
  //     descricao: 'Turma 0004729A / 19h - 23h',
  //     latitude: -22.350808540575265,
  //     longitude: -49.03217930003996,
  //     dtInicio: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0),
  //     dtFim: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 0),
  //     local: 'Bloco A - Sala 4',
  //     cpfOrganizador: '12345678909',
  //   )
  // ];

  //   Future<LoginResponse> login(String cpf, String senha) async {
  //   final response = await http.post(
  //     Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/auth/login'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'cpf': cpf,
  //       'senha': senha,
  //     }),
  //   );

  //   final responseData = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('access_token', responseData['access_token']);

  //     final getMeResponse = await getMe();

  //     if (getMeResponse.code != 200) {
  //       return LoginResponse.fromJson({
  //         'code': getMeResponse.code,
  //         'error': getMeResponse.error,
  //       });
  //     }

  //     return LoginResponse.fromJson({
  //       'code': response.statusCode,
  //       'access_token': responseData['access_token'],
  //     });
  //   } else {
  //     return LoginResponse.fromJson({
  //       'code': response.statusCode,
  //       'error': responseData['message'],
  //     });
  //   }
  // }

  Future<EventosResponse> fetchEventos(
      int pagina, int limite, String cpf) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.get('access_token');
    final uri =
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento').replace(
      queryParameters: {
        'pagina': pagina.toString(),
        'limite': limite.toString(),
        'cpf_convidado': cpf,
      },
    );

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Adiciona um print para depurar a resposta
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return EventosResponse.fromJson(responseData);
    } else {
      return EventosResponse.fromJson({
        'code': response.statusCode,
        'error': responseData['message'],
      });
    }
  }

  Future<List<Evento>> getEventosConvidado() async {
    final prefs = await SharedPreferences.getInstance();
    final cpf = prefs.get('cpf').toString();
    final response = await fetchEventos(1, 10, cpf);

    if (response.code != 200) {
      Get.snackbar('Erro', response.error!);
      return [];
    }

    print('AQUI É O RESPONSE DO FETCH EVENTOS');
    print(response.code);
    print(response.eventos![0].nome);
    print(response.eventos![0].id);
    print(response.eventos![0].longitude);
    print(response.eventos![0].latitude);

    return response.eventos ?? [];
  }

  getEventosConvidadosEOrganizados(int pagina, int limite, String? filtro) {
    // TODO: lógica para obter as aulas de forma paginada
    return [
      Evento(
          id: 'sasasa',
          nome: 'asasasa',
          status: 'asasas',
          descricao: 'asasasa',
          dataHora: DateTime.now(),
          local: 'local',
          cpfOrganizador: '23232323232',
          dtCriacao: DateTime.now(),
          dtUltAtualizacao: DateTime.now(),
          convidados: Convidados(total: 1, emails: ['asasasa']),
          checkIns: CheckIns(total: 1, emails: ['asasasa']),
          checkOuts: CheckOuts(total: 1, emails: ['asasasa'])),
    ];
  }

  Future<List<Evento>> getAulas() async => await getEventosConvidado();
}
