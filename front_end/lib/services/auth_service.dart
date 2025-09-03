import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _apiBaseUrl =
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  // Cerca di fare il login automatico all'avvio dell'app
  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      _token = token;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  // Metodo per la registrazione standard
  Future<String> register(
      String name, String surname, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody['message'];
    } else {
      throw Exception(
          responseBody['message'] ?? 'Errore durante la registrazione.');
    }
  }

  // Metodo per il login (sia standard che Google)
  Future<void> login(String jwtToken) async {
    _token = jwtToken;
    _isAuthenticated = true;
    await _storage.write(key: 'jwt_token', value: jwtToken);
    notifyListeners();
  }

  // Metodo per il logout
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }
}
