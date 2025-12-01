package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/resendVerification")
public class ResendVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email").trim().toLowerCase();

        if (email == null || email.isEmpty()) {
            response.sendRedirect("jbseekerlanding.jsp?error=missing_email");
            return;
        }

        String checkSql = "SELECT id, firstname, is_active FROM signup_details WHERE email = ?";
        String dbConfig = "java:/comp/env/jdbc/database";
        DatabaseConnection dbConn = new DatabaseConnection(dbConfig);
        Connection conn = dbConn.getConnection();

        try (
            PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                boolean isActive = rs.getBoolean("is_active");
                String firstname = rs.getString("firstname");
                int userId = rs.getInt("id");

                if (isActive) {
                    // Already verified
                    response.sendRedirect("jbseekerlanding.jsp?info=already_verified");
                    return;
                }

                // Generate new token
                String newToken = UUID.randomUUID().toString();
                Timestamp newExpiry = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5 mins

                String updateSql = "UPDATE signup_details SET verification_token = ?, token_expires_at = ? WHERE id = ?";

                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, newToken);
                    updateStmt.setTimestamp(2, newExpiry);
                    updateStmt.setInt(3, userId);

                    updateStmt.executeUpdate();
                }

                // Build verification link dynamically
                String baseUrl = request.getScheme() + "://" + request.getServerName()
                        + (request.getServerPort() != 80 && request.getServerPort() != 443
                        ? ":" + request.getServerPort()
                        : "")
                        + request.getContextPath();
                String verificationLink = baseUrl + "/verify?token=" + newToken;

                // Send email
                EmailUtil.sendEmail(email, "Resend: Confirm Your Account",
                        "Hello " + firstname + ",\n\n" +
                        "You requested a new verification link.\n" +
                        "Click the link below to verify your email:\n" +
                        verificationLink + "\n\n" +
                        "Ajirika Team");

                response.sendRedirect("jbseekerlanding.jsp?success=verification_resent");

            } else {
                // Email not found
                response.sendRedirect("jbseekerlanding.jsp?error=email_not_found");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("jbseekerlanding.jsp?error=server_error");
        }
    }
}
