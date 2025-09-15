package com.smartapp.backend.auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.smartapp.backend.model.LoginRequest;
import com.smartapp.backend.model.User;
import com.smartapp.backend.repo.UserRepository;
import com.smartapp.backend.service.EmailService;
import com.smartapp.backend.service.JwtService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager; // Per validare le credenziali
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final GoogleTokenVerifier googleTokenVerifier;

    public AuthController(JwtService jwtService, AuthenticationManager authenticationManager, UserRepository userRepository, PasswordEncoder passwordEncoder, EmailService emailService, GoogleTokenVerifier googleTokenVerifier) {
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
        this.googleTokenVerifier = googleTokenVerifier;
    }

    // --- ENDPOINT DI LOGIN STANDARD AGGIORNATO ---
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        // Usa l'AuthenticationManager per verificare le credenziali
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword())
        );
        
        // Se l'autenticazione ha successo, authentication.getPrincipal() conterrà i dettagli dell'utente
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        // Genera il token JWT
        String jwtToken = jwtService.generateToken(userDetails);
        
        return ResponseEntity.ok(Map.of("jwtToken", jwtToken));
    }
    
    // --- ENDPOINT GOOGLE AGGIORNATO ---
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
            
            User user = userRepository.findByUsername(email).orElseGet(() -> {
                User newUser = new User();
                // ... (logica di creazione utente esistente)
                newUser.setEnabled(true);
                return userRepository.save(newUser);
            });
            
            // Genera il token JWT anche per l'utente Google
            String jwtToken = jwtService.generateToken(new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), List.of()));
            return ResponseEntity.ok(Map.of("jwtToken", jwtToken));
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "Token Google non valido."));
        }
    }

    // NUOVO: Endpoint per la registrazione standard
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegistrationRequest registrationRequest) {
        // Controlla se l'email (usata come username) è già in uso
        if (userRepository.findByUsername(registrationRequest.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("message", "Questa email è già registrata."));
        }

        User newUser = new User();
        newUser.setName(registrationRequest.getName());
        newUser.setSurname(registrationRequest.getSurname());
        newUser.setUsername(registrationRequest.getEmail());
        newUser.setPassword(passwordEncoder.encode(registrationRequest.getPassword())); // Cripta la password!
        
        // Genera e imposta il token di conferma
        String token = UUID.randomUUID().toString();
        newUser.setConfirmationToken(token);
        newUser.setEnabled(false); // L'account è disabilitato finché non viene confermato

        userRepository.save(newUser);

        // Invia l'email di conferma in modo asincrono
        emailService.sendRegistrationConfirmationEmail(newUser.getUsername(), token);

        return ResponseEntity.ok(Map.of("message", "Registrazione avvenuta con successo. Controlla la tua email per attivare l'account."));
    }

    // NUOVO: Endpoint per la conferma dell'account
    @GetMapping("/confirm")
    public ResponseEntity<?> confirmRegistration(@RequestParam("token") String token) {
        Optional<User> userOptional = userRepository.findByConfirmationToken(token);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setEnabled(true);
            user.setConfirmationToken(null); // Il token può essere usato una sola volta
            userRepository.save(user);
            // In un'app reale, qui si potrebbe reindirizzare a una pagina di successo del frontend
            return ResponseEntity.ok("Account attivato con successo! Ora puoi effettuare il login.");
        } else {
            return ResponseEntity.badRequest().body("Token di conferma non valido o scaduto.");
        }
    }
}