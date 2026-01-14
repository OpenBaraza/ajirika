package org.processCV;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

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
import opennlp.tools.util.MarkableFileInputStreamFactory;


public class analyzeCV {

	// Paths to the OpenNLP models. Make sure these files are in your 'models' directory.
	// private static final String SENTENCE_MODEL_PATH = "/models/en-sent.bin";
	// private static final String TOKEN_MODEL_PATH = "/models/en-token.bin";
	// private static final String POS_MODEL_PATH = "/models/en-pos-maxent.bin";
	// private static final String NER_PERSON_MODEL_PATH = "/models/en-ner-person.bin";
	// private static final String NER_ORGANIZATION_MODEL_PATH = "/models/en-ner-organization.bin";
	// private static final String NER_LOCATION_MODEL_PATH = "/models/en-ner-location.bin";
	// private static final String NER_CV_MODEL_PATH = "/models/en-ner-cv.bin";
	// private static final String CUST_PERSON_MODEL_PATH = "/models/cust-person.bin";
	// private static final String NER_EDUC_MODEL_PATH = "/models/en-ner-education.bin";
	// private static final String NER_EXP_MODEL_PATH = "/models/en-ner-experience.bin";
	

	private SentenceDetectorME sentenceDetector;
	private TokenizerME tokenizer;
	private POSTaggerME posTagger;
	private NameFinderME nameFinderPerson;
	private NameFinderME nameFinderOrganization;
	private NameFinderME nameFinderLocation;
	private NameFinderME nameFinderCV;
	private NameFinderME nameFinderPersonAdd;
	private NameFinderME nameFinderEduc;
	private NameFinderME nameFinderExp;

	/**
	* Constructor to load all necessary OpenNLP models.
	* It's crucial to handle IOException as model files might be missing or corrupted.
	*/
	public analyzeCV() {
        try {
            // Load Sentence Detector Model
            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-sent.bin")) {
                if (modelIn == null) throw new IOException("Sentence model not found in classpath");
                SentenceModel model = new SentenceModel(modelIn);
                sentenceDetector = new SentenceDetectorME(model);
            }

            // Load Tokenizer Model
            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-token.bin")) {
                if (modelIn == null) throw new IOException("Tokenizer model not found in classpath");
                TokenizerModel model = new TokenizerModel(modelIn);
                tokenizer = new TokenizerME(model);
            }

