package com.smartapp.backend.auth;

// Questo DTO (Data Transfer Object) trasporta i dati per la registrazione.
public class RegistrationRequest {
    private String name;
    private String surname;
    private String email; // Useremo l'email come username
    private String password;

    // --- Genera Getter e Setter con il tuo IDE ---
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSurname() { return surname; }
    public void setSurname(String surname) { this.surname = surname; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
