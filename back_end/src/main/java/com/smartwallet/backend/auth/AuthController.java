package com.smartwallet.backend.auth;

// ... (import necessari: Spring, User, UserRepository, etc.)
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
// ... altri import

import com.smartwallet.backend.model.LoginRequest;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    // ... (injection del repository e del password encoder)

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        // Logica:
        // 1. Trova l'utente per username.
        // 2. Se non esiste, ritorna 401 Unauthorized.
        // 3. Se esiste, confronta la password inviata con quella hashata nel DB.
        // 4. Se corrispondono, ritorna 200 OK con un messaggio/token.
        // 5. Se non corrispondono, ritorna 401 Unauthorized.
        return ResponseEntity.ok("Login successful"); // Semplificato per ora
    }
}
