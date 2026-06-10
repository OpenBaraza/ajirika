package org.processCV;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONArray;
import org.json.JSONObject;

import edu.stanford.nlp.pipeline.CoreDocument;
import edu.stanford.nlp.pipeline.CoreEntityMention;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;

public class breakdownCV {
    private static final Logger log = Logger.getLogger(breakdownCV.class.getName());

    private static final Pattern EMAIL_PATTERN = Pattern.compile("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b");
    private static final Pattern PHONE_PATTERN = Pattern.compile("(?:\\+?\\d{1,3}[-.\\s]?)?\\d{3}[-.\\s]?\\d{3}[-.\\s]?\\d{4}");
    private static final Pattern PERSONAL_INFO_PATTERN = Pattern.compile("(?i)(?:name|email|phone|address|contact|mobile)\\s*:?\\s*([^\\n]+)");
    private static final Pattern DATE_RANGE_PATTERN2 = Pattern.compile(
        "(?i)(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)\\s*[-–—]\\s*(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)"
    );

    private static final String[] SUMMARY_HEADERS = {"summary", "profile", "professional summary", "personal profile", "about me", "objective"};
    private static final String[] EDUCATION_HEADERS = {"education", "educational background", "academic qualifications", "academic background", "qualifications"};
    private static final String[] EXPERIENCE_HEADERS = {
        "experience", "work experience", "employment history", "professional experience",
        "career history", "work history", "employment", "professional background",
        "practical experience", "certifications", "practical experience & certifications"
    };
    private static final String[] SKILLS_HEADERS = {"skills", "technical skills", "core competencies", "key skills", "professional skills"};
    private static final String[] REFERENCES_HEADERS = {"references", "referees", "professional references"};
    private static final String[] PROJECTS_HEADERS = {"projects", "personal projects", "project"};

    private static final String[] DEGREE_TERMS = {"certificate", "bachelor", "master", "phd", "bsc", "msc", "diploma", "degree", "course"};
    private static final String[] SCHOOL_TERMS = {"school", "college", "university", "institute", "academy", "polytechnic", "secondary"};
    private static final String[] PROFESSIONAL_TITLES = {
        "engineer", "senior", "supervisor", "developer", "manager", "analyst", "consultant",
        "architect", "scientist", "designer", "specialist", "officer", "coordinator", "intern",
        "assistant", "technician", "executive", "director", "administrator", "trainer"
    };
    private static final String[] COMPANY_TERMS = {
        "company", "organization", "firm", "agency", "corporation", "bank", "enterprise",
        "association", "foundation", "startup", "ltd", "inc", "plc", "llc", "limited",
        "ventures", "solutions", "systems", "group", "labs", "partners", "technologies"
    };

    private static final String[] fullDateFormats = {
        "yyyy-MM-dd", "dd-MM-yyyy", "MM/dd/yyyy", "dd/MM/yyyy",
        "MMMM d, yyyy", "EEE, MMM d, yyyy", "yyyy/MM/dd"
    };
    private static final String[] partialDateFormats = {"MMMM yyyy", "MMM yyyy", "yyyy-MM"};

    // Bullet characters produced by PDF and DOCX parsers
    private static final String BULLET_REGEX = "^[\\s\\u2022\\u00b7\\u2013\\u200b\\ufffd\\u00c2\\u00b7•·–\\-]+";

    // Shared CoreNLP pipeline
    private static final StanfordCoreNLP nlpPipeline;

   static {
    Properties props = new Properties();
    props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
    props.setProperty("ner.model",
        "edu/stanford/nlp/models/ner/english.all.3class.distsim.crf.ser.gz," +
        "edu/stanford/nlp/models/ner/english.muc.7class.distsim.crf.ser.gz," +
        "edu/stanford/nlp/models/ner/english.conll.4class.distsim.crf.ser.gz," +
        "models/cv-ner-model.ser.gz");
    nlpPipeline = new StanfordCoreNLP(props);
}

