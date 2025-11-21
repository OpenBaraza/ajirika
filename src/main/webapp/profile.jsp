<%@ page import="com.ajirika.User" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp"); // or modal
        return;
    }

    String email = user.getEmail();
    String firstname = user.getFirstname();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
</head>
<body>
    <h1>Welcome, <%= firstname %>!</h1>
</body>
</html>


