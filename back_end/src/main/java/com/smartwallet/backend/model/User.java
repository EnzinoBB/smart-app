package com.smartwallet.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true, nullable = false)
    private String username;
    @Column(nullable = false)
    private String password;
    
    private String name;
    private String surname;
    private String nickname;
    private boolean enabled = false;
    private String confirmationToken;
    
    public Long getId() {
        return id;
    }
    public String getUsername() {
        return username;
    }
    public String getPassword() {
        return password;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getName() {
        return name;
    }
    public String getSurname() {
        return surname;
    }
    public String getNickname() {
        return nickname;
    }
    public boolean isEnabled() {
        return enabled;
    }
    public String getConfirmationToken() {
        return confirmationToken;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void setSurname(String surname) {
        this.surname = surname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
    public void setConfirmationToken(String confirmationToken) {
        this.confirmationToken = confirmationToken;
    }
    
    
}