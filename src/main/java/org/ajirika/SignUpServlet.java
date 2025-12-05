package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.baraza.DB.BDB;

@WebServlet("/signupForm")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstname = request.getParameter("firstname");
        String middlename = request.getParameter("middlename");
        String lastname = request.getParameter("lastname");
        String countryCode = request.getParameter("countryCode"); 
        String phonenumber = request.getParameter("phonenumber");
        String email = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password");

        // Basic null/empty check
        if (firstname == null || email == null || password == null ||
            firstname.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("jbseekerlanding.jsp?error=missing_fields");
            return;
        }

        String token = UUID.randomUUID().toString();
        Timestamp expiry = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // +5 minutes

        String sql = "INSERT INTO signup_details (firstname, middlename, lastname, country_code, phonenumber, email, password, verification_token, token_expires_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String dbConfig = "java:/comp/env/jdbc/database";
        BDB dbConn = new BDB(dbConfig);
        Connection conn = dbConn.getDB();

        try {

            try (
                PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, firstname);
                stmt.setString(2, middlename);
                stmt.setString(3, lastname);
                stmt.setString(4, countryCode);
                stmt.setString(5, phonenumber);
                stmt.setString(6, email);
                stmt.setString(7, password);
                stmt.setString(8, token);
                stmt.setTimestamp(9, expiry);

                stmt.executeUpdate();

                // 🔹 Dynamically build the base URL (works in dev & production)
                String baseUrl = request.getScheme() + "://" + request.getServerName()
                        + (request.getServerPort() != 80 && request.getServerPort() != 443
                        ? ":" + request.getServerPort()
                        : "")
                        + request.getContextPath();

                String verificationLink = baseUrl + "/verify?token=" + token;

                response.sendRedirect("jbseekerlanding.jsp?success=verification_sent");

            } catch (SQLException e) {
                // Check for duplicate email (UNIQUE violation)
                if (e.getSQLState() != null && e.getSQLState().startsWith("23")) { // 23 = integrity constraint violation
                    response.sendRedirect("jbseekerlanding.jsp?error=email_exists");
                } else {
                    e.printStackTrace();
                    response.sendRedirect("jbseekerlanding.jsp?error=signup_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jbseekerlanding.jsp?error=signup_failed");
        }
    }
}
