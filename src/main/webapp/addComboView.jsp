<%--
  Created by IntelliJ IDEA.
  User: lehuy
  Date: 10/28/2025
  Time: 1:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  <html>
<%@ page import ="Model.Dish" %>
<%@ page import ="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Combo Mới</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        /* CSS tối giản để dễ hình dung */
        .container { display: flex; max-width: 900px; margin: 20px auto; gap: 20px; }
        .form-area, .search-area { border: 1px solid #ccc; padding: 15px; }
        .list-dish { width: 50%; }
        .search-results { width: 50%; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    </style>
</head>
<body>

<h1>Add Combo View</h1>

<form action="combo" method="POST" id="addComboForm">
    <input type="hidden" name="action" value="add">

    <label for="comboNameInput">Tên Combo:</label>
    <input type="text" id="comboNameInput" name="comboname" value="" required>

    <div class="container">

        <div class="list-dish form-area">
            <h2>Danh sách Món ăn của Combo</h2>
            <table>
                <thead>
                <tr>
                    <th>Món ăn</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody id="selectedDishTableBody">
                <c:forEach var="entry" items="${selectedDishMap}">
                    <tr>
                        <td>${entry.key.dishname}</td>
                        <td>${entry.key.dishprice}</td>
                        <td>
                            <input type="number"
                                   class="dish-quantity"
                                   data-dish-id="${entry.key.id}"
                                   value="${entry.value}"
                                   min="1"
                                   style="width: 50px;"
                                   onchange="updateQuantity(${entry.key.id}, this.value)">
                        </td>
                        <td>
                            <button type="button" onclick="removeDish(${entry.key.id})">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty selectedDishMap}">
                    <tr><td colspan="4">Chưa có món ăn nào được thêm.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <div class="search-results search-area">
            <h2>Tìm kiếm Món ăn</h2>
            <input type="text" id="dishNameInput" placeholder="Tên món ăn">
            <button type="button" onclick="searchDishes()">Tìm</button>

            <br><br>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Món ăn</th>
                    <th>Giá</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody id="searchResultsTableBody">
                <c:if test="${not empty searchResultList}">
                    <c:forEach var="dish" items="${searchResultList}">
                        <tr>
                            <td>${dish.id}</td>
                            <td>${dish.dishname}</td>
                            <td>${dish.dishprice}</td>
                            <td>
                                <button type="button" onclick="addDishToCombo(${dish.id})">Thêm</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <br>
    <label for="comboPriceInput">Giá Combo:</label>
    <input type="number" step="0.01" id="comboPriceInput" name="comboprice" required>

    <button type="submit">Submit</button>

    <c:if test="${not empty successMessage}">
        <p style="color: green;">${successMessage}</p>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <p style="color: red;">${errorMessage}</p>
    </c:if>
</form>

<script>
    // --- JavaScript & AJAX Logic ---

    // 1. Hàm tìm kiếm món ăn (Gửi AJAX tới DishServlet)
    function searchDishes() {
        var dishName = $('#dishNameInput').val();

        // Gửi yêu cầu AJAX đến DishServlet
        $.ajax({
            url: "dish",
            type: "GET",
            data: {
                searching_token: dishName,
                // Thêm tham số đặc biệt để servlet biết chỉ trả về JSON
                // Thay vì forward đến findingDishView.jsp
                ajax_request: true
            },
            dataType: "json",
            success: function(response) {
                //response la 1 chuoi JSON:
                /*

                :
                description : "Món nước truyền thống với bánh phở và thịt bò"
                dishname : "Phở Bò"
                dishprice : 45000
                id : 1
                 */
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
                // Nếu viết trong JSP, cần escape ký tự '$' để tránh bị JSP hiểu nhầm là EL.

                var rowHTML = `<tr>
                                <td>\${dish.id}</td>
                                <td>\${dish.dishname}</td>
                                <td>\${dish.dishprice}</td>
                                <td><button type="button" onclick="addDishToCombo(\${dish.id})">Thêm</button></td>
                           </tr>`;
                tableBody.append($(rowHTML));
            });
        } else {
            tableBody.append('<tr><td colspan="4">Không tìm thấy món ăn nào.</td></tr>');
        }
    }

    // 3. Thêm món ăn vào Combo (Gửi Form/AJAX tới ComboServlet để lưu vào Session)
    function addDishToCombo(dishId) {
        // Sử dụng Form Submission thay vì AJAX để tận dụng session và forward (đơn giản hơn)
        // Nếu dùng AJAX, ComboServlet cần trả về HTML/JSON để cập nhật list-dish table

        // Đơn giản nhất: Gửi một request tới ComboServlet để xử lý logic session
        window.location.href = "combo?action=add_dish&dishId=" + dishId;
    }

    // 4. Xóa món ăn khỏi Combo
    function removeDish(dishId) {
        window.location.href = "combo?action=remove_dish&dishId=" + dishId;
    }

    // 5. Cập nhật số lượng món ăn trong Combo
    function updateQuantity(dishId, quantity) {
        window.location.href = "combo?action=update_quantity&dishId=" + dishId + "&quantity=" + quantity;
    }

    // Load danh sách món ăn đã chọn khi trang load lần đầu (nếu có trong session)
    // Code hiển thị ban đầu đã được xử lý bằng JSTL (c:forEach)
</script>

<c:if test="${not empty successMessage}">
    <script>
        // Hiển thị popup thông báo
        alert("${successMessage}");

        // Quay lại trang addComboView.jsp sau khi bấm OK hoặc 5s (phòng trường hợp người không bấm OK)
        setTimeout(function() {
            window.location.href = "combo";
        }, 5000);
    </script>
</c:if>

<c:if test="${not empty errorMessage}">
    <script>
        alert("${errorMessage}");
        setTimeout(function() {
            window.location.href = "combo";
        }, 5000);
    </script>
</c:if>

</body>
</html>