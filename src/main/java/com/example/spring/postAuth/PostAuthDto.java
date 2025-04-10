package com.example.spring.postAuth;

import lombok.Data;

@Data
public class PostAuthDto {
    private int id;
    private String title;
    private String content;
    private String userId;
    private String createdAt;
    private String updatedAt;
}
