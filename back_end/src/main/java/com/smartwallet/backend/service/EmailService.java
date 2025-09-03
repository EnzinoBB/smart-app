package com.smartwallet.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    // JavaMailSender viene iniettato da Spring con la configurazione
    // presente in application.properties.
    private final JavaMailSender javaMailSender;

    @Autowired
    public EmailService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    /**
     * Invia un'email di conferma registrazione.
     * Questo metodo è annotato con @Async per essere eseguito in un thread separato
     * e non bloccare la richiesta HTTP di registrazione dell'utente.
     *
     * @param userEmail L'indirizzo email del destinatario.
     * @param token     Il token di conferma univoco generato per l'utente.
     */
    @Async
    public void sendRegistrationConfirmationEmail(String userEmail, String token) {
        try {
            SimpleMailMessage mailMessage = new SimpleMailMessage();
            
            // Imposta il destinatario, l'oggetto e il corpo dell'email.
            mailMessage.setTo(userEmail);
            mailMessage.setSubject("Conferma la tua registrazione a Smart Wallet");
            
            // Costruisce il link di conferma che l'utente dovrà cliccare.
            // NOTA: 'localhost:8080' è per lo sviluppo. In produzione,
            // questo dovrebbe essere il dominio del tuo backend o frontend.
            String confirmationUrl = "http://localhost:8080/api/auth/confirm?token=" + token;
            
            // Testo dell'email.
            String messageText = "Grazie per esserti registrato a Smart Wallet!\n\n"
                               + "Per favore, clicca sul link qui sotto per attivare il tuo account:\n"
                               + confirmationUrl + "\n\n"
                               + "Se non hai richiesto tu questa registrazione, per favore ignora questa email.";
            
            mailMessage.setText(messageText);

            // Invia l'email.
            javaMailSender.send(mailMessage);

            System.out.println("Email di conferma inviata a: " + userEmail);

        } catch (Exception e) {
            // In un'applicazione reale, dovresti usare un logger (es. SLF4J)
            // per registrare l'errore in modo più strutturato.
            System.err.println("Errore durante l'invio dell'email a " + userEmail + ": " + e.getMessage());
            // Potresti anche implementare una logica di retry qui.
        }
    }
}
