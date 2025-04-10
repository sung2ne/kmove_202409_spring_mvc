<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% pageContext.setAttribute("newLine", "\n"); %>

<%@ include file="../base/top.jsp" %>
<%@ include file="../base/navbar.jsp" %>
<%@ include file="../base/title.jsp" %>
<%@ include file="../base/message.jsp" %>

<%-- 페이지 내용 --%>
<div class="row">
    <div class="col-12">
        <%-- 검색, 등록 버튼 --%>
        <div class="mb-3 d-flex justify-content-between">
            <%-- 검색 --%>
            <form action="/users" method="get">
                <div class="input-group">
                    <select name="searchType" class="form-select">
                        <option value="username" ${searchType == 'username' ? 'selected' : ''}>이름</option>
                        <option value="phone" ${searchType == 'phone' ? 'selected' : ''}>연락처</option>
                        <option value="email" ${searchType == 'email' ? 'selected' : ''}>이메일</option>
                        <option value="userId" ${searchType == 'userId' ? 'selected' : ''}>아이디</option>
                        <option value="all" <c:if test="${searchType == 'all'}">selected</c:if>>전체</option>
                    </select>
                    <input type="text" name="searchKeyword" class="form-control" value="${searchKeyword}" size="30" placeholder="검색어를 입력하세요">
                    <button type="submit" class="btn btn-primary">검색</button>
                    <c:if test="${searchKeyword != null}">
                        <a href="/users" class="btn btn-danger">취소</a>
                    </c:if>
                </div>
            </form>
            <%--// 검색 --%>
        </div>
        <%--// 검색, 등록 버튼 --%>

        <%-- 사용자 목록 --%>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>연락처</th>
                    <th>이메일</th>
                    <th>권한</th>
                    <th>등록일시</th>
                    <th>수정일시</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                <tr>
                    <td><a href="/users/${user.userId}">${user.userId}</a></td>
                    <td>${user.username}</td>
                    <td>${user.phone}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>${user.createdAt.substring(0, 16)}</td>
                    <td>${user.updatedAt.substring(0, 16)}</td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
        <%--// 사용자 목록 --%>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <%-- 이전 페이지 --%>
                <c:if test="${pagination.currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="/users?page=1">처음</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="/users?page=${pagination.currentPage - 1}">이전</a>
                    </li>
                </c:if>                
                <%--// 이전 페이지 --%>

                <%-- 페이지 번호 --%>
                <c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNumber">
                    <li class="page-item">
                        <a class="page-link <c:if test='${pageNumber == pagination.currentPage}'>active</c:if>" href="/users?page=${pageNumber}">${pageNumber}</a>
                    </li>
                </c:forEach>
                <%--// 페이지 번호 --%>

                <%-- 다음 페이지 --%>
                <c:if test="${pagination.currentPage < pagination.totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="/users?page=${pagination.currentPage + 1}">다음</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="/users?page=${pagination.totalPages}">마지막</a>
                    </li>
                </c:if>                
                <%--// 다음 페이지 --%>
            </ul>
        </nav>
    </div>
</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    /* 자바스크립트 */
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
