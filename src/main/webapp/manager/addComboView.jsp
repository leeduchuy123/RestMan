<%--
  Created by IntelliJ IDEA.
  User: lehuy
  Date: 10/28/2025
  Time: 1:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import ="model.Dish" %>
<%@ page import ="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Combo Mới</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        /* CSS TỐI GIẢN THEO BỐ CỤC HÌNH ẢNH */

        /* CSS MỚI: Chỉ áp dụng cho .main-wrapper để căn giữa nó, không thay đổi body */
        .main-wrapper-container {
            display: flex;
            justify-content: center; /* Căn giữa theo chiều ngang */
            width: 100%;
            margin-top: 20px; /* Thêm khoảng cách với header */
        }

        /* Khung chứa toàn bộ nội dung */
        .main-wrapper {
            background-color: white;
            border: 1px solid #ccc;
            padding: 20px;
            width: 800px; /* Chiều rộng cố định như trong ảnh */
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 20px;
        }

        /* Form chính */
        #addComboForm {
            display: flex;
            flex-direction: column;
        }

        /* Vùng Tên Combo (Top-right) */
        .combo-name-container {
            display: flex;
            justify-content: flex-end; /* Đẩy về bên phải */
            margin-bottom: 20px;
        }

        .combo-name-container input[type="text"] {
            padding: 5px;
            border: 1px solid black; /* Viền đen như trong ảnh */
            width: 150px;
            text-align: center;
            box-sizing: border-box; /* Giúp padding không làm tăng kích thước tổng */
        }

        /* Container 2 cột chính */
        .main-content-container {
            display: flex;
            gap: 15px; /* Khoảng cách giữa 2 cột */
        }

        /* Cột bên trái: List Dish of Combo */
        .list-dish-panel {
            flex: 1; /* Chiếm 1 phần */
            border: 1px solid black;
            padding: 10px;
            min-height: 300px; /* Tạo chiều cao tối thiểu */
        }

        /* Cột bên phải: Search Area */
        .search-area-panel {
            flex: 1; /* Chiếm 1 phần */
            border: 1px solid black;
            padding: 10px;
        }

        /* Tiêu đề của Panel (tùy chỉnh để khớp với ảnh, dùng div thay vì h2) */
        .panel-title {
            font-weight: bold;
            text-align: center;
            margin-bottom: 10px;
        }

        /* Bảng */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        .list-dish-panel table {
            border: none;
        }

        .list-dish-panel th, .list-dish-panel td {
            border: 1px solid black;
            padding: 5px;
            text-align: center;
        }

        .search-area-panel table {
            border: 1px solid black; /* Viền ngoài cho bảng search */
        }

        .search-area-panel th, .search-area-panel td {
            border: none;
            border-bottom: 1px solid black;
            padding: 5px;
            text-align: left;
        }

        .search-area-panel tr:last-child td {
            border-bottom: none;
        }

        .search-area-panel th:nth-child(3), .search-area-panel td:nth-child(3) {
            text-align: right; /* Căn phải cho cột Action/Thêm */
        }

        /* Vùng tìm kiếm */
        .search-input-group {
            display: flex;
            gap: 5px;
            margin-bottom: 10px;
        }

        .search-input-group input {
            flex-grow: 1;
            padding: 5px;
            border: 1px solid black;
        }

        .search-input-group button {
            padding: 5px 10px;
            border: 1px solid black;
            background-color: white;
            cursor: pointer;
        }

        /* Cột Action trong bảng tìm kiếm (dòng Add) */
        .search-results-table .action-cell {
            text-align: right;
        }

        .search-results-table .action-cell button {
            padding: 5px 10px;
            border: 1px solid black;
            background-color: white;
            cursor: pointer;
        }

        /* Nút Submit và Price cuối trang */
        .bottom-actions {
            display: flex;
            justify-content: flex-start; /* Nút Submit và Price ở bên trái */
            align-items: center;
            margin-top: 20px;
            gap: 15px;
        }

        /* CSS cho nút Submit */
        .bottom-actions button[type="submit"] {
            padding: 8px 20px;
            background-color: #4c8ffb; /* Màu xanh submit */
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 3px;
            font-weight: bold;
        }

        /* CSS MỚI: Định dạng Input Price theo yêu cầu */
        #comboPriceInput {
            display: block !important; /* HIỂN THỊ LẠI INPUT */
            padding: 5px;
            border: 1px solid black;
            width: 100px;
            text-align: left;
            box-sizing: border-box;
            /* Xóa các thuộc tính ẩn trước đó */
            outline: initial;
        }

        /* Ẩn các label cũ không cần thiết, trừ input price đã được hiển thị lại */
        #addComboForm > label[for="comboNameInput"],
        #addComboForm > label[for="comboPriceInput"] {
            display: none;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />

