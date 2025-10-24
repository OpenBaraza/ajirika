package com.ajirika;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/submitForm")
public class SubmitFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String comment = request.getParameter("comment");

        String sql = "INSERT INTO submissions (role, name, email, comment) VALUES (?, ?, ?, ?)";

        try {
            // Load PostgreSQL JDBC driver before creating the connection
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(
                        "jdbc:postgresql://localhost:5432/ajirika_db",
                        "andrew_ajirika",
                        null);  // no password
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, role);
                stmt.setString(2, name);
                stmt.setString(3, email);
                stmt.setString(4, comment);
                stmt.executeUpdate();

                System.out.println("Data inserted successfully!");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirect after submission
        response.sendRedirect("index.jsp?success=true");
    }
}

