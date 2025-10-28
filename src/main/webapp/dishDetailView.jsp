<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  <html>
<html>
<head>
    <title>Dish Detail View</title>
</head>
<body>
<h1> Dish Detail View </h1>

<div>
    <table border="1" style="border-collapse: collapse; width: 600px;">
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
                <td><c:out value="${dishDetail.dishprice}"/></td>
                <td><c:out value="${dishDetail.description}"/></td>
            </tr>
        </c:if>
        <c:if test="${dishDetail == null}">
            <tr><td colspan="4">Dish not found.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>

<div style="margin-top: 50px; text-align: right;">
    <form action="FindingDishView.jsp" method="GET">
        <button type="submit">Return</button>
    </form>
</div>
</body>
</html>
