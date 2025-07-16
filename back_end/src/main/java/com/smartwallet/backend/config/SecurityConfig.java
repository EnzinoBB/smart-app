package com.smartwallet.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // 1. Disabilita CSRF (non necessario per API stateless)
            .csrf(csrf -> csrf.disable())

            // 2. Imposta la gestione della sessione su STATELESS
            // Non creeremo una sessione HTTP, ogni richiesta è indipendente
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

            // 3. Definisci le regole di autorizzazione per le richieste HTTP
            .authorizeHttpRequests(auth -> auth
                // Permetti l'accesso pubblico al nostro endpoint di autenticazione
                .requestMatchers("/api/auth/**",
                "/api/**"      // Per abilitare swagger ad accedere a tutte le api
                ).permitAll() 
                // Richiedi l'autenticazione per qualsiasi altra richiesta
                .anyRequest().authenticated() 
            );

        return http.build();
    }
}
