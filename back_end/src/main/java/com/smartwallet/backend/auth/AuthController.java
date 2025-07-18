package com.smartwallet.backend.auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.smartwallet.backend.model.LoginRequest;
import com.smartwallet.backend.model.User; // Assicurati di avere la classe User
import com.smartwallet.backend.repo.UserRepository; // Assicurati di avere lo UserRepository
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder; // Lo aggiungeremo in seguito
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final GoogleTokenVerifier googleTokenVerifier;
    private final UserRepository userRepository;
    // private final PasswordEncoder passwordEncoder; // Necessario quando salveremo gli utenti

    public AuthController(GoogleTokenVerifier googleTokenVerifier, UserRepository userRepository) {
        this.googleTokenVerifier = googleTokenVerifier;
        this.userRepository = userRepository;
    }

    // Endpoint per il login tradizionale
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        if ("user".equals(loginRequest.getUsername()) && "password".equals(loginRequest.getPassword())) {
            return ResponseEntity.ok(Map.of("message", "Login successful"));
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("message", "Username o password non validi"));
        }
    }

    // NUOVO: Endpoint per il login/registrazione con Google
    @PostMapping("/google")
    public ResponseEntity<?> loginWithGoogle(@RequestBody Map<String, String> tokenMap) {
        String idToken = tokenMap.get("idToken");
        if (idToken == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Il token ID è mancante."));
        }

        Optional<GoogleIdToken.Payload> payloadOptional = googleTokenVerifier.verify(idToken);

        if (payloadOptional.isPresent()) {
            GoogleIdToken.Payload payload = payloadOptional.get();
            String email = payload.getEmail();
            
            // Cerca l'utente nel nostro DB. Se non esiste, ne crea uno nuovo.
            User user = userRepository.findByUsername(email)
                .orElseGet(() -> {
                    User newUser = new User();
                    newUser.setUsername(email);
                    // Per gli utenti Google, la password non è necessaria nel modo tradizionale.
                    // Si può impostare un valore casuale e sicuro.
                    newUser.setPassword(UUID.randomUUID().toString());
                    // In un'app reale, potresti voler salvare anche nome, cognome, foto, etc.
                    // newUser.setFirstName((String) payload.get("given_name"));
                    return userRepository.save(newUser);
                });

            // A questo punto, l'utente esiste nel nostro sistema.
            // Ora dovremmo generare il nostro token JWT e restituirlo.
            // Per ora, restituiamo un semplice messaggio di successo.
            String jwtToken = "token_jwt_fittizio_per_" + user.getUsername(); // Logica JWT da implementare
            return ResponseEntity.ok(Map.of("jwtToken", jwtToken));
            
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("message", "Token Google non valido."));
        }
    }
}