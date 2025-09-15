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

// Aggiungiamo 'with SingleTickerProviderStateMixin' per le animazioni
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final String _apiBaseUrl =
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  // --- IMPOSTAZIONE ANIMAZIONI ---
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Inizializziamo il controller per l'animazione
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Creiamo un'animazione di dissolvenza
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Creiamo un'animazione di scorrimento dal basso verso l'alto
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Avviamo l'animazione
    _animationController.forward();
  }

  @override
  void dispose() {
    // Rilasciamo le risorse del controller quando il widget viene eliminato
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // --- FINE IMPOSTAZIONE ANIMAZIONI ---

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
      // Usiamo un colore di sfondo per un look più pulito
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            // Applichiamo le animazioni a tutto il contenuto della colonna
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 400), // Larghezza massima del form
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.wallet_rounded,
                          size: 80, color: Colors.blue),
                      const SizedBox(height: 20),
                      Text('Welcome to Smart App',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Sign in to continue',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600])),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const Center(
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator()))
                      else ...[
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text('LOGIN',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('OR')),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- CORREZIONE: Pulsante Google centrato ---
                        if (kIsWeb)
                          // Avvolgiamo il pulsante web in un Center
                          Center(
                              child: GoogleButtonWeb(
                                  onGoogleSignIn: _sendTokenToBackend))
                        else
                          ElevatedButton.icon(
                            icon: Image.asset('assets/images/google-logo.png',
                                height: 22.0),
                            label: const Text('Sign in with Google'),
                            onPressed: _signInWithGoogleMobile,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey[300]!)),
                            ),
                          ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        const RegistrationPage()));
                              },
                              child: const Text("Sign Up"),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
