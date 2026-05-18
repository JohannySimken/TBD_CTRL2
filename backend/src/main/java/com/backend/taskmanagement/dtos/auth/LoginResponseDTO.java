package com.backend.taskmanagement.dtos.auth;

import lombok.Data;

@Data
public class LoginResponseDTO {
    private String token;
    private String username;
    private String role;
}