    // Public Entry Points

    public JSONObject extractCVData(String cvText) {
        JSONObject result = new JSONObject();
        result.put("personal_info", new JSONObject());
        result.put("summary", "");
        result.put("education", new JSONArray());
        result.put("experience", new JSONArray());
        result.put("skills", new JSONArray());
        result.put("references", new JSONArray());

        System.out.println("Plain text extracted: " + cvText.substring(0, Math.min(100, cvText.length())) + "...");

        debugExtraction(cvText);
        Map<String, List<String>> sections = extractSections(cvText);

        System.out.println("\n=== SECTIONS EXTRACTION RESULTS ===");
        for (Map.Entry<String, List<String>> entry : sections.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue().size() + " items");
            for (int i = 0; i < Math.min(3, entry.getValue().size()); i++)
                System.out.println("  - " + entry.getValue().get(i));
        }

        System.out.println("\n=== PERSONAL INFORMATION SECTION ===");
        extractPersonalInfo(cvText, result);
        System.out.println("Personal info extracted: " + result.getJSONObject("personal_info").toString(2));

        System.out.println("\n=== EDUCATION SECTION ===");
        result.put("education", parseEducation(sections.getOrDefault("education", Collections.emptyList())));

        System.out.println("\n=== EXPERIENCE SECTION ===");
        result.put("experience", parseExperience(sections.getOrDefault("experience", Collections.emptyList())));

        System.out.println("\n=== SKILLS SECTION ===");
        result.put("skills", parseSkills(sections.getOrDefault("skills", Collections.emptyList())));

        System.out.println("\n=== REFERENCES SECTION ===");
        result.put("references", parseReferences(sections.getOrDefault("references", Collections.emptyList())));

