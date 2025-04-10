package com.example.spring.user;

import lombok.Data;

@Data
public class UserDto {
    private String userId;
    private String password;
    private String username;
    private String email;
    private String phone;
    private String role;
    private String createdAt;
    private String updatedAt;    
}
