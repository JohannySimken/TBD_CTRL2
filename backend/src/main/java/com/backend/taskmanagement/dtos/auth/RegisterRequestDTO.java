package com.backend.taskmanagement.dtos.auth;

import lombok.Data;

@Data
public class RegisterRequestDTO {
    private String username;
    private String email;
    private String password;
    private Double latitude; //Front no envia un objeto "Point" es por esto que se separa en latitude y longitude
    private Double longitude;
}