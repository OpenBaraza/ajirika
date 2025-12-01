package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/checkEmail")
public class EmailCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        boolean exists = false;

        if (email != null && !email.trim().isEmpty()) {

            String dbConfig = "java:/comp/env/jdbc/database";
            DatabaseConnection dbConn = new DatabaseConnection(dbConfig);
            Connection conn = dbConn.getConnection();

            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT 1 FROM signup_details WHERE email = ? LIMIT 1")) {
                    ps.setString(1, email.trim().toLowerCase());
                    try (ResultSet rs = ps.executeQuery()) {
                        exists = rs.next();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(exists ? "exists" : "available");
    }
}

