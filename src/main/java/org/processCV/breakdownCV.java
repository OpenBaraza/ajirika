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

    // Shared CoreNLP pipeline — built once for the JVM lifetime
    private static final StanfordCoreNLP nlpPipeline;
    
    /*static {
        Properties props = new Properties();
        props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
        nlpPipeline = new StanfordCoreNLP(props);
    }
    */

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

    // ==================== PUBLIC ENTRY POINTS ====================

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

    /**
     * Called by analyzeHeaders — kept for API compatibility
     */
    public JSONObject identifySections(Map<String, List<String>> allHeaders, String cvText) {
        JSONObject infoArray = new JSONObject();
        infoArray.put("education", new JSONArray());
        infoArray.put("experience", new JSONArray());
        infoArray.put("skills", new JSONArray());
        infoArray.put("references", new JSONArray());
        return infoArray;
    }

    // ==================== SECTION EXTRACTION ====================

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
                if (isProjectsHeader(trimmed)) {
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

    private boolean isProjectsHeader(String line) {
        String lower = line.replaceAll("(?i)^[a-z0-9]{1,3}\\.\\s*", "").trim().toLowerCase();
        for (String h : PROJECTS_HEADERS) if (lower.equals(h) || lower.startsWith(h)) return true;
        return false;
    }

    // ==================== EDUCATION ====================

    private JSONArray parseEducation(List<String> lines) {
        System.out.println("Parsing education with " + lines.size() + " lines");
        JSONArray result = new JSONArray();

        String institute = "", certificate = "", rawdate = "";

        for (String raw : lines) {
            String line = stripBullet(raw).trim();
            String lower = line.toLowerCase();
            System.out.println("  Edu line: " + line);

            if (line.isEmpty()) continue;

            // Date range detection — highest priority
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
                result.put(buildEducationEntry(institute, certificate, rawdate));
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

    // ==================== EXPERIENCE ====================

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

            // Extract role — look for known title keywords
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

    // ==================== SKILLS ====================

    private JSONArray parseSkills(List<String> lines) {
        System.out.println("Parsing skills with " + lines.size() + " lines");
        JSONArray result = new JSONArray();

        for (String raw : lines) {
            // Strip bullet characters
            String line = stripBullet(raw).trim();
            if (line.isEmpty()) continue;
            System.out.println("  Skill line: " + line);

            // If line has a category label like "Security Tools: ..." split on first colon
            if (line.contains(":")) {
                String[] parts = line.split(":", 2);
                String category = parts[0].trim();
                String items = parts.length > 1 ? parts[1].trim() : "";

                // Split items by comma
                String[] skills = items.split(",");
                for (String skill : skills) {
                    String s = skill.trim();
                    if (!s.isEmpty()) {
                        JSONObject skillObj = new JSONObject();
                        skillObj.put("category", category);
                        skillObj.put("skill", s);
                        result.put(skillObj);
                    }
                }
            } else {
                // Plain skill line — split by comma or add whole line
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

    // ==================== REFERENCES ====================

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

    // ==================== PERSONAL INFO ====================

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
    
         /*          
            for (CoreEntityMention em : doc.entityMentions()) {
                System.out.println("  " + em.entityType() + ": " + em.text());
                if (em.entityType().equals("EMAIL") && !personalInfo.has("email"))
                    personalInfo.put("email", em.text());
            }
        */ 


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

    // ==================== HELPERS ====================

    /**
     * Strips leading bullet characters produced by PDF/DOCX parsers.
     * Handles: •, ·, –, zero-width space, UTF-8 garbage bytes from Tika
     */
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




























/*package org.processCV;

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

    private static final Pattern PERSONAL_INFO_PATTERN = Pattern.compile("(?i)(?:name|email|phone|address|contact|mobile)\\s*:?\\s*([^\\n]+)");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b");
    private static final Pattern PHONE_PATTERN = Pattern.compile("(?:\\+?\\d{1,3}[-.\\s]?)?\\d{3}[-.\\s]?\\d{3}[-.\\s]?\\d{4}");
    private static final Pattern NAME_PATTERN = Pattern.compile("(?i)^([A-Z][a-z]+(\\s[A-Z][a-z]+)+)$");
    private static final Pattern DATE_RANGE_PATTERN = Pattern.compile("\\d{4}-\\d{2}-\\d{2}\\s*[-–—]\\s*\\d{4}-\\d{2}-\\d{2}");
    private static final Pattern DATE_RANGE_PATTERN2 = Pattern.compile(
        "(?i)(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)\\s*[-–—]\\s*(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)"
    );

    private static final String[] SUMMARY_HEADERS = {"summary", "profile", "professional summary", "personal profile", "about me", "objective"};
    private static final String[] EDUCATION_HEADERS = {"education", "educational background", "academic qualifications", "academic background", "qualifications"};
    private static final String[] EXPERIENCE_HEADERS = {
        "experience", "work experience", "employment history",
        "professional experience", "career history", "work history",
        "employment", "professional background", "career summary",
        "work", "jobs", "positions", "career", "professional",
        "practical experience", "certifications", "practical experience & certifications"
    };
    private static final String[] EXP_OUTLIERS = {"objective"};
    private static final String[] SKILLS_HEADERS = {
        "skills", "technical skills", "core competencies", "key skills", "professional skills"
    };
    private static final String[] REFERENCES_HEADERS = {"references", "referees", "professional references"};
    private static final String[] DEGREE_TERMS = {"certificate", "bachelor", "master", "phd", "course", "bsc", "msc", "diploma", "degree"};
    private static final String[] SCHOOL_TERMS = {
        "school", "college", "university", "institute", "academy", "polytechnic",
        "secondary", "high school"
    };
    private static final String[] PROFESSIONAL_TITLES = {
        "engineer", "senior", "supervisor", "developer", "manager", "analyst", "consultant",
        "architect", "scientist", "designer", "specialist", "officer", "coordinator", "intern",
        "assistant", "technician", "executive", "director", "administrator", "trainer"
    };
    private static final String[] COMPANY_TERMS = {
        "company", "organization", "firm", "agency", "corporation", "commercial", "bank", "enterprise", "institute",
        "association", "foundation", "non-profit", "startup", "ltd", "inc", "plc", "llc",
        "limited", "ventures", "solutions", "systems", "group", "labs", "partners", "technologies"
    };
    private static final String[] COMMON_SECTIONS = {
        "Education", "Experience", "Work Experience", "Skills",
        "Projects", "Certifications", "Achievements", "References",
        "Objective", "Summary", "Profile", "Languages", "Interests"
    };
    private static final String[] fullDateFormats = {
        "yyyy-MM-dd", "dd-MM-yyyy", "MM/dd/yyyy", "dd/MM/yyyy",
        "MMMM d, yyyy", "EEE, MMM d, yyyy", "yyyy/MM/dd"
    };
    private static final String[] partialDateFormats = {
        "MMMM yyyy", "MMM yyyy", "yyyy-MM"
    };

    // Shared CoreNLP pipeline — built once
    private static StanfordCoreNLP nlpPipeline;
    static {
        Properties props = new Properties();
        props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
        nlpPipeline = new StanfordCoreNLP(props);
    }

    public class HeaderResults {
        public List<String> expHeader = new ArrayList<>();
        public List<String> eduHeader = new ArrayList<>();
        public List<String> skillsHeader = new ArrayList<>();
        public List<String> refHeader = new ArrayList<>();
    }

    HeaderResults sectionResults = new HeaderResults();

    public JSONObject identifySections(Map<String, List<String>> allHeaders, String cvText) {
        System.out.println("Identifying sections from document");

        for (String item : allHeaders.get("education")) {
            String trimmed = item.trim();
            String lower = trimmed.toLowerCase();
            int spaceCount = trimmed.length() - trimmed.replace(" ", "").length();
            if (containsAnyIgnoreCase(lower, EDUCATION_HEADERS) &&
                !containsAnyIgnoreCase(lower, DEGREE_TERMS) &&
                !containsAnyIgnoreCase(lower, SCHOOL_TERMS) &&
                spaceCount <= 1) {
                sectionResults.eduHeader.add(trimmed);
                System.out.println("possible education header: " + trimmed);
            }
        }

        for (String item : allHeaders.get("experience")) {
            String trimmed = item.trim();
            String lower = trimmed.toLowerCase();
            int spaceCount = trimmed.length() - trimmed.replace(" ", "").length();
            if (containsAnyIgnoreCase(lower, EXPERIENCE_HEADERS) &&
                !containsAnyIgnoreCase(lower, DEGREE_TERMS) &&
                !containsAnyIgnoreCase(lower, PROFESSIONAL_TITLES) &&
                !containsAny(lower, EXP_OUTLIERS) &&
                spaceCount <= 1) {
                sectionResults.expHeader.add(trimmed);
                System.out.println("possible experience header: " + trimmed);
            }
        }

        for (String item : allHeaders.get("skills")) {
            String trimmed = item.trim();
            String lower = trimmed.toLowerCase();
            int spaceCount = trimmed.length() - trimmed.replace(" ", "").length();
            if (containsAnyIgnoreCase(lower, SKILLS_HEADERS) && spaceCount <= 2) {
                sectionResults.skillsHeader.add(trimmed);
                System.out.println("possible skills header: " + trimmed);
            }
        }

        for (String item : allHeaders.get("references")) {
            String trimmed = item.trim();
            String lower = trimmed.toLowerCase();
            int spaceCount = trimmed.length() - trimmed.replace(" ", "").length();
            if (containsAnyIgnoreCase(lower, REFERENCES_HEADERS) && spaceCount <= 1) {
                sectionResults.refHeader.add(trimmed);
                System.out.println("possible reference header: " + trimmed);
            }
        }

        Map<String, List<String>> sectionContent = new HashMap<>();
        sectionContent.put("experience", new ArrayList<>());
        sectionContent.put("education", new ArrayList<>());
        sectionContent.put("skills", new ArrayList<>());
        sectionContent.put("references", new ArrayList<>());

        String[] lines = cvText.split("\\r?\\n");
        String currentSection = null;
        for (String line : lines) {
            String trimmed = line.trim();
            if (sectionResults.expHeader.contains(trimmed)) { currentSection = "experience"; continue; }
            if (sectionResults.eduHeader.contains(trimmed)) { currentSection = "education"; continue; }
            if (sectionResults.skillsHeader.contains(trimmed)) { currentSection = "skills"; continue; }
            if (sectionResults.refHeader.contains(trimmed)) { currentSection = "references"; continue; }
            if (currentSection != null && sectionContent.containsKey(currentSection)) {
                sectionContent.get(currentSection).add(trimmed);
            }
        }

        System.out.println("========== SECTION CONTENT ==========");
        for (Map.Entry<String, List<String>> entry : sectionContent.entrySet()) {
            System.out.println("---- " + entry.getKey().toUpperCase() + " ----");
            if (entry.getValue().isEmpty()) {
                System.out.println("  (no content found)");
            } else {
                for (String line : entry.getValue()) System.out.println("  " + line);
            }
        }

        JSONObject infoArray = new JSONObject();
        infoArray.put("education", new JSONArray());
        infoArray.put("experience", new JSONArray());
        infoArray.put("skills", new JSONArray());
        infoArray.put("references", new JSONArray());

        parseEducationAndStore(sectionContent, infoArray);
        parseExperienceAndStore(sectionContent, infoArray);
        parseSkillsAndStore(sectionContent, infoArray);
        parseReferencesAndStore(sectionContent, infoArray);

        return infoArray;
    }

    private void parseExperienceAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
        List<String> experienceSection = sectionContent.getOrDefault("experience", Collections.emptyList());
        System.out.println("Parsing experience section with " + experienceSection.size() + " entries");
        JSONArray experienceArray = infoArray.getJSONArray("experience");
        String jobTitle = "", company = "", rawdate = "";
        Matcher dateMatcher;
        for (String line : experienceSection) {
            String text = line.trim();
            String lower = text.toLowerCase().replaceAll("[.,;:]$", "");
            dateMatcher = DATE_RANGE_PATTERN2.matcher(lower);
            if (rawdate.isEmpty() && dateMatcher.find()) { rawdate = text; }
            if (jobTitle.isEmpty() && containsAny(lower, PROFESSIONAL_TITLES) && !containsAny(lower, COMPANY_TERMS)) { jobTitle = text; }
            if (company.isEmpty() && containsAny(lower, COMPANY_TERMS)) { company = text; }
            if (!jobTitle.isEmpty() && !company.isEmpty() && !rawdate.isEmpty()) {
                JSONObject entry = new JSONObject();
                entry.put("role", jobTitle);
                entry.put("employer", company);
                entry.put("dates", rawdate);
                experienceArray.put(entry);
                jobTitle = ""; company = ""; rawdate = "";
            }
        }
    }

    private void parseSkillsAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
        List<String> skillsSection = sectionContent.getOrDefault("skills", Collections.emptyList());
        JSONArray skillsArray = infoArray.getJSONArray("skills");
        for (String line : skillsSection) {
            String text = line.trim();
            if (!text.isEmpty()) skillsArray.put(text);
        }
    }

    private void parseReferencesAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
        List<String> referenceSection = sectionContent.getOrDefault("references", Collections.emptyList());
        JSONArray referenceArray = infoArray.getJSONArray("references");
        String name = "", org = "", role = "", contact = "";
        for (String line : referenceSection) {
            String text = line.trim();
            if (name.isEmpty() && !text.isEmpty()) { name = text; continue; }
            else if (org.isEmpty() && !text.isEmpty()) { org = text; continue; }
            else if (role.isEmpty() && !text.isEmpty()) { role = text; continue; }
            else if (contact.isEmpty() && (text.contains("@") || text.matches(".*\\d{3,}.*"))) { contact = text; }
            if (!name.isEmpty() && !org.isEmpty() && !role.isEmpty() && !contact.isEmpty()) {
                JSONObject entry = new JSONObject();
                entry.put("name", name); entry.put("organization", org);
                entry.put("role", role); entry.put("contact", contact);
                referenceArray.put(entry);
                name = ""; org = ""; role = ""; contact = "";
            }
        }
    }

    private void parseEducationAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
        List<String> educationSection = sectionContent.getOrDefault("education", Collections.emptyList());
        System.out.println("Parsing education section with " + educationSection.size() + " entries");
        JSONArray educationArray = infoArray.getJSONArray("education");
        Matcher dateMatcher;
        String institute = "", certificate = "", rawdate = "";
        for (String line : educationSection) {
            String trimmed = line.trim();
            String lower = trimmed.toLowerCase().replaceAll("[.,;:]$", "");
            dateMatcher = DATE_RANGE_PATTERN2.matcher(lower);
            if (rawdate.isEmpty() && dateMatcher.find()) { rawdate = trimmed; }
            else if (certificate.isEmpty() && containsAny(lower, DEGREE_TERMS)) { certificate = trimmed; }
            else if (institute.isEmpty() && containsAny(lower, SCHOOL_TERMS)) { institute = trimmed; }
            if (!institute.isEmpty() && !certificate.isEmpty() && !rawdate.isEmpty()) {
                JSONObject eduEntry = buildEducationEntry(institute, certificate, rawdate);
                educationArray.put(eduEntry);
                institute = ""; certificate = ""; rawdate = "";
            }
        }
    }

    private JSONObject buildEducationEntry(String institute, String certificate, String rawdate) {
        JSONObject entry = new JSONObject();
        String[] parts = rawdate.replaceAll("[–—]", "-").split("\\s*-\\s*");
        String eduFrom = parseDateFlexible(parts[0]);
        String eduTo = (parts.length == 2) ? parseDateFlexible(parts[1]) : "";
        String eduLevel;
        String certLower = certificate.toLowerCase();
        if (certLower.contains("certificate")) eduLevel = "4";
        else if (certLower.contains("high school")) eduLevel = "3";
        else if (certLower.contains("secondary")) eduLevel = "2";
        else if (certLower.contains("bachelor") || certLower.contains("degree") || certLower.contains("bsc")) eduLevel = "8";
        else if (certLower.contains("master") || certLower.contains("phd")) eduLevel = "9";
        else if (certLower.contains("diploma")) eduLevel = "7";
        else eduLevel = "N/A";
        entry.put("edu-level", eduLevel);
        entry.put("institution", institute);
        entry.put("edu-from", eduFrom);
        entry.put("edu-to", eduTo);
        entry.put("certification", certificate);
        return entry;
    }

    private String parseDateFlexible(String dateStr) {
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String trimmed = dateStr.trim();
        if (trimmed.equalsIgnoreCase("present") || trimmed.equalsIgnoreCase("ongoing") || trimmed.equalsIgnoreCase("current")) {
            return LocalDate.now().format(outputFormat);
        }
        for (String pattern : fullDateFormats) {
            try {
                DateTimeFormatter formatter = new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern(pattern).toFormatter();
                return LocalDate.parse(trimmed, formatter).format(outputFormat);
            } catch (DateTimeParseException ignored) {}
        }
        for (String pattern : partialDateFormats) {
            try {
                DateTimeFormatter formatter = new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern(pattern).toFormatter();
                return YearMonth.parse(trimmed, formatter).atDay(1).format(outputFormat);
            } catch (DateTimeParseException ignored) {}
        }
        try {
            return LocalDate.of(Integer.parseInt(trimmed), 1, 1).format(outputFormat);
        } catch (NumberFormatException ignored) {}
        System.out.println("Could not parse date: " + trimmed);
        return trimmed;
    }

    private boolean containsAnyIgnoreCase(String text, String[] terms) {
        text = text.toLowerCase();
        for (String term : terms) {
            if (text.contains(term.toLowerCase())) return true;
        }
        return false;
    }

    public JSONObject extractCVData(String cvText) {
        JSONObject result = new JSONObject();
        result.put("personal_info", new JSONObject());
        result.put("summary", "");
        result.put("education", new JSONArray());
        result.put("experience", new JSONArray());
        result.put("skills", new JSONArray());
        result.put("references", new JSONArray());

        System.out.println("Plain text extracted: " + (cvText.length() > 100 ? cvText.substring(0, 100) + "..." : cvText));

        debugExtraction(cvText);
        Map<String, List<String>> sections = extractSections(cvText);

        System.out.println("\n=== SECTIONS EXTRACTION RESULTS ===");
        for (Map.Entry<String, List<String>> entry : sections.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue().size() + " items");
            for (int i = 0; i < Math.min(3, entry.getValue().size()); i++) {
                System.out.println("  - " + entry.getValue().get(i));
            }
        }

        System.out.println("\n=== PERSONAL INFORMATION SECTION ===");
        extractPersonalInfo(cvText, result);
        System.out.println("Personal info extracted: " + result.getJSONObject("personal_info").toString(2));

        System.out.println("\n=== SUMMARY SECTION ===");
        if (sections.containsKey("summary")) {
            String summary = String.join("\n", sections.get("summary"));
            result.put("summary", summary);
        }

        System.out.println("\n=== EDUCATION SECTION ===");
        if (sections.containsKey("education")) {
            JSONArray educationArray = parseEducation(sections.get("education"));
            result.put("education", educationArray);
        }

        System.out.println("\n=== EXPERIENCE SECTION ===");
        if (sections.containsKey("experience")) {
            JSONArray experienceArray = parseExperienceFlexible(sections.get("experience"));
            result.put("experience", experienceArray);
        }

        System.out.println("\n=== SKILLS SECTION ===");
        if (sections.containsKey("skills")) {
            JSONArray skillsArray = parseSkills(sections.get("skills"));
            result.put("skills", skillsArray);
        }

        System.out.println("\n=== REFERENCES SECTION ===");
        if (sections.containsKey("references")) {
            JSONArray referencesArray = parseReferences(sections.get("references"));
            result.put("references", referencesArray);
        }

        System.out.println("\n=== CV EXTRACTION COMPLETED ===");
        System.out.println(result.toString());
        return result;
    }

    private Map<String, List<String>> extractSections(String plainText) {
        System.out.println("Extracting sections from document");
        Map<String, List<String>> sections = new HashMap<>();
        sections.put("summary", new ArrayList<>());
        sections.put("education", new ArrayList<>());
        sections.put("experience", new ArrayList<>());
        sections.put("skills", new ArrayList<>());
        sections.put("references", new ArrayList<>());

        System.out.println("Using line-based section extraction");
        extractSectionsLineByLine(plainText, sections);

        for (String section : sections.keySet()) {
            System.out.println("Section '" + section + "' contains " + sections.get(section).size() + " entries");
        }
        return sections;
    }

    /**
     * Detects section headers including prefixed formats like "A. EDUCATION", "B. EXPERIENCE"
     */

    /*
    private String detectSectionHeader(String line) {
        String lowerLine = line.toLowerCase().trim();

        // Strip common prefix patterns: "A.", "B.", "1.", "I." etc.
        lowerLine = lowerLine.replaceAll("^[a-z0-9]{1,3}\\.\\s*", "");

        // Remove trailing formatting characters
        lowerLine = lowerLine.replaceAll("[:\\-_=•]+$", "").trim();

        // Must be short enough to be a header (real headers are rarely > 60 chars)
        if (lowerLine.length() > 60) return null;

        System.out.println("Checking header: '" + lowerLine + "'");

        for (String header : SUMMARY_HEADERS) {
            if (lowerLine.equals(header) || lowerLine.startsWith(header)) return "summary";
        }
        for (String header : EDUCATION_HEADERS) {
            if (lowerLine.equals(header) || lowerLine.startsWith(header)) return "education";
        }
        for (String header : EXPERIENCE_HEADERS) {
            if (lowerLine.equals(header) || lowerLine.startsWith(header)) return "experience";
        }
        for (String header : SKILLS_HEADERS) {
            if (lowerLine.equals(header) || lowerLine.startsWith(header)) return "skills";
        }
        for (String header : REFERENCES_HEADERS) {
            if (lowerLine.equals(header) || lowerLine.startsWith(header)) return "references";
        }
        return null;
    }

    private void extractSectionsLineByLine(String plainText, Map<String, List<String>> sections) {
        String[] lines = plainText.split("\\r?\\n");
        String currentSection = null;

        for (String line : lines) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;

            String detectedSection = detectSectionHeader(trimmed);
            if (detectedSection != null) {
                currentSection = detectedSection;
                System.out.println("Set section: " + currentSection + " from line: " + trimmed);
                continue;
            }

            // Skip URLs and mailto links — they pollute all sections
            if (trimmed.startsWith("http") || trimmed.startsWith("mailto:")) continue;

            if (currentSection != null && sections.containsKey(currentSection)) {
                sections.get(currentSection).add(trimmed);
            } else if (currentSection == null) {
                String inferred = inferSectionFromContent(trimmed);
                if (inferred != null) sections.get(inferred).add(trimmed);
            }
        }
    }

    private String inferSectionFromContent(String line) {
        String lower = line.toLowerCase();
        if (containsAnyIgnoreCase(line, DEGREE_TERMS) || containsAnyIgnoreCase(line, SCHOOL_TERMS)) return "education";
        if (containsAnyIgnoreCase(line, PROFESSIONAL_TITLES) || containsAnyIgnoreCase(line, COMPANY_TERMS)) return "experience";
        if (line.length() < 50 && (lower.contains("java") || lower.contains("python") || lower.contains("sql") || lower.contains("•"))) return "skills";
        if (lower.contains("@") || PHONE_PATTERN.matcher(line).find()) return "references";
        return null;
    }

    private void debugExtraction(String plainText) {
        System.out.println("=== DEBUG: Content length: " + plainText.length());
        System.out.println("First 300 chars:\n" + plainText.substring(0, Math.min(300, plainText.length())));
        System.out.println("\n=== DEBUG: SECTION HEADER SCAN ===");
        String[] lines = plainText.split("\\r?\\n");
        for (int i = 0; i < Math.min(25, lines.length); i++) {
            String line = lines[i].trim();
            if (!line.isEmpty()) {
                String detected = detectSectionHeader(line);
                System.out.println("Line " + i + ": '" + line + "'" + (detected != null ? " -> SECTION: " + detected : ""));
            }
        }
    }

    private boolean allSectionsEmpty(Map<String, List<String>> sections) {
        for (List<String> c : sections.values()) { if (!c.isEmpty()) return false; }
        return true;
    }

    private boolean containsAny(String text, String[] keywords) {
        for (String keyword : keywords) { if (text.contains(keyword)) return true; }
        return false;
    }

    private void extractPersonalInfo(String plainText, JSONObject result) {
        JSONObject personalInfo = new JSONObject();

        // Step 1: Extract name from first non-empty line — most reliable signal
        String[] lines = plainText.trim().split("\\r?\\n");
        for (String line : lines) {
            String trimmed = line.trim();
            // Skip blank, URL, and mailto lines
            if (trimmed.isEmpty() || trimmed.startsWith("http") || trimmed.startsWith("mailto:")) continue;
            // Take first reasonable line as name if it looks like a name (short, no @ or digits dominating)
            if (trimmed.length() > 2 && trimmed.length() < 60 && !trimmed.contains("@") && !trimmed.matches(".*\\d{5,}.*")) {
                // Strip anything after | , + phone numbers — take just the name part
                String namePart = trimmed.split("[|,+]")[0].trim();
                if (namePart.length() > 2) {
                    personalInfo.put("name", namePart);
                    System.out.println("[FirstLine] Assigned name: " + namePart);
                }
            }
            break;
        }

        // Step 2: CoreNLP for email and supplementary entities
        try {
            CoreDocument doc = new CoreDocument(plainText.substring(0, Math.min(1000, plainText.length())));
            nlpPipeline.annotate(doc);
            for (CoreEntityMention em : doc.entityMentions()) {
                System.out.println("  " + em.entityType() + ": " + em.text());
                if (em.entityType().equals("EMAIL") && !personalInfo.has("email")) {
                    personalInfo.put("email", em.text());
                }
            }
        } catch (Exception e) {
            System.out.println("[CoreNLP] Failed: " + e.getMessage());
        }

        // Step 3: Regex fallback for email
        if (!personalInfo.has("email")) {
            Matcher emailMatcher = EMAIL_PATTERN.matcher(plainText);
            if (emailMatcher.find()) personalInfo.put("email", emailMatcher.group(0));
        }

        // Step 4: Phone
        Matcher phoneMatcher = PHONE_PATTERN.matcher(plainText);
        if (phoneMatcher.find()) personalInfo.put("phone", phoneMatcher.group(0));

        // Step 5: Labeled fields
        Matcher personalInfoMatcher = PERSONAL_INFO_PATTERN.matcher(plainText);
        while (personalInfoMatcher.find()) {
            String infoLine = personalInfoMatcher.group(0).toLowerCase();
            String value = personalInfoMatcher.group(1).trim();
            if (infoLine.contains("address") && !personalInfo.has("address")) personalInfo.put("address", value);
            else if (infoLine.contains("name") && !personalInfo.has("name")) personalInfo.put("name", value);
            else if ((infoLine.contains("phone") || infoLine.contains("mobile")) && !personalInfo.has("phone")) personalInfo.put("phone", value);
            else if (infoLine.contains("email") && !personalInfo.has("email")) personalInfo.put("email", value);
        }

        result.put("personal_info", personalInfo);
    }

    private boolean isLikelyName(String text) {
        String[] parts = text.split("\\s+");
        if (parts.length >= 2 && parts.length <= 3) {
            for (String part : parts) {
                if (part.isEmpty() || !Character.isUpperCase(part.charAt(0))) return false;
            }
            return true;
        }
        return false;
    }

    private JSONArray parseEducation(List<String> educationSection) {
        System.out.println("Parsing education section with " + educationSection.size() + " entries");
        JSONArray education = new JSONArray();
        Matcher dateMatcher;
        String institute = "", certificate = "", rawdate = "";

        for (String line : educationSection) {
            String text = line.trim().toLowerCase().replaceAll("[.,;:]$", "");
            System.out.println("  Examining line: " + line);

            dateMatcher = DATE_RANGE_PATTERN2.matcher(text);
            if (rawdate.isEmpty() && dateMatcher.find()) {
                rawdate = line.trim();
            } else if (certificate.isEmpty() && containsAny(text, DEGREE_TERMS)) {
                certificate = line.trim();
            } else if (institute.isEmpty() && containsAny(text, SCHOOL_TERMS)) {
                institute = line.trim();
            }

            if (!institute.isEmpty() && !certificate.isEmpty() && !rawdate.isEmpty()) {
                JSONObject entry = buildEducationEntry(institute, certificate, rawdate);
                education.put(entry);
                System.out.println("  Saved entry: " + entry.toString(2));
                institute = ""; certificate = ""; rawdate = "";
            }
        }
        return education;
    }

    private JSONArray parseExperienceFlexible(List<String> experienceSection) {
        JSONArray experience = new JSONArray();
        List<List<String>> jobBlocks = new ArrayList<>();
        List<String> currentBlock = new ArrayList<>();

        for (String line : experienceSection) {
            line = line.trim();
            if (line.isEmpty()) {
                if (!currentBlock.isEmpty()) { jobBlocks.add(new ArrayList<>(currentBlock)); currentBlock.clear(); }
            } else {
                currentBlock.add(line);
            }
        }
        if (!currentBlock.isEmpty()) jobBlocks.add(currentBlock);

        for (List<String> block : jobBlocks) {
            JSONObject job = extractJobFromBlock(block);
            if (job.length() > 0) experience.put(job);
        }
        return experience;
    }

    private JSONObject extractJobFromBlock(List<String> lines) {
        JSONObject job = new JSONObject();
        for (String line : lines) {
            if (containsDate(line)) job.put("dates", line);
            else if (!job.has("position")) job.put("position", line);
            else if (!job.has("company")) job.put("company", line);
            else job.put("description", job.optString("description", "") + " " + line);
        }
        return job;
    }

    private boolean containsDate(String text) {
        return text.matches(".*\\b(19|20)\\d{2}\\b.*") ||
               text.toLowerCase().contains("present") ||
               text.toLowerCase().contains("current") ||
               text.matches(".*\\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\\b.*");
    }

    private JSONArray parseSkills(List<String> skillsSection) {
        JSONArray skills = new JSONArray();
        String skillText = String.join(" ", skillsSection);
        String[] delimiters = {"•", "·", ",", ";", "\\|"};
        for (String delimiter : delimiters) {
            String[] items = skillText.split(delimiter);
            if (items.length > 1) {
                for (String item : items) {
                    String trimmed = item.trim();
                    if (!trimmed.isEmpty() && trimmed.length() < 50) skills.put(trimmed);
                }
                return skills;
            }
        }
        // Fallback: add each line as a skill
        for (String line : skillsSection) {
            String trimmed = line.trim();
            if (!trimmed.isEmpty()) skills.put(trimmed);
        }
        return skills;
    }

    private JSONArray parseReferences(List<String> referencesSection) {
        JSONArray references = new JSONArray();
        for (int i = 0; i + 3 < referencesSection.size(); i += 4) {
            JSONObject entry = new JSONObject();
            entry.put("referee-name", referencesSection.get(i).trim());
            entry.put("referee-position", referencesSection.get(i + 1).trim());
            entry.put("referee-company", referencesSection.get(i + 2).trim());
            entry.put("referee-email", referencesSection.get(i + 3).trim());
            references.put(entry);
        }
        return references;
    }

    private void addReferenceEntry(JSONArray references, String referenceText) {
        JSONObject reference = new JSONObject();
        reference.put("raw", referenceText.trim());
        String[] lines = referenceText.split("\n");
        if (lines.length > 0 && isLikelyName(lines[0].trim())) reference.put("name", lines[0].trim());
        Matcher emailMatcher = EMAIL_PATTERN.matcher(referenceText);
        if (emailMatcher.find()) reference.put("email", emailMatcher.group(0));
        Matcher phoneMatcher = PHONE_PATTERN.matcher(referenceText);
        if (phoneMatcher.find()) reference.put("phone", phoneMatcher.group(0));
        references.put(reference);
    }

    private void addEducationEntry(JSONArray education, String entryText) {
        JSONObject entry = new JSONObject();
        entry.put("raw", entryText.trim());
        Pattern degreePattern = Pattern.compile("(?i)(Bachelor|Master|Ph\\.?D|Diploma|Certificate|Degree|BSc|BA|MSc|MA|MBA|MD|LLB)[^,;.]*");
        Matcher degreeMatcher = degreePattern.matcher(entryText);
        if (degreeMatcher.find()) entry.put("degree", degreeMatcher.group(0).trim());
        Pattern institutionPattern = Pattern.compile("(?i)(University|College|School|Institute)[^,;.]*");
        Matcher institutionMatcher = institutionPattern.matcher(entryText);
        if (institutionMatcher.find()) entry.put("institution", institutionMatcher.group(0).trim());
        education.put(entry);
    }

    private void addExperienceEntry(JSONArray experience, String entryText) {
        JSONObject entry = new JSONObject();
        entry.put("raw", entryText.trim());
        experience.put(entry);
    }

    private void extractDates(String text, JSONObject obj) {
        Pattern dateRangePattern = Pattern.compile(
            "((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[.,\\s]+)?\\d{4}\\s*[\\-–—to]+\\s*((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[.,\\s]+)?\\d{4}|Present|Current",
            Pattern.CASE_INSENSITIVE);
        Matcher m = dateRangePattern.matcher(text);
        if (m.find()) {
            String[] parts = m.group(0).split("[\\-–—to]+");
            if (parts.length >= 2) { obj.put("start_date", parts[0].trim()); obj.put("end_date", parts[1].trim()); }
        }
    }

    private boolean isCommonWord(String word) {
        String[] common = {"the", "and", "for", "with", "that", "this", "from", "they", "have", "been"};
        word = word.toLowerCase();
        for (String c : common) { if (word.equals(c)) return true; }
        return false;
    }
}
*/