import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventosQueryParams {
  final String pagina;
  final String limite;
  final String? cpfConvidado;
  final String? cpfOrganizador;

  EventosQueryParams(
      {required this.pagina,
      required this.limite,
      this.cpfConvidado,
      this.cpfOrganizador});
}

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
  Future<EventosResponse> fetchEventos(
      {EventosQueryParams? eventosQueryParams}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.get('access_token');
    final uri =
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento').replace(
      queryParameters: {
        'pagina': eventosQueryParams?.pagina.toString(),
        'limite': eventosQueryParams?.limite.toString(),
        if (eventosQueryParams?.cpfConvidado != null)
          'cpfConvidado': eventosQueryParams?.cpfConvidado,
        if (eventosQueryParams?.cpfOrganizador != null)
          'cpfOrganizador': eventosQueryParams?.cpfOrganizador,
      },
    );

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

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
    final response = await fetchEventos(
      eventosQueryParams: EventosQueryParams(
        pagina: '1',
        limite: '10',
        cpfConvidado: cpf,
      ),
    );

    if (response.code != 200) {
      Get.snackbar('Erro', response.error!);
      return [];
    }

    return response.eventos ?? [];
  }

  Future<List<Evento>> getEventosConvidadosEOrganizados() async {
    // TODO: aqui não está buscando certo, está retornando todos os eventos
    final prefs = await SharedPreferences.getInstance();
    final cpf = prefs.get('cpf').toString();

    final response = await fetchEventos(
      eventosQueryParams: EventosQueryParams(
        pagina: '1',
        limite: '10',
        cpfConvidado: cpf,
        cpfOrganizador: cpf,
      ),
    );

    if (response.code != 200) {
      Get.snackbar('Erro', response.error!);
      return [];
    }

    return response.eventos ?? [];
  }

  Future<List<Evento>> getAulas() async => await getEventosConvidado();
}
