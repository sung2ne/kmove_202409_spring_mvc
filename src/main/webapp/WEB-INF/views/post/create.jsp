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
        <form id="createForm" action="/posts/create" method="post" enctype="multipart/form-data">
            <div class="card mb-3">
                <div class="card-header">
                    <span class="text-danger">*</span> 표시는 필수항목입니다.
                </div>
                <div class="card-body">
                    <%-- 제목 --%>
                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <span class="text-danger">*</span> 제목
                        </label>
                        <input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력하세요">
                    </div>
                    <%-- 내용 --%>
                    <div class="mb-3">
                        <label for="content" class="form-label">
                            <span class="text-danger">*</span> 내용
                        </label>
                        <textarea class="form-control" id="content" name="content" rows="10" placeholder="내용을 입력하세요"></textarea>
                    </div>
                    <%-- 작성자 --%>
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <span class="text-danger">*</span> 작성자
                        </label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="작성자를 입력하세요">
                    </div>
                    <%-- 비밀번호 --%>
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <span class="text-danger">*</span> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력하세요">
                    </div>
                    <%-- 첨부파일 --%>
                    <div class="mb-3">
                        <label for="uploadFile" class="form-label">
                            첨부파일
                        </label>
                        <input type="file" class="form-control" id="uploadFile" name="uploadFile" accept="*/*">
                    </div>
                </div>
            </div>
            <%-- 버튼 --%>
            <div>
                <button type="submit" class="btn btn-primary">등록</button>
                <a href="/posts" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    $(document).ready(function() {
        $("#createForm").submit(function(event) {
            event.preventDefault();
            
            // 제목 유효성 검사
            if ($("#title").val() == "") {
                alert("제목을 입력하세요.");
                $("#title").focus();
                return false;
            }

            // 내용 유효성 검사
            else if ($("#content").val() == "") {
                alert("내용을 입력하세요.");
                $("#content").focus();
                return false;
            }

            // 작성자 유효성 검사
            else if ($("#username").val() == "") {
                alert("작성자를 입력하세요.");
                $("#username").focus();
                return false;
            }

            // 비밀번호 유효성 검사
            else if ($("#password").val() == "") {
                alert("비밀번호를 입력하세요.");
                $("#password").focus();
                return false;
            }
            
            return true;
        });
    });
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
