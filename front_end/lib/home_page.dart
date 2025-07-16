// Importa il pacchetto principale di Flutter per i widget Material Design.
import 'package:flutter/material.dart';

// HomePage è la prima schermata che l'utente vedrà.
class HomePage extends StatelessWidget {
  // Costruttore per il widget HomePage.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold fornisce la struttura base per una schermata (app bar, body, etc.).
    return Scaffold(
      appBar: AppBar(
        // La barra in alto nell'applicazione.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Smart Wallet'),
      ),
      body: const Center(
        // Centra il suo contenuto (un widget Text) sia verticalmente che orizzontalmente.
        child: Text(
          'Benvenuto in Smart Wallet!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
