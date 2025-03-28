package com.example.spring.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.spring.libs.Pagination;

@Service
public class UserService {
    
    @Autowired
    UserDao userDao;

    @Autowired
    PasswordEncoder passwordEncoder;

    // 사용자 등록
    public boolean create(UserDto user) {
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        int result = userDao.create(user);
        return result > 0;
    }

    // 사용자 목록
    public Map<String, Object> list(int currentPage, int listCountPerPage, int pageCountPerPage, String searchType, String searchKeyword) {
        // 전체 사용자 수 조회
        int totalCount = userDao.totalCount(searchType, searchKeyword);

        // 페이지네이션 객체 생성
        Pagination pagination = new Pagination(currentPage, listCountPerPage, pageCountPerPage, totalCount);

        // 페이지네이션 객체를 활용하여 사용자 목록 조회
        List<UserDto> users = userDao.list(pagination.offset(), listCountPerPage, searchType, searchKeyword);

        // 결과 맵 생성
        Map<String, Object> result = new HashMap<>();
        result.put("users", users);
        result.put("pagination", pagination);

        return result;
    }

    // 사용자 보기
    public UserDto read(UserDto user) {
        return userDao.read(user);
    }

    // 사용자 수정
    public boolean update(UserDto user) {
        // 비밀번호가 있으면 암호화
        if (user.getPassword() != null && !user.getPassword().equals("")) {
            String encodedPassword = passwordEncoder.encode(user.getPassword());
            user.setPassword(encodedPassword);
        }

        // 사용자 수정
        int result = userDao.update(user);
        return result > 0;
    }

    // 사용자 삭제
    public boolean delete(UserDto user) {
        int result = userDao.delete(user.getUserId());
        return result > 0;
    }
}
