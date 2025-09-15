package com.smartapp.backend.auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class GoogleTokenVerifier {

    // Inietta il Client ID dal file application.properties
    @Value("${google.oauth.client-id}")
    private String googleClientId;

    /**
     * Verifica il token ID di Google e restituisce i dettagli se valido.
     *
     * @param idTokenString il token ID ricevuto dal frontend.
     * @return un Optional contenente il payload del token, o vuoto se il token non è valido.
     */
    public Optional<GoogleIdToken.Payload> verify(String idTokenString) {
        try {
            // Costruisce il verificatore del token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            // Verifica il token. Se non è valido, `verify` restituisce null.
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                return Optional.of(idToken.getPayload());
            }
        } catch (Exception e) {
            // Logga l'errore in un'applicazione reale
            System.err.println("Errore durante la verifica del token Google: " + e.getMessage());
        }
        return Optional.empty();
    }
}