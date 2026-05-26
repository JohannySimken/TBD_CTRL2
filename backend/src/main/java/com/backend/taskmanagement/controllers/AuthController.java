package com.backend.taskmanagement.controllers;

import com.backend.taskmanagement.dtos.auth.LoginRequestDTO;
import com.backend.taskmanagement.dtos.auth.LoginResponseDTO;
import com.backend.taskmanagement.dtos.auth.RegisterRequestDTO;
import com.backend.taskmanagement.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<LoginResponseDTO> register(@RequestBody RegisterRequestDTO dto) {
        LoginResponseDTO result = userService.register(dto);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO dto) {
        LoginResponseDTO result = userService.login(dto);
        return ResponseEntity.ok(result);
    }
}
