import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiController {
  // URL base do seu backend
  static const String baseUrl = "https://trabalho-integracao-sistemas.vercel.app";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['sessionToken'];

      // Salva o token de forma segura
      await _storage.write(key: 'auth_token', value: token);

      return true;
    } else {
      print("Erro de login: ${response.body}");
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return true;
    } else {
      print("Erro de cadastro: ${response.body}");
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  
  Future<http.Response> logout() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json',if (token != null) 'Authorization': 'Bearer $token'},
    );
    await _storage.delete(key: 'auth_token');
    return response;
  }

  Future<http.Response> getPontosColeta() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/pontos-coleta'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> getTurnosColeta() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/turnos-coleta'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<Map<String, dynamic>?> getAirQuality(double lat, double lon) async {
    final url =
        Uri.parse('https://api.openaq.org/v2/latest?coordinates=$lat,$lon');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Erro ao buscar qualidade do ar: ${response.body}");
      return null;
    }
  }
}
