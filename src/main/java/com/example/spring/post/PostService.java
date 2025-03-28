package com.example.spring.post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.spring.libs.Pagination;

@Service
public class PostService {
    
    @Autowired
    PostDao postDao;

    @Autowired
    PasswordEncoder passwordEncoder;

    // 비밀번호 확인
    public boolean verifyPassword(PostDto post) {
        PostDto originalPost = postDao.read(post.getId());
        // return originalPost.getPassword().equals(post.getPassword());
        return passwordEncoder.matches(
            post.getPassword(),         // 평문 비밀번호
            originalPost.getPassword()  // 암호화된 비밀번호
        );
    }

    // 게시글 등록
    public boolean create(PostDto post) {
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(post.getPassword());
        post.setPassword(encodedPassword);

        int result = postDao.create(post);
        return result > 0;
    }

    // 게시글 목록
    public Map<String, Object> list(int currentPage, int listCountPerPage, int pageCountPerPage, String searchType, String searchKeyword) {
        // 전체 게시글 수 조회
        int totalCount = postDao.totalCount(searchType, searchKeyword);

        // 페이지네이션 객체 생성
        Pagination pagination = new Pagination(currentPage, listCountPerPage, pageCountPerPage, totalCount);

        // 페이지네이션 객체를 활용하여 게시글 목록 조회
        List<PostDto> posts = postDao.list(pagination.offset(), listCountPerPage, searchType, searchKeyword);

        // 결과 맵 생성
        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("pagination", pagination);

        return result;
    }

    // 게시글 보기
    public PostDto read(int id) {
        return postDao.read(id);
    }

    // 게시글 수정
    public boolean update(PostDto post) {
        // 비밀번호 확인
        if (!verifyPassword(post)) {
            return false;
        }

        // 게시글 수정
        int result = postDao.update(post);
        return result > 0;
    }

    // 게시글 삭제
    public boolean delete(PostDto post) {
        // 비밀번호 확인
        if (!verifyPassword(post)) {
            return false;
        }

        // 게시글 삭제
        int result = postDao.delete(post.getId());
        return result > 0;
    }
}
