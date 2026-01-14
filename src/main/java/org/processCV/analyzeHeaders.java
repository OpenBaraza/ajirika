package org.processCV;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileOutputStream;
// import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import java.util.HashMap;


import opennlp.tools.namefind.NameFinderME;
import opennlp.tools.namefind.TokenNameFinderModel;
import opennlp.tools.namefind.TokenNameFinderFactory;
import opennlp.tools.postag.POSModel;
import opennlp.tools.postag.POSTaggerME;
import opennlp.tools.sentdetect.SentenceDetectorME;
import opennlp.tools.sentdetect.SentenceModel;
import opennlp.tools.tokenize.TokenizerME;
import opennlp.tools.tokenize.TokenizerModel;
import opennlp.tools.util.Span;
import opennlp.tools.namefind.NameSample;
import opennlp.tools.namefind.NameSampleDataStream;
import opennlp.tools.util.ObjectStream;
import opennlp.tools.util.PlainTextByLineStream;
import opennlp.tools.util.TrainingParameters;
import opennlp.tools.util.InputStreamFactory;
// import opennlp.tools.util.MarkableFileInputStreamFactory;

public class analyzeHeaders {

    // Paths to the OpenNLP models. Make sure these files are in your 'models' directory.
	// private static final String SENTENCE_MODEL_PATH = "./models/en-sent.bin";
    private static final String CUST_SENTENCE_MODEL_PATH = "./models/en-cust-sent.bin"; // Custom sentence reading model
	private static final String TOKEN_MODEL_PATH = "./models/en-token.bin";
	private static final String POS_MODEL_PATH = "./models/en-pos-maxent.bin";
    private static final String NER_EXP_HEAD_MODEL_PATH = "./models/en-ner-experience-header.bin";
	private static final String NER_EDU_HEAD_MODEL_PATH = "./models/en-ner-education-header.bin";
	private static final String NER_SKILL_HEAD_MODEL_PATH = "./models/en-ner-skills-header.bin";
	private static final String NER_REF_HEAD_MODEL_PATH = "./models/en-ner-ref-header.bin";

    private SentenceDetectorME sentenceDetector;
	private TokenizerME tokenizer;
	private POSTaggerME posTagger;
    private NameFinderME nameFinderExpHead;
	private NameFinderME nameFinderEduHead;
	private NameFinderME nameFinderSkillsHead;
	private NameFinderME nameFinderRefHead;

	public static List<String> expHeadersList = new ArrayList<>();
    public static List<String> eduHeadersList = new ArrayList<>();
	public static List<String> skillsHeadersList = new ArrayList<>();
	public static List<String> refHeadersList = new ArrayList<>();

	breakdownCV bCV;

    public analyzeHeaders() {

        try {
            // Load Sentence Detector Model
			try (InputStream modelIn = new FileInputStream(CUST_SENTENCE_MODEL_PATH)) {
				SentenceModel model = new SentenceModel(modelIn);
				sentenceDetector = new SentenceDetectorME(model);
			}

			// Load Tokenizer Model
			try (InputStream modelIn = new FileInputStream(TOKEN_MODEL_PATH)) {
				TokenizerModel model = new TokenizerModel(modelIn);
				tokenizer = new TokenizerME(model);
			}

			// Load POS Tagger Model
			try (InputStream modelIn = new FileInputStream(POS_MODEL_PATH)) {
				POSModel model = new POSModel(modelIn);
				posTagger = new POSTaggerME(model);
			}

			// Load Named Entity Recognition Models
            // For Experience Headers
            try (InputStream modelIn = new FileInputStream(NER_EXP_HEAD_MODEL_PATH)) {
				TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
				nameFinderExpHead = new NameFinderME(model);
            }
			// For Education Headers
            try (InputStream modelIn = new FileInputStream(NER_EDU_HEAD_MODEL_PATH)) {
				TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
				nameFinderEduHead = new NameFinderME(model);
            }
			// For Skills Headers
            try (InputStream modelIn = new FileInputStream(NER_SKILL_HEAD_MODEL_PATH)) {
				TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
				nameFinderSkillsHead = new NameFinderME(model);
            }
			// For References Headers
            try (InputStream modelIn = new FileInputStream(NER_REF_HEAD_MODEL_PATH)) {
				TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
				nameFinderRefHead = new NameFinderME(model);
            }

        } catch (IOException ex) {
            System.err.println("Error loading OpenNLP models: " + ex.getMessage());
			ex.printStackTrace();
			System.exit(1);
        }
    }

