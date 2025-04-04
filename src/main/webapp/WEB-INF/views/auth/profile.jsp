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
    <div class="col-4 offset-4">
        <div class="card mb-3">
            <div class="card-header">
                프로필
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <tbody>
                            <tr>
                                <th class="col-3">아이디</th>
                                <td class="col-9">${profile.userId}</td>
                            </tr>
                            <tr>
                                <th>이름</th>
                                <td>${profile.username}</td>
                            </tr>
                            <tr>
                                <th>이메일</th>
                                <td>${profile.email}</td>
                            </tr>
                            <tr>
                                <th>전화번호</th>
                                <td>${profile.phone}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer">
                <a href="/auth/update-profile" class="btn btn-outline-warning">프로필 수정</a>
                <a href="/auth/update-password" class="btn btn-outline-danger">비밀번호 수정</a>
            </div>
        </div>
    </div>
</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%@ include file="../base/bottom.jsp" %>
