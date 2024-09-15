import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpResponse {
  final int code;
  final String? error;

  HttpResponse({required this.code, this.error});

  factory HttpResponse.fromJson(Map<String, dynamic> json) {
    return HttpResponse(
      code: json['code'],
      error: json['error'],
    );
  }
}

class LoginResponse {
  final int code;
  final String? accessToken;
  final String? error;

  LoginResponse({required this.code, this.accessToken, this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      accessToken: json['access_token'],
      error: json['error'],
    );
  }
}

class GetMeResponse {
  final int code;
  final String? cpf;
  final String? email;
  final String? nome;
  final String? error;

  GetMeResponse(
      {required this.code, this.cpf, this.email, this.nome, this.error});

  factory GetMeResponse.fromJson(Map<String, dynamic> json) {
    return GetMeResponse(
      code: json['code'],
      cpf: json['cpf'],
      email: json['email'],
      nome: json['nome'],
      error: json['error'],
    );
  }
}

class LoginRepository {
  Future<LoginResponse> login(String cpf, String senha) async {
    final response = await http.post(
      Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cpf': cpf,
        'senha': senha,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', responseData['access_token']);

      final getMeResponse = await getMe();

      if (getMeResponse.code != 200) {
        return LoginResponse.fromJson({
          'code': getMeResponse.code,
          'error': getMeResponse.error,
        });
      }

      return LoginResponse.fromJson({
        'code': response.statusCode,
        'access_token': responseData['access_token'],
      });
    } else {
      return LoginResponse.fromJson({
        'code': response.statusCode,
        'error': responseData['message'],
      });
    }
  }

  Future<GetMeResponse> getMe() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.get('access_token');

    final response = await http.get(
        Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        });

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cpf', responseData['cpf']);
      await prefs.setString('email', responseData['email']);
      await prefs.setString('nome', responseData['nome']);

      return GetMeResponse.fromJson({
        'code': response.statusCode,
        'cpf': responseData['cpf'],
        'email': responseData['email'],
        'nome': responseData['nome'],
      });
    } else {
      return GetMeResponse.fromJson({
        'code': response.statusCode,
        'error': responseData['message'],
      });
    }
  }

  Future<HttpResponse> signUp(
      String cpf, String nome, String email, String senha, String foto) async {
    final response = await http.post(
      Uri.parse(FlutterConfig.get('SRPG_API_BASE_URL') + '/usuario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cpf': cpf,
        'nome': nome,
        'email': email,
        'senha': senha,
        'foto': foto,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return HttpResponse.fromJson({
        'code': response.statusCode,
        'error': null,
      });
    } else {
      String errorMessage;
      if (responseData['message'] is List) {
        errorMessage = (responseData['message'] as List).join('\n');
      } else {
        errorMessage = responseData['message'] ?? 'Erro ao cadastrar usuário!';
      }

      return HttpResponse.fromJson({
        'code': response.statusCode,
        'error': errorMessage,
      });
    }
  }
}
