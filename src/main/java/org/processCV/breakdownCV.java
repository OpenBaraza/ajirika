package org.processCV;

import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.IOException;

import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Locale;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.format.DateTimeParseException;

import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONObject;
import org.json.JSONArray;

import opennlp.tools.sentdetect.SentenceDetectorME;
import opennlp.tools.sentdetect.SentenceModel;


public class breakdownCV {
	private static final Logger log = Logger.getLogger(breakdownCV.class.getName());

	// private static final String SENTENCE_MODEL_PATH = "./models/en-sent.bin";

	// Section detection patterns
	private static final Pattern PERSONAL_INFO_PATTERN = Pattern.compile("(?i)(?:name|email|phone|address|contact|mobile)\\s*:?\\s*([^\\n]+)");
	private static final Pattern EMAIL_PATTERN = Pattern.compile("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b");
	private static final Pattern PHONE_PATTERN = Pattern.compile("(?:\\+?\\d{1,3}[-.\\s]?)?\\d{3}[-.\\s]?\\d{3}[-.\\s]?\\d{4}");

	private static final Pattern NAME_PATTERN = Pattern.compile("(?i)^([A-Z][a-z]+(\\s[A-Z][a-z]+)+)$");

	private static final Pattern DATE_RANGE_PATTERN = Pattern.compile("\\d{4}-\\d{2}-\\d{2}\\s*[-–—]\\s*\\d{4}-\\d{2}-\\d{2}");

	private static final Pattern DATE_RANGE_PATTERN2 = Pattern.compile(
		"(?i)(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)\\s*[-–—]\\s*(\\d{4}-\\d{2}-\\d{2}|(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\\s*\\d{0,4}|\\d{4}|present|currently)"
	);

	// Common CV section headers
	private static final String[] SUMMARY_HEADERS = {"summary", "profile", "professional summary", "personal profile", "about me", "objective"};
	private static final String[] EDUCATION_HEADERS = {"education", "educational background", "academic qualifications", "academic background", "qualifications"};
	
	private static final String[] EXPERIENCE_HEADERS = {
		"experience", "work experience", "employment history",
		"professional experience", "career history", "work history",
		"employment", "professional background", "career summary",
		"work", "jobs", "positions", "career", "professional"
	};
	private static final String[] EXP_OUTLIERS = {
		"objective"
	};
	private static final String[] SKILLS_HEADERS = {
		"skills", "technical skills", "core competencies", "key skills", "professional skills"
	};
	private static final String[] REFERENCES_HEADERS = {"references", "referees", "professional references"};
	private static final String[] DEGREE_TERMS = {"certificate", "bachelor", "master", "phd", "course"};
	private static final String[] SCHOOL_TERMS = {
		"school", "college", "university", "institute", "academy", "polytechnic", "college",
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

	public class HeaderResults {
		public List<String> expHeader = new ArrayList<>();
		public List<String> eduHeader = new ArrayList<>();
		public List<String> skillsHeader = new ArrayList<>();
		public List<String> refHeader = new ArrayList<>();
	}

	HeaderResults sectionResults = new HeaderResults();

	public JSONObject identifySections(Map<String, List<String>> allHeaders, String cvText) {
		System.out.println("Identifying sections from document");

		// === HEADER DETECTION ===
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

		// === INIT SECTION CONTENT MAP ===
		Map<String, List<String>> sectionContent = new HashMap<>();
		sectionContent.put("experience", new ArrayList<>());
		sectionContent.put("education", new ArrayList<>());
		sectionContent.put("skills", new ArrayList<>());
		sectionContent.put("references", new ArrayList<>());

		String[] lines = cvText.split("\\r?\\n");

		String currentSection = null;
		for (String line : lines) {
			String trimmed = line.trim();

			if (sectionResults.expHeader.contains(trimmed)) {
				currentSection = "experience";
				continue;
			}
			if (sectionResults.eduHeader.contains(trimmed)) {
				currentSection = "education";
				continue;
			}
			if (sectionResults.skillsHeader.contains(trimmed)) {
				currentSection = "skills";
				continue;
			}
			if (sectionResults.refHeader.contains(trimmed)) {
				currentSection = "references";
				continue;
			}

			// Add content under the current section
			if (currentSection != null && sectionContent.containsKey(currentSection)) {
				sectionContent.get(currentSection).add(trimmed);
			}
		}

		System.out.println("========== SECTION CONTENT ==========");

		for (Map.Entry<String, List<String>> entry : sectionContent.entrySet()) {
			String sectionName = entry.getKey();
			List<String> linesInSection = entry.getValue();

			System.out.println("---- " + sectionName.toUpperCase() + " ----");

			if (linesInSection.isEmpty()) {
				System.out.println("  (no content found)");
			} else {
				for (String line : linesInSection) {
					System.out.println("  " + line);
				}
			}

			System.out.println(); // blank line between sections
		}

		// === FINAL JSON OBJECT ===
		JSONObject infoArray = new JSONObject();
		infoArray.put("education", new JSONArray());
		infoArray.put("experience", new JSONArray());
		infoArray.put("skills", new JSONArray());
		infoArray.put("references", new JSONArray());

		// Parse each section with its handler
		parseEducationAndStore(sectionContent, infoArray);
		parseExperienceAndStore(sectionContent, infoArray);
		parseSkillsAndStore(sectionContent, infoArray);
		parseReferencesAndStore(sectionContent, infoArray);

		// Pretty print
		// System.out.println("Final JSON: " + infoArray.toString(2));

		return infoArray;
	}

	// ==================== EXPERIENCE ====================
	private void parseExperienceAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
		List<String> experienceSection = sectionContent.getOrDefault("experience", Collections.emptyList());

		System.out.println("-------------------------------------------------------------------------");
		System.out.println("Parsing experience section with " + experienceSection.size() + " entries");

		JSONArray experienceArray = infoArray.getJSONArray("experience");

		String jobTitle = "", company = "", rawdate = "";

		Matcher dateMatcher;

		for (String line : experienceSection) {
			String text = line.trim();
			String lower = text.toLowerCase().replaceAll("[.,;:]$", "");

			System.out.println("    Examining line: " + text);

			// Date detection
			dateMatcher = DATE_RANGE_PATTERN2.matcher(lower);
			if (rawdate.isEmpty() && dateMatcher.find()) {
				System.out.println("    Found date line: " + text);
				rawdate = text;

				System.out.println("    date: " + rawdate);
				System.out.println("    job: " + jobTitle);
				System.out.println("    company: " + company);
				System.out.println("");
			}

			// If job title empty, assign first capitalized line
			if (jobTitle.isEmpty() && containsAny(lower, PROFESSIONAL_TITLES) && !containsAny(lower, COMPANY_TERMS)) {
				System.out.println("    Found job title: " + text);
				jobTitle = text;

				System.out.println("    date: " + rawdate);
				System.out.println("    job: " + jobTitle);
				System.out.println("    company: " + company);
				System.out.println("");
			}

			// If company empty, assign second capitalized line
			if (company.isEmpty() && containsAny(lower, COMPANY_TERMS)) {
				System.out.println("    Found company: " + text);
				company = text;

				System.out.println("    date: " + rawdate);
				System.out.println("    job: " + jobTitle);
				System.out.println("    company: " + company);
				System.out.println("");
			}

			// When all filled, save entry
			if (!jobTitle.isEmpty() && !company.isEmpty() && !rawdate.isEmpty()) {
				JSONObject entry = new JSONObject();
				entry.put("role", jobTitle);
				entry.put("employer", company);
				entry.put("dates", rawdate);
				experienceArray.put(entry);

				System.out.println("Saved experience entry: " + entry.toString(2));

				// reset
				jobTitle = "";
				company = "";
				rawdate = "";
			}
		}
	}

