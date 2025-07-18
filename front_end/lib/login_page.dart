import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; // Contiene HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final String _apiBaseUrl = 'http://localhost:8080'; // Per emulatore Android

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Inserisci qui il Client ID Web per l'esecuzione su web
    // clientId: 'IL_TUO_ID_CLIENT_WEB.apps.googleusercontent.com',
    scopes: ['email'],
  );

  // -- LOGICA PER IL LOGIN TRADIZIONALE --
  Future<void> _login() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _navigateToHome();
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorSnackbar(responseBody['message'] ?? 'Credenziali non valide');
      }
    } catch (e) {
      _showErrorSnackbar('Errore di connessione. Controlla il server.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // -- NUOVO: LOGICA PER IL LOGIN CON GOOGLE --
  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // L'utente ha annullato il popup
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        _showErrorSnackbar("Impossibile ottenere il token da Google.");
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      // Invia il token al nostro backend per la validazione
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/api/auth/google'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        // Il backend ha validato il token e ci ha loggato
        // In un'app reale, qui salveremmo il JWT ricevuto dal backend
        _navigateToHome();
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorSnackbar(
          responseBody['message'] ?? 'Errore durante la validazione del token.',
        );
        await _googleSignIn
            .signOut(); // Logout da Google in caso di errore del nostro backend
      }
    } catch (error) {
      _showErrorSnackbar("Errore durante l'accesso con Google.");
      print(error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showErrorSnackbar(String message) {
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                ElevatedButton(onPressed: _login, child: const Text('Login')),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: Image.asset(
                    'assets/images/google-logo.png',
                    height: 24.0,
                  ),
                  label: const Text('Accedi con Google'),
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
