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
        <form id="registerForm" action="/auth/register" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    회원가입
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
                    <%-- 비밀번호 확인 --%>
                    <div class="mb-3">
                        <label for="password2" class="form-label">
                            <span class="text-danger">*</span> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password2" name="password2" placeholder="비밀번호 확인을 입력하세요">
                    </div>
                    <%-- 이름 --%>
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <span class="text-danger">*</span> 작성자
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
                    <%-- 전화번호 --%>
                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <span class="text-danger">*</span> 전화번호
                        </label>
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="전화번호를 입력하세요">
                    </div>
                </div>
            </div>
            <%-- 버튼 --%>
            <div>
                <button type="submit" class="btn btn-primary">회원가입</button>
                <a href="/auth/login" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
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

        // 회원가입 폼 유효성 검사
        $('#registerForm').val({
            rulue: {
                userId: {
                    required: true,
                    minlength: 6,
                    maxlength: 20
                },
                password: {
                    required: true,
                    // 특수문자 적용
                    // pattern: /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,20}$/,
                    minlength: 8,
                    maxlength: 20
                },
                password2: {
                    required: true,
                    equalTo: '#password'
                },
                username: {
                    required: true,
                    minlength: 2,
                    maxlength: 5
                },
                email: {
                    required: true,
                    email: true
                },
                phone: {
                    required: true,                 
                    pattern: phonePattern
                }
            },
            message: {
                userId: {
                    required: '아이디를 입력하세요.',
                    minlength: '아이디는 6자 이상 20자 이하로 입력하세요.',
                    maxlength: '아이디는 6자 이상 20자 이하로 입력하세요.'
                },
                password: {
                    required: '비밀번호를 입력하세요.',
                    minlength: '비밀번호는 8자 이상 20자 이하로 입력하세요.',
                    maxlength: '비밀번호는 8자 이상 20자 이하로 입력하세요.'
                },
                password2: {
                    required: '비밀번호 확인을 입력하세요.',
                    equalTo: '비밀번호가 일치하지 않습니다.'
                },
                username: {
                    required: '이름을 입력하세요.',
                    minlength: '이름은 2자 이상 5자 이하로 입력하세요.',
                    maxlength: '이름은 2자 이상 5자 이하로 입력하세요.'
                },
                email: {
                    required: '이메일을 입력하세요.',
                    email: '이메일 형식이 올바르지 않습니다.'
                },
                phone: {
                    required: '전화번호를 입력하세요.',
                    pattern: '전화번호 형식이 올바르지 않습니다.'
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
    });
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
