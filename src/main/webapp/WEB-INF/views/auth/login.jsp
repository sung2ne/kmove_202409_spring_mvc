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
        <form id="loginForm" action="/auth/login" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    로그인
                </div>
                <div class="card-body">
                    <%-- 아이디 --%>
                    <div class="mb-3">
                        <label for="userId" class="form-label">
                            <span class="text-danger">*</span> 아이디
                        </label>
                        <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디를 입력하세요">
                    </div>
                    <%-- 비밀번호 --%>
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <span class="text-danger">*</span> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력하세요">
                    </div>
                </div>
                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">로그인</button>
                    <a href="/auth/login" class="btn btn-secondary">취소</a>
                </div>
            </div>            
        </form>
    </div>
</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    $(document).ready(function() {
        // 로그인 폼 유효성 검사
        $('#loginForm').validate({
            rules: {
                userId: {
                    required: true,
                },
                password: {
                    required: true,
                },
            },
            messages: {
                userId: {
                    required: '아이디를 입력하세요.',
                },
                password: {
                    required: '비밀번호를 입력하세요.',
                },
            },
            errorClass: 'is-invalid',
            validClass: 'is-valid',
            errorPlacement: function(error, element) {
                error.addClass('invalid-feedback');
                element.closest('.mb-3').append(error);
            },
            submitHandler: function(form) {
                form.submit();
            }
        });
    });
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
