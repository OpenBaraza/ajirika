package org.processCV;

import java.io.*;
import java.nio.file.*;
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

    // Custom PrintStream to capture logs
    private static class LogCaptureStream extends OutputStream {
        private final StringBuilder buffer = new StringBuilder();
        
        @Override
        public void write(int b) {
            buffer.append((char) b);
        }
        
        public String getLogs() {
            return buffer.toString();
        }
        
        public void clear() {
            buffer.setLength(0);
        }
    }

    private String getLoggedInUserId(HttpServletRequest request) {
        try {
            String username = request.getUserPrincipal().getName();
            System.out.println("Logged in user from uploadProcess: " + username);

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

        // Create log capture stream
        LogCaptureStream logStream = new LogCaptureStream();
        PrintStream logPrintStream = new PrintStream(logStream, true);
        
        // Save original System.out
        PrintStream originalOut = System.out;
        
        try {
            // Redirect System.out to capture logs
            System.setOut(logPrintStream);
            
            Part filePart = request.getPart("cvFile");
            if (filePart == null || filePart.getSize() == 0) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "No file uploaded");
                errorResponse.put("logs", logStream.getLogs());
                out.print(errorResponse.toString());
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
            Files.deleteIfExists(tempDir);

            // === 4. Send JSON response with logs ===
            JSONObject responseObj = new JSONObject();
            responseObj.put("data", result);
            responseObj.put("logs", logStream.getLogs());
            out.print(responseObj.toString(2));

        } catch (Exception ex) {
            ex.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "Processing failed: " + ex.getMessage());
            errorResponse.put("logs", logStream.getLogs());
            out.print(errorResponse.toString());
        } finally {
            // Restore original System.out
            System.setOut(originalOut);
            out.close();
        }
    }
}