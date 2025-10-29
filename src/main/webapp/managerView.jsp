<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LOGIC: Giữ nguyên logic kiểm tra session
    HttpSession currentSession = request.getSession(false);

    if(currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String username = (String) currentSession.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager View</title>
    <style>
        /* CSS Chung cho Menu View (Lấy từ Customer View) */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
            /* Đảm bảo nội dung nằm dưới Header */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-content {
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            align-items: center; /* Căn giữa nội dung */
            flex-grow: 1; /* Cho phép vùng này chiếm hết không gian còn lại */
        }

        h1.view-title {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 500;
        }

        /* Menu container */
        .manager-menu {
            list-style: none; /* Xóa gạch đầu dòng */
            padding: 0;
            margin: 0;
            width: 300px; /* Chiều rộng cố định cho menu */
            display: flex;
            flex-direction: column;
            gap: 15px; /* Khoảng cách giữa các mục menu */
        }

        .menu-item a {
            display: block;
            text-decoration: none;
            color: #333; /* Màu chữ */
            background-color: #ffffff; /* Nền trắng */
            padding: 15px 20px;
            border-radius: 6px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Bóng nhẹ, tối giản */
            text-align: center;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .menu-item a:hover {
            background-color: #e9e9e9; /* Đổi màu khi hover */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15); /* Bóng rõ hơn khi hover */
            transform: translateY(-2px); /* Hiệu ứng nổi nhẹ */
        }

    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="main-content">
    <h1 class="view-title">Manager View</h1>

    <ul class="manager-menu">
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/dish">Finding Dish</a>
        </li>
        <li class="menu-item">
            <a href="#">View Statis</a>
        </li>
        <li class="menu-item">
            <a href="#">Manage Dish</a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/combo?action=manage_combo">Manage Combo</a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </li>
    </ul>
</div>
</body>
</html>