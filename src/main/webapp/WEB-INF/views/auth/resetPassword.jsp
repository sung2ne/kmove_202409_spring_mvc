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

    <%-- 전화번호로 비밀번호 초기화 폼 --%>
    <div class="col-6">
        <form id="resetPasswordByPhoneForm" action="/auth/reset-password" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    전화번호로 비밀번호 초기화
                </div>
                <div class="card-body">
                    <%-- 이름 --%>
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <span class="text-danger">*</span> 이름
                        </label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="이름을 입력하세요">
                    </div>
                    <%-- 전화번호 --%>
                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <span class="text-danger">*</span> 전화번호 (숫자만 입력하세요.)
                        </label>
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="전화번호를 입력하세요">
                    </div>
                </div>
                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">아이디 찾기</button>
                    <a href="/auth/login" class="btn btn-secondary">취소</a>
                </div>
            </div>          
        </form>
    </div>
    <%-- 전화번호로 비밀번호 초기화 폼 --%>

    <%-- 이메일로 비밀번호 초기화 폼 --%>
    <div class="col-6">
        <form id="resetPasswordByEmailForm" action="/auth/reset-password" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    이메일로 비밀번호 초기화
                </div>
                <div class="card-body">
                    <%-- 이름 --%>
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <span class="text-danger">*</span> 이름
                        </label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="이름을 입력하세요">
                    </div>
                    <%-- 이메일 --%>
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <span class="text-danger">*</span> 이메일
                        </label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="이메일을 입력하세요">
                    </div>
                </div>
                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">아이디 찾기</button>
                    <a href="/auth/login" class="btn btn-secondary">취소</a>
                </div>
            </div>
        </form>
    </div>
    <%-- 이메일로 비밀번호 초기화 폼 --%>

</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    $(document).ready(function() {
        // 전화번호 입력 제한 및 형식화
        $('#phone').on('keypress', function(e) {
            // 숫자 키(0-9)만 허용, 그 외 입력은 차단
            if (!/[0-9]/.test(String.fromCharCode(e.which)) && e.which != 8 && e.which != 0) {
                e.preventDefault();
            }
        }).on('input', function() {
            // 숫자만 남기기
            let phone = $(this).val().replace(/[^0-9]/g, '');
            
            // 입력 값이 3자리 이상일 때 010으로 시작하는지 확인
            if (phone.length >= 3 && !phone.startsWith('010')) {
                phone = '010' + phone.substring(Math.min(3, phone.length));
            }
            
            // 형식화
            if (phone.length <= 3) {
                $(this).val(phone);
            } else if (phone.length <= 7) {
                $(this).val(phone.replace(/(\d{3})(\d{1,4})/, '$1-$2'));
            } else {
                $(this).val(phone.replace(/(\d{3})(\d{4})(\d{0,4})/, '$1-$2-$3'));
            }
            
            // 최대 11자리로 제한
            if (phone.length > 11) {
                phone = phone.substring(0, 11);
                $(this).val(phone.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3'));
            }
        });

        // 전화번호로 비밀번호 초기화 폼 유효성 검사
        $('#resetPasswordByPhoneForm').validate({
            rules: {
                username: {
                    required: true,
                },
                phone: {
                    required: true,
                }
            },
            messages: {
                username: {
                    required: '이름을 입력하세요.',
                },
                phone: {
                    required: '전화번호를 입력하세요.',
                }
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

        // 이메일로 비밀번호 초기화 폼 유효성 검사
        $('#resetPasswordByEmailForm').validate({
            rules: {
                username: {
                    required: true,
                },
                email: {
                    required: true,
                    email: true,
                },
            },
            messages: {
                username: {
                    required: '이름을 입력하세요.',
                },
                email: {
                    required: '이메일을 입력하세요.',
                    email: '이메일 형식이 올바르지 않습니다.',
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
