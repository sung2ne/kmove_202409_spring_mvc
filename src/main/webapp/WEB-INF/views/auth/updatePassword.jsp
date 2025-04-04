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
        <form id="updatePasswordForm" action="/auth/update-password" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    비밀번호 수정
                </div>
                <div class="card-body">
                    <%-- 비밀번호 --%>
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <span class="text-danger">*</span> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력하세요">
                    </div>
                    <%-- 비밀번호 확인 --%>
                    <div class="mb-3">
                        <label for="password2" class="form-label">
                            <span class="text-danger">*</span> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password2" name="password2" placeholder="비밀번호 확인을 입력하세요">
                    </div>
                </div>
                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">비밀번호 수정</button>
                    <a href="/auth/profile" class="btn btn-secondary">취소</a>
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
        // 비밀번호 수정 폼 유효성 검사
        $('#updatePasswordForm').validate({
            rules: {
                password: {
                    required: true,
                    minlength: 8,
                    maxlength: 20
                },
                password2: {
                    required: true,
                    equalTo: '#password'
                },
            },
            messages: {
                password: {
                    required: '비밀번호를 입력하세요.',
                    minlength: '비밀번호는 8자 이상 20자 이하로 입력하세요.',
                    maxlength: '비밀번호는 8자 이상 20자 이하로 입력하세요.'
                },
                password2: {
                    required: '비밀번호 확인을 입력하세요.',
                    equalTo: '비밀번호가 일치하지 않습니다.'
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
