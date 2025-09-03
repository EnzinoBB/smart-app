import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop' as js;
import 'dart:ui_web' as ui_web;
import 'package:frontend/config/app_config.dart'; // Importa la nostra classe di configurazione

// --- La sezione delle interfacce JS non cambia ---
@js.JS('google.accounts.id')
@js.staticInterop
class _GoogleAccountsId {}

extension on _GoogleAccountsId {
  external void initialize(_GoogleIdConfiguration config);
  external void renderButton(
    web.HTMLElement parent,
    _RenderButtonOptions options,
  );
}

@js.JS()
@js.staticInterop
@js.anonymous
class _GoogleIdConfiguration {
  external factory _GoogleIdConfiguration({
    required js.JSString client_id,
    required js.JSFunction callback,
  });
}

@js.JS()
@js.staticInterop
class CredentialResponse {}

extension on CredentialResponse {
  @js.JS('credential')
  external js.JSString get credential;
}

@js.JS()
@js.staticInterop
@js.anonymous
class _RenderButtonOptions {
  external factory _RenderButtonOptions({
    required js.JSString theme,
    required js.JSString size,
    required js.JSString width,
  });
}

@js.JS('google.accounts')
@js.staticInterop
class _GoogleAccounts {}

extension on _GoogleAccounts {
  @js.JS('id')
  external _GoogleAccountsId get id;
}

@js.JS('google')
@js.staticInterop
class _Google {}

extension on _Google {
  @js.JS('accounts')
  external _GoogleAccounts get accounts;
}

extension on web.Window {
  @js.JS('google')
  external _Google get google;
}

// --- Widget Flutter con la logica corretta ---
class GoogleButtonWeb extends StatefulWidget {
  final Function(String idToken) onGoogleSignIn;
  const GoogleButtonWeb({super.key, required this.onGoogleSignIn});

  @override
  State<GoogleButtonWeb> createState() => _GoogleButtonWebState();
}

class _GoogleButtonWebState extends State<GoogleButtonWeb> {
  final String _viewId =
      'google-signin-button-${DateTime.now().millisecondsSinceEpoch}';

  // NUOVO: Flag per tracciare lo stato di inizializzazione.
  bool _isGoogleButtonInitialized = false;

  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      return web.HTMLDivElement()
        ..id = _viewId
        ..style.height = '100%'
        ..style.width = '100%';
    });
  }

  @js.JSExport()
  void _onCredentialResponse(CredentialResponse response) {
    final String idToken = response.credential.toDart;
    widget.onGoogleSignIn(idToken);
  }

  @override
  Widget build(BuildContext context) {
    // Usiamo ancora addPostFrameCallback per essere sicuri che il widget sia nel DOM.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Eseguiamo l'inizializzazione solo se non è già stata fatta.
      if (!_isGoogleButtonInitialized) {
        try {
          final gId = web.window.google.accounts.id;

          final config = _GoogleIdConfiguration(
            client_id: AppConfig.googleWebClientId.toJS,
            callback: _onCredentialResponse.toJS,
          );
          gId.initialize(config);

          final parent = web.document.getElementById(_viewId);
          if (parent != null) {
            final renderOptions = _RenderButtonOptions(
              theme: 'outline'.toJS,
              size: 'large'.toJS,
              width: '250'.toJS,
            );
            gId.renderButton(parent as web.HTMLElement, renderOptions);

            // Impostiamo il flag a true per non ripetere l'operazione.
            setState(() {
              _isGoogleButtonInitialized = true;
            });
          }
        } catch (e) {
          // Se c'è un errore (es. `google` non è ancora definito),
          // lo vedremo nella console del browser.
          print("Errore durante l'inizializzazione del pulsante Google: $e");
        }
      }
    });

    return SizedBox(
      height: 50,
      width: 250,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}
