
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  <html>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h1> Finding Dish View </h1>

    <div>
        <form action="dish" method="GET">
            <input type="text" name="searching_token">
            <button type="submit">Finding</button>
        </form>
    </div>

    <div>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Dish's name</th>
                <th>Price (VNĐ)</th>
            </tr>
            </thead>
            <tbody>
                <c:forEach var="dish" items="${dishList}">
                <tr>
                    <td> <c:out value="${dish.id}"></c:out> </td>
                    <td> <c:out value="${dish.dishname}"></c:out> </td>
                    <td> <c:out value="${dish.dishprice}"></c:out> </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div>
        <form action="customerView.jsp" method="GET">
            <button type="submit">Return</button>
        </form>
    </div>
</body>
</html>
