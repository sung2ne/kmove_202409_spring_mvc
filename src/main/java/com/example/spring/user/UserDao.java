package com.example.spring.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {
    
    // SqlSession 객체 주입
    @Autowired
    SqlSession sqlSession;

    // UserMapper.xml에 정의된 namespace
    private static final String namespace = "userMapper";

    // 로깅을 위한 변수
    private static final Logger logger = LoggerFactory.getLogger(UserDao.class);

    // 사용자 등록
    public int create(UserDto user) {
        int result = -1;

        try {
            result = sqlSession.insert(namespace + ".create", user);
        } catch (DataAccessException e) {
            logger.error("사용자 등록 오류 : {}", e.getMessage(), e);
        }

        return result;
    }

    // 사용자 목록
    public List<UserDto> list(int offset, int listCountPerPage, String searchType, String searchKeyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("listCountPerPage", listCountPerPage);
        params.put("searchType", searchType);
        params.put("searchKeyword", searchKeyword);
        
        List<UserDto> users = null;
        
        try {
            users = sqlSession.selectList(namespace + ".list", params);
        } catch (Exception e) {
            logger.error("사용자 목록 오류 : {}", e.getMessage(), e);
        }

        return users;
    }

    // 사용자 보기
    public UserDto read(UserDto user) {
        try {
            user = sqlSession.selectOne(namespace + ".read", user);
        } catch (Exception e) {
            logger.error("사용자 보기 오류 : {}", e.getMessage(), e);
        }

        return user;
    }

    // 사용자 수정
    public int update(UserDto user) {
        int result = -1;

        try {
            result = sqlSession.update(namespace + ".update", user);
        } catch (DataAccessException e) {
            logger.error("사용자 수정 오류 : {}", e.getMessage(), e);
        }

        return result;
    }

    // 사용자 삭제
    public int delete(String userId) {
        int result = -1;

        try {
            result = sqlSession.delete(namespace + ".delete", userId);
        } catch (DataAccessException e) {
            logger.error("사용자 삭제 오류 : {}", e.getMessage(), e);
        }

        return result;
    }

    // 전체 사용자 수
    public int totalCount(String searchType, String searchKeyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchType", searchType);
        params.put("searchKeyword", searchKeyword);

        int result = 0;

        try {
            result = sqlSession.selectOne(namespace + ".totalCount", params);
        } catch (DataAccessException e) {
            logger.error("전체 사용자 수 오류 : {}", e.getMessage(), e);
        }

        return result;
    }
}
