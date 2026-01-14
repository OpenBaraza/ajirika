package org.processCV;

import java.io.BufferedReader;
// import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.BorderLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JLabel;
import javax.swing.JButton;
import javax.swing.JTextField;

// import opennlp.tools.namefind.NameFinderME;
// import opennlp.tools.namefind.NameSample;
// import opennlp.tools.namefind.NameSampleDataStream;
// import opennlp.tools.namefind.TokenNameFinderFactory;
// import opennlp.tools.namefind.TokenNameFinderModel;
// import opennlp.tools.util.InputStreamFactory;
import opennlp.tools.util.ObjectStream;
import opennlp.tools.util.PlainTextByLineStream;
import opennlp.tools.util.TrainingParameters;
import opennlp.tools.sentdetect.SentenceDetectorME;
import opennlp.tools.sentdetect.SentenceModel;
import opennlp.tools.sentdetect.SentenceSample;
import opennlp.tools.sentdetect.SentenceSampleStream;
import opennlp.tools.sentdetect.SentenceDetectorFactory;

import javax.swing.JTextArea;

public class App implements ActionListener {

	JTextField txtFileName;
	JButton btTrainSent, btRead, btAnalyse, btBreakdown, btTrainCV,
	btTrainNames, btTrainEduc, btTrainExp, btTrainExpHead, btAnalyseHead,
	btTrainCustSent, btTrainEduHead, btTrainSkillsHead, btTrainRefHead;

	JTextArea txtArea01, txtArea02, txtArea03, txtArea04,
	txtArea05, txtArea06, txtArea07, txtArea09,
	txtArea10;

	readCV rCV;
	analyzeCV aCV;
	breakdownCV bCV;
	analyzeHeaders aH;

	public static void main(String[] args) {
		App ap = new App();
	}

	public App() {
		rCV = new readCV();
		aCV = new analyzeCV();
		bCV = new breakdownCV();
		aH = new analyzeHeaders();

		JPanel headerPanel = new JPanel();
		JLabel lblFileName = new JLabel("CV Name :");
		headerPanel.add(lblFileName);
		txtFileName = new JTextField(20);
		txtFileName.setText("./cv/CV_Example01.pdf");
		headerPanel.add(txtFileName);

		btTrainCustSent = new JButton("Train Cust Sent");
		btTrainCustSent.addActionListener(this);
		headerPanel.add(btTrainCustSent);

		btRead = new JButton("Read CV");
		btRead.addActionListener(this);
		headerPanel.add(btRead);

		btAnalyse = new JButton("Analyse CV");
		btAnalyse.addActionListener(this);
		headerPanel.add(btAnalyse);

		// btBreakdown = new JButton("Beakdown CV");
		// btBreakdown.addActionListener(this);
		// headerPanel.add(btBreakdown);

		// btTrainCV = new JButton("Train CV");
		// btTrainCV.addActionListener(this);
		// headerPanel.add(btTrainCV);

		// btTrainNames = new JButton("Train Names");
		// btTrainNames.addActionListener(this);
		// headerPanel.add(btTrainNames);

		// btTrainEduc = new JButton("Train Education");
		// btTrainEduc.addActionListener(this);
		// headerPanel.add(btTrainEduc);

		// btTrainExp = new JButton("Train Experience");
		// btTrainExp.addActionListener(this);
		// headerPanel.add(btTrainExp);

		btTrainExpHead = new JButton("Train Exp Headers");
		btTrainExpHead.addActionListener(this);
		headerPanel.add(btTrainExpHead);

		btTrainEduHead = new JButton("Train Edu Headers");
		btTrainEduHead.addActionListener(this);
		headerPanel.add(btTrainEduHead);

		btTrainSkillsHead = new JButton("Train Skills Headers");
		btTrainSkillsHead.addActionListener(this);
		headerPanel.add(btTrainSkillsHead);

		btTrainRefHead = new JButton("Train Ref Headers");
		btTrainRefHead.addActionListener(this);
		headerPanel.add(btTrainRefHead);

		btAnalyseHead = new JButton("Analyse Headers");
		btAnalyseHead.addActionListener(this);
		headerPanel.add(btAnalyseHead);

		JTabbedPane tabbedPane = new JTabbedPane();

		txtArea01 = new JTextArea();
		JScrollPane scrollPane01 = new JScrollPane(txtArea01);
		tabbedPane.addTab("CV Text", scrollPane01);

		txtArea02 = new JTextArea();
		JScrollPane scrollPane02 = new JScrollPane(txtArea02);
		tabbedPane.addTab("CV Sections", scrollPane02);

		txtArea03 = new JTextArea();
		JScrollPane scrollPane03 = new JScrollPane(txtArea03);
		tabbedPane.addTab("CV Breakdown", scrollPane03);

		txtArea04 = new JTextArea();
		JScrollPane scrollPane04 = new JScrollPane(txtArea04);
		tabbedPane.addTab("Train Skills", scrollPane04);
		txtArea04.setText(readFile("./models/cv.train"));

		txtArea05 = new JTextArea();
		JScrollPane scrollPane05 = new JScrollPane(txtArea05);
		tabbedPane.addTab("Train Names", scrollPane05);
		txtArea05.setText(readFile("./models/names.train"));

		txtArea06 = new JTextArea();
		JScrollPane scrollPane06 = new JScrollPane(txtArea06);
		tabbedPane.addTab("Train Education", scrollPane06);
		txtArea06.setText(readFile("./models/education.train"));

		txtArea07 = new JTextArea();
		JScrollPane scrollPane07 = new JScrollPane(txtArea07);
		tabbedPane.addTab("Train Experience", scrollPane07);
		txtArea07.setText(readFile("./models/experience.train"));

		txtArea09 = new JTextArea();
		JScrollPane scrollPane09 = new JScrollPane(txtArea09);
		tabbedPane.addTab("Header Analysis", scrollPane09);

		JFrame frame = new JFrame("FrameDemo");
		frame.getContentPane().add(headerPanel, BorderLayout.PAGE_START);
		frame.getContentPane().add(tabbedPane, BorderLayout.CENTER);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(1100, 800);
		frame.setVisible(true);
	}

