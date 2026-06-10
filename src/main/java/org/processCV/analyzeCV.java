package org.processCV;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.pipeline.CoreDocument;
import edu.stanford.nlp.pipeline.CoreSentence;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;

public class analyzeCV {

    private static StanfordCoreNLP pipeline;

    static {
        Properties props = new Properties();
        props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
        pipeline = new StanfordCoreNLP(props);
    }

    public String parseCv(String cvText) {
        StringBuffer sb = new StringBuffer();

        CoreDocument document = new CoreDocument(cvText);
        pipeline.annotate(document);

        sb.append("--- Sentence Detection ---");
        for (int i = 0; i < document.sentences().size(); i++) {
            sb.append("\nSentence " + (i + 1) + ": " + document.sentences().get(i).text());
        }
        sb.append("\n------------------------\n");

        sb.append("\n--- Detailed NLP Analysis per Sentence ---");
        for (CoreSentence sentence : document.sentences()) {
            sb.append("\nAnalyzing: \"" + sentence.text() + "\"");

            List<String> tokens = new ArrayList<>();
            List<String> tags = new ArrayList<>();
            List<String> lemmas = new ArrayList<>();

            for (CoreLabel token : sentence.tokens()) {
                tokens.add(token.word());
                tags.add(token.tag());
                lemmas.add(token.lemma());
            }

            sb.append("\n  Tokens: " + tokens);
            sb.append("\n  POS Tags: " + tags);
            sb.append("\n  Lemmas: " + lemmas);
            sb.append("\n  Named Entities:");

            for (CoreLabel token : sentence.tokens()) {
                String ner = token.ner();
                if (!ner.equals("O")) {
                    sb.append("\n    " + ner + ": " + token.word());
                }
            }
        }
        sb.append("\n------------------------\n");

        return sb.toString();
    }

    public String extractContactInfo(String text) {
        return "\n--- Contact Information ---\n------------------------\n";
    }

    public String extractEducation(String text) {
        return "\n--- Education Details ---\n  (Requires custom models)\n------------------------\n";
    }

    public String extractExperience(String text) {
        return "\n--- Experience Details ---\n  (Requires custom models)\n------------------------\n";
    }

    // Retained for API compatibility with App.java — no-op under CoreNLP
    public void trainModel(String trainingData, int pType) {
        System.out.println("trainModel() not supported under CoreNLP. No-op.");
    }
}
