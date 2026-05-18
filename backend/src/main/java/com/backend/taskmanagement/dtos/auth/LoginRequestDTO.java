package com.backend.taskmanagement.dtos.auth;

import lombok.Data;

@Data
public class LoginRequestDTO {
    private String username;
    private String password;
}