<%--
  Created by IntelliJ IDEA.
  User: lehuy
  Date: 10/29/2025
  Time: 10:40 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* CSS Tối giản cho Header */
    .app-header {
        background-color: #4CAF50; /* Màu xanh lá cây - đại diện cho nhà hàng */
        color: white;
        padding: 10px 20px;
        display: flex;
        justify-content: space-between; /* Căn đều hai bên */
        align-items: center;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Bóng nhẹ */
    }

    /* Vùng chứa Title và Welcome Message */
    .header-left-content {
        display: flex;
        flex-direction: column; /* Quan trọng: xếp các mục theo chiều dọc */
        align-items: flex-start; /* Căn lề trái cho cả hai dòng */
    }

    .system-title {
        font-size: 40px;
        font-weight: bold;
        margin: 0;
    }

    .welcome-message {
        font-size: 18px; /* Giữ kích thước nhỏ */
        font-style: italic;
        margin-top: 5px; /* Tạo khoảng cách nhỏ giữa hai dòng */
    }
</style>

<header class="app-header">
    <div class="header-left-content">
        <h3 class="system-title">Restaurant Management System</h3>

        <div class="welcome-message">
            <c:if test="${sessionScope.username != null}">
                Chào mừng đến với hệ thống, **<c:out value="${sessionScope.username}"/>**!
            </c:if>
            <c:if test="${sessionScope.username == null}">
                Vui lòng đăng nhập để sử dụng hệ thống.
            </c:if>
        </div>
    </div>
</header>
