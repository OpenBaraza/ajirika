package org.processCV;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import org.json.JSONArray;
import org.json.JSONObject;

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
@WebServlet("/annotateCV/*")
public class annotateCV extends HttpServlet {

    private static final String TRAIN_FILE =
        "/home/upao/Documents/ATTACHEMENT/ajirika/ner-training/cv-train.tsv";
    
    private static final java.util.regex.Pattern VALID_LABEL =
        java.util.regex.Pattern.compile("^(O|[BI]-(PERSON|JOB_TITLE|DEGREE|ORGANIZATION))$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String path = request.getPathInfo();

        try {
            if ("/tokenize".equals(path)) {
                handleTokenize(request, out);
            } else if ("/export".equals(path)) {
                handleExport(request, out);
            } else {
                response.setStatus(404);
                out.print(new JSONObject().put("error", "Unknown action: " + path).toString());
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            JSONObject err = new JSONObject();
            err.put("error", ex.getMessage() == null ? ex.toString() : ex.getMessage());
            out.print(err.toString());
        } finally {
            out.close();
        }
    }

    private void handleTokenize(HttpServletRequest request, PrintWriter out) throws Exception {
        Part filePart = request.getPart("cvFile");
        if (filePart == null || filePart.getSize() == 0) {
            out.print(new JSONObject().put("error", "No file uploaded").toString());
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        Path tempDir = Files.createTempDirectory("cv_annotate_");
        Path tempFile = tempDir.resolve(originalFileName);
        try (InputStream input = filePart.getInputStream();
             FileOutputStream output = new FileOutputStream(tempFile.toFile())) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) output.write(buffer, 0, bytesRead);
        }

        readCV reader = new readCV();
        String rawText = reader.read(tempFile.toString());

        breakdownCV parser = new breakdownCV();
        JSONArray segments = parser.tokenizeForAnnotation(rawText);

        Files.deleteIfExists(tempFile);
        Files.deleteIfExists(tempDir);

        JSONObject data = new JSONObject();
        data.put("segments", segments);
        JSONObject responseObj = new JSONObject();
        responseObj.put("data", data);
        out.print(responseObj.toString());
    }

    private void handleExport(HttpServletRequest request, PrintWriter out) throws Exception {
        StringBuilder bodyBuilder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) bodyBuilder.append(line);
        }

        JSONObject payload = new JSONObject(bodyBuilder.toString());
        JSONArray segments = payload.getJSONArray("segments");

        StringBuilder tsv = new StringBuilder();
        int tokenCount = 0;

        for (int s = 0; s < segments.length(); s++) {
            JSONObject seg = segments.getJSONObject(s);
            JSONArray tokens = seg.getJSONArray("tokens");
            JSONArray labels = seg.getJSONArray("labels");

            if (tokens.length() != labels.length()) {
                out.print(new JSONObject().put("error",
                    "Segment " + s + ": token/label count mismatch").toString());
                return;
            }

            for (int i = 0; i < tokens.length(); i++) {
                String token = tokens.getString(i);
                String label = labels.getString(i);
                if (!VALID_LABEL.matcher(label).matches()) {
                    out.print(new JSONObject().put("error",
                        "Segment " + s + " token " + i + ": invalid label '" + label + "'").toString());
                    return;
                }
                tsv.append(token).append('\t').append(label).append('\n');
                tokenCount++;
            }
            tsv.append('\n');
        }

        synchronized (annotateCV.class) {
            Path trainPath = Paths.get(TRAIN_FILE);
            String prefix = "";
            if (Files.exists(trainPath) && Files.size(trainPath) > 0) {
                try (java.io.RandomAccessFile raf = new java.io.RandomAccessFile(trainPath.toFile(), "r")) {
                    raf.seek(raf.length() - 1);
                    if (raf.read() != '\n') prefix = "\n";
                }
            }
            Files.writeString(trainPath, prefix + tsv.toString(),
                StandardOpenOption.CREATE, StandardOpenOption.APPEND);
        }

        long totalTokens;
        try (var lineStream = Files.lines(Paths.get(TRAIN_FILE))) {
            totalTokens = lineStream.filter(l -> !l.isBlank()).count();
        }

        JSONObject data = new JSONObject();
        data.put("appendedSegments", segments.length());
        data.put("appendedTokens", tokenCount);
        data.put("totalFileTokens", totalTokens);
        JSONObject responseObj = new JSONObject();
        responseObj.put("data", data);
        out.print(responseObj.toString());
    }
}