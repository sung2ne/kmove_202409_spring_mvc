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
        <form id="updateForm" action="/auth-posts/${post.id}/update" method="post" enctype="multipart/form-data">
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
                        <input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력하세요" value="${post.title}">
                    </div>
                    <%-- 내용 --%>
                    <div class="mb-3">
                        <label for="content" class="form-label">
                            <span class="text-danger">*</span> 내용
                        </label>
                        <textarea class="form-control" id="content" name="content" rows="10" placeholder="내용을 입력하세요">${post.content}</textarea>
                    </div>
                    <%-- 첨부파일 --%>
                    <c:if test="${not empty post.fileName}">
                        <div class="mb-3"> 
                            <div class="mb-2">  
                                <span>현재 파일: <a href="/auth-posts/${post.id}/download" class="btn btn-outline-primary">${post.originalFileName}</a></span>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="deleteFile" id="deleteFile" value="false">
                                <label class="form-check-label text-danger" for="deleteFile">
                                    파일 삭제
                                </label>
                            </div>
                        </div>
                    </c:if>
                    <div class="mb-3">
                        <label for="uploadFile" class="form-label">첨부 파일</label>
                        <input type="file" class="form-control" id="uploadFile" name="uploadFile" accept="*/*">
                        <small class="form-text text-muted">새 파일을 선택하면 기존 파일은 자동으로 삭제됩니다.</small>
                    </div>
                    <%--// 첨부파일 --%>
                </div>
            </div>
            <%-- 버튼 --%>
            <div>
                <button type="submit" class="btn btn-primary">수정</button>
                <a href="/auth-posts/${post.id}" class="btn btn-secondary">취소</a>
            </div>
            <%--// 버튼 --%>
        </form>
    </div>
</div>
<%--// 페이지 내용 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    $(document).ready(function() {
        $("#updateForm").submit(function(event) {
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
        });
    });
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
