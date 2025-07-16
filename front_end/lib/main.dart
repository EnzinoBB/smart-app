// Importa il pacchetto principale di Flutter per i widget Material Design.
import 'package:flutter/material.dart';
import 'login_page.dart';

// Il punto di ingresso principale dell'applicazione.
void main() {
  // Avvia l'app Flutter eseguendo la classe MyApp.
  runApp(const MyApp());
}

// MyApp è il widget radice dell'intera applicazione.
class MyApp extends StatelessWidget {
  // Costruttore per il widget MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp è il widget che imposta le basi per un'app Material Design.
    return MaterialApp(
      // Rimuoviamo il banner "DEBUG" in alto a destra.
      debugShowCheckedModeBanner: false,
      title: 'Smart Wallet',
      theme: ThemeData(
        // Definiamo il tema dell'app, partendo da un colore base.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // Abilitiamo Material 3 per un look & feel moderno.
        useMaterial3: true,
      ),
      // La schermata iniziale (home) della nostra app sarà HomePage.
      home: const LoginPage(), // Sostituisci HomePage con LoginPage
    );
  }
}
