<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Account Verified</title>
    <link rel="stylesheet" href="https://cdn.tailwindcss.com">
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">

    <div class="bg-white p-10 rounded-xl shadow-lg text-center w-full max-w-md">
        <h1 class="text-3xl font-bold text-green-600 mb-4">Welcome!</h1>
        <p class="text-gray-700 text-lg mb-6">
            Your account has been successfully verified.  
            You can now log in and start using your account.
        </p>

        <a href="login.jsp" 
           class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
           Go to Login
        </a>
    </div>

</body>
</html>