        System.out.println("\n=== CV EXTRACTION COMPLETED ===");
        System.out.println(result.toString());
        return result;
    }

     // Called by analyzeHeaders — kept for API compatibility

    public JSONObject identifySections(Map<String, List<String>> allHeaders, String cvText) {
        JSONObject infoArray = new JSONObject();
        infoArray.put("education", new JSONArray());
        infoArray.put("experience", new JSONArray());
        infoArray.put("skills", new JSONArray());
        infoArray.put("references", new JSONArray());
        return infoArray;
    }

    // Section Extraction 

    private Map<String, List<String>> extractSections(String plainText) {
        Map<String, List<String>> sections = new HashMap<>();
        sections.put("summary", new ArrayList<>());
        sections.put("education", new ArrayList<>());
        sections.put("experience", new ArrayList<>());
        sections.put("skills", new ArrayList<>());
        sections.put("references", new ArrayList<>());

        String[] lines = plainText.split("\\r?\\n");
        String currentSection = null;
        // Track how many non-header lines we've seen before first section
        // to avoid pre-header content leaking into inferred sections
        boolean firstSectionFound = false;

        for (String line : lines) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;
            if (trimmed.startsWith("http") || trimmed.startsWith("mailto:")) continue;

            String detected = detectSectionHeader(trimmed);
            if (detected != null) {
                currentSection = detected;
                firstSectionFound = true;
                System.out.println("Set section: " + currentSection + " from line: " + trimmed);
                continue;
            }

            if (currentSection != null) {
                // Skip lines that are themselves section headers of other sections we don't track
                // (e.g. PROJECTS — we don't have a projects bucket, stop adding to current section)
                if (isStopHeader(trimmed)) {
                    currentSection = null;
                    continue;
                }
                sections.get(currentSection).add(trimmed);
            }
            // Lines before first section header are intentionally ignored
            // to prevent summary/personal content leaking into sections
        }

        for (String s : sections.keySet())
            System.out.println("Section '" + s + "' contains " + sections.get(s).size() + " entries");

        return sections;
    }

    private String detectSectionHeader(String line) {
        // Strip leading section prefix: "A.", "B.", "1.", "II." etc.
        String stripped = line.replaceAll("(?i)^[a-z0-9]{1,3}\\.\\s*", "").trim();
        // Remove trailing punctuation/formatting
        stripped = stripped.replaceAll("[:\\-_=•]+$", "").trim();

        String lower = stripped.toLowerCase();

        // Must be short to be a header
        if (lower.length() > 65) return null;

        for (String h : SUMMARY_HEADERS)  if (lower.equals(h) || lower.startsWith(h)) return "summary";
        for (String h : EDUCATION_HEADERS) if (lower.equals(h) || lower.startsWith(h)) return "education";
        for (String h : EXPERIENCE_HEADERS) if (lower.equals(h) || lower.startsWith(h)) return "experience";
        for (String h : SKILLS_HEADERS)   if (lower.equals(h) || lower.startsWith(h)) return "skills";
        for (String h : REFERENCES_HEADERS) if (lower.equals(h) || lower.startsWith(h)) return "references";

        System.out.println("Checking header: '" + lower + "'");
        return null;
    }

    private static final String[] STOP_HEADERS = {"projects", "personal projects", "project", "accomplishments", "achievements", "awards"};

    private boolean isStopHeader(String line) {
        String lower = line.replaceAll("(?i)^[a-z0-9]{1,3}\\.\\s*", "").trim().toLowerCase();
        for (String h : STOP_HEADERS) if (lower.equals(h) || lower.startsWith(h)) return true;
        return false;
    }

    // Education 

    private JSONArray parseEducation(List<String> lines) {
        System.out.println("Parsing education with " + lines.size() + " lines");
        JSONArray result = new JSONArray();

        String institute = "", certificate = "", rawdate = "";

        for (String raw : lines) {
            String line = stripBullet(raw).trim();
            String lower = line.toLowerCase();
            System.out.println("  Edu line: " + line);

            if (line.isEmpty()) continue;

            // Date range detection - highest priority
            Matcher dm = DATE_RANGE_PATTERN2.matcher(lower);
            if (dm.find() && rawdate.isEmpty()) {
                rawdate = line;
                System.out.println("    -> date: " + rawdate);
                continue;
            }

            // Degree/certificate detection
            // Handle combined lines like "UNIVERSITY NAME - Degree in X"
            if (containsAny(lower, DEGREE_TERMS)) {
                // If line also contains school term, split on " - " or ":"
                if (containsAny(lower, SCHOOL_TERMS)) {
                    String[] parts = line.split("\\s*[-–—:]\\s*", 2);
                    if (parts.length == 2) {
                        if (institute.isEmpty()) institute = parts[0].trim();
                        if (certificate.isEmpty()) certificate = parts[1].trim();
                        System.out.println("    -> combined: inst=" + institute + " cert=" + certificate);
                        continue;
                    }
                }
                if (certificate.isEmpty()) {
                    certificate = line;
                    System.out.println("    -> certificate: " + certificate);
                    continue;
                }
            }

            // School/institution detection
            if (containsAny(lower, SCHOOL_TERMS) && institute.isEmpty()) {
                institute = line;
                System.out.println("    -> institute: " + institute);
                continue;
            }

            // If we have all three, save and reset
            if (!institute.isEmpty() && !certificate.isEmpty() && !rawdate.isEmpty()) {
                JSONObject newEntry = buildEducationEntry(institute, certificate, rawdate);
                boolean duplicate = false;
                for (int i = 0; i < result.length(); i++) {
                    if (result.getJSONObject(i).optString("institution","")
                            .contains(newEntry.optString("institution","").substring(0, 
                                Math.min(10, newEntry.optString("institution","").length())))) {
                        duplicate = true;
                        break;
                    }
                }
                if (!duplicate) result.put(newEntry);

                System.out.println("    Saved education entry");
                institute = ""; certificate = ""; rawdate = "";
            }
        }

        // Save last pending entry
        if (!institute.isEmpty() || !certificate.isEmpty()) {
            if (!rawdate.isEmpty() || !certificate.isEmpty()) {
                result.put(buildEducationEntry(
                    institute.isEmpty() ? "Unknown" : institute,
                    certificate.isEmpty() ? "Unknown" : certificate,
                    rawdate
                ));
            }
        }

        System.out.println("Education entries parsed: " + result.length());
        return result;
    }

    private JSONObject buildEducationEntry(String institute, String certificate, String rawdate) {
        JSONObject entry = new JSONObject();
        String[] parts = rawdate.replaceAll("[–—]", "-").split("\\s*-\\s*", 2);
        String eduFrom = parts.length >= 1 ? parseDateFlexible(parts[0].trim()) : "";
        String eduTo   = parts.length == 2 ? parseDateFlexible(parts[1].trim()) : "";

        String certLower = certificate.toLowerCase();
        String eduLevel;
        if (certLower.contains("certificate"))                                  eduLevel = "4";
        else if (certLower.contains("high school"))                             eduLevel = "3";
        else if (certLower.contains("secondary"))                               eduLevel = "2";
        else if (certLower.contains("bachelor") || certLower.contains("bsc") || certLower.contains("degree")) eduLevel = "8";
        else if (certLower.contains("master") || certLower.contains("phd"))    eduLevel = "9";
        else if (certLower.contains("diploma"))                                 eduLevel = "7";
        else                                                                    eduLevel = "N/A";

        entry.put("edu-level", eduLevel);
        entry.put("institution", institute);
        entry.put("edu-from", eduFrom);
        entry.put("edu-to", eduTo);
        entry.put("certification", certificate);
        return entry;
    }

    // Experience 

    private JSONArray parseExperience(List<String> lines) {
        System.out.println("Parsing experience with " + lines.size() + " lines");
        JSONArray result = new JSONArray();

        for (String raw : lines) {
            String line = stripBullet(raw).trim();
            if (line.isEmpty()) continue;
            System.out.println("  Exp line: " + line);

            JSONObject entry = new JSONObject();
            String lower = line.toLowerCase();

            // Date detection within the line
            Matcher dm = DATE_RANGE_PATTERN2.matcher(lower);
            if (dm.find()) {
                entry.put("dates", dm.group(0));
            }

            // Extract role - look for known title keywords
            if (containsAny(lower, PROFESSIONAL_TITLES)) {
                // Try to split "Role: description" or "Role at Company"
                String role = line.split("[:\\-–—]")[0].trim();
                entry.put("role", role);
            }

            // Put the full line as description regardless
            entry.put("description", line);

            if (entry.length() > 1) { // more than just description
                result.put(entry);
            } else {
                // Still add it as a plain entry
                result.put(entry);
            }
        }

        System.out.println("Experience entries parsed: " + result.length());
        return result;
    }

    // Skills

    private JSONArray parseSkills(List<String> lines) {
    System.out.println("Parsing skills with " + lines.size() + " lines");
    JSONArray result = new JSONArray();

    // First pass: join continuation lines to their category header
    // A continuation line is one that has no colon and is not a new category
    List<String> joined = new ArrayList<>();
    String currentCategory = null;
    StringBuilder currentItems = new StringBuilder();

    for (String raw : lines) {
        String line = stripBullet(raw).trim();
        if (line.isEmpty()) continue;

        if (line.endsWith(":")) {
            // Pure category header with no items on same line
            if (currentCategory != null && currentItems.length() > 0) {
                joined.add(currentCategory + ": " + currentItems.toString().trim());
            }
            currentCategory = line.substring(0, line.length() - 1).trim();
            currentItems = new StringBuilder();
        } else if (line.contains(":") && !line.startsWith("http")) {
            // Category header with items on same line
            if (currentCategory != null && currentItems.length() > 0) {
                joined.add(currentCategory + ": " + currentItems.toString().trim());
            }
            int colon = line.indexOf(":");
            currentCategory = line.substring(0, colon).trim();
            currentItems = new StringBuilder(line.substring(colon + 1).trim());
        } else {
            // Continuation line — append to current category or add as standalone
            if (currentCategory != null) {
                if (currentItems.length() > 0) currentItems.append(", ");
                currentItems.append(line);
            } else {
                joined.add(line);
            }
        }
    }
    // Flush last category
    if (currentCategory != null && currentItems.length() > 0) {
        joined.add(currentCategory + ": " + currentItems.toString().trim());
    }

    // Second pass: parse joined lines into skill objects
    for (String line : joined) {
        if (line.contains(":")) {
            int colon = line.indexOf(":");
            String category = line.substring(0, colon).trim();
            String items = line.substring(colon + 1).trim();
            for (String item : items.split(",")) {
                String s = item.trim();
                if (!s.isEmpty()) {
                    JSONObject obj = new JSONObject();
                    obj.put("category", category);
                    obj.put("skill", s);
                    result.put(obj);
                }
            }
        } else {
            String[] parts = line.split(",");
            for (String part : parts) {
                String s = part.trim();
                if (!s.isEmpty()) result.put(s);
            }
        }
    }

    System.out.println("Skills parsed: " + result.length());
    return result;
    }

    // References 

    private JSONArray parseReferences(List<String> lines) {
        System.out.println("Parsing references with " + lines.size() + " lines");
        JSONArray result = new JSONArray();
        JSONObject current = new JSONObject();

        for (String raw : lines) {
            String line = stripBullet(raw).trim();
            if (line.isEmpty()) {
                if (current.length() > 0) { result.put(current); current = new JSONObject(); }
                continue;
            }
            if (line.contains("@")) current.put("email", line);
            else if (PHONE_PATTERN.matcher(line).find()) current.put("phone", line);
            else if (!current.has("name")) current.put("name", line);
            else if (!current.has("organization")) current.put("organization", line);
            else if (!current.has("role")) current.put("role", line);
        }
        if (current.length() > 0) result.put(current);

        System.out.println("References parsed: " + result.length());
        return result;
    }

    // Personal Info

    private void extractPersonalInfo(String plainText, JSONObject result) {
        JSONObject personalInfo = new JSONObject();

        // Step 1: First non-empty, non-URL line = name
        for (String line : plainText.split("\\r?\\n")) {
            String trimmed = line.trim();
            if (trimmed.isEmpty() || trimmed.startsWith("http") || trimmed.startsWith("mailto:")) continue;
            if (trimmed.length() > 2 && trimmed.length() < 60 && !trimmed.contains("@") && !trimmed.matches(".*\\d{5,}.*")) {
                String namePart = trimmed.split("[|,+]")[0].trim();
                if (namePart.length() > 2) {
                    personalInfo.put("name", namePart);
                    System.out.println("[FirstLine] Assigned name: " + namePart);
                }
            }
            break;
        }

        // Step 2: CoreNLP on first 1000 chars for email
        try {
            CoreDocument doc = new CoreDocument(plainText.substring(0, Math.min(1000, plainText.length())));
            nlpPipeline.annotate(doc);

            for (CoreEntityMention em : doc.entityMentions()) {
                System.out.println("  " + em.entityType() + ": " + em.text());
                if (em.entityType().equals("EMAIL") && !personalInfo.has("email")) {
                    personalInfo.put("email", em.text());
                }
                if (em.entityType().equals("PERSON") && !personalInfo.has("corenlp_name")) {
                    personalInfo.put("corenlp_name", em.text());
                    System.out.println("[CoreNLP custom] Assigned name: " + em.text());
                }
            }
                // Use CoreNLP name only if first-line heuristic produced something suspicious
                // (contains digits or is longer than 40 chars it is probably not a name)
                if (personalInfo.has("corenlp_name")) {
                    String firstLineName = personalInfo.optString("name", "");
                    if (firstLineName.isEmpty() || firstLineName.length() > 40 || firstLineName.matches(".*\\d.*")) {
                        personalInfo.put("name", personalInfo.getString("corenlp_name"));
                    }
                    personalInfo.remove("corenlp_name");
                }
        }
            catch (Exception e) {
                System.out.println("[CoreNLP] Failed: " + e.getMessage());
            }

        // Step 3: Regex fallbacks
        if (!personalInfo.has("email")) {
            Matcher m = EMAIL_PATTERN.matcher(plainText);
            if (m.find()) personalInfo.put("email", m.group(0));
        }
        Matcher pm = PHONE_PATTERN.matcher(plainText);
        if (pm.find()) personalInfo.put("phone", pm.group(0));

        // Step 4: Labeled fields
        Matcher lm = PERSONAL_INFO_PATTERN.matcher(plainText);
        while (lm.find()) {
            String infoLine = lm.group(0).toLowerCase();
            String value = lm.group(1).trim();
            if (infoLine.contains("address") && !personalInfo.has("address")) personalInfo.put("address", value);
            else if (infoLine.contains("name") && !personalInfo.has("name")) personalInfo.put("name", value);
            else if ((infoLine.contains("phone") || infoLine.contains("mobile")) && !personalInfo.has("phone")) personalInfo.put("phone", value);
            else if (infoLine.contains("email") && !personalInfo.has("email")) personalInfo.put("email", value);
        }

        result.put("personal_info", personalInfo);
    }

    // Helpers 

    private String stripBullet(String line) {
        return line.replaceAll(BULLET_REGEX, "").trim();
    }

    private String parseDateFlexible(String dateStr) {
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String trimmed = dateStr.trim();
        if (trimmed.equalsIgnoreCase("present") || trimmed.equalsIgnoreCase("ongoing") || trimmed.equalsIgnoreCase("current"))
            return LocalDate.now().format(outputFormat);
        for (String pattern : fullDateFormats) {
            try {
                return LocalDate.parse(trimmed, new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern(pattern).toFormatter()).format(outputFormat);
            } catch (DateTimeParseException ignored) {}
        }
        for (String pattern : partialDateFormats) {
            try {
                return YearMonth.parse(trimmed, new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern(pattern).toFormatter()).atDay(1).format(outputFormat);
            } catch (DateTimeParseException ignored) {}
        }
        try { return LocalDate.of(Integer.parseInt(trimmed), 1, 1).format(outputFormat); }
        catch (NumberFormatException ignored) {}
        System.out.println("Could not parse date: " + trimmed);
        return trimmed;
    }

    private boolean containsAny(String text, String[] keywords) {
        for (String k : keywords) if (text.contains(k)) return true;
        return false;
    }

    private boolean containsAnyIgnoreCase(String text, String[] terms) {
        String lower = text.toLowerCase();
        for (String t : terms) if (lower.contains(t.toLowerCase())) return true;
        return false;
    }

    private boolean isLikelyName(String text) {
        String[] parts = text.split("\\s+");
        if (parts.length < 2 || parts.length > 3) return false;
        for (String p : parts) if (p.isEmpty() || !Character.isUpperCase(p.charAt(0))) return false;
        return true;
    }

    private void debugExtraction(String plainText) {
        System.out.println("=== DEBUG: Content length: " + plainText.length());
        System.out.println("First 300 chars:\n" + plainText.substring(0, Math.min(300, plainText.length())));
        System.out.println("\n=== DEBUG: SECTION HEADER SCAN ===");
        String[] lines = plainText.split("\\r?\\n");
        for (int i = 0; i < Math.min(30, lines.length); i++) {
            String line = lines[i].trim();
            if (!line.isEmpty()) {
                String detected = detectSectionHeader(line);
                System.out.println("Line " + i + ": '" + line + "'" + (detected != null ? " -> SECTION: " + detected : ""));
            }
        }
    }
}
