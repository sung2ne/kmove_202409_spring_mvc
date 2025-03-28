package com.example.spring.post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Component;

@Component
public class PostDao {
    @Autowired
    SqlSession sqlSession;

    private static final String namespace = "postMapper";

    // 게시글 등록
    public int create(PostDto post) {
        int result = -1;

        try {
            // SQL 쿼리가 올바르게 실행될 경우, result의 값은 -1에서 1로 변경됨
            result = sqlSession.insert(namespace + ".create", post);
        } catch (DataAccessException e) {
            e.printStackTrace();
        }

        return result;
    }

    // 게시글 목록
    public List<PostDto> list(int offset, int listCountPerPage, String searchType, String searchKeyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("listCountPerPage", listCountPerPage);
        params.put("searchType", searchType);
        params.put("searchKeyword", searchKeyword);
        
        List<PostDto> posts = null;
        
        try {
            posts = sqlSession.selectList(namespace + ".list", params);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return posts;
    }

    // 게시글 보기
    public PostDto read(int id) {
        PostDto post = null;

        try {
            post = sqlSession.selectOne(namespace + ".read", id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return post;
    }

    // 게시글 수정
    public int update(PostDto post) {
        int result = -1;

        try {
            result = sqlSession.update(namespace + ".update", post);
        } catch (DataAccessException e) {
            e.printStackTrace();
        }

        return result;
    }

    // 게시글 삭제
    public int delete(int id) {
        int result = -1;

        try {
            result = sqlSession.delete(namespace + ".delete", id);
        } catch (DataAccessException e) {
            e.printStackTrace();
        }

        return result;
    }

    // 전체 게시글 수
    public int totalCount(String searchType, String searchKeyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchType", searchType);
        params.put("searchKeyword", searchKeyword);
        return sqlSession.selectOne(namespace + ".totalCount", params);
    }
}
