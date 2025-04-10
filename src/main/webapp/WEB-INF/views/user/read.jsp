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
    <div class="col-4">
        <%-- 사용자 보기 --%>
        <div class="card mb-3">
            <div class="card-header">
                <h5 class="card-title">사용자 정보</h5>
            </div>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">
                    <div class="d-flex justify-content-between">
                        <div class="text-muted text-sm">아이디</div>
                        <div>${user.userId}</div>
                    </div>
                </li>
                <li class="list-group-item">
                    <div class="d-flex justify-content-between">
                        <div class="text-muted text-sm">이름</div>
                        <div>${user.username}</div>
                    </div>
                </li>
                <li class="list-group-item">
                    <div class="d-flex justify-content-between">
                        <div class="text-muted text-sm">연락처</div>
                        <div>${user.phone}</div>
                    </div>
                </li>
                <li class="list-group-item">
                    <div class="d-flex justify-content-between">
                        <div class="text-muted text-sm">이메일</div>
                        <div>${user.email}</div>
                    </div>
                </li>
                <li class="list-group-item">
                    <div class="d-flex justify-content-between">
                        <div class="text-muted text-sm">권한</div>
                        <div>
                            <c:if test="${user.role == '사용자'}">
                                사용자
                            </c:if>
                            <c:if test="${user.role == '관리자'}">
                                <span class="btn btn-outline-danger">관리자</span>
                            </c:if>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
        <%--// 사용자 보기 --%>
        <%-- 버튼 --%>
        <div>
            <a href="/users" class="btn btn-primary">목록</a>
            <c:if test="${user.role == '사용자'}">
                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">삭제</button>
            </c:if>
        </div>
        <%--// 버튼 --%>
    </div>
</div>
<%--// 페이지 내용 --%>

<%--// 삭제 모달 --%>
<c:if test="${user.role == '사용자'}">
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="deleteForm" action="/users/${user.userId}/delete" method="POST">
                <div class="modal-header">
                    <h1 class="modal-title fs-5 text-danger" id="deleteModalModalLabel">
                        <strong>사용자 삭제</strong>
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
</c:if>
<%--// 삭제 모달 --%>

<%@ include file="../base/script.jsp" %>

<%@ include file="../base/bottom.jsp" %>
