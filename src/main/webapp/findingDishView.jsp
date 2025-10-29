<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Tìm kiếm món ăn</title>
    <style>
        /* CSS Chung (Giữ nguyên các phần không liên quan) */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .content-wrapper {
            flex-grow: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 500;
        }

        /* --- Thanh tìm kiếm (Giữ nguyên) --- */
        .search-area {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            width: 500px;
            justify-content: flex-end;
        }

        .search-area input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            flex-grow: 1;
            max-width: 300px;
        }

        .search-area button {
            background-color: #007bff;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .search-area button:hover {
            background-color: #0056b3;
        }

        /* --- Bảng Kết quả --- */
        table {
            width: 70%;
            max-width: 800px;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 50px;
        }

        thead {
            background-color: #e0e0e0;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            color: #333;
            font-weight: 600;
        }

        tbody tr:hover {
            background-color: #f5f5f5;
        }

        /* CĂN CHỈNH: Cột ID */
        th:nth-child(1), td:nth-child(1) {
            width: 5%;
        }

        /* CĂN CHỈNH: Cột Price (VNĐ) */
        th:nth-child(3) {
            text-align: right;
            width: 15%;
        }

        td:nth-child(3) {
            text-align: right;
        }

        /* CĂN CHỈNH QUAN TRỌNG: Cột Action (Cột thứ 4) */
        /* Căn chỉnh tiêu đề và dữ liệu về trung tâm */
        th:nth-child(4) {
            text-align: center; /* Căn giữa tiêu đề Action */
            width: 15%;
        }

        td:nth-child(4) {
            text-align: center; /* Căn giữa nút View Detail */
            width: 15%;
        }

        /* Cột Dish's name (Cột thứ 2) chiếm phần lớn diện tích */
        td:nth-child(2) {
            width: auto;
        }

        /* Tối ưu nút View Detail */
        .view-detail-btn {
            background-color: #007bff;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: background-color 0.3s;
        }
        .view-detail-btn:hover {
            background-color: #0056b3;
        }


        /* --- Khu vực Return Button (Giữ nguyên) --- */
        .return-area {
            align-self: flex-end;
            padding: 0 30px 20px 0;
        }

        .return-area button {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .return-area button:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="content-wrapper">

    <h1 class="view-title">Finding Dish View</h1>

    <div class="search-area">
        <form action="dish" method="GET" style="display: flex; gap: 10px; width: 100%; justify-content: flex-end;">
            <input type="text" name="searching_token" placeholder="Tìm kiếm tên món ăn..." />
            <button type="submit">Finding</button>
        </form>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Dish's name</th>
            <th>Price (VNĐ)</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="dish" items="${dishList}">
            <tr>
                <td> <c:out value="${dish.id}"></c:out> </td>
                <td> <c:out value="${dish.dishname}"></c:out> </td>
                <td><fmt:formatNumber value="${dish.dishprice}" type="number" groupingUsed="true" maxFractionDigits="0" /> </td>
                <td>
                    <form action="dish" method="GET" style="display:inline">
                        <input type="hidden" name="id" value="${dish.id}" />
                        <button type="submit" class="view-detail-btn">View Detail</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty dishList}">
            <tr>
                <td colspan="4" style="text-align: center;">Không tìm thấy món ăn nào.</td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <div class="return-area">
        <form action="customerView.jsp" method="GET">
            <button type="submit">Return</button>
        </form>
    </div>
</div>
</body>
</html>