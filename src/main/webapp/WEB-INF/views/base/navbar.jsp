<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% pageContext.setAttribute("newLine", "\n"); %>

<%-- 네비게이션 바 --%>
<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">스프링 MVC 프로젝트</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
            aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/posts">게시글</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/users">사용자</a>
                </li>
            </ul>
            <div class="d-flex">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <c:if test="${not empty sessionScope.userId}">
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/profile">프로필</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/logout">로그아웃</a>
                        </li>
                    </c:if>
                    <c:if test="${empty sessionScope.userId}">
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/login">로그인</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/auth/register">회원가입</a>
                        </li>
                    </c:if>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<%--// 네비게이션 바 --%>