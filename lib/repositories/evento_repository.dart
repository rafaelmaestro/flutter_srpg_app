import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEventoFinalizadoPresentes {
  final List<Presenca> presentes;
  final List<String> ausentes;

  GetEventoFinalizadoPresentes({
    required this.presentes,
    required this.ausentes,
  });

  factory GetEventoFinalizadoPresentes.fromJson(Map<String, dynamic> json) {
    return GetEventoFinalizadoPresentes(
      presentes: List<Presenca>.from(
        json['presentes'].map((item) => Presenca.fromJson(item)),
      ),
      ausentes: List<String>.from(json['ausentes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presentes': presentes.map((item) => item.toJson()).toList(),
      'ausentes': ausentes,
    };
  }
}

class Presenca {
  final String email;
  final String permanencia;

  Presenca({
    required this.email,
    required this.permanencia,
  });

  factory Presenca.fromJson(Map<String, dynamic> json) {
    return Presenca(
      email: json['email'],
      permanencia: json['permanencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'permanencia': permanencia,
    };
  }
}

class Registro {
  final String id;
  final DateTime dtHoraCheckIn;
  final DateTime? dtHoraCheckOut;

  Registro({
    required this.id,
    required this.dtHoraCheckIn,
    this.dtHoraCheckOut,
  });

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      id: json['id'],
      dtHoraCheckIn: DateTime.parse(json['dt_hora_check_in']),
      dtHoraCheckOut: json['dt_hora_check_out'] != null
          ? DateTime.parse(json['dt_hora_check_out'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dt_hora_check_in': dtHoraCheckIn.toIso8601String(),
      'dt_hora_check_out': dtHoraCheckOut?.toIso8601String(),
    };
  }
}

class CriarEventoParams {
  final String nome;
  final String descricao;
  final String local;
  final String dtInicioPrevista;
  final String dtFimPrevista;
  final String cpfOrganizador;
  final int distanciaMaximaPermitida;
  final int minutosTolerancia;
  List<String> convidados;

  CriarEventoParams({
    required this.nome,
    required this.descricao,
    required this.local,
    required this.distanciaMaximaPermitida,
    required this.minutosTolerancia,
    required this.dtInicioPrevista,
    required this.dtFimPrevista,
    required this.cpfOrganizador,
    required this.convidados,
  });
}

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

class RealizarCheckInOuCheckOutResponse {
  final List<Registro> registros;

  RealizarCheckInOuCheckOutResponse({required this.registros});

  factory RealizarCheckInOuCheckOutResponse.fromJson(
      Map<String, dynamic> json) {
    var registrosJson = json['registros'] as List;
    List<Registro> registrosList =
        registrosJson.map((i) => Registro.fromJson(i)).toList();

    return RealizarCheckInOuCheckOutResponse(registros: registrosList);
  }

  Map<String, dynamic> toJson() {
    return {
      'registros': registros.map((registro) => registro.toJson()).toList(),
    };
  }
}

class EventoResponse {
  final int code;
  final String? error;
  final Evento evento;

  EventoResponse({
    required this.code,
    this.error,
    required this.evento,
  });

  factory EventoResponse.fromJson(Map<String, dynamic> json) {
    return EventoResponse(
      code: json['code'] ?? 200,
      error: json['error'] as String?,
      evento: Evento.fromJson(json['evento'] as Map<String, dynamic>),
    );
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
          ?.map((evento) => Evento.fromJson(evento as Map<String, dynamic>))
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

//TODO: refatorar para realizar paginação de verdade
  Future<List<Evento>> getEventosConvidadosEOrganizadosPendentesOuEmAndamento(
      String limite) async {
    final prefs = await SharedPreferences.getInstance();
    final cpf = prefs.get('cpf').toString();

    try {
      final response = await fetchEventos(
        eventosQueryParams: EventosQueryParams(
          pagina: '1',
          limite: limite,
          cpfConvidado: cpf,
          cpfOrganizador: cpf,
          status: 'PENDENTE, EM_ANDAMENTO, PAUSADO',
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

  Future<List<Evento>> getEventosFinalizados(String limite) async {
    final prefs = await SharedPreferences.getInstance();
    final cpf = prefs.get('cpf').toString();

    try {
      final response = await fetchEventos(
        eventosQueryParams: EventosQueryParams(
          pagina: '1',
          limite: limite,
          cpfConvidado: null,
          cpfOrganizador: cpf,
          status: 'FINALIZADO',
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

  Future<EventoResponse> criarEvento(
      {CriarEventoParams? criarEventoParams}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.get('access_token');
    final cpf = prefs.get('cpf').toString();

    final response = await http.post(
      Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        'nome': criarEventoParams?.nome ?? '',
        'descricao': criarEventoParams?.descricao ?? '',
        'distancia_maxima_permitida':
            criarEventoParams?.distanciaMaximaPermitida,
        'minutos_tolerancia': criarEventoParams?.minutosTolerancia,
        'local': criarEventoParams?.local ?? '',
        'dt_inicio_prevista': criarEventoParams?.dtInicioPrevista ?? '',
        'dt_fim_prevista': criarEventoParams?.dtFimPrevista ?? '',
        'cpf_organizador': cpf,
        'convidados': criarEventoParams?.convidados ?? [],
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return EventoResponse.fromJson(responseData);
    } else {
      return EventoResponse.fromJson({
        'code': response.statusCode,
        'error': responseData['message'],
      });
    }
  }

  Future<EventoResponse> getEvento(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final response = await http.get(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(responseData['message']);
      }

      return EventoResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<RealizarCheckInOuCheckOutResponse> realizarCheckIn(
      {required String idEvento,
      required String emailConvidado,
      double? porcentagemPresenca}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final response = await http.post(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') +
            '/evento/check-in/$idEvento'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'email_convidado': emailConvidado,
          'porcentagem_presenca': porcentagemPresenca,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw Exception(responseData['message']);
      }
      return RealizarCheckInOuCheckOutResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<RealizarCheckInOuCheckOutResponse> realizarCheckOut(
      {required String idEvento, required String emailConvidado}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final response = await http.post(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') +
            '/evento/check-out/$idEvento'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'email_convidado': emailConvidado,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw Exception(responseData['message']);
      }
      return RealizarCheckInOuCheckOutResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<RealizarCheckInOuCheckOutResponse> getRegistrosCheckIn(
      {required String idEvento, required String emailConvidado}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final uri = Uri.parse(
              FlutterConfig.get('SRPG_API_BASE_URL') + '/check-in/registros')
          .replace(
        queryParameters: {
          'id_evento': idEvento,
          'email_convidado': emailConvidado,
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

      if (response.statusCode != 200) {
        throw Exception(responseData['message']);
      }
      return RealizarCheckInOuCheckOutResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<EventoResponse> iniciarEvento(
      String idEvento, double latitude, double longitude) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final response = await http.patch(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento/$idEvento'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'status': 'EM_ANDAMENTO',
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(responseData['message']);
      }
      return EventoResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<GetEventoFinalizadoPresentes> getEventoFinalizadoPresentes(
      String idEvento) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final uri = Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') +
          '/evento/$idEvento/presentes');

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(responseData['message']);
      }
      return GetEventoFinalizadoPresentes.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<EventoResponse> atualizarStatusEvento(
      String idEvento, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final response = await http.patch(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/evento/$idEvento'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'status': status,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(responseData['message']);
      }
      return EventoResponse.fromJson(responseData);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> gerarRelatorio(String idEvento) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.get('access_token');

      final uri = Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') +
          '/evento/$idEvento/relatorio');

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw Exception(responseData['message']);
      }
    } catch (err) {
      rethrow;
    }
  }
}
