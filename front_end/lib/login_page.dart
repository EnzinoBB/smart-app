import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; // Assumendo che la home page sia in un file separato

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;

  // NOTA CRUCIALE PER LO SVILUPPO LOCALE!
  // L'emulatore Android non può usare 'localhost' o '127.0.0.1' per raggiungere il tuo PC.
  // Deve usare l'indirizzo IP speciale '10.0.2.2'.
  final String _apiUrl = 'http://localhost:8080/api/auth/login';

  Future<void> _login() async {
    // ... Logica per chiamare il backend ...
    // 1. Imposta _isLoading = true
    // 2. Prendi username e password dai controller
    // 3. Fai la chiamata http.post all'apiUrl
    // 4. Se la risposta è 200, naviga a HomePage
    // 5. Altrimenti, mostra un messaggio di errore (es. con uno SnackBar)
    // 6. Imposta _isLoading = false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
