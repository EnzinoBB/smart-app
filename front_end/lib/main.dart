import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Il ChangeNotifierProvider rende l'AuthService disponibile in tutta l'app
    return ChangeNotifierProvider(
      create: (ctx) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// Questo widget funge da "guardia". Controlla lo stato di autenticazione
// e mostra la pagina di login o la home page di conseguenza.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // All'avvio, chiediamo all'AuthService di provare un login automatico
    Provider.of<AuthService>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    // Il Consumer ascolta le notifiche dell'AuthService e si ricostruisce
    // quando lo stato di autenticazione cambia (login/logout).
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isAuthenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
