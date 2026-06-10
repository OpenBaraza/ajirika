package org.processCV;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

public class analyzeHeaders {

    public static List<String> expHeadersList = new ArrayList<>();
    public static List<String> eduHeadersList = new ArrayList<>();
    public static List<String> skillsHeadersList = new ArrayList<>();
    public static List<String> refHeadersList = new ArrayList<>();

    private static final List<String> EXP_KEYWORDS = Arrays.asList(
        "experience", "employment", "work history", "career", "professional background",
        "positions held", "work experience", "job history"
    );
    private static final List<String> EDU_KEYWORDS = Arrays.asList(
        "education", "academic", "qualifications", "studies", "training",
        "certifications", "degrees", "academic background"
    );
    private static final List<String> SKILLS_KEYWORDS = Arrays.asList(
        "skills", "competencies", "expertise", "technical skills", "abilities",
        "proficiencies", "tools", "technologies", "core competencies"
    );
    private static final List<String> REF_KEYWORDS = Arrays.asList(
        "references", "referees", "reference", "available upon request"
    );

    breakdownCV bCV;

    public analyzeHeaders() {
        // No models to load
    }

    public String parseHeaders(String cvText) {
        StringBuffer sb = new StringBuffer();
        bCV = new breakdownCV();

        expHeadersList.clear();
        eduHeadersList.clear();
        skillsHeadersList.clear();
        refHeadersList.clear();

        String[] lines = cvText.split("\\r?\\n");

        sb.append("--- Header Detection (Rule-Based) ---");

        for (String line : lines) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;

            String lower = trimmed.toLowerCase();

            // Only consider short lines as potential headers
            if (trimmed.length() > 60) continue;

            for (String kw : EXP_KEYWORDS) {
                if (lower.contains(kw)) {
                    expHeadersList.add(trimmed);
                    sb.append("\n  EXP-HEADER: " + trimmed);
                    System.out.println("Identified Exp Header: " + trimmed);
                    break;
                }
            }
            for (String kw : EDU_KEYWORDS) {
                if (lower.contains(kw)) {
                    eduHeadersList.add(trimmed);
                    sb.append("\n  EDU-HEADER: " + trimmed);
                    System.out.println("Identified Edu Header: " + trimmed);
                    break;
                }
            }
            for (String kw : SKILLS_KEYWORDS) {
                if (lower.contains(kw)) {
                    skillsHeadersList.add(trimmed);
                    sb.append("\n  SKILL-HEADER: " + trimmed);
                    System.out.println("Identified Skill Header: " + trimmed);
                    break;
                }
            }
            for (String kw : REF_KEYWORDS) {
                if (lower.contains(kw)) {
                    refHeadersList.add(trimmed);
                    sb.append("\n  REF-HEADER: " + trimmed);
                    System.out.println("Identified Ref Header: " + trimmed);
                    break;
                }
            }
        }

        Map<String, List<String>> allHeaders = new HashMap<>();
        allHeaders.put("experience", new ArrayList<>(expHeadersList));
        allHeaders.put("education", new ArrayList<>(eduHeadersList));
        allHeaders.put("skills", new ArrayList<>(skillsHeadersList));
        allHeaders.put("references", new ArrayList<>(refHeadersList));

        System.out.println("All Exp Headers: " + allHeaders.get("experience"));
        System.out.println("All Edu Headers: " + allHeaders.get("education"));
        System.out.println("All Skills Headers: " + allHeaders.get("skills"));
        System.out.println("All Ref Headers: " + allHeaders.get("references"));

        sb.append("\n------------------------\n");

        JSONObject cvInfo = bCV.identifySections(allHeaders, cvText);
        System.out.println("From analyzeHeaders: " + cvInfo.toString(2));

        return sb.toString();
    }

    // Retained for API compatibility with App.java — no-op
    public void trainHeaderModel(String trainingFilePath, int pType) {
        System.out.println("trainHeaderModel() not supported in rule-based mode. No-op.");
    }
}
