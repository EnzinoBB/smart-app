import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:frontend/registration_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'google_button_web.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final String _apiBaseUrl =
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  // Logica completa per il login standard
  Future<void> _login() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // NOTA: Il backend non ha ancora un endpoint per il login standard che restituisce un JWT.
      // Questa è una chiamata fittizia per ora, che andrà aggiornata quando il backend sarà pronto.
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200 && mounted) {
        final responseBody = jsonDecode(response.body);
        // Quando il backend restituirà un token per il login standard, lo useremo qui.
        // Per ora, simuliamo il successo.
        final fakeJwtToken = responseBody['jwtToken'] ??
            'fake_token_for_${_usernameController.text}';
        await Provider.of<AuthService>(context, listen: false)
            .login(fakeJwtToken);
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorSnackbar(responseBody['message'] ?? 'Credenziali non valide');
      }
    } catch (e) {
      _showErrorSnackbar('Errore di connessione: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Logica completa per il login con Google su mobile
  Future<void> _signInWithGoogleMobile() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        await _sendTokenToBackend(idToken);
      } else {
        _showErrorSnackbar("Impossibile ottenere il token da Google.");
      }
    } catch (error) {
      _showErrorSnackbar("Errore durante l'accesso con Google.");
      print(error);
    } finally {
      // L'isLoading viene gestito dentro _sendTokenToBackend,
      // ma lo impostiamo a false qui per sicurezza in caso di errori prematuri.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Logica condivisa e completa per inviare il token al backend
  Future<void> _sendTokenToBackend(String idToken) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/api/auth/google'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200 && mounted) {
        final responseBody = jsonDecode(response.body);
        final jwtToken = responseBody['jwtToken'];
        await Provider.of<AuthService>(context, listen: false).login(jwtToken);
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorSnackbar(
            responseBody['message'] ?? 'Errore di validazione del token.');
        if (!kIsWeb) await GoogleSignIn().signOut();
      }
    } catch (e) {
      _showErrorSnackbar("Errore di connessione: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Wallet - Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username (Email)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator()))
              else ...[
                ElevatedButton(onPressed: _login, child: const Text('Login')),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                if (kIsWeb)
                  GoogleButtonWeb(onGoogleSignIn: _sendTokenToBackend)
                else
                  ElevatedButton.icon(
                    icon: Image.asset('assets/images/google-logo.png',
                        height: 24.0),
                    label: const Text('Accedi con Google'),
                    onPressed: _signInWithGoogleMobile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const RegistrationPage()),
                    );
                  },
                  child: const Text("Non hai un account? Registrati"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
