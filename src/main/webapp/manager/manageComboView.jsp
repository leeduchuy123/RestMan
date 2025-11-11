<%@ page import="java.util.List" %>
<%@ page import="model.Combo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Quản lý Combo</title>
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

        h1.view-title {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 500;
        }

        /* --- Khu vực Nút Thêm Combo (Add Combo) --- */
        .top-actions {
            width: 80%;
            max-width: 900px;
            margin-bottom: 20px;
            text-align: right; /* Đẩy nút Add combo sang phải */
        }

        .add-combo-btn {
            background-color: #28a745; /* Màu xanh lá cây */
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .add-combo-btn:hover {
            background-color: #218838;
        }

        /* --- Tiêu đề List of Combo --- */
        h2.list-title {
            width: 80%;
            max-width: 900px;
            text-align: center;
            margin-bottom: 10px;
            color: #555;
            font-size: 20px;
            font-weight: 500;
        }

        /* --- Bảng Combo (Tương tự Finding Dish View) --- */
        table {
            width: 80%;
            max-width: 900px;
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

        /* CĂN CHỈNH CÁC CỘT */
        th:nth-child(1), td:nth-child(1) { /* ID */
            width: 5%;
        }

        th:nth-child(4) { /* Price */
            text-align: right;
            width: 10%;
        }
        td:nth-child(4) {
            text-align: right;
        }

        th:nth-child(5), td:nth-child(5) { /* Action */
            text-align: center;
            width: 15%;
        }

        th:nth-child(2) { /* Combo's name */
            width: 20%;
        }
        th:nth-child(3) { /* Dishes / Description */
            width: auto;
        }


        /* Nút Delete */
        .delete-btn {
            background-color: #dc3545; /* Màu đỏ */
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: background-color 0.3s;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }

        /* --- Khu vực Return Button (Giống các trang trước) --- */
        .return-area {
            align-self: flex-end;
            padding-right: calc( (100% - 900px) / 2 ); /* Đẩy sang phải bằng khoảng cách căn giữa của bảng */
        }

        @media (max-width: 900px) {
            .return-area {
                align-self: center;
                width: 80%;
                padding-right: 0;
                text-align: right;
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
    <h1 class="view-title">Manage Combo View</h1>

    <div class="top-actions">
        <button type="button" class="add-combo-btn" onclick="window.location.href='<%=request.getContextPath()%>/manager/addComboView.jsp';">Add combo</button>
    </div>

    <h2 class="list-title">List of Combo</h2>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Combo's name</th>
            <th>Description</th> <th>Price</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Combo> combosList = (List<Combo>) request.getAttribute("comboList");
            if(combosList != null && !combosList.isEmpty()) {
                for(Combo combo : combosList) {
        %>
        <tr>
            <td><%= combo.getId() %></td>
            <td><%= combo.getComboname()%></td>
            <td><%= combo.getDescription()%></td>
            <td>
                <%-- Sử dụng JSTL fmt:formatNumber để định dạng giá --%>
                <fmt:formatNumber value="<%= combo.getComboprice()%>" type="number" groupingUsed="true" maxFractionDigits="0" />
            </td>
            <td>
                <form action="combo" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="comboId" value="<%= combo.getId() %>">
                    <button type="submit" class="delete-btn">Delete</button>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="5" style="text-align: center;">No combo found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="return-area">
        <form action="<%=request.getContextPath()%>/manager/managerView.jsp" method="get">
            <button type="submit">Return</button>
        </form>
    </div>
</div>
</body>
</html>