    /**
	* Parses the given CV text and prints various NLP outputs.
	*
	* @param cvText The text content of the Curriculum Vitae.
	*/
    public String parseHeaders(String cvText) {
        StringBuffer sb = new StringBuffer();
		bCV = new breakdownCV();

		// test cv plain text
		String cvText2 = "WORK EXPERIENCE\n"+
			"Dew CIS Solutions\n Jan 2025 - June 2025\n Software Developer\n"+
			"Kenya Commercial Bank\n Feb 2023 - April 2023\n Business Analyst\n"+
			"EDUCATION\n"+
			"Strathmore University\n April 2020 - June 2024\n Bachelor of Business Information Technology\n"+
			"Nova Pioneer Tatu Boys High School\n Jan 2016 - Nov 2019\n Kenya Certificate of Secondary Education\n"+
			"SKILLS\n"+
			"Java\n JavaScript\n Postgres\n Linux(WSL)\n"+
			"REFEREES\n"+
			"Ref Name\n refemail@example.com\n Ref Company Limited\n IT Supervisor";

        // Reset the feature generators for each new document to avoid accumulating context
        nameFinderExpHead.clearAdaptiveData();
		nameFinderEduHead.clearAdaptiveData();
		nameFinderSkillsHead.clearAdaptiveData();
		nameFinderRefHead.clearAdaptiveData();

        // 1. Sentence Detection
		sb.append("--- Sentence Detection ---");
		String[] sentences = sentenceDetector.sentDetect(cvText);
		for (int i = 0; i < sentences.length; i++) {
			sb.append("\nSentence " + (i + 1) + ": " + sentences[i]);
		}
		sb.append("\n------------------------\n");

        // Process each sentence for further NLP tasks
		sb.append("\n--- Detailed NLP Analysis per Sentence ---");
        for (String sentence : sentences) {
            sb.append("\nAnalyzing: \"" + sentence + "\"");

			// 2. Tokenization
			String[] tokens = tokenizer.tokenize(sentence);
			sb.append("\n  Tokens: " + Arrays.toString(tokens));

			// 3. Part-of-Speech Tagging
			String[] tags = posTagger.tag(tokens);
			sb.append("\n  POS Tags: " + Arrays.toString(tags));

			sb.append("\n  Named Entities:");

            // Find Experience Header
			Span[] experienceHeadSpans = nameFinderExpHead.find(tokens);
			for (Span span : experienceHeadSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				expHeadersList.add(entity);
				sb.append("\n    experience header : " + span.getType() + ": " + entity);
                System.out.println("identified Exp Header: "+ entity);
			}

			// Find Education Header
			Span[] educationHeadSpans = nameFinderEduHead.find(tokens);
			for (Span span : educationHeadSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				eduHeadersList.add(entity);
				sb.append("\n    education header : " + span.getType() + ": " + entity);
                System.out.println("identified Edu Header: "+ entity);
			}

			// Find Skills Header
			Span[] skillsHeadSpans = nameFinderSkillsHead.find(tokens);
			for (Span span : skillsHeadSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				skillsHeadersList.add(entity);
				sb.append("\n    skills header : " + span.getType() + ": " + entity);
                System.out.println("identified Skill Header: "+ entity);
			}

			// Find References Header
			Span[] refHeadSpans = nameFinderRefHead.find(tokens);
			for (Span span : refHeadSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				refHeadersList.add(entity);
				sb.append("\n    ref header : " + span.getType() + ": " + entity);
                System.out.println("identified Ref Header: "+ entity);
			}
        }

		// Data stored in a Map
		Map<String, List<String>> allHeaders = new HashMap<>();
		
		allHeaders.put("experience", expHeadersList);
		allHeaders.put("education", eduHeadersList);
		allHeaders.put("skills", skillsHeadersList);
		allHeaders.put("references", refHeadersList);
		
		// Print stored headers
		System.out.println("All Exp Headers: " + allHeaders.get("experience"));
		System.out.println("All Edu Headers: " + allHeaders.get("education"));
		System.out.println("All Skills Headers: " + allHeaders.get("skills"));
		System.out.println("All Ref Headers: " + allHeaders.get("references"));

        sb.append("\n------------------------\n");

		JSONObject cvInfo = bCV.identifySections(allHeaders, cvText);
		System.out.println("This is from analyzeHeaders: " + cvInfo.toString(2));

		
		return sb.toString();
    }

