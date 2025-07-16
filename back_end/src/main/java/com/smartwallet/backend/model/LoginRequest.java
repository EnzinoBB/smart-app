package com.smartwallet.backend.model;

// Questa classe è un Data Transfer Object (DTO).
// Il suo unico scopo è quello di modellare i dati in arrivo
// dalla richiesta JSON di login.
// Esempio di JSON che questa classe può mappare:
// {
//   "username": "user123",
//   "password": "password123"
// }

public class LoginRequest {

    private String username;
    private String password;

    // È necessario un costruttore vuoto per la deserializzazione JSON da parte di Spring (Jackson).
    public LoginRequest() {
    }

    // Costruttore con parametri, utile per i test.
    public LoginRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // Getter per permettere a Spring di accedere ai campi.
    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    // Setter per permettere a Spring di popolare i campi.
    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
