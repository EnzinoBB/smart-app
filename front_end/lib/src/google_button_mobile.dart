import 'package:flutter/material.dart';

// Questo è un widget segnaposto che non fa nulla.
// Viene usato quando l'app non è in esecuzione sul web.
class GoogleButtonWeb extends StatelessWidget {
  final Function(String idToken) onGoogleSignIn;

  const GoogleButtonWeb({super.key, required this.onGoogleSignIn});

  @override
  Widget build(BuildContext context) {
    // Su mobile, non dobbiamo mostrare nulla, quindi restituiamo un widget vuoto.
    return const SizedBox.shrink();
  }
}
