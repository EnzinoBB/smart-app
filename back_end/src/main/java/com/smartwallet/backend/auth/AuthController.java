package com.smartwallet.backend.auth;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.smartwallet.backend.model.LoginRequest;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    // Per questo primo test, usiamo credenziali hardcoded.
    // In seguito, questa logica interrogherà il database.
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        // Controlla se le credenziali corrispondono a quelle di test
        if ("user".equals(loginRequest.getUsername()) && "password".equals(loginRequest.getPassword())) {
            // Se corrette, restituisci 200 OK con un messaggio di successo
            return ResponseEntity.ok(Map.of("message", "Login successful"));
        } else {
            // Se errate, restituisci 401 Unauthorized con un messaggio di errore
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("message", "Username o password non validi"));
        }
    }
}