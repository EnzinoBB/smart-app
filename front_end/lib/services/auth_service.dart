import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _apiBaseUrl =
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  AuthService() {
    // Inizializziamo il plugin di Google Sign-In SOLO se non siamo sul web.
    if (!kIsWeb) {
      _initializeGoogleSignIn();
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Errore durante l-inizializzazione di Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!kIsWeb && !_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<void> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        await sendGoogleTokenToBackend(idToken);
      } else {
        throw Exception("Impossibile ottenere l'idToken da Google.");
      }
    } on GoogleSignInException catch (e) {
      print('GoogleSignInException: ${e.code.name} - ${e.description}');
      throw Exception(
          'Si è verificato un errore durante l-accesso con Google.');
    } catch (e) {
      print('Errore imprevisto in signInWithGoogle: $e');
      throw Exception(e.toString());
    }
  }

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      _token = token;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

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

  Future<void> login(String jwtToken) async {
    _token = jwtToken;
    _isAuthenticated = true;
    await _storage.write(key: 'jwt_token', value: jwtToken);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'jwt_token');

    if (!kIsWeb && _isGoogleSignInInitialized) {
      await _googleSignIn.signOut();
    }

    notifyListeners();
  }

  Future<void> sendGoogleTokenToBackend(String idToken) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/api/auth/google'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final jwtToken = responseBody['jwtToken'];
      if (jwtToken != null) {
        await login(jwtToken);
      } else {
        throw Exception('Il token JWT non è stato ricevuto dal backend.');
      }
    } else {
      final responseBody = jsonDecode(response.body);
      if (!kIsWeb) await _googleSignIn.signOut();
      throw Exception(responseBody['message'] ??
          'Errore di validazione del token da parte del backend.');
    }
  }
}
