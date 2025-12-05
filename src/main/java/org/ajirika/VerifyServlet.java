package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.baraza.DB.BDB;

@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String token = request.getParameter("token");

        // Clear token and expiry after successful verification
        String sql = "UPDATE signup_details SET is_active = TRUE, "
                + "verification_token = NULL, "
                + "token_expires_at = NULL "
                + "WHERE verification_token = ? "
                + "AND token_expires_at > NOW()";

        String dbConfig = "java:/comp/env/jdbc/database";
        BDB dbConn = new BDB(dbConfig);
        Connection conn = dbConn.getDB();

        try (
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, token);
            int updated = stmt.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("verification_success.jsp");
            } else {
                response.sendRedirect("verification_failed.jsp?reason=expired_or_invalid");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("verification_failed.jsp");
        }
    }
}
