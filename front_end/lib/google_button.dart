// Questo file agisce come un "ponte".
// Esporta il file corretto in base alla piattaforma.

export 'src/google_button_mobile.dart' // Esporta lo stub di default
    if (dart.library.js_interop) 'src/google_button_web.dart'; // Se la libreria JS è disponibile (cioè sul web), esporta invece l'implementazione web.
