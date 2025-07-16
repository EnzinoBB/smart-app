package com.smartwallet.backend.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.smartwallet.backend.model.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}
