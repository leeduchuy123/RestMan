<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết Món ăn</title>
    <style>
        /* CSS Chung */
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
            align-items: center; /* Căn giữa nội dung chính */
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 500;
        }

        /* --- Bảng Chi tiết Món ăn --- */
        .detail-table {
            width: 80%; /* Độ rộng của bảng */
            max-width: 900px;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 50px;
        }

        .detail-table thead {
            background-color: #e0e0e0;
        }

        .detail-table th, .detail-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .detail-table th {
            color: #333;
            font-weight: 600;
        }

        /* CĂN CHỈNH: Cột Price (VNĐ) */
        .detail-table th:nth-child(3) {
            text-align: right;
            width: 15%;
        }
        .detail-table td:nth-child(3) {
            text-align: right;
        }

        /* CĂN CHỈNH: Cột Description */
        .detail-table td:nth-child(4) {
            /* Cho phép Description chiếm nhiều không gian hơn */
            width: auto;
        }

        /* CĂN CHỈNH: Cột ID */
        .detail-table th:nth-child(1), .detail-table td:nth-child(1) {
            width: 5%;
        }

        /* --- Khu vực Return Button (Giống FindingDishView) --- */
        .return-area {
            /* Vùng này nằm trong content-wrapper, đẩy sang góc phải */
            align-self: flex-end;
            padding-right: calc( (100% - 900px) / 2 ); /* Đẩy sang phải bằng khoảng cách căn giữa của bảng */
            /* Do bảng có max-width 900px, nên tính toán offset */
        }

        /* Dành cho màn hình nhỏ hơn 900px, căn chỉnh sang phải 20px */
        @media (max-width: 900px) {
            .return-area {
                align-self: center;
                width: 80%; /* Chiếm 80% độ rộng của content-wrapper */
                padding-right: 0;
                text-align: right; /* Căn nút sang phải */
            }
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
<jsp:include page="../common/header.jsp" />

<div class="content-wrapper">
    <h1> Dish Detail View </h1>

    <div>
        <table class="detail-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Dish's name</th>
                <th>Price (VNĐ)</th>
                <th>Description</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${dishDetail != null}">
                <tr>
                    <td><c:out value="${dishDetail.id}"/></td>
                    <td><c:out value="${dishDetail.dishname}"/></td>
                    <td><fmt:formatNumber value="${dishDetail.dishprice}" type="number" groupingUsed="true" maxFractionDigits="0" /></td>
                    <td><c:out value="${dishDetail.description}"/></td>
                </tr>
            </c:if>
            <c:if test="${dishDetail == null}">
                <tr><td colspan="4" style="text-align: center;">Dish not found.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="return-area">
        <form action="<%=request.getContextPath()%>/customer/findingDishView.jsp" method="GET">
            <button type="submit">Return</button>
        </form>
    </div>
</div>
</body>
</html>