            // Load POS Tagger Model
            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-pos-maxent.bin")) {
                if (modelIn == null) throw new IOException("POS model not found in classpath");
                POSModel model = new POSModel(modelIn);
                posTagger = new POSTaggerME(model);
            }

            // Load Named Entity Recognition Models
            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-person.bin")) {
                if (modelIn == null) throw new IOException("Person NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderPerson = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-organization.bin")) {
                if (modelIn == null) throw new IOException("Organization NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderOrganization = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-location.bin")) {
                if (modelIn == null) throw new IOException("Location NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderLocation = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-cv.bin")) {
                if (modelIn == null) throw new IOException("CV NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderCV = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/cust-person.bin")) {
                if (modelIn == null) throw new IOException("Custom person model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderPersonAdd = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-education.bin")) {
                if (modelIn == null) throw new IOException("Education NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderEduc = new NameFinderME(model);
            }

            try (InputStream modelIn = analyzeCV.class.getResourceAsStream("/models/en-ner-experience.bin")) {
                if (modelIn == null) throw new IOException("Experience NER model not found in classpath");
                TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
                nameFinderExp = new NameFinderME(model);
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
	public String parseCv(String cvText) {
		StringBuffer sb = new StringBuffer();

		// Reset the feature generators for each new document to avoid accumulating context
		nameFinderPerson.clearAdaptiveData();
		nameFinderOrganization.clearAdaptiveData();
		nameFinderLocation.clearAdaptiveData();
		nameFinderCV.clearAdaptiveData();
		nameFinderPersonAdd.clearAdaptiveData();
		nameFinderEduc.clearAdaptiveData();
		nameFinderExp.clearAdaptiveData();

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

			// Find Persons
			Span[] personSpans = nameFinderPerson.find(tokens);
			for (Span s : personSpans) {
				sb.append("\n    Person: " + s.getType() + " [" + s.getStart() + ".." + s.getEnd() + "] " +
						String.join(" ", Arrays.copyOfRange(tokens, s.getStart(), s.getEnd())));
			}

			// Find Organizations
			Span[] organizationSpans = nameFinderOrganization.find(tokens);
			for (Span s : organizationSpans) {
				sb.append("\n    Organization: " + s.getType() + " [" + s.getStart() + ".." + s.getEnd() + "] " +
						String.join(" ", Arrays.copyOfRange(tokens, s.getStart(), s.getEnd())));
			}

			// Find Locations
			Span[] locationSpans = nameFinderLocation.find(tokens);
			for (Span s : locationSpans) {
				sb.append("\n    Location: " + s.getType() + " [" + s.getStart() + ".." + s.getEnd() + "] " +
						String.join(" ", Arrays.copyOfRange(tokens, s.getStart(), s.getEnd())));
			}
			
			// Find CV items
			Span[] CVspans = nameFinderCV.find(tokens);
			for (Span span : CVspans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				sb.append("\n    CV : " + span.getType() + ": " + entity);
			}

			// Find Additional names
			Span[] oPersionSpans = nameFinderPersonAdd.find(tokens);
			for (Span span : oPersionSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				sb.append("\n    oPerson : " + span.getType() + ": " + entity);
			}

			// Find Education
			Span[] educationSpans = nameFinderEduc.find(tokens);
			for (Span span : educationSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				sb.append("\n    education : " + span.getType() + ": " + entity);
			}

			// Find Experience
			Span[] experienceSpans = nameFinderExp.find(tokens);
			for (Span span : experienceSpans) {
				String entity = String.join(" ", Arrays.copyOfRange(tokens, span.getStart(), span.getEnd()));
				sb.append("\n    experience : " + span.getType() + ": " + entity);
			}
		}
		sb.append("\n------------------------\n");
		
		return sb.toString();
	}
	
	// For extracting contact details
	public String extractContactInfo(String text) {
		StringBuffer sb = new StringBuffer();
		
		sb.append("\n--- Contact Information ---");
		
		sb.append("------------------------\n");
		
		return sb.toString();
	}

	// For extracting education details (requires more sophisticated logic or custom NER)
	public String extractEducation(String text) {
		StringBuffer sb = new StringBuffer();
		
		sb.append("\n--- Education Details (Conceptual) ---");
		// This would typically involve custom NER models trained for 'University', 'Degree', 'GraduationYear'
		// Or rule-based extraction after POS tagging and dependency parsing.
		sb.append("  (Requires custom models or advanced rule-based parsing)");
		sb.append("------------------------\n");
		
		return sb.toString();
	}

	// For extracting experience details
	public String extractExperience(String text) {
		StringBuffer sb = new StringBuffer();
		
		sb.append("\n--- Experience Details (Conceptual) ---");
		// Similar to education, this would benefit greatly from custom NER for 'JobTitle', 'CompanyName', 'Duration', 'Responsibilities'
		sb.append("  (Requires custom models or advanced rule-based parsing)");
		sb.append("------------------------\n");
		
		return sb.toString();
	}

	// process the training text and load the model
	public void trainModel(String trainingData, int pType) {
        try {
            InputStreamFactory factory = fromString(trainingData);
            ObjectStream<String> lineStream = new PlainTextByLineStream(factory, StandardCharsets.UTF_8);
            ObjectStream<NameSample> sampleStream = new NameSampleDataStream(lineStream);

            TrainingParameters params = new TrainingParameters();
            params.put(TrainingParameters.ITERATIONS_PARAM, "100");
            params.put(TrainingParameters.CUTOFF_PARAM, "1");

            String outputPath = null;
            TokenNameFinderModel model = null;

            if(pType == 1) {
                model = NameFinderME.train("en", "cv", sampleStream, params, new TokenNameFinderFactory());
                nameFinderCV = new NameFinderME(model);
                outputPath = "en-ner-cv.bin";
            } else if(pType == 2) {
                model = NameFinderME.train("en", "person", sampleStream, params, new TokenNameFinderFactory());
                nameFinderPersonAdd = new NameFinderME(model);
                outputPath = "cust-person.bin";
            } else if(pType == 3) {
                model = NameFinderME.train("en", "education", sampleStream, params, new TokenNameFinderFactory());
                nameFinderEduc = new NameFinderME(model);
                outputPath = "en-ner-education.bin";
            } else if(pType == 4) {
                model = NameFinderME.train("en", "experience", sampleStream, params, new TokenNameFinderFactory());
                nameFinderExp = new NameFinderME(model);
                outputPath = "en-ner-experience.bin";
            }

            if (model != null && outputPath != null) {
                // Save to current working directory (or specify absolute path)
                model.serialize(new FileOutputStream(outputPath));
                System.out.println("Model trained and saved as: " + outputPath);
            }

        } catch (IOException ex) {
            System.err.println("Error during model training: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

	public InputStreamFactory fromString(String data) {
        return () -> new ByteArrayInputStream(data.getBytes(StandardCharsets.UTF_8));
    }
}

