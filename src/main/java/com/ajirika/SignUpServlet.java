package com.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signupForm")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:postgresql://sandbox:5432/ajirika";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Invent2k";

    //private static final String URL = "jdbc:postgresql://localhost:5432/your_database";
    //private static final String USER = "your_username";
    //private static final String PASSWORD = "your_password";


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstname = request.getParameter("firstname");
        String middlename = request.getParameter("middlename");
        String lastname = request.getParameter("lastname");
        String phonenumber = request.getParameter("phonenumber");
        String email = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password");

        // Basic null/empty check
        if (firstname == null || email == null || password == null ||
            firstname.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("jbseekerlanding.jsp?error=missing_fields");
            return;
        }

        String sql = "INSERT INTO signup_details (firstname, middlename, lastname, phonenumber, email, password) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, firstname);
                stmt.setString(2, middlename);
                stmt.setString(3, lastname);
                stmt.setString(4, phonenumber);
                stmt.setString(5, email);
                stmt.setString(6, password);

                stmt.executeUpdate();

                response.sendRedirect("jbseekerlanding.jsp?success=true");

            } catch (SQLException e) {
                // Check for duplicate email (UNIQUE violation)
                if (e.getSQLState() != null && e.getSQLState().startsWith("23")) { // 23 = integrity constraint violation
                    response.sendRedirect("jbseekerlanding.jsp?error=email_exists");
                } else {
                    e.printStackTrace();
                    response.sendRedirect("jbseekerlanding.jsp?error=signup_failed");
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("jbseekerlanding.jsp?error=db_driver_missing");
        }
    }
}