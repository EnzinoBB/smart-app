import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Necessario per codificare i dati in JSON
import 'home_page.dart'; // Importiamo il file che contiene HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // NOTA: '10.0.2.2' è l'IP speciale per raggiungere il localhost del tuo PC
  // dall'emulatore Android. Se esegui l'app sul web, dovrai usare 'localhost'.
  final String _apiUrl = 'http://localhost:8080/api/auth/login';

  Future<void> _login() async {
    // Se stiamo già caricando, non fare nulla
    if (_isLoading) return;

    // 1. Mostra l'indicatore di caricamento
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Prepara la richiesta HTTP
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Codifica i dati dei TextField in un corpo JSON
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      // 3. Controlla la risposta del server
      if (response.statusCode == 200) {
        // Successo! Naviga alla HomePage
        // Usiamo pushReplacement per non permettere all'utente di tornare alla login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Fallimento (es. 401 Unauthorized)
        // Mostra un messaggio di errore
        final responseBody = jsonDecode(response.body);
        _showErrorSnackbar(responseBody['message'] ?? 'Credenziali non valide');
      }
    } catch (e) {
      // Errore di connessione o altro
      print('Errore durante il login: $e');
      _showErrorSnackbar(
        'Errore di connessione. Controlla il server e la rete.',
      );
    } finally {
      // 4. Nascondi l'indicatore di caricamento, in ogni caso
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
