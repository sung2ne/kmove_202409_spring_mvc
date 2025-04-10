package com.example.spring.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 로그인하지 않은 경우, 로그인 페이지로 리디렉트
        if (request.getSession().getAttribute("userId") == null) {            
            response.sendRedirect("/auth/logout");
            return false;
        }

        // /users 로 시작하는 URL은 관리자만 접근 가능
        String requestURI = request.getRequestURI();
        if (requestURI.startsWith("/users")) {
            String role = (String) request.getSession().getAttribute("role");
            if (!"관리자".equals(role)) {
                response.sendRedirect("/auth/logout");
                return false;
            }
        }

        return true; // 로그인한 경우 계속 진행
    }
}
