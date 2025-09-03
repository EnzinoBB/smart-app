// frontend/lib/config/app_config.dart

class AppConfig {
  // Legge la variabile GOOGLE_WEB_CLIENT_ID che abbiamo definito nel file .env.
  // La parola 'const' qui è importante per le performance.
  // String.fromEnvironment() è il modo in cui Flutter ci permette di leggere
  // i valori passati tramite --dart-define.
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        'CLIENT_ID_NON_TROVATO', // Un valore di default per evitare errori
  );
}