    public void trainHeaderModel(String trainingFilePath, int pType) {
		try {
			// Read from file path
			InputStreamFactory factory = () -> new FileInputStream(trainingFilePath);
			ObjectStream<String> lineStream = new PlainTextByLineStream(factory, "UTF-8");
			ObjectStream<NameSample> sampleStream = new NameSampleDataStream(lineStream);

			// Training parameters
			TrainingParameters params = new TrainingParameters();
			params.put(TrainingParameters.ITERATIONS_PARAM, "100");
			params.put(TrainingParameters.CUTOFF_PARAM, "1");

			if (pType == 1) {
				// Train experience headers model
				TokenNameFinderModel expModel = NameFinderME.train(
					"en", "EXP-HEADER", sampleStream, params, new TokenNameFinderFactory()
				);
				nameFinderExpHead = new NameFinderME(expModel);
				try (FileOutputStream modelOut = new FileOutputStream(NER_EXP_HEAD_MODEL_PATH)) {
					expModel.serialize(modelOut);
				}
			} else if (pType == 2) {
				// Train education headers model
				TokenNameFinderModel eduModel = NameFinderME.train(
					"en", "EDU-HEADER", sampleStream, params, new TokenNameFinderFactory()
				);
				nameFinderEduHead = new NameFinderME(eduModel);
				try (FileOutputStream modelOut = new FileOutputStream(NER_EDU_HEAD_MODEL_PATH)) {
					eduModel.serialize(modelOut);
				}
			} else if (pType == 3) {
				// Train skills headers model
				TokenNameFinderModel skillModel = NameFinderME.train(
					"en", "SKILL-HEADER", sampleStream, params, new TokenNameFinderFactory()
				);
				nameFinderSkillsHead = new NameFinderME(skillModel);
				try (FileOutputStream modelOut = new FileOutputStream(NER_SKILL_HEAD_MODEL_PATH)) {
					skillModel.serialize(modelOut);
				}
			} else if (pType == 4) {
				// Train references headers model
				TokenNameFinderModel refModel = NameFinderME.train(
					"en", "REFERENCE-HEADER", sampleStream, params, new TokenNameFinderFactory()
				);
				nameFinderRefHead = new NameFinderME(refModel);
				try (FileOutputStream modelOut = new FileOutputStream(NER_REF_HEAD_MODEL_PATH)) {
					refModel.serialize(modelOut);
				}
			}

			System.out.println("Model trained successfully from file: " + trainingFilePath);

		} catch (IOException ex) {
			System.err.println("Error training model: " + ex.getMessage());
			ex.printStackTrace();
		}
	}

    public InputStreamFactory fromString(String data) {
        return () -> new ByteArrayInputStream(data.getBytes("UTF-8"));
    }
}