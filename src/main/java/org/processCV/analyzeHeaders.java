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
    // private static final String CUST_SENTENCE_MODEL_PATH = "./models/en-cust-sent.bin"; // Custom sentence reading model
	// private static final String TOKEN_MODEL_PATH = "./models/en-token.bin";
	// private static final String POS_MODEL_PATH = "./models/en-pos-maxent.bin";
    // private static final String NER_EXP_HEAD_MODEL_PATH = "./models/en-ner-experience-header.bin";
	// private static final String NER_EDU_HEAD_MODEL_PATH = "./models/en-ner-education-header.bin";
	// private static final String NER_SKILL_HEAD_MODEL_PATH = "./models/en-ner-skills-header.bin";
	// private static final String NER_REF_HEAD_MODEL_PATH = "./models/en-ner-ref-header.bin";

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
            // Load Custom Sentence Detector Model
            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-cust-sent.bin")) {
                if (modelIn == null) throw new IOException("Custom sentence model not found");
                SentenceModel model = new SentenceModel(modelIn);
                sentenceDetector = new SentenceDetectorME(model);
            }

            // Load Tokenizer Model
            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-token.bin")) {
                if (modelIn == null) throw new IOException("Tokenizer model not found");
                TokenizerModel model = new TokenizerModel(modelIn);
                tokenizer = new TokenizerME(model);
            }

            // Load POS Tagger Model
            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-pos-maxent.bin")) {
                if (modelIn == null) throw new IOException("POS model not found");
                POSModel model = new POSModel(modelIn);
                posTagger = new POSTaggerME(model);
            }

            // Load Header NER Models
            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-ner-experience-header.bin")) {
                if (modelIn == null) throw new IOException("Experience header model not found");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderExpHead = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-ner-education-header.bin")) {
                if (modelIn == null) throw new IOException("Education header model not found");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderEduHead = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-ner-skills-header.bin")) {
                if (modelIn == null) throw new IOException("Skills header model not found");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderSkillsHead = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeHeaders.class.getResourceAsStream("/models/en-ner-ref-header.bin")) {
                if (modelIn == null) throw new IOException("Reference header model not found");
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

        // Clear static lists to avoid accumulation across calls
        expHeadersList.clear();
        eduHeadersList.clear();
        skillsHeadersList.clear();
        refHeadersList.clear();

        // Reset adaptive data
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

        // 2. Process each sentence
        sb.append("\n--- Header NER Analysis ---");
        for (String sentence : sentences) {
            sb.append("\nAnalyzing: \"" + sentence + "\"");

            String[] tokens = tokenizer.tokenize(sentence);
            String[] tags = posTagger.tag(tokens);
            sb.append("\n  Tokens: " + Arrays.toString(tokens));
            sb.append("\n  POS Tags: " + Arrays.toString(tags));
            sb.append("\n  Named Entities:");

            // Experience Headers
            Span[] expSpans = nameFinderExpHead.find(tokens);
            for (Span span : expSpans) {
                String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
                expHeadersList.add(entity);
                sb.append("\n    EXP-HEADER: " + entity);
                System.out.println("Identified Exp Header: " + entity);
            }

            // Education Headers
            Span[] eduSpans = nameFinderEduHead.find(tokens);
            for (Span span : eduSpans) {
                String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
                eduHeadersList.add(entity);
                sb.append("\n    EDU-HEADER: " + entity);
                System.out.println("Identified Edu Header: " + entity);
            }

            // Skills Headers
            Span[] skillSpans = nameFinderSkillsHead.find(tokens);
            for (Span span : skillSpans) {
                String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
                skillsHeadersList.add(entity);
                sb.append("\n    SKILL-HEADER: " + entity);
                System.out.println("Identified Skill Header: " + entity);
            }

            // Reference Headers
            Span[] refSpans = nameFinderRefHead.find(tokens);
            for (Span span : refSpans) {
                String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
                refHeadersList.add(entity);
                sb.append("\n    REF-HEADER: " + entity);
                System.out.println("Identified Ref Header: " + entity);
            }
        }

        // Build header map
        Map<String, List<String>> allHeaders = new HashMap<>();
        allHeaders.put("experience", new ArrayList<>(expHeadersList));
        allHeaders.put("education", new ArrayList<>(eduHeadersList));
        allHeaders.put("skills", new ArrayList<>(skillsHeadersList));
        allHeaders.put("references", new ArrayList<>(refHeadersList));

        // Log results
        System.out.println("All Exp Headers: " + allHeaders.get("experience"));
        System.out.println("All Edu Headers: " + allHeaders.get("education"));
        System.out.println("All Skills Headers: " + allHeaders.get("skills"));
        System.out.println("All Ref Headers: " + allHeaders.get("references"));

        sb.append("\n------------------------\n");

        // Pass to breakdownCV for section identification
        JSONObject cvInfo = bCV.identifySections(allHeaders, cvText);
        System.out.println("From analyzeHeaders: " + cvInfo.toString(2));

        return sb.toString();
    }

	/**
     * Trains a custom header detection model from a training file.
     */
    public void trainHeaderModel(String trainingFilePath, int pType) {
        try {
            InputStreamFactory factory = () -> new java.io.FileInputStream(trainingFilePath);
            ObjectStream<String> lineStream = new PlainTextByLineStream(factory, "UTF-8");
            ObjectStream<NameSample> sampleStream = new NameSampleDataStream(lineStream);

            TrainingParameters params = new TrainingParameters();
            params.put(TrainingParameters.ITERATIONS_PARAM, "100");
            params.put(TrainingParameters.CUTOFF_PARAM, "1");

            String outputPath = null;
            TokenNameFinderModel model = null;

            switch (pType) {
                case 1:
                    model = NameFinderME.train("en", "EXP-HEADER", sampleStream, params, new TokenNameFinderFactory());
                    nameFinderExpHead = new NameFinderME(model);
                    outputPath = "/models/en-ner-experience-header.bin";
                    break;
                case 2:
                    model = NameFinderME.train("en", "EDU-HEADER", sampleStream, params, new TokenNameFinderFactory());
                    nameFinderEduHead = new NameFinderME(model);
                    outputPath = "/models/en-ner-education-header.bin";
                    break;
                case 3:
                    model = NameFinderME.train("en", "SKILL-HEADER", sampleStream, params, new TokenNameFinderFactory());
                    nameFinderSkillsHead = new NameFinderME(model);
                    outputPath = "/models/en-ner-skills-header.bin";
                    break;
                case 4:
                    model = NameFinderME.train("en", "REFERENCE-HEADER", sampleStream, params, new TokenNameFinderFactory());
                    nameFinderRefHead = new NameFinderME(model);
                    outputPath = "/models/en-ner-ref-header.bin";
                    break;
                default:
                    throw new IllegalArgumentException("Invalid pType: " + pType);
            }

            // Save model to filesystem (not classpath)
            if (model != null && outputPath != null) {
                // Extract filename only (save to current dir or configurable path)
                String fileName = outputPath.substring(outputPath.lastIndexOf('/') + 1);
                model.serialize(new FileOutputStream(fileName));
                System.out.println("Model trained and saved as: " + fileName);
            }

        } catch (IOException ex) {
            System.err.println("Error training model: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public InputStreamFactory fromString(String data) {
        return () -> new ByteArrayInputStream(data.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }
}