package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.baraza.DB.BDB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signupForm")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstname = request.getParameter("firstname");
        String middlename = request.getParameter("middlename");
        String surname = request.getParameter("surname"); 
        String email = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password");

        if (firstname == null || surname == null || email == null || password == null ||
            firstname.trim().isEmpty() || surname.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("jbseekerlanding.jsp?error=missing_fields");
            return;
        }

        String dbConfig = "java:/comp/env/jdbc/database";
        BDB dbConn = new BDB(dbConfig);
        Connection conn = dbConn.getDB();

        String sql = "INSERT INTO applicants (first_name, middle_name, surname, applicant_email, applicant_password) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, firstname.trim());
            stmt.setString(2, middlename != null ? middlename.trim() : null);
            stmt.setString(3, surname.trim());
            stmt.setString(4, email);
            stmt.setString(5, password);

            stmt.executeUpdate();
            response.sendRedirect("jbseekerlanding.jsp?success=signup_successful");

        } catch (SQLException e) {
            e.printStackTrace();

            if (e.getSQLState() != null && e.getSQLState().startsWith("23")) {
                response.sendRedirect("jbseekerlanding.jsp?error=email_exists");
            } else {
                response.sendRedirect("jbseekerlanding.jsp?error=signup_failed");
            }
        } finally {
            dbConn.close();
        }
    }
}