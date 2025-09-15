package com.smartapp.backend.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.smartapp.backend.model.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    
    // Metodo per trovare un utente dal suo username (email)
    Optional<User> findByUsername(String username);

    // NUOVO: Metodo per trovare un utente dal suo token di conferma
    Optional<User> findByConfirmationToken(String confirmationToken);
}