<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CoreNLP CV Parsing Feasibility | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #6d28d9; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #f5f3ff; color: #6d28d9; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #f5f3ff; color: #6d28d9; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #ddd6fe; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose .note { background: #f5f3ff; border-left: 3px solid #7c3aed; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #5b21b6; }
    .prose .warn { background: #fef3c7; border-left: 3px solid #f59e0b; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #92400e; }
    .badge-good { display:inline-block; background:#dcfce7; color:#166534; font-size:0.7rem; font-weight:700; padding:2px 8px; border-radius:999px; }
    .badge-bad { display:inline-block; background:#fee2e2; color:#991b1b; font-size:0.7rem; font-weight:700; padding:2px 8px; border-radius:999px; }
    .badge-med { display:inline-block; background:#fef9c3; color:#854d0e; font-size:0.7rem; font-weight:700; padding:2px 8px; border-radius:999px; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-purple-50 to-pink-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-purple-600 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">

      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">CoreNLP CV Parsing Feasibility Evaluation for Ajirika HCM</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions Interns</p>
    </div>
  </section>

  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Objective</h2>
    <p>To determine whether <strong>Stanford CoreNLP</strong> is a viable NLP solution for the <strong>Ajirika HCM platform</strong> by analysing the repository, assessing compatibility, building a minimal standalone proof-of-concept that processes a real CV document, and evaluating output quality on CV-structured text.</p>
    <p>The test question was deliberately narrow: <em>Can Stanford CoreNLP meaningfully process and understand a CV-sized document instead of a few sentences?</em></p>

    <h2>Why Stanford CoreNLP Was Explored</h2>
    <p>Ajirika is a Human Capital Management platform. A natural evolution is automated CV/resume parsing extracting structured information from unstructured candidate documents. CoreNLP was selected because:</p>
    <ul>
      <li>It is <strong>Java-native</strong>, matching Ajirika's backend language</li>
      <li>It is <strong>open-source and free</strong> no API costs or rate limits</li>
      <li>It runs <strong>entirely on-premise</strong> no data leaves the server</li>
      <li>It has an established <strong>NER pipeline</strong> directly applicable to CV parsing</li>
    </ul>

    <h2>Repository Analysis</h2>
    <table>
      <tr><th>Layer</th><th>Technology</th></tr>
      <tr><td>Backend</td><td>Java</td></tr>
      <tr><td>Build System</td><td>Apache Ant</td></tr>
      <tr><td>Web Runtime</td><td>Apache Tomcat (WAR deployment)</td></tr>
      <tr><td>Database</td><td>PostgreSQL</td></tr>
      <tr><td>Frontend</td><td>Server-rendered HTML/JSP</td></tr>
    </table>
    <p>Ajirika is built on the <strong>Baraza Framework</strong> a Java development framework where UI components and business logic are declared in XML. This means there are no REST controllers to extend trivially, and dependencies are managed via Ant, not Maven.</p>

    <h2>Compatibility Findings</h2>
    <table>
      <tr><th>Dimension</th><th>Assessment</th></tr>
      <tr><td>Language compatibility</td><td><span class="badge-good">FULL</span> Both Java no bridging required</td></tr>
      <tr><td>Memory requirements</td><td><span class="badge-med">MEDIUM</span> ~400MB heap; requires <code>-Xmx4g</code></td></tr>
      <tr><td>NER accuracy dates/cities/emails</td><td><span class="badge-good">GOOD</span> Reliable extractions</td></tr>
      <tr><td>NER accuracy African names</td><td><span class="badge-bad">HIGH RISK</span> Consistently missed</td></tr>
      <tr><td>NER accuracy tech tools</td><td><span class="badge-bad">HIGH RISK</span> Misclassified as LOCATION/PERSON</td></tr>
    </table>

    <h2>Architecture Decision</h2>
    <p>For this evaluation: a <strong>standalone executable JAR</strong> that accepts a CV file path, extracts plain text, runs the CoreNLP pipeline, and outputs a named entity summary to the console. This approach completely isolates NLP behaviour from the Ajirika codebase zero integration risk, zero Ant classpath issues.</p>
    <p>One new dependency added: <strong>Apache PDFBox 3.0.3</strong> for PDF text extraction.</p>

    <h2>Implementation</h2>
    <pre><code>// PDFBox 3.x API load PDF
try (PDDocument document = Loader.loadPDF(file)) {
    PDFTextStripper stripper = new PDFTextStripper();
    return stripper.getText(document);
}

// CoreNLP pipeline
Properties props = new Properties();
props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
StanfordCoreNLP pipeline = new StanfordCoreNLP(props);

CoreDocument document = new CoreDocument(extractedText);
pipeline.annotate(document);

// Named entity summary
for (CoreEntityMention em : document.entityMentions()) {
    String type = em.entityType();
    String text2 = em.text();
    if (entityMap.containsKey(type) &amp;&amp; !entityMap.get(type).contains(text2)) {
        entityMap.get(type).add(text2);
    }
}</code></pre>
    <pre><code>java -Xmx4g -jar target/corenlp-demo-1.0-SNAPSHOT.jar /path/to/cv.pdf</code></pre>

    <h2>Results &amp; NLP Quality Evaluation</h2>
    <h3>Named Entity Summary (Actual Output)</h3>
    <table>
      <tr><th>Entity Type</th><th>Extracted Values</th></tr>
      <tr><td>PERSON</td><td>Nmap, Hydra, Python <em>(misclassified)</em></td></tr>
      <tr><td>ORGANIZATION</td><td>Google, Catholic University of Eastern Africa, Tata Group</td></tr>
      <tr><td>LOCATION</td><td>Wireshark, Nmap, Tcpdump <em>(misclassified)</em></td></tr>
      <tr><td>CITY</td><td>Nairobi, Kinshasa</td></tr>
      <tr><td>COUNTRY</td><td>Kenya, Democratic Republic of the Congo</td></tr>
      <tr><td>DATE</td><td>November 2027, September 2017, April 2026 (all correct)</td></tr>
      <tr><td>EMAIL</td><td>mazibohoppo@proton.me, mazibohoppo@gmail.com</td></tr>
    </table>

    <h3>Reliable vs Unreliable</h3>
    <p><strong>Reliable:</strong> email addresses (perfect), all dates (excellent), cities and countries, Western organisation names.</p>
    <p><strong>Unreliable:</strong> candidate name "UPAO MAZIBO" missed entirely. Security tools (Wireshark, Nmap) misclassified. No CERTIFICATION or SKILL entity types exist in CoreNLP's default label set.</p>

    <div class="warn">African names absent from CoreNLP's training corpus (Wall Street Journal, etc.) receive no PERSON tag. This is a fundamental limitation not a configuration issue.</div>

    <h2>Challenges Encountered</h2>
    <table>
      <tr><th>#</th><th>Challenge</th><th>Resolution</th></tr>
      <tr><td>1</td><td><code>PDDocument.load(File)</code> compilation failure</td><td>PDFBox 3.x removed legacy <code>load()</code> replaced with <code>Loader.loadPDF(file)</code></td></tr>
      <tr><td>2</td><td>African candidate name not detected</td><td>Documented as fundamental limitation requires custom NER training</td></tr>
      <tr><td>3</td><td>Security tools misclassified</td><td>Domain-specific proper nouns resemble place/person names in news-trained model</td></tr>
    </table>

    <h2>Future Recommendations</h2>
    <ul>
      <li><strong>Option 1: Custom NER training</strong>: train on annotated African CVs (~500–1000 labelled). High accuracy, high effort.</li>
      <li><strong>Option 2: Rule-based post-processing</strong>: use CoreNLP for dates/emails/cities and layer keyword rules for skills and name extraction. Pragmatic hybrid.</li>
      <li><strong>Option 3: Transformer-based model</strong> (bert-base-NER, spaCy): highest accuracy but Python-ecosystem requires a microservice bridge.</li>
      <li><strong>Option 4: Dedicated CV parsing API</strong> (Affinda, RChilli): lowest effort, immediate results, handles African names out of the box.</li>
    </ul>

    <h2>Key Lessons</h2>
    <ul>
      <li>CoreNLP is corpus-dependent it performs well on entities that appear in English news text, poorly on African names and technical tool names</li>
      <li>CV text is structurally adversarial for sentence boundary detection bullet points and newlines are not sentence-ending punctuation</li>
      <li>Separating extraction from annotation kept debugging surfaces small</li>
      <li><code>-Xmx4g</code> is not optional default JVM settings cause <code>OutOfMemoryError</code> during pipeline initialisation</li>
    </ul>

  </article>

  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <a href="<%= request.getContextPath() %>/blog/corenlp-setup.jsp" class="text-purple-600 font-semibold text-sm hover:underline">← CoreNLP Local Setup</a>
    <a href="<%= request.getContextPath() %>/blog/corenlp-web-integration.jsp" class="text-purple-600 font-semibold text-sm hover:underline">Next: Web Integration →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