<div class="main-wrapper-container">
    <div class="main-wrapper">
        <h1>Add Combo View</h1>

        <form action="<%=request.getContextPath()%>/combo" method="POST" id="addComboForm">
            <input type="hidden" name="action" value="add">

            <div class="combo-name-container">
                <input type="text" id="comboNameInput" name="comboname" placeholder="Combo name" value="${param.comboname}" required>
            </div>

            <div class="main-content-container">

                <div class="list-dish-panel">
                    <div class="panel-title">List Dish of Combo</div>
                    <table>
                        <thead>
                        <tr>
                            <th>Dish</th>
                            <th>Price</th>
                            <th>Amount</th>
                        </tr>
                        </thead>
                        <tbody id="selectedDishTableBody">
                        <c:forEach var="entry" items="${selectedDishMap}">
                            <tr>
                                <td>${entry.key.dishname}</td>
                                <td>
                                    <fmt:formatNumber value="${entry.key.dishprice}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                </td>
                                <td>
                                    <input type="number"
                                           class="dish-quantity"
                                           data-dish-id="${entry.key.id}"
                                           value="${entry.value}"
                                           min="1"
                                           style="width: 50px; border: 1px solid black; text-align: center;"
                                           onchange="updateQuantity(${entry.key.id}, this.value)">
                                    <button type="button" onclick="removeDish(${entry.key.id})" style="border: 1px solid black; background: white;">X</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty selectedDishMap}">
                            <tr><td colspan="3">Chưa có món ăn nào được thêm.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="search-area-panel">
                    <div class="search-input-group">
                        <input type="text" id="dishNameInput" placeholder="Dish name" value="${param.searching_token}">
                        <button type="button" onclick="searchDishes()">Find</button>
                    </div>

                    <table class="search-results-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Dish</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody id="searchResultsTableBody">
                        <c:if test="${not empty searchResultList}">
                            <c:forEach var="dish" items="${searchResultList}">
                                <tr>
                                    <td>${dish.id}</td>
                                    <td>${dish.dishname}</td>
                                    <td class="action-cell">
                                        <button type="button" onclick="addDishToCombo(${dish.id})">Add</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty searchResultList}">
                            <tr>
                                <td></td>
                                <td></td>
                                <td class="action-cell">
                                    <button type="button" style="visibility: hidden;">Add</button> </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="bottom-actions">
                <button type="submit">Submit</button>

                <input type="number" step="0.01" id="comboPriceInput" name="comboprice" placeholder="Price" value="${param.comboprice}" required>
            </div>


            <c:if test="${not empty successMessage}">
                <p style="color: green; margin-top: 10px;">${successMessage}</p>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <p style="color: red; margin-top: 10px;">${errorMessage}</p>
            </c:if>
        </form>
    </div>
</div>

<script>
    // --- JavaScript & AJAX Logic (KHÔNG THAY ĐỔI) ---

    // 1. Hàm tìm kiếm món ăn (Gửi AJAX tới DishServlet)
    function searchDishes() {
        var dishName = $('#dishNameInput').val();

        // Gửi yêu cầu AJAX đến DishServlet
        $.ajax({
            url: "<%= request.getContextPath()%>/dish",
            type: "GET",
            data: {
                searching_token: dishName,
                // Thêm tham số đặc biệt để servlet biết chỉ trả về JSON
                ajax_request: true
            },
            dataType: "json",
            success: function(response) {
                // Xử lý dữ liệu JSON trả về và cập nhật bảng kết quả
                updateSearchResults(response);
            },
            error: function(xhr, status, error) {
                console.error("AJAX Search Error: " + error);
                alert("Lỗi tìm kiếm món ăn.");
            }
        });
    }

    // 2. Cập nhật bảng kết quả tìm kiếm (Sau khi nhận JSON từ DishServlet)
    function updateSearchResults(dishList) {
        var tableBody = $('#searchResultsTableBody');
        tableBody.empty(); // Xóa kết quả cũ

        if (dishList && dishList.length > 0) {
            console.log("Dữ liệu nhận được:", dishList);
            $.each(dishList, function(i, dish) {
                console.log("dish object:", dish);
                // Lưu ý: dùng backtick (`) và \${...} trong JavaScript để chèn biến.
                var rowHTML = `<tr>
                                <td>\${dish.id}</td>
                                <td>\${dish.dishname}</td>
                                <td class="action-cell"><button type="button" onclick="addDishToCombo(\${dish.id})">Add</button></td>
                           </tr>`;
                tableBody.append($(rowHTML));
            });
        } else {
            // Thêm hàng trống với nút Add ẩn để giữ bố cục
            tableBody.append(`<tr>
                                <td></td>
                                <td></td>
                                <td class="action-cell">
                                    <button type="button" style="visibility: hidden;">Add</button>
                                </td>
                            </tr>`);
        }
    }

    // 3. Thêm món ăn vào Combo (Gửi Form/AJAX tới ComboServlet để lưu vào Session)
    function addDishToCombo(dishId) {
        // Đơn giản nhất: Gửi một request tới ComboServlet để xử lý logic session
        window.location.href = "<%=request.getContextPath()%>/combo?action=add_dish&dishId=" + dishId;
    }

    // 4. Xóa món ăn khỏi Combo
    function removeDish(dishId) {
        window.location.href = "<%=request.getContextPath()%>/combo?action=remove_dish&dishId=" + dishId;
    }

    // 5. Cập nhật số lượng món ăn trong Combo
    function updateQuantity(dishId, quantity) {
        window.location.href = "<%=request.getContextPath()%>/combo?action=update_quantity&dishId=" + dishId + "&quantity=" + quantity;
    }
    // Logic alert giữ nguyên
    <c:if test="${not empty successMessage}">
    alert("${successMessage}");
    setTimeout(function() {
        window.location.href = "<%=request.getContextPath()%>/combo";
    });
    </c:if>

    <c:if test="${not empty errorMessage}">
    alert("${errorMessage}");
    setTimeout(function() {
        window.location.href = "<%=request.getContextPath()%>/combo";
    });
    </c:if>
</script>

</body>
</html>