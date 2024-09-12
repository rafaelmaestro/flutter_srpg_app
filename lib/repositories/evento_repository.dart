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
  final String? nome;
  final String? status;

  EventosQueryParams(
      {required this.pagina,
      required this.limite,
      this.cpfConvidado,
      this.cpfOrganizador,
      this.nome,
      this.status});

  Map<String, String> toMap() {
    final Map<String, String> params = {
      'pagina': pagina,
      'limite': limite,
    };

    if (cpfConvidado != null) {
      params['cpf_convidado'] = cpfConvidado!;
    }

    if (cpfOrganizador != null) {
      params['cpf_organizador'] = cpfOrganizador!;
    }

    if (nome != null) {
      params['nome'] = nome!;
    }

    if (status != null) {
      params['status'] = status!;
    }

    return params;
  }
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
    final queryParams = eventosQueryParams?.toMap();

    final uri =
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento').replace(
      queryParameters: queryParams,
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
    try {
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
        throw Exception(response.error);
      }

      return response.eventos ?? [];
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Evento>>
      getEventosConvidadosEOrganizadosPendentesOuEmAndamento() async {
    final prefs = await SharedPreferences.getInstance();
    final cpf = prefs.get('cpf').toString();

    try {
      final response = await fetchEventos(
        eventosQueryParams: EventosQueryParams(
          pagina: '1',
          limite: '10',
          cpfConvidado: cpf,
          cpfOrganizador: cpf,
          status: 'PENDENTE, EM_ANDAMENTO',
        ),
      );

      if (response.code != 200) {
        throw Exception(response.error);
      }

      return response.eventos ?? [];
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Evento>> getAulas() async {
    try {
      return await getEventosConvidado();
    } catch (err) {
      rethrow;
    }
  }
}
