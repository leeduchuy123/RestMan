<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>The Restaurant manager - Login</title>
    <style>
        /* CSS cho phong cách Minimalism */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6; /* Màu nền nhẹ nhàng */
            display: flex;
            justify-content: center; /* Căn giữa theo chiều ngang */
            align-items: center; /* Căn giữa theo chiều dọc */
            min-height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: #ffffff; /* Nền trắng cho form */
            padding: 40px;
            border-radius: 8px; /* Bo tròn góc */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Bóng nhẹ */
            width: 300px; /* Độ rộng cố định cho form */
            text-align: center;
        }

        h1 {
            color: #333; /* Màu chữ tiêu đề */
            margin-bottom: 25px;
            font-size: 24px;
            font-weight: 500;
        }

        h2.subtitle {
            color: #555;
            font-size: 18px;
            margin-bottom: 30px;
            font-weight: 400;
        }

        /* Ẩn table và sử dụng div/flexbox cho bố cục hiện đại hơn */
        .input-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .input-group label {
            display: block;
            margin-bottom: 5px;
            color: #666;
            font-size: 14px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; /* Quan trọng để padding không làm tăng chiều rộng */
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #007bff; /* Thay đổi màu viền khi focus */
            outline: none;
        }

        input[type="submit"] {
            background-color: #007bff; /* Màu xanh dương hiện đại */
            color: white;
            padding: 8px 15px; /* Giảm padding để nút bé lại */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 15px;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="login-container">
    <h1>The Restaurant manager</h1>
    <h2 class="subtitle">Login Form</h2>
    <form action="<%=request.getContextPath()%>/login" method="post">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />
        </div>
        <div class="submit-button-area">
            <input type="submit" value="Login" />
        </div>
    </form>
</div>
</body>
</html>