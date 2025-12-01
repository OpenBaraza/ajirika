package org.ajirika;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/loginForm")
public class LoginServlet extends HttpServlet {
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    User user = Database.getUserByEmail(email);

    if (user != null && password.equals(user.getPassword())) {
      // Set session
      HttpSession session = request.getSession();
      session.setAttribute("user", user);
      response.getWriter().write("success");
    } else {
      // Invalid login
      request.setAttribute("loginError", true);
      response.getWriter().write("fail");
    }
  }
}