	public void actionPerformed(ActionEvent ev) {
		System.out.println("BASE click : " + ev.getActionCommand());

		String fileName = txtFileName.getText();

		if(ev.getActionCommand().equals("Read CV")) {
			txtArea01.setText(rCV.read(fileName));
		} else if(ev.getActionCommand().equals("Analyse CV")) {
			txtArea02.setText(aCV.parseCv(txtArea01.getText()));
		} else if(ev.getActionCommand().equals("Beakdown CV")) {
			txtArea03.setText(bCV.extractCVData(txtArea01.getText()).toString(4));
		} else if(ev.getActionCommand().equals("Train CV")) {
			aCV.trainModel(txtArea04.getText(), 1);
		} else if(ev.getActionCommand().equals("Train Names")) {
			aCV.trainModel(txtArea05.getText(), 2);
		} else if(ev.getActionCommand().equals("Train Education")) {
			aCV.trainModel(txtArea06.getText(), 3);
		} else if(ev.getActionCommand().equals("Train Experience")) {
			aCV.trainModel(txtArea07.getText(), 4);
		} else if(ev.getActionCommand().equals("Train Exp Headers")) {
			aH.trainHeaderModel("./models/exp-headers.train", 1);
		} else if(ev.getActionCommand().equals("Train Edu Headers")) {
			aH.trainHeaderModel("./models/edu-headers.train", 2);
		} else if(ev.getActionCommand().equals("Analyse Headers")) {
			txtArea09.setText(aH.parseHeaders(txtArea01.getText()));
		} else if(ev.getActionCommand().equals("Train Cust Sent")) {
			trainCustSentModel("./models/cust-sent.train");
		} else if(ev.getActionCommand().equals("Train Skills Headers")) {
			aH.trainHeaderModel("./models/skill-headers.train", 3);
		} else if(ev.getActionCommand().equals("Train Ref Headers")) {
			aH.trainHeaderModel("./models/ref-headers.train", 4);
		}

	}

	public void trainCustSentModel(String trainingFilePath) {
		File trainFile = new File(trainingFilePath);
		File modelFile = new File("./models/en-cust-sent.bin");

		System.out.println("Training Sentences -------");
	
		try (ObjectStream<String> lineStream =
				 new PlainTextByLineStream(() -> new FileInputStream(trainFile), StandardCharsets.UTF_8);
			 ObjectStream<SentenceSample> sampleStream = new SentenceSampleStream(lineStream)) {
	
			// Create a factory with default settings
			SentenceDetectorFactory factory = new SentenceDetectorFactory("en", true, null, null);
	
			// Train the model
			SentenceModel model = SentenceDetectorME.train("en", sampleStream, factory, TrainingParameters.defaultParams());
	
			// Save the model
			try (OutputStream modelOut = new BufferedOutputStream(new FileOutputStream(modelFile))) {
				model.serialize(modelOut);
			}
	
			System.out.println("Model trained successfully from file: " + trainFile.getAbsolutePath());
	
		} catch (IOException ex) {
			System.err.println("Error training custom sentence model: " + ex.getMessage());
			ex.printStackTrace();
		}
	}

	private String readFile(String filePath) {
		StringBuffer strLearn = new StringBuffer();
		try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
			String line;
			while ((line = reader.readLine()) != null) strLearn.append(line + "\n");
		} catch (IOException ex) {
			System.err.println("Error reading file: " + ex.getMessage());
		}
		return strLearn.toString();
	}

}
