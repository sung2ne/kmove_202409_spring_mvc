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
        <form id="updateProfileForm" action="/auth/update-profile" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    프로필 수정
                </div>
                <div class="card-body">
                    <%-- 이름 --%>
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <span class="text-danger">*</span> 이름
                        </label>
                        <input type="text" class="form-control" id="username" name="username" value="${profile.username}" placeholder="이름을 입력하세요">
                    </div>
                    <%-- 이메일 --%>
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <span class="text-danger">*</span> 이메일
                        </label>
                        <input type="email" class="form-control" id="email" name="email" value="${profile.email}" placeholder="이메일을 입력하세요">
                    </div>
                    <%-- 전화번호 --%>
                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <span class="text-danger">*</span> 전화번호 (숫자만 입력하세요.)
                        </label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${profile.phone}" placeholder="전화번호를 입력하세요">
                    </div>
                </div>
                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">프로필 수정</button>
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

        // 프로필 수정 폼 유효성 검사
        $('#updateProfileForm').validate({
            rules: {
                username: {
                    required: true,
                    minlength: 2,
                    maxlength: 5
                },
                email: {
                    required: true,
                    email: true,
                    remote: {
                        url: '/auth/check-email',
                        type: 'post',
                        data: {
                            email: function() {
                                return $('#email').val();
                            },
                        },
                        dataFilter: function(response) {
                            const data = JSON.parse(response);

                            // 사용자의 원래 이메일
                            let originalEmail = '${profile.email}';

                            // 사용자가 이메일을 변경했는지 확인
                            if (originalEmail !== $('#email').val()) {
                                // 사용자가 이메일을 변경했으면 중복 체크
                                return !data.exists;
                            } else {
                                // 사용자가 이메일을 변경하지 않았으면 중복 체크를 하지 않음
                                return true;
                            }
                        }
                    }
                },
                phone: {
                    required: true,
                    remote: {
                        url: '/auth/check-phone',
                        type: 'post',
                        data: {
                            phone: function() {
                                return $('#phone').val();
                            },
                        },
                        dataFilter: function(response) {
                            const data = JSON.parse(response);
                            
                            // 사용자의 원래 전화번호
                            let originalPhone = '${profile.phone}';

                            // 사용자가 전화번호를 변경했는지 확인
                            if (originalPhone !== $('#phone').val()) {
                                // 사용자가 전화번호를 변경했으면 중복 체크
                                return !data.exists;
                            } else {
                                // 사용자가 전화번호를 변경하지 않았으면 중복 체크를 하지 않음
                                return true;
                            }
                        }
                    }
                }
            },
            messages: {
                username: {
                    required: '이름을 입력하세요.',
                    minlength: '이름은 2자 이상 5자 이하로 입력하세요.',
                    maxlength: '이름은 2자 이상 5자 이하로 입력하세요.'
                },
                email: {
                    required: '이메일을 입력하세요.',
                    email: '이메일 형식이 올바르지 않습니다.',
                    remote: '이미 사용중인 이메일입니다.'
                },
                phone: {
                    required: '전화번호를 입력하세요.',
                    remote: '이미 사용중인 전화번호입니다.'
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
