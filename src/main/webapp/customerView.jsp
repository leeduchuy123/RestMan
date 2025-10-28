
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession currentSession = request.getSession(false);

    if(currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String username = (String) currentSession.getAttribute("username");
%>
<html>
<head>
    <title>Customer View</title>
</head>
<body>
    <h1>WELCOME CUSTOMER: <%= username %></h1>
    <li>
        <ul><a href="${pageContext.request.contextPath}/dish">Finding Dish</a></ul>
        <ul><a href="#">Order Table</a></ul>
        <ul><a href="#">Order Dish</a></ul>
    </li>
</body>
</html>
