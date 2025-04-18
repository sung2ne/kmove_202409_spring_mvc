package com.example.spring.authPost;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class AuthPostDto {
    // 게시글 정보
    private int id; // 구분자
    private String title; // 제목
    private String content; // 내용
    private String password; // 비밀번호
    private String userId; // 사용자 아이디
    private String createdAt; // 작성일시
    private String updatedAt; // 수정일시
    private MultipartFile uploadFile;   // 업로드할 파일 정보
    private String fileName;            // 업로드 이후 변경된 파일명
    private String originalFileName;    // 업로드 이전 파일명
    private boolean deleteFile;         // 파일 삭제 여부(수정에서 사용)

    // 사용자 정보
    private String username; // 작성자
    private String email; // 이메일
    private String phone; // 전화번호
}
