package org.ajirika;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.baraza.DB.BDB;
import org.json.JSONObject;
import org.processCV.CVImportHelper;
import org.processCV.breakdownCV;
import org.processCV.readCV;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize = 1024 * 1024 * 10,
                 maxRequestSize = 1024 * 1024 * 50)
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
            firstname.trim().isEmpty() || surname.trim().isEmpty() ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("jbseekerlanding.jsp?error=missing_fields");
            return;
        }

        BDB dbConn = new BDB("java:/comp/env/jdbc/database");
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

            // Optional CV upload
            try {
                Part cvPart = request.getPart("cvFile");
                if (cvPart != null && cvPart.getSize() > 0) {
                    String fileName = Paths.get(cvPart.getSubmittedFileName()).getFileName().toString();
                    Path tempDir = Files.createTempDirectory("cv_signup_");
                    Path tempFile = tempDir.resolve(fileName);
                    try (InputStream in = cvPart.getInputStream();
                         FileOutputStream out = new FileOutputStream(tempFile.toFile())) {
                        byte[] buf = new byte[1024];
                        int n;
                        while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
                    }
                    readCV reader = new readCV();
                    String rawText = reader.read(tempFile.toString());
                    breakdownCV parser = new breakdownCV();
                    JSONObject cvResult = parser.extractCVData(rawText);
                    CVImportHelper.saveForNewUser(dbConn, email, cvResult);
                    Files.deleteIfExists(tempFile);
                    Files.deleteIfExists(tempDir);
                }
            } catch (Exception cvEx) {
                // If CV processing fails registration still succeeds
                cvEx.printStackTrace();
            }

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