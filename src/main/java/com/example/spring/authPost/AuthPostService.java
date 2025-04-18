package com.example.spring.authPost;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.spring.libs.Pagination;

@Service
public class AuthPostService {
    
    @Autowired
    AuthPostDao authPostDao;

    // 게시글 등록
    public boolean create(AuthPostDto post) {
        int result = authPostDao.create(post);
        return result > 0;
    }

    // 게시글 목록
    public Map<String, Object> list(int currentPage, int listCountPerPage, int pageCountPerPage, String searchType, String searchKeyword) {
        // 전체 게시글 수 조회
        int totalCount = authPostDao.totalCount(searchType, searchKeyword);

        // 페이지네이션 객체 생성
        Pagination pagination = new Pagination(currentPage, listCountPerPage, pageCountPerPage, totalCount);

        // 페이지네이션 객체를 활용하여 게시글 목록 조회
        List<AuthPostDto> posts = authPostDao.list(pagination.offset(), listCountPerPage, searchType, searchKeyword);

        // 결과 맵 생성
        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("pagination", pagination);

        return result;
    }

    // 게시글 보기
    public AuthPostDto read(int id) {
        return authPostDao.read(id);
    }

    // 게시글 수정
    public boolean update(AuthPostDto post) {
        // 게시글 수정
        int result = authPostDao.update(post);
        return result > 0;
    }

    // 게시글 삭제
    public boolean delete(AuthPostDto post) {
        // 게시글 삭제
        int result = authPostDao.delete(post.getId());
        return result > 0;
    }
}
