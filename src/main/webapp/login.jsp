<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Tomcat Authentication</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            background: white;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            width: 320px;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #0078e7;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background: #005bb5;
        }
        .signup-link {
            text-align: center;
            margin-top: 15px;
        }
        .signup-link a {
            color: #0078e7;
            text-decoration: none;
        }
        .signup-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Login</h2>
    <form method="POST" action="j_security_check">
        <input type="text" name="j_username" placeholder="Username" required />
        <input type="password" name="j_password" placeholder="Password" required />
        <button type="submit">Login</button>
    </form>
    <div class="signup-link">
        Don't have an account? 
        <a href="jbseekerlanding.jsp" id="openSignupFromLogin">Sign Up</a>
    </div>
</div>

</body>
</html>
