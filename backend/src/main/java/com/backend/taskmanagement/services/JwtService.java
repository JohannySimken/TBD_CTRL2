package com.backend.taskmanagement.services;


import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {
    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.expiration}")
    private String expiration;

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(String email, String role, Long userId){
        return Jwts.builder()
                .subject(email)
                .claim("role", role)
                .claim("userId", userId)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + Long.parseLong(expiration)))
                .signWith(getKey())
                .compact();
    }

    public Claims extractClaims(String token){
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }


    public Boolean isValid(String token){
        try{
            extractClaims(token);
            return true;

        } catch (JwtException | IllegalArgumentException e){
            return false;
        }
    }

    public String extractEmail(String token){
        return extractClaims(token).getSubject();
    }

    public String extractRole(String token){
        return extractClaims(token).get("role").toString();
    }

    public Long extractUserId(String token){
        return Long.parseLong(extractClaims(token).get("userId").toString());
    }

}