	// ==================== SKILLS ====================
	private void parseSkillsAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
		List<String> skillsSection = sectionContent.getOrDefault("skills", Collections.emptyList());

		System.out.println("-------------------------------------------------------------------------");
		System.out.println("Parsing skills section with " + skillsSection.size() + " entries");

		JSONArray skillsArray = infoArray.getJSONArray("skills");

		for (String line : skillsSection) {
			String text = line.trim();
			if (!text.isEmpty()) {
				skillsArray.put(text);
				System.out.println("Added skill: " + text);
			}
		}
	}

	// ==================== REFERENCES ====================
	private void parseReferencesAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
		List<String> referenceSection = sectionContent.getOrDefault("references", Collections.emptyList());

		System.out.println("-------------------------------------------------------------------------");
		System.out.println("Parsing reference section with " + referenceSection.size() + " entries");

		JSONArray referenceArray = infoArray.getJSONArray("references");

		String name = "", org = "", role = "", contact = "";

		for (String line : referenceSection) {
			String text = line.trim();

			if (name.isEmpty() && !text.isEmpty()) {
				name = text;
				continue;
			} else if (org.isEmpty() && !text.isEmpty()) {
				org = text;
				continue;
			} else if (role.isEmpty() && !text.isEmpty()) {
				role = text;
				continue;
			} else if (contact.isEmpty() && (text.contains("@") || text.matches(".*\\d{3,}.*"))) {
				contact = text;
			}

			if (!name.isEmpty() && !org.isEmpty() && !role.isEmpty() && !contact.isEmpty()) {
				JSONObject entry = new JSONObject();
				entry.put("name", name);
				entry.put("organization", org);
				entry.put("role", role);
				entry.put("contact", contact);

				referenceArray.put(entry);

				System.out.println("Saved reference entry: " + entry.toString(2));

				// reset
				name = "";
				org = "";
				role = "";
				contact = "";
			}
		}
	}

	// ==================== EDUCATION ====================

	private void parseEducationAndStore(Map<String, List<String>> sectionContent, JSONObject infoArray) {
		List<String> educationSection = sectionContent.getOrDefault("education", Collections.emptyList());
	
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("Parsing education section with " + educationSection.size() + " entries");
	
		JSONArray educationArray = infoArray.getJSONArray("education");
	
		Matcher dateMatcher;
		String institute = "", certificate = "", rawdate = "";
	
		for (String line : educationSection) {
			String trimmed = line.trim();
			String lower = trimmed.toLowerCase().replaceAll("[.,;:]$", "");
			System.out.println("  Examining line: " + trimmed);
	
			// Date line
			dateMatcher = DATE_RANGE_PATTERN2.matcher(lower);
			if (rawdate.isEmpty() && dateMatcher.find()) {
				System.out.println("    Found date line: " + trimmed);
				rawdate = trimmed;
			}
			// Degree or Certification line
			else if (certificate.isEmpty() && containsAny(lower, DEGREE_TERMS)) {
				System.out.println("    Found certification line: " + trimmed);
				certificate = trimmed;
			}
			// Institution line
			else if (institute.isEmpty() && containsAny(lower, SCHOOL_TERMS)) {
				System.out.println("    Found institution line: " + trimmed);
				institute = trimmed;
			}
	
			// When all 3 fields are filled, create entry
			if (!institute.isEmpty() && !certificate.isEmpty() && !rawdate.isEmpty()) {
				JSONObject eduEntry = buildEducationEntry(institute, certificate, rawdate);
				educationArray.put(eduEntry);
				System.out.println("  Saved entry: " + eduEntry.toString(2));
	
				// Reset for next block
				institute = "";
				certificate = "";
				rawdate = "";
			}
		}
	}
	
	/**
	 * Builds the education JSON object with parsed dates and edu-level
	 */
	private JSONObject buildEducationEntry(String institute, String certificate, String rawdate) {
		JSONObject entry = new JSONObject();
	
		String[] parts = rawdate.replaceAll("[–—]", "-").split("\\s* - \\s*");
		String eduFrom = parseDateFlexible(parts[0]);
		String eduTo = (parts.length == 2) ? parseDateFlexible(parts[1]) : "";
	
		String eduLevel;
		if (certificate.toLowerCase().contains("certificate")) {
			eduLevel = "4";
		} else if (certificate.toLowerCase().contains("high school")) {
			eduLevel = "3";
		} else if (certificate.toLowerCase().contains("secondary")) {
			eduLevel = "2";
		} else if (certificate.toLowerCase().contains("bachelor") || certificate.toLowerCase().contains("degree")) {
			eduLevel = "8";
		} else if (certificate.toLowerCase().contains("master") || certificate.toLowerCase().contains("phd")) {
			eduLevel = "9";
		} else if (certificate.toLowerCase().contains("diploma")) {
			eduLevel = "7";
		} else {
			eduLevel = "N/A";
		}
	
		entry.put("edu-level", eduLevel);
		entry.put("institution", institute);
		entry.put("edu-from", eduFrom);
		entry.put("edu-to", eduTo);
		entry.put("certification", certificate);
	
		return entry;
	}
	
	/**
	 * Tries to parse a date string with multiple formats
	 */
	private String parseDateFlexible(String dateStr) {
		DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String trimmed = dateStr.trim();
	
		// Special case: present/current
		if (trimmed.equalsIgnoreCase("present") || trimmed.equalsIgnoreCase("ongoing") || trimmed.equalsIgnoreCase("current")) {
			return LocalDate.now().format(outputFormat);
		}
	
		// Try full date formats
		for (String pattern : fullDateFormats) {
			try {
				DateTimeFormatter formatter = new DateTimeFormatterBuilder()
						.parseCaseInsensitive()
						.appendPattern(pattern)
						.toFormatter();
				LocalDate date = LocalDate.parse(trimmed, formatter);
				return date.format(outputFormat);
			} catch (DateTimeParseException ignored) {}
		}
	
		// Try partial date formats (e.g., MMM yyyy)
		for (String pattern : partialDateFormats) {
			try {
				DateTimeFormatter formatter = new DateTimeFormatterBuilder()
						.parseCaseInsensitive()
						.appendPattern(pattern)
						.toFormatter();
				YearMonth ym = YearMonth.parse(trimmed, formatter);
				return ym.atDay(1).format(outputFormat);
			} catch (DateTimeParseException ignored) {}
		}
	
		// Try year-only
		try {
			int yearOnly = Integer.parseInt(trimmed);
			return LocalDate.of(yearOnly, 1, 1).format(outputFormat);
		} catch (NumberFormatException ignored) {}
	
		// Could not parse
		System.out.println("⚠️ Could not parse date: " + trimmed);
		return trimmed;
	}

	private boolean containsAnyIgnoreCase(String text, String[] terms) {
		text = text.toLowerCase();
		for (String term : terms) {
			if (text.contains(term.toLowerCase())) {
				return true;
			}
		}
		return false;
	}


	/**
	* Extracts structured data from a CV
	*
	* @param cvFile InputStream containing the CV document
	* @return JSONObject with structured CV data
	*/
	public JSONObject extractCVData(String cvText) {
		JSONObject result = new JSONObject();

		// Create base sections for data
		result.put("personal_info", new JSONObject());
		result.put("summary", "");
		result.put("education", new JSONArray());
		result.put("experience", new JSONArray());
		result.put("skills", new JSONArray());
		result.put("references", new JSONArray());


		// Extract text content
		// String cvText = doc.body().text();
		// result.put("plain_text", plainText);
		System.out.println("Plain text extracted: " + (cvText.length() > 100 ? cvText.substring(0, 100) + "..." : cvText));


		// Add debug information
		debugExtraction(cvText);

		// Extract sections
		Map<String, List<String>> sections = extractSections(cvText);

		// Log what was found
		System.out.println("\n=== SECTIONS EXTRACTION RESULTS ===");
		for (Map.Entry<String, List<String>> entry : sections.entrySet()) {
			System.out.println(entry.getKey() + ": " + entry.getValue().size() + " items");
			for (int i = 0; i < Math.min(3, entry.getValue().size()); i++) {
				System.out.println("  - " + entry.getValue().get(i));
			}
			if (entry.getValue().size() > 3) {
				System.out.println("  ... and " + (entry.getValue().size() - 3) + " more items");
			}
		}

		// Process personal information
		System.out.println("\n=== PERSONAL INFORMATION SECTION ===");
		extractPersonalInfo(cvText, result);
		System.out.println("Personal info extracted: " + result.getJSONObject("personal_info").toString(2));

		// Process summary
		System.out.println("\n=== SUMMARY SECTION ===");
		if (sections.containsKey("summary")) {
			String summary = String.join("\n", sections.get("summary"));
			result.put("summary", summary);
			System.out.println("Summary extracted: " + summary);
		} else {
			System.out.println("No summary section found");
		}

		// Process education
		System.out.println("\n=== EDUCATION SECTION ===");
		if (sections.containsKey("education")) {
			List<String> educationContent = sections.get("education");
			System.out.println("Raw education content:");
			for (String line : educationContent) {
				System.out.println("  - " + line);
			}

			JSONArray educationArray = parseEducation(educationContent);
			result.put("education", educationArray);
			System.out.println("Parsed education entries: " + educationArray.length());
			for (int i = 0; i < educationArray.length(); i++) {
				System.out.println("  Entry " + (i+1) + ": " + educationArray.getJSONObject(i).toString(2));
			}
		} else {
			System.out.println("No education section found");
		}

		// Process experience
		System.out.println("\n=== EXPERIENCE SECTION ===");
		if (sections.containsKey("experience")) {
			List<String> experienceContent = sections.get("experience");
			System.out.println("Raw experience content:");
			for (String line : experienceContent) {
				System.out.println("  - " + line);
			}

			JSONArray experienceArray = parseExperienceFlexible(experienceContent);
			result.put("experience", experienceArray);
			System.out.println("Parsed experience entries: " + experienceArray.length());
			for (int i = 0; i < experienceArray.length(); i++) {
				System.out.println("  Entry " + (i+1) + ": " + experienceArray.getJSONObject(i).toString(2));
			}
		} else {
			System.out.println("No experience section found");
		}

		// Process skills
		System.out.println("\n=== SKILLS SECTION ===");
		if (sections.containsKey("skills")) {
			List<String> skillsContent = sections.get("skills");
			System.out.println("Raw skills content:");
			for (String line : skillsContent) {
				System.out.println("  - " + line);
			}

			JSONArray skillsArray = parseSkills(skillsContent);
			result.put("skills", skillsArray);
			System.out.println("Parsed skills: " + skillsArray.length());
			System.out.println("Skills: " + skillsArray.toString(2));
		} else {
			System.out.println("No skills section found");
		}

		// Process references
		System.out.println("\n=== REFERENCES SECTION ===");
		if (sections.containsKey("references")) {
			List<String> referencesContent = sections.get("references");
			System.out.println("Raw references content:");
			for (String line : referencesContent) {
				System.out.println("  - " + line);
			}

			JSONArray referencesArray = parseReferences(referencesContent);
			result.put("references", referencesArray);
			System.out.println("Parsed references: " + referencesArray.length());
			for (int i = 0; i < referencesArray.length(); i++) {
				System.out.println("  Entry " + (i+1) + ": " + referencesArray.getJSONObject(i).toString(2));
			}
		} else {
			System.out.println("No references section found");
		}

		System.out.println("\n=== CV EXTRACTION COMPLETED ===");

		System.out.println(result.toString());

		return result;
	}

	/**
	* Extracts sections from the document
	*/
	private Map<String, List<String>> extractSections(String plainText) {
		System.out.println("Extracting sections from document");
		Map<String, List<String>> sections = new HashMap<>();
		// Initialize sections
		sections.put("summary", new ArrayList<>());
		sections.put("education", new ArrayList<>());
		sections.put("experience", new ArrayList<>());
		sections.put("skills", new ArrayList<>());
		sections.put("references", new ArrayList<>());
		List<String> sectionOrder = new ArrayList<>();

		// === LOAD SENTENCE MODEL FROM CLASSPATH ===
		try (InputStream modelIn = breakdownCV.class.getResourceAsStream("/models/en-sent.bin")) {
			if (modelIn == null) {
				System.err.println("Sentence model not found in classpath. Falling back to line-based parsing.");
				extractSectionsLineByLine(plainText, sections);
				return sections;
			}
			System.out.println("Using OpenNLP sentence detector from classpath");
			SentenceModel model = new SentenceModel(modelIn);
			SentenceDetectorME sentenceDetector = new SentenceDetectorME(model);
			String[] sentences = sentenceDetector.sentDetect(plainText);
			System.out.println("Detected " + sentences.length + " sentences");

			String currentSection = null;
			for (String sentence : sentences) {
				String trimmed = sentence.trim();
				if (trimmed.isEmpty()) continue;
				System.out.println("Processing sentence: " + trimmed);

				// Check if this sentence is a section header
				String detectedSection = detectSectionHeader(trimmed);
				if (detectedSection != null) {
					currentSection = detectedSection;
					System.out.println("Detected section header: " + currentSection);
					if (!sectionOrder.contains(currentSection)) {
						sectionOrder.add(currentSection);
					}
					continue;
				}

				// Add content to current section
				if (currentSection != null && sections.containsKey(currentSection)) {
					sections.get(currentSection).add(trimmed);
					System.out.println("Added to " + currentSection + ": " + trimmed);
				}
			}
		} catch (IOException e) {
			System.err.println("Error loading sentence model: " + e.getMessage());
			e.printStackTrace();
			// Fallback to line-based parsing on any error
			extractSectionsLineByLine(plainText, sections);
		}

		// If no sections found, try alternative extraction
		if (allSectionsEmpty(sections)) {
			System.out.println("No sections found with sentence-based approach, trying line-based approach");
			extractSectionsLineByLine(plainText, sections);
		}

		// Print section statistics
		for (String section : sections.keySet()) {
			System.out.println("Section '" + section + "' contains " + sections.get(section).size() + " entries");
		}
		return sections;
	}

	private String detectSectionHeader(String line) {
		String lowerLine = line.toLowerCase().trim();

		// Remove common formatting characters
		lowerLine = lowerLine.replaceAll("[:\\-_=•]+$", "").trim();

		System.out.println("Checking if '" + lowerLine + "' is a section header");

		// Check against known headers with exact and partial matches
		for (String header : SUMMARY_HEADERS) {
			if (lowerLine.equals(header) ||
				(lowerLine.contains(header) && lowerLine.length() < header.length() + 10)) {
				System.out.println("Matched summary header: " + header);
				return "summary";
			}
		}

		for (String header : EDUCATION_HEADERS) {
			if (lowerLine.equals(header) ||
				(lowerLine.contains(header) && lowerLine.length() < header.length() + 10)) {
				System.out.println("Matched education header: " + header);
				return "education";
			}
		}

		for (String header : EXPERIENCE_HEADERS) {
			if (lowerLine.equals(header) ||
				(lowerLine.contains(header) && lowerLine.length() < header.length() + 10)) {
				System.out.println("Matched experience header: " + header);
				return "experience";
			}
		}

		for (String header : SKILLS_HEADERS) {
			if (lowerLine.equals(header) ||
				(lowerLine.contains(header) && lowerLine.length() < header.length() + 10)) {
				System.out.println("Matched skills header: " + header);
				return "skills";
			}
		}

		for (String header : REFERENCES_HEADERS) {
			if (lowerLine.equals(header) ||
				(lowerLine.contains(header) && lowerLine.length() < header.length() + 10)) {
				System.out.println("Matched references header: " + header);
				return "references";
			}
		}

		return null;
	}

	private void extractSectionsLineByLine(String plainText, Map<String, List<String>> sections) {
		System.out.println("Using line-by-line extraction fallback");
		String[] lines = plainText.split("\n");
		String currentSection = null;

		for (int i = 0; i < lines.length; i++) {
			String line = lines[i].trim();
			if (line.isEmpty()) continue;

			System.out.println("Line " + i + ": " + line);

			// Check if this line is a section header
			String detectedSection = detectSectionHeader(line);
			if (detectedSection != null) {
				currentSection = detectedSection;
				System.out.println("Set current section to: " + currentSection);
				continue;
			}

			// Add content to current section
			if (currentSection != null && sections.containsKey(currentSection)) {
				sections.get(currentSection).add(line);
				System.out.println("Added to " + currentSection + ": " + line);
			} else if (currentSection == null) {
				// Try to infer section from content
				String inferredSection = inferSectionFromContent(line);
				if (inferredSection != null) {
					sections.get(inferredSection).add(line);
					System.out.println("Inferred section " + inferredSection + " for: " + line);
				}
			}
		}
	}

	private String inferSectionFromContent(String line) {
		String lowerLine = line.toLowerCase();

		// Education indicators
		if (containsAnyIgnoreCase(line, DEGREE_TERMS) ||
			containsAnyIgnoreCase(line, SCHOOL_TERMS) ||
			lowerLine.matches(".*\\b(19|20)\\d{2}\\b.*") &&
			(lowerLine.contains("university") || lowerLine.contains("college") || lowerLine.contains("school"))) {
			return "education";
		}

		// Experience indicators
		if (containsAnyIgnoreCase(line, PROFESSIONAL_TITLES) ||
			containsAnyIgnoreCase(line, COMPANY_TERMS) ||
			(lowerLine.matches(".*\\b(19|20)\\d{2}\\b.*") &&
			(lowerLine.contains("present") || lowerLine.contains("current")))) {
			return "experience";
		}

		// Skills indicators (usually short lines with technical terms)
		if (line.length() < 50 &&
			(lowerLine.contains("java") || lowerLine.contains("python") || lowerLine.contains("sql") ||
			lowerLine.contains("management") || lowerLine.contains("analysis") ||
			lowerLine.contains("•") || lowerLine.contains("·"))) {
			return "skills";
		}

		// References indicators
		if (lowerLine.contains("@") ||
			PHONE_PATTERN.matcher(line).find() ||
			lowerLine.contains("referee") || lowerLine.contains("reference")) {
			return "references";
		}

		return null;
	}

	private void debugExtraction(String plainText) {
		System.out.println("=== DEBUG: RAW CONTENT ANALYSIS ===");
		System.out.println("Content length: " + plainText.length());
		System.out.println("First 500 characters:");
		System.out.println(plainText.substring(0, Math.min(500, plainText.length())));

		System.out.println("\n=== DEBUG: LOOKING FOR SECTION HEADERS ===");
		String[] lines = plainText.split("\n");
		for (int i = 0; i < Math.min(20, lines.length); i++) {
			String line = lines[i].trim();
			if (!line.isEmpty()) {
				String detected = detectSectionHeader(line);
				System.out.println("Line " + i + ": '" + line + "'" +
								(detected != null ? " -> SECTION: " + detected : ""));
			}
		}

		System.out.println("\n=== DEBUG: CHECKING FOR KEYWORDS ===");
		for (String header : EXPERIENCE_HEADERS) {
			if (plainText.toLowerCase().contains(header)) {
				System.out.println("Found experience keyword: " + header);
			}
		}
		for (String header : EDUCATION_HEADERS) {
			if (plainText.toLowerCase().contains(header)) {
				System.out.println("Found education keyword: " + header);
			}
		}
	}

	/**
	* Checks if all sections in the map are empty
	*/
	private boolean allSectionsEmpty(Map<String, List<String>> sections) {
		for (List<String> sectionContent : sections.values()) {
			if (!sectionContent.isEmpty()) {
				return false;
			}
		}
		return true;
	}

	/**
	* Checks if text contains any of the given keywords
	*/
	private boolean containsAny(String text, String[] keywords) {
		for (String keyword : keywords) {
			if (text.contains(keyword)) {
				return true;
			}
		}
		return false;
	}

	/**
	* Extracts personal information from the CV
	*/
	private void extractPersonalInfo(String plainText, JSONObject result) {
		JSONObject personalInfo = new JSONObject();

		// Try to extract name from the first few lines of the document
		// Elements potentialNameElements = doc.select("h1, h2, h3, title, p:first-of-type");
		// System.out.println("Looking for name in " + potentialNameElements.size() + " potential elements");
		// for (Element el : potentialNameElements) {
		//     String potentialName = el.text().trim();
		//     System.out.println("  Checking potential name: " + potentialName);
		//     if (isLikelyName(potentialName)) {
		//         personalInfo.put("name", potentialName);
		//         System.out.println("  Found likely name: " + potentialName);
		//         break;
		//     }
		// }

		// Extract email addresses
		System.out.println("Looking for email addresses");
		Matcher emailMatcher = EMAIL_PATTERN.matcher(plainText);
		if (emailMatcher.find()) {
			String email = emailMatcher.group(0);
			personalInfo.put("email", email);
			System.out.println("  Found email: " + email);
		}

		// Extract phone numbers
		System.out.println("Looking for phone numbers");
		Matcher phoneMatcher = PHONE_PATTERN.matcher(plainText);
		if (phoneMatcher.find()) {
			String phone = phoneMatcher.group(0);
			personalInfo.put("phone", phone);
			System.out.println("  Found phone: " + phone);
		}

		// Look for other personal information with labels
		System.out.println("Looking for labeled personal information");
		Matcher personalInfoMatcher = PERSONAL_INFO_PATTERN.matcher(plainText);
		while (personalInfoMatcher.find()) {
			String infoLine = personalInfoMatcher.group(0).toLowerCase();
			String value = personalInfoMatcher.group(1).trim();
			System.out.println("  Found info line: " + infoLine + " => " + value);

			if (infoLine.contains("address") && !personalInfo.has("address")) {
				personalInfo.put("address", value);
				System.out.println("    Identified as address");
			} else if (infoLine.contains("name") && !personalInfo.has("name")) {
				personalInfo.put("name", value);
				System.out.println("    Identified as name");
			} else if ((infoLine.contains("phone") || infoLine.contains("mobile")) && !personalInfo.has("phone")) {
				personalInfo.put("phone", value);
				System.out.println("    Identified as phone");
			} else if (infoLine.contains("email") && !personalInfo.has("email")) {
				personalInfo.put("email", value);
				System.out.println("    Identified as email");
			}
		}

		result.put("personal_info", personalInfo);
	}

	/**
	* Checks if a string is likely to be a person's name
	*/
	private boolean isLikelyName(String text) {
		// Simple heuristic: 2-3 words, each starting with capital letter
		String[] parts = text.split("\\s+");
		if (parts.length >= 2 && parts.length <= 3) {
			for (String part : parts) {
				if (part.isEmpty() || !Character.isUpperCase(part.charAt(0))) {
					return false;
				}
			}
			return true;
		}
		return false;
	}

	/**
	* Parses education information
	*/

	private JSONArray parseEducation(List<String> educationSection) {
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("This is parsing education");
		System.out.println("Parsing education section with " + educationSection.size() + " entries");
		JSONArray education = new JSONArray();
		Matcher dateMatcher;

		String institute = "", certificate = "", rawdate = "";

		for (String line : educationSection) {
			String text = line.trim().toLowerCase().replaceAll("[.,;:]$", "");
			System.out.println("  Examining line: " + line);

			// Date line
			dateMatcher = DATE_RANGE_PATTERN2.matcher(text);
			if (rawdate.isEmpty() && dateMatcher.find()) {
				System.out.println("    Found date line: " + line);
				rawdate = line.trim();
			}
			// Degree or Certification line
			else if (certificate.isEmpty() && containsAny(text, DEGREE_TERMS)) {
				System.out.println("    Found certification line: " + line);
				certificate = line.trim();
			}
			// Institution line
			else if (institute.isEmpty() && containsAny(text, SCHOOL_TERMS)) {
				System.out.println("    Found institution line: " + line);
				institute = line.trim();
			}

			// When all 3 fields are filled, create entry
			if (!institute.isEmpty() && !certificate.isEmpty() && !rawdate.isEmpty()) {
				String[] parts = rawdate.replaceAll("[–—]", "-").split("\\s* - \\s*");
				System.out.println("    This is the configured date: " + Arrays.toString(parts));
				System.out.println("    parts length: " + parts.length);
				if (parts.length == 2) {
					DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");

					String dateStr = parts[0].trim();
					String eduFrom = null;

					// Try full date formats first
					for (String pattern : fullDateFormats) {
						try {
							DateTimeFormatter formatter = new DateTimeFormatterBuilder()
									.parseCaseInsensitive()
									.appendPattern(pattern)
									.toFormatter();
							LocalDate date = LocalDate.parse(dateStr, formatter);
							eduFrom = date.format(outputFormat);
							break; // Found valid format
						} catch (DateTimeParseException ignored) {}
					}

					// Try partial date formats if full didn't work
					if (eduFrom == null) {
						for (String pattern : partialDateFormats) {
							try {
								DateTimeFormatter formatter = new DateTimeFormatterBuilder()
									.parseCaseInsensitive()
									.appendPattern(pattern)
									.toFormatter();
								YearMonth ym = YearMonth.parse(dateStr, formatter);
								eduFrom = ym.atDay(1).format(outputFormat);
								break;
							} catch (DateTimeParseException ignored) {}
						}
					}

					// Try year-only (e.g. "2020")
					if (eduFrom == null) {
						try {
							int yearOnly = Integer.parseInt(dateStr);
							eduFrom = LocalDate.of(yearOnly, 1, 1).format(outputFormat);
						} catch (NumberFormatException ignored) {}
					}

					if (eduFrom == null) {
						System.out.println("⚠️ Could not parse start date: " + dateStr);
						eduFrom = dateStr;
					}

					String dateStr2 = parts[1].trim();
					String eduTo = null;

					if (dateStr2.equalsIgnoreCase("present") || dateStr2.equalsIgnoreCase("ongoing") || dateStr2.equalsIgnoreCase("current")) {
						eduTo = LocalDate.now().format(outputFormat);
					} else {
						// Try full date formats first
						for (String pattern : fullDateFormats) {
							try {
								DateTimeFormatter formatter = new DateTimeFormatterBuilder()
										.parseCaseInsensitive()
										.appendPattern(pattern)
										.toFormatter();
								LocalDate date = LocalDate.parse(dateStr2, formatter);
								eduTo = date.format(outputFormat);
								break; // Found valid format
							} catch (DateTimeParseException ignored) {}
						}

						// Try partial date formats if full didn't work
						if (eduTo == null) {
							for (String pattern : partialDateFormats) {
								try {
									DateTimeFormatter formatter = new DateTimeFormatterBuilder()
										.parseCaseInsensitive()
										.appendPattern(pattern)
										.toFormatter();
									YearMonth ym = YearMonth.parse(dateStr2, formatter);
									eduTo = ym.atDay(1).format(outputFormat);
									break;
								} catch (DateTimeParseException ignored) {}
							}
						}

						// Try year-only (e.g. "2020")
						if (eduTo == null) {
							try {
								int yearOnly = Integer.parseInt(dateStr2);
								eduTo = LocalDate.of(yearOnly, 1, 1).format(outputFormat);
							} catch (NumberFormatException ignored) {}
						}

						if (eduTo == null) {
							System.out.println("⚠️ Could not parse start date: " + dateStr2);
							eduTo = dateStr2;
						}
					}

					String eduLevel;
					if (certificate.toLowerCase().contains("certificate")) {
						eduLevel = "4";
					} else if (certificate.toLowerCase().contains("high school")) {
						eduLevel = "3";
					} else if (certificate.toLowerCase().contains("secondary")) {
						eduLevel = "2";
					} else if (certificate.toLowerCase().contains("bachelor") || certificate.toLowerCase().contains("degree")) {
						eduLevel = "8";
					} else if (certificate.toLowerCase().contains("master") || certificate.toLowerCase().contains("phd")) {
						eduLevel = "9";
					} else if (certificate.toLowerCase().contains("diploma")) {
						eduLevel = "7";
					} else {
						eduLevel = "N/A";
					}

					JSONObject entry = new JSONObject();
					entry.put("edu-level", eduLevel);
					entry.put("institution", institute);
					entry.put("edu-from", eduFrom);
					entry.put("edu-to", eduTo);
					entry.put("certification", certificate);

					education.put(entry);
					System.out.println("  Saved entry: " + entry.toString(2));

					// Reset for next block
					institute = "";
					certificate = "";
					rawdate = "";
				}
			}
		}

		System.out.println("Parsed education entries: " + education.length());
		for (int i = 0; i < education.length(); i++) {
			System.out.println("  Entry " + (i + 1) + ": " + education.getJSONObject(i).toString(2));
		}

		return education;
	}


	private JSONArray parseEducations(List<String> educationSection) {
		System.out.println("Parsing education section with " + educationSection.size() + " entries");
		JSONArray education = new JSONArray();
		Pattern degreePattern = Pattern.compile("(?i)(Bachelor|Master|Ph\\.?D|Diploma|Certificate|Degree|BSc|BA|MSc|MA|MBA|MD|LLB)");
		Pattern yearPattern = Pattern.compile("\\b(19|20)\\d{2}\\b");

		StringBuilder currentEntry = new StringBuilder();
		boolean inEntry = false;

		for (String line : educationSection) {
			// Start of new entry detection heuristics
			boolean isNewEntry = yearPattern.matcher(line).find() ||
								degreePattern.matcher(line).find() ||
								line.contains("University") ||
								line.contains("College") ||
								line.contains("School");

			System.out.println("  Examining line: " + line);
			System.out.println("    Is new entry: " + isNewEntry);

			if (isNewEntry && inEntry && currentEntry.length() > 0) {
				// Save previous entry
				System.out.println("    Saving previous entry: " + currentEntry.toString());
				addEducationEntry(education, currentEntry.toString());
				currentEntry = new StringBuilder();
			}

			currentEntry.append(line).append(" ");
			inEntry = true;
		}

		// Add the last entry if any
		if (currentEntry.length() > 0) {
			System.out.println("  Saving final entry: " + currentEntry.toString());
			addEducationEntry(education, currentEntry.toString());
		}

		return education;
	}

	/**
	* Adds an education entry to the education array
	*/
	private void addEducationEntry(JSONArray education, String entryText) {
		System.out.println("  Processing education entry: " + entryText);
		JSONObject entry = new JSONObject();
		entry.put("raw", entryText.trim());

		// Extract degree
		Pattern degreePattern = Pattern.compile("(?i)(Bachelor|Master|Ph\\.?D|Diploma|Certificate|Degree|BSc|BA|MSc|MA|MBA|MD|LLB)[^,;.]*");
		Matcher degreeMatcher = degreePattern.matcher(entryText);
		if (degreeMatcher.find()) {
			String degree = degreeMatcher.group(0).trim();
			entry.put("degree", degree);
			System.out.println("    Found degree: " + degree);
		}

		// Extract institution
		Pattern institutionPattern = Pattern.compile("(?i)(University|College|School|Institute)[^,;.]*");
		Matcher institutionMatcher = institutionPattern.matcher(entryText);
		if (institutionMatcher.find()) {
			String institution = institutionMatcher.group(0).trim();
			entry.put("institution", institution);
			System.out.println("    Found institution: " + institution);
		}

		// Extract years
		Pattern yearPattern = Pattern.compile("\\b(19|20)\\d{2}\\b");
		Matcher yearMatcher = yearPattern.matcher(entryText);
		List<String> years = new ArrayList<>();
		while (yearMatcher.find()) {
			years.add(yearMatcher.group(0));
		}

		if (years.size() >= 2) {
			entry.put("start_year", years.get(0));
			entry.put("end_year", years.get(1));
			System.out.println("    Found years: " + years.get(0) + " to " + years.get(1));
		} else if (years.size() == 1) {
			if (entryText.toLowerCase().contains("present") || entryText.toLowerCase().contains("current")) {
				entry.put("start_year", years.get(0));
				entry.put("end_year", "Present");
				System.out.println("    Found years: " + years.get(0) + " to Present");
			} else {
				entry.put("year", years.get(0));
				System.out.println("    Found year: " + years.get(0));
			}
		}

		education.put(entry);
	}

	/**
	* Parses work experience information
	*/

	private JSONArray parseExperienceFlexible(List<String> experienceSection) {
		JSONArray experience = new JSONArray();

		// Group lines into potential job entries
		List<List<String>> jobBlocks = new ArrayList<>();
		List<String> currentBlock = new ArrayList<>();

		for (String line : experienceSection) {
			line = line.trim();
			if (line.isEmpty()) {
				if (!currentBlock.isEmpty()) {
					jobBlocks.add(new ArrayList<>(currentBlock));
					currentBlock.clear();
				}
			} else {
				currentBlock.add(line);
			}
		}

		// Add the last block
		if (!currentBlock.isEmpty()) {
			jobBlocks.add(currentBlock);
		}

		// Process each job block
		for (List<String> block : jobBlocks) {
			JSONObject job = extractJobFromBlock(block);
			if (job.length() > 0) {
				experience.put(job);
			}
		}

		return experience;
	}

	private JSONObject extractJobFromBlock(List<String> lines) {
		JSONObject job = new JSONObject();

		for (String line : lines) {
			// Look for dates anywhere in the line
			if (containsDate(line)) {
				job.put("dates", line);
			}
			// First non-date line is likely the job title
			else if (!job.has("position")) {
				job.put("position", line);
			}
			// Second non-date line is likely the company
			else if (!job.has("company")) {
				job.put("company", line);
			}
			// Rest could be description
			else {
				String desc = job.optString("description", "");
				job.put("description", desc + " " + line);
			}
		}

		return job;
	}

	private boolean containsDate(String text) {
		// More flexible date detection
		return text.matches(".*\\b(19|20)\\d{2}\\b.*") ||
		text.toLowerCase().contains("present") ||
		text.toLowerCase().contains("current") ||
		text.matches(".*\\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\\b.*");
	}


	private JSONArray parseExperiences(List<String> experienceSection) {
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("This is parsing experience");
		System.out.println("Parsing experience section with " + experienceSection.size() + " entries");
		JSONArray experience = new JSONArray();
		Pattern yearPattern = Pattern.compile("\\b(19|20)\\d{2}\\b");
		Pattern monthYearPattern = Pattern.compile("(?i)(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[.,\\s]+\\d{4}");

		StringBuilder currentEntry = new StringBuilder();
		boolean inEntry = false;

		for (String line : experienceSection) {
			// Start of new entry detection
			boolean isNewEntry = (yearPattern.matcher(line).find() && line.length() < 100) ||
								(monthYearPattern.matcher(line).find() && line.length() < 100) ||
								line.contains("position") ||
								line.contains("title");

			System.out.println("  Examining line: " + line);
			System.out.println("    Is new entry: " + isNewEntry);

			if (isNewEntry && inEntry && currentEntry.length() > 0) {
				// Save previous entry
				System.out.println("    Saving previous entry: " + currentEntry.toString());
				addExperienceEntry(experience, currentEntry.toString());
				currentEntry = new StringBuilder();
			}

			currentEntry.append(line).append(" ");
			inEntry = true;
		}

		// Add the last entry if any
		if (currentEntry.length() > 0) {
			System.out.println("  Saving final entry: " + currentEntry.toString());
			addExperienceEntry(experience, currentEntry.toString());
		}

		return experience;
	}

	/**
	* Adds a work experience entry to the experience array
	*/
	private void addExperienceEntry(JSONArray experience, String entryText) {
		System.out.println("  Processing experience entry: " + entryText);
		JSONObject entry = new JSONObject();
		entry.put("raw", entryText.trim());

		// Extract position/title
		Pattern titlePattern = Pattern.compile("(?i)(position|title|role)[^a-z]*([^,;.]*)", Pattern.CASE_INSENSITIVE);
		Matcher titleMatcher = titlePattern.matcher(entryText);
		if (titleMatcher.find()) {
			String position = titleMatcher.group(2).trim();
			entry.put("position", position);
			System.out.println("    Found position: " + position);
		} else {
			// Try to find the first sentence as it often contains the job title
			String[] sentences = entryText.split("[.;]");
			if (sentences.length > 0) {
				String position = sentences[0].trim();
				entry.put("position", position);
				System.out.println("    Found position (from first sentence): " + position);
			}
		}

		// Extract company/organization
		Pattern companyPattern = Pattern.compile("(?i)(company|organization|employer|at)[^a-z]*([^,;.]*)", Pattern.CASE_INSENSITIVE);
		Matcher companyMatcher = companyPattern.matcher(entryText);
		if (companyMatcher.find()) {
			String company = companyMatcher.group(2).trim();
			entry.put("company", company);
			System.out.println("    Found company: " + company);
		}

		// Extract dates
		System.out.println("    Extracting dates");
		extractDates(entryText, entry);

		// Extract responsibilities
		if (entryText.toLowerCase().contains("responsibilities") ||
			entryText.toLowerCase().contains("duties") ||
			entryText.toLowerCase().contains("achievements")) {
			Pattern respPattern = Pattern.compile("(?i)(?:responsibilities|duties|achievements)[^a-z]*(.+)$", Pattern.DOTALL);
			Matcher respMatcher = respPattern.matcher(entryText);
			if (respMatcher.find()) {
				String responsibilities = respMatcher.group(1).trim();
				entry.put("responsibilities", responsibilities);
				System.out.println("    Found responsibilities: " +
								(responsibilities.length() > 50 ? responsibilities.substring(0, 50) + "..." : responsibilities));
			}
		}

		experience.put(entry);
	}

	/**
	* Extracts dates from text and adds them to the JSON object
	*/
	private void extractDates(String text, JSONObject obj) {
		// Look for date ranges like "2015 - 2018" or "Jan 2015 - Dec 2018"
		Pattern dateRangePattern = Pattern.compile("((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[.,\\s]+)?\\d{4}\\s*[\\-–—to]+\\s*((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[.,\\s]+)?\\d{4}|Present|Current", Pattern.CASE_INSENSITIVE);
		Matcher dateRangeMatcher = dateRangePattern.matcher(text);

		if (dateRangeMatcher.find()) {
			String dateRange = dateRangeMatcher.group(0);
			System.out.println("    Found date range: " + dateRange);
			String[] parts = dateRange.split("[\\-–—to]+");

			if (parts.length >= 2) {
				obj.put("start_date", parts[0].trim());
				obj.put("end_date", parts[1].trim());
				System.out.println("      Start date: " + parts[0].trim());
				System.out.println("      End date: " + parts[1].trim());
			}
		} else {
			// Look for individual years
			Pattern yearPattern = Pattern.compile("\\b(19|20)\\d{2}\\b");
			Matcher yearMatcher = yearPattern.matcher(text);
			List<String> years = new ArrayList<>();

			while (yearMatcher.find()) {
				years.add(yearMatcher.group(0));
			}

			if (years.size() >= 2) {
				obj.put("start_year", years.get(0));
				obj.put("end_year", years.get(1));
				System.out.println("    Found years: " + years.get(0) + " to " + years.get(1));
			} else if (years.size() == 1) {
				if (text.toLowerCase().contains("present") || text.toLowerCase().contains("current")) {
					obj.put("start_year", years.get(0));
					obj.put("end_year", "Present");
					System.out.println("    Found years: " + years.get(0) + " to Present");
				} else {
					obj.put("year", years.get(0));
					System.out.println("    Found year: " + years.get(0));
				}
			}
		}
	}

	/**
	* Parses skills information
	*/
	private JSONArray parseSkills(List<String> skillsSection) {
		System.out.println("Parsing skills section with " + skillsSection.size() + " entries");
		JSONArray skills = new JSONArray();

		// Join all skill text
		String skillText = String.join(" ", skillsSection);
		System.out.println("  Combined skill text: " +
						(skillText.length() > 100 ? skillText.substring(0, 100) + "..." : skillText));

		// Common skill delimiters
		String[] skillDelimiters = {"•", "·", ",", ";", "\\|", "\\n"};

		// Try to split by delimiters
		for (String delimiter : skillDelimiters) {
			String[] skillItems = skillText.split(delimiter);
			if (skillItems.length > 1) {
				System.out.println("  Found delimiter: '" + delimiter + "', extracted " + skillItems.length + " skills");
				for (String skill : skillItems) {
					String trimmed = skill.trim();
					if (!trimmed.isEmpty() && trimmed.length() < 50) {  // Likely a skill if less than 50 chars
						skills.put(trimmed);
						System.out.println("    Added skill: " + trimmed);
					}
				}
				return skills;
			}
		}

		// If no good delimiter found, try to extract skills using pattern matching
		System.out.println("  No good delimiter found, using pattern matching");
		Pattern skillPattern = Pattern.compile("\\b([A-Za-z]+(\\s[A-Za-z]+){0,3})\\b");
		Matcher skillMatcher = skillPattern.matcher(skillText);

		while (skillMatcher.find()) {
			String skill = skillMatcher.group(1).trim();
			if (skill.length() > 3 && skill.length() < 50 && !isCommonWord(skill)) {
				skills.put(skill);
				System.out.println("    Added skill: " + skill);
			}
		}

		return skills;
	}

	/**
	* Checks if a word is a common non-skill word
	*/
	private boolean isCommonWord(String word) {
		String[] commonWords = {"the", "and", "for", "with", "that", "this", "from", "they", "have", "been"};
		word = word.toLowerCase();

		for (String commonWord : commonWords) {
			if (word.equals(commonWord)) {
				return true;
			}
		}

		return false;
	}

	/**
	* Parses references information
	*/

	private JSONArray parseReferences(List<String> referencesSection) {
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("This is parsing references");
		System.out.println("Parsing references section with " + referencesSection.size() + " entries");
		JSONArray references = new JSONArray();

		for (int i = 0; i + 3 < referencesSection.size(); i += 4) {
			String refereeName = referencesSection.get(i).trim();
			String refereePosition = referencesSection.get(i + 1).trim();
			String refereeCompany = referencesSection.get(i + 2).trim();
			String refereeEmail = referencesSection.get(i + 3).trim();

			System.out.println("  Processing lines: ");
			System.out.println("    Referee Name: " + refereeName);
			System.out.println("    Referee Position: " + refereePosition);
			System.out.println("    Referee Company: " + refereeCompany);
			System.out.println("    Referee Email: " + refereeEmail);

			JSONObject entry = new JSONObject();
			entry.put("referee-name", refereeName);
			entry.put("referee-position", refereePosition);
			entry.put("referee-company", refereeCompany);
			entry.put("referee-email", refereeEmail);

			references.put(entry);
		}

		System.out.println("Parsed reference entries: " + references.length());
		for (int i = 0; i < references.length(); i++) {
			System.out.println("  Entry " + (i + 1) + ": " + references.getJSONObject(i).toString(2));
		}

		return references;
	}

	private JSONArray parseReference(List<String> referencesSection) {
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("This is parsing references");
		System.out.println("Parsing references section with " + referencesSection.size() + " entries");

		JSONArray references = new JSONArray();
		JSONObject currentRef = new JSONObject();

		for (String line : referencesSection) {
			String text = line.trim();
			String lower = text.toLowerCase();
			System.out.println("  Examining line: " + text);

			// Email detection
			if (text.contains("@")) {
				currentRef.put("email", text);
				System.out.println("    Identified email: " + text);
			}
			// Phone detection
			else if (PHONE_PATTERN.matcher(text).find()) {
				currentRef.put("phone", text);
				System.out.println("    Identified phone: " + text);
			}
			// Likely name/title (usually capitalized, or starts with "Mr.", "Ms.", etc.)
			else if (text.matches("(?i).*(mr\\.|ms\\.|mrs\\.|dr\\.|prof\\.|head|manager|director|officer|lecturer).*")) {
				// May contain title
				if (!currentRef.has("title")) {
					currentRef.put("title", text);
					System.out.println("    Identified title: " + text);
				} else if (!currentRef.has("name")) {
					currentRef.put("name", text);
					System.out.println("    Identified name: " + text);
				}
			}
			// Fallback: long text likely to be a reference body
			else if (text.length() > 5) {
				if (!currentRef.has("raw")) {
					currentRef.put("raw", text);
				} else {
					currentRef.put("raw", currentRef.getString("raw") + " " + text);
				}
			}

			// If we have at least an email and a title/name, save the entry
			if (currentRef.has("email") && (currentRef.has("name") || currentRef.has("title"))) {
				references.put(currentRef);
				System.out.println("    Saved reference: " + currentRef.toString(2));
				currentRef = new JSONObject(); // reset for next reference
			}
		}

		// Save last pending reference if any
		if (!currentRef.isEmpty()) {
			references.put(currentRef);
			System.out.println("  Saved final reference: " + currentRef.toString(2));
		}

		System.out.println("Parsed reference entries: " + references.length());
		for (int i = 0; i < references.length(); i++) {
			System.out.println("  Entry " + (i + 1) + ": " + references.getJSONObject(i).toString(2));
		}

		return references;
	}


	/**
	* Adds a reference entry to the references array
	*/
	private void addReferenceEntry(JSONArray references, String referenceText) {
		System.out.println("  Processing reference entry: " + referenceText);
		JSONObject reference = new JSONObject();
		reference.put("raw", referenceText.trim());

		// Extract name (assuming it's at the beginning of the reference)
		String[] lines = referenceText.split("\n");
		if (lines.length > 0) {
			String potentialName = lines[0].trim();
			if (isLikelyName(potentialName)) {
				reference.put("name", potentialName);
				System.out.println("    Found name: " + potentialName);
			}
		}

		// Extract contact information
		Matcher emailMatcher = EMAIL_PATTERN.matcher(referenceText);
		if (emailMatcher.find()) {
			String email = emailMatcher.group(0);
			reference.put("email", email);
			System.out.println("    Found email: " + email);
		}

		Matcher phoneMatcher = PHONE_PATTERN.matcher(referenceText);
		if (phoneMatcher.find()) {
			String phone = phoneMatcher.group(0);
			reference.put("phone", phone);
			System.out.println("    Found phone: " + phone);
		}

		// Extract title/position if present
		Pattern titlePattern = Pattern.compile("(?i)(professor|dr|director|manager|supervisor|head)[^,;.]*", Pattern.CASE_INSENSITIVE);
		Matcher titleMatcher = titlePattern.matcher(referenceText);
		if (titleMatcher.find()) {
			String title = titleMatcher.group(0).trim();
			reference.put("title", title);
			System.out.println("    Found title: " + title);
		}

		references.put(reference);
	}

	// Add this method to help debug
	private void debugCV(String plainText) {
		System.out.println("=== FULL CV TEXT ===");
		System.out.println(plainText);
		System.out.println("=== END CV TEXT ===");

		// Check what sections are being detected
		String[] lines = plainText.split("\n");
		for (int i = 0; i < lines.length; i++) {
			String line = lines[i].trim().toLowerCase();
			if (containsAny(line, EXPERIENCE_HEADERS)) {
				System.out.println("FOUND EXPERIENCE HEADER AT LINE " + i + ": " + lines[i]);
			}
		}
	}
}
