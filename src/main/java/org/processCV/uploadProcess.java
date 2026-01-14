package org.processCV;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import org.json.JSONObject;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
                 maxFileSize = 1024 * 1024 * 10,      // 10 MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50 MB
@WebServlet("/processCV")
public class uploadProcess extends HttpServlet {
    BDB db = null;
    String orgId = "0";
    String userID = "0";

    private String getLoggedInUserId(HttpServletRequest request) {
        try {
            String username = request.getUserPrincipal().getName();
            System.out.println("Logged in user from uploadProcess: " + username);

            // ⚠️ SECURITY: Use parameterized query in production!
            String sql = "SELECT entity_id FROM entitys WHERE user_name = '" + username + "'";
            BQuery rs = new BQuery(db, sql);

            if (rs.moveNext()) {
                return rs.getString("entity_id");
            } else {
                System.out.println("No entity found for username: " + username);
                return "-1";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "-1";
        }
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        db = new BDB("java:/comp/env/jdbc/database");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (!db.isValid()) db.reconnect("java:/comp/env/jdbc/database");

        userID = getLoggedInUserId(request);
        System.out.println("Resolved userID in uploadProcess = " + userID);

        if (orgId == null) orgId = "0";
        if (userID == null) userID = "-1";

        try {
            Part filePart = request.getPart("cvFile");
            if (filePart == null || filePart.getSize() == 0) {
                out.print(new JSONObject().put("error", "No file uploaded").toString());
                return;
            }

            // === 1. Save uploaded file to temp location ===
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            Path tempDir = Files.createTempDirectory("cv_upload_");
            Path tempFile = tempDir.resolve(originalFileName);
            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(tempFile.toFile())) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            System.out.println("Saved to: " + tempFile);

            // === 2. Process CV ===
            readCV reader = new readCV();
            String rawText = reader.read(tempFile.toString());

            breakdownCV parser = new breakdownCV();
            JSONObject result = parser.extractCVData(rawText);

            // === 3. Clean up temp file ===
            Files.deleteIfExists(tempFile);
            Files.deleteIfExists(tempDir); // only works if empty

            // === 4. Send JSON response ===
            out.print(result.toString(2)); // pretty-print for debugging

        } catch (Exception ex) {
            ex.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Processing failed: " + ex.getMessage());
            out.print(error.toString());
        } finally {
            out.close();
        }
    }
}