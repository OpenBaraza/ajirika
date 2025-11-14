<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verification Failed</title>
    <link rel="stylesheet" href="https://cdn.tailwindcss.com">
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">

    <div class="bg-white p-10 rounded-xl shadow-lg text-center w-full max-w-md">
        <h1 class="text-3xl font-bold text-red-600 mb-4">❌ Verification Failed</h1>
        <p class="text-gray-700 text-lg mb-6">
            The verification link may be invalid or already used.
        </p>

        <form action="resendVerification" method="post">
            <input type="email" name="email" placeholder="Enter your email" required>
            <button type="submit">Resend Verification Email</button>
        </form>


        <a href="jbseekerlanding.jsp" 
           class="bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition">
           Return to Home
        </a>
    </div>

</body>
</html>
