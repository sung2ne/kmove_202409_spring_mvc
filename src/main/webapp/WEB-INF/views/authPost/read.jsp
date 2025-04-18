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
        <%-- 게시글 보기 --%>
        <div class="card mb-3">
            <div class="card-header">
                <h5 class="card-title">${post.title}</h5>
            </div>
            <div class="card-body">
                <div class="mb-3 text-muted">
                    작성자: ${post.username} | 등록일시: ${post.createdAt.substring(0, 16)} | 수정일시: ${post.updatedAt.substring(0, 16)}
                </div>
                <c:if test="${post.fileName != null}">
                    <div class="mb-3">
                        첨부파일: <a href="/auth-posts/${post.id}/download" class="btn btn-outline-primary">${post.originalFileName}</a>
                    </div>
                </c:if>                
                <div class="mb-3">${fn:replace(post.content, newLine, '<br>')}</div>
            </div>
        </div>
        <%--// 게시글 보기 --%>
        <%-- 버튼 --%>
        <div>
            <a href="/auth-posts" class="btn btn-primary">목록</a>
            <%-- 게시글 등록한 사람만 수정, 삭제 가능 --%>
            <c:if test="${post.userId == sessionScope.userId}">
                <a href="/auth-posts/${post.id}/update" class="btn btn-warning">수정</a>
                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">삭제</button>
            </c:if>
            <%--// 게시글 등록한 사람만 수정, 삭제 가능 --%>
        </div>
        <%--// 버튼 --%>
    </div>
</div>
<%--// 페이지 내용 --%>

<%--// 삭제 모달 --%>
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="deleteForm" action="/auth-posts/${post.id}/delete" method="POST">
                <div class="modal-header">
                    <h1 class="modal-title fs-5 text-danger" id="deleteModalModalLabel">
                        <strong>게시글 삭제</strong>
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <p class="text-danger">삭제된 데이터는 복구할 수 없습니다.</p>
                        <p>정말 삭제하시겠습니까?</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-outline-danger">삭제</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%--// 삭제 모달 --%>

<%@ include file="../base/script.jsp" %>

<%-- script --%>
<script>
    /* 자바스크립트 */
</script>
<%--// script --%>

<%@ include file="../base/bottom.jsp" %>
