package org.processCV;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.json.JSONObject;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.processCV.CVImportHelper;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
                 maxFileSize = 1024 * 1024 * 10,      // 10 MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50 MB
@WebServlet("/processCV")
public class uploadProcess extends HttpServlet {
    BDB db = null;
    String orgId = "0";
    String userID = "0";

    private static final ThreadLocal<StringBuilder> REQUEST_LOG = new ThreadLocal<>();

    private static class ThreadLocalPrintStream extends PrintStream {
        public ThreadLocalPrintStream(PrintStream base) { super(base, true); }

        @Override
        public void println(String s) {
            StringBuilder buf = REQUEST_LOG.get();
            if (buf != null) buf.append(s == null ? "null" : s).append('\n');
            else super.println(s);
        }

        @Override
        public void print(String s) {
            StringBuilder buf = REQUEST_LOG.get();
            if (buf != null) buf.append(s == null ? "null" : s);
            else super.print(s);
        }

        @Override
        public void write(byte[] b, int off, int len) {
            StringBuilder buf = REQUEST_LOG.get();
            if (buf != null) buf.append(new String(b, off, len, StandardCharsets.UTF_8));
            else super.write(b, off, len);
        }
    }

    private String getLoggedInUserId(HttpServletRequest request) {
        try {
            String username = request.getUserPrincipal().getName();

            if (username == null || !username.matches("[a-zA-Z0-9@._\\-]+")) {
                System.out.println("Rejected unsafe username format");
                return "-1";
            }

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
        System.setOut(new ThreadLocalPrintStream(System.out));
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                try {
                    userID = getLoggedInUserId(request);
                } catch (Exception e) {
                    userID = "-1";
                }
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (db != null && !db.isValid()) db.reconnect("java:/comp/env/jdbc/database");

        userID = getLoggedInUserId(request);
        System.out.println("Resolved userID in uploadProcess = " + userID);

        if (orgId == null) orgId = "0";
        if (userID == null) userID = "-1";

        StringBuilder logBuffer = new StringBuilder();
        REQUEST_LOG.set(logBuffer);

        try {
            
            Part filePart = request.getPart("cvFile");
            if (filePart == null || filePart.getSize() == 0) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "No file uploaded");
                errorResponse.put("logs", logBuffer.toString());
                out.print(errorResponse.toString());
                return;
            }

            // Save uploaded file to temp location
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

            // Process CV
            readCV reader = new readCV();
            String rawText = reader.read(tempFile.toString());

            breakdownCV parser = new breakdownCV();
            JSONObject result = parser.extractCVData(rawText);

            // Save to profile DB if user is authenticated
            boolean cvImported = false;
            if (!"-1".equals(userID) && db != null && db.isValid()) {
                cvImported = CVImportHelper.saveForLoggedInUser(db, orgId, userID, result);
            }
            result.put("cv_imported", cvImported);

            // Clean up temp file
            Files.deleteIfExists(tempFile);
            Files.deleteIfExists(tempDir);

            // Send JSON response with logs
            JSONObject responseObj = new JSONObject();
            responseObj.put("data", result);
            responseObj.put("logs", logBuffer.toString());
            out.print(responseObj.toString(2));

        } catch (Exception ex) {
            ex.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "Processing failed: " + ex.getMessage());
            errorResponse.put("logs", logBuffer.toString());
            out.print(errorResponse.toString());
        } finally {
            REQUEST_LOG.remove();
            out.close();
        }
    }
}
