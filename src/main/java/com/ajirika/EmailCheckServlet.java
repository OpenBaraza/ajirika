package com.ajirika;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/checkEmail")
public class EmailCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:postgresql://sandbox:5432/ajirika";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Invent2k";

    //private static final String URL = "jdbc:postgresql://localhost:5432/your_database";
    //private static final String USER = "your_username";
    //private static final String PASSWORD = "your_password";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        boolean exists = false;

        if (email != null && !email.trim().isEmpty()) {
            try {
                Class.forName("org.postgresql.Driver");
                try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                     PreparedStatement ps = conn.prepareStatement(
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

