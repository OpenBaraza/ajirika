<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CoreNLP Web Integration | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #065f46; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #ecfdf5; color: #065f46; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #ecfdf5; color: #065f46; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #a7f3d0; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose .note { background: #ecfdf5; border-left: 3px solid #10b981; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #065f46; }
    .prose .warn { background: #fef3c7; border-left: 3px solid #f59e0b; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #92400e; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-green-50 to-teal-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-green-700 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-green-100 text-green-700 rounded-full">Web Integration</span>
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-gray-100 text-gray-500 rounded-full">Tomcat · JSP · Servlet</span>
      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">CoreNLP CV Parsing — Web Integration into Ajirika HCM</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions Internship</p>
    </div>
  </section>

  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Objective</h2>
    <p>This phase documents a two-phase evaluation: a standalone CLI proof-of-concept, then integrating Stanford CoreNLP directly into the running Ajirika web application, replacing the personal information extraction logic in the existing NLP pipeline, and verifying end-to-end operation through the browser interface.</p>

    <h2>Phase 1 — Repository Analysis</h2>
    <p>The confirmed technology stack after cloning and analysing the repository:</p>
    <table>
      <tr><th>Layer</th><th>Technology</th></tr>
      <tr><td>Backend</td><td>Java</td></tr>
      <tr><td>Build System</td><td>Apache Maven 3.x</td></tr>
      <tr><td>Web Runtime</td><td>Apache Tomcat 10.1</td></tr>
      <tr><td>Database</td><td>PostgreSQL 18</td></tr>
      <tr><td>Frontend</td><td>JSP with Tailwind CSS</td></tr>
      <tr><td>NLP Library (declared)</td><td>Apache OpenNLP 2.5.2</td></tr>
      <tr><td>Document Parsing</td><td>Apache Tika 3.1.0</td></tr>
    </table>

    <h3>Key Structural Finding</h3>
    <p>The OpenNLP implementation required <strong>seven custom trained model files</strong> (en-ner-person.bin, en-ner-organization.bin, en-ner-cv.bin, etc.) that were absent from the repository. The pipeline was <strong>non-functional without significant additional work</strong>. CoreNLP was evaluated as an alternative because it ships pre-trained English NER models requiring no custom training to run.</p>
    <p>The existing architecture:</p>
    <ul>
      <li><code>readCV.java</code> — uses Tika + Jsoup to extract and structure text from PDF/DOC/DOCX files</li>
      <li><code>breakdownCV.java</code> — rule-based section detection and parsing with OpenNLP fallback</li>
      <li><code>uploadProcess.java</code> — Jakarta servlet mapped to <code>/processCV</code></li>
      <li><code>processCV.jsp</code> — fully built frontend with upload form, processing log tab, and results tab</li>
    </ul>

    <h2>Phase 2 — Compatibility Findings</h2>
    <table>
      <tr><th>Dimension</th><th>Assessment</th></tr>
      <tr><td>Language compatibility</td><td>Full — both Java, no bridging required</td></tr>
      <tr><td>Build system</td><td>Maven → Maven Central; two dependency declarations needed</td></tr>
      <tr><td>Memory</td><td>~400MB heap; <code>-Xmx4g</code> mandatory; pipeline must be a singleton</td></tr>
      <tr><td>Compiler target</td><td>CoreNLP requires minimum Java 11; project was at Java 8</td></tr>
    </table>

    <h2>Phase 3 — Architecture: Surgical Integration</h2>
    <p>The decision was to <strong>not create a new servlet</strong> but to modify the existing <code>breakdownCV.java</code> to replace its personal information extraction logic with CoreNLP NER, leaving all rule-based section detection intact. This was the lowest-risk path — the URL mapping, file handling, log capture, and JSON response format remained unchanged.</p>

    <h2>Phase 4 — Standalone POC</h2>
    <p>Dependencies added to <code>corenlp-demo/pom.xml</code>:</p>
    <pre><code>&lt;dependency&gt;
  &lt;groupId&gt;edu.stanford.nlp&lt;/groupId&gt;
  &lt;artifactId&gt;stanford-corenlp&lt;/artifactId&gt;
  &lt;version&gt;4.5.10&lt;/version&gt;
&lt;/dependency&gt;
&lt;dependency&gt;
  &lt;groupId&gt;edu.stanford.nlp&lt;/groupId&gt;
  &lt;artifactId&gt;stanford-corenlp&lt;/artifactId&gt;
  &lt;version&gt;4.5.10&lt;/version&gt;
  &lt;classifier&gt;models&lt;/classifier&gt;
&lt;/dependency&gt;
&lt;dependency&gt;
  &lt;groupId&gt;org.apache.pdfbox&lt;/groupId&gt;
  &lt;artifactId&gt;pdfbox&lt;/artifactId&gt;
  &lt;version&gt;3.0.3&lt;/version&gt;
&lt;/dependency&gt;</code></pre>
    <p>The pipeline processed 303 words across 16 detected sentences from a real PDF CV with no errors. Model loading: ~12 seconds. The feasibility question was answered: <strong>CoreNLP can process a CV-sized document.</strong></p>

    <h2>Phase 5 — Web Integration</h2>
    <h3>Prerequisites</h3>
    <pre><code># Load database schema
sudo -u postgres psql -d baraza -f db/01.baraza.sql
sudo -u postgres psql -d baraza -f db/02.profile.sql</code></pre>
    <p>JNDI Datasource in <code>/opt/tomcat/conf/context.xml</code>:</p>
    <pre><code>&lt;Resource name="jdbc/database"
          auth="Container"
          type="javax.sql.DataSource"
          driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:5432/baraza"
          username="postgres" password="postgres"
          maxTotal="20" maxIdle="10" maxWaitMillis="-1"/&gt;</code></pre>

    <h3>Defensive Null-Safety Fixes in uploadProcess.java</h3>
    <pre><code>// Before
if (!db.isValid()) db.reconnect("java:/comp/env/jdbc/database");

// After
if (db != null &amp;&amp; !db.isValid()) db.reconnect("java:/comp/env/jdbc/database");

// No authenticated user during testing
try {
    userID = getLoggedInUserId(request);
} catch (Exception e) {
    System.out.println("No authenticated user, defaulting userID to -1");
    userID = "-1";
}</code></pre>

    <h3>CoreNLP Integration in breakdownCV.java</h3>
    <pre><code>private void extractPersonalInfo(String plainText, JSONObject result) {
    JSONObject personalInfo = new JSONObject();
    try {
        Properties props = new Properties();
        props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
        StanfordCoreNLP nlpPipeline = new StanfordCoreNLP(props);
        CoreDocument doc = new CoreDocument(plainText);
        nlpPipeline.annotate(doc);

        for (CoreEntityMention em : doc.entityMentions()) {
            System.out.println("  " + em.entityType() + ": " + em.text());
            if (em.entityType().equals("PERSON") &amp;&amp; !personalInfo.has("name"))
                personalInfo.put("name", em.text());
            if (em.entityType().equals("EMAIL") &amp;&amp; !personalInfo.has("email"))
                personalInfo.put("email", em.text());
        }
    } catch (Exception e) {
        System.out.println("[CoreNLP] Pipeline failed, falling back to regex: " + e.getMessage());
    }
    // Regex fallback for email
    if (!personalInfo.has("email")) {
        Matcher emailMatcher = EMAIL_PATTERN.matcher(plainText);
        if (emailMatcher.find()) personalInfo.put("email", emailMatcher.group(0));
    }
    // First-line fallback for name
    if (!personalInfo.has("name")) {
        String firstLine = plainText.trim().split("\\n")[0].trim();
        if (firstLine.length() &gt; 2 &amp;&amp; firstLine.length() &lt; 60)
            personalInfo.put("name", firstLine);
    }
    result.put("personal_info", personalInfo);
}</code></pre>

    <h3>Build &amp; Deploy</h3>
    <pre><code>mvn package -Dmaven.test.skip=true
sudo /opt/tomcat/bin/shutdown.sh
sudo rm -rf /opt/tomcat/webapps/ajirika
sudo cp target/ajirika.war /opt/tomcat/webapps/
export JAVA_OPTS="-Xmx4g -Xms512m"
sudo -E /opt/tomcat/bin/startup.sh</code></pre>
    <div class="note">WAR size: <strong>599MB</strong> — reflecting the inclusion of the CoreNLP models JAR (~400MB). Expected for an evaluation deployment.</div>

    <h2>Testing Results</h2>
    <p>JSON response produced after uploading the test CV through the browser:</p>
    <pre><code>{
  "personal_info": {
    "name": "Nmap",
    "email": "mazibohoppo@proton.me"
  },
  "education": [],
  "experience": [{ "position": "OSINT, Incident Response..." }],
  "skills": [],
  "references": []
}</code></pre>
    <p>Email: correct. Name: <strong>incorrect</strong> — "Nmap" assigned because CoreNLP encountered the security tool name before the actual person name in the merged text block. Education, skills, and references empty due to section detection failures upstream of CoreNLP — a <code>readCV</code> architecture issue, not a CoreNLP issue.</p>

    <h2>Challenges Encountered</h2>
    <table>
      <tr><th>Challenge</th><th>Root Cause</th><th>Resolution</th></tr>
      <tr><td>PDFBox 3.x API breaking change</td><td><code>PDDocument.load(File)</code> removed in 3.0</td><td>Replaced with <code>Loader.loadPDF(file)</code></td></tr>
      <tr><td>Duplicate servlet URL mapping</td><td>New servlet and <code>uploadProcess</code> both mapped to <code>/processCV</code></td><td>Deleted new servlet; integrated into existing one</td></tr>
      <tr><td>Compiler target Java 8 incompatible</td><td>CoreNLP requires Java 11</td><td>Updated <code>maven.compiler.source</code> and <code>target</code> to 11</td></tr>
      <tr><td>NPE on <code>db.isValid()</code></td><td>JNDI datasource not configured — <code>db</code> was null</td><td>Added null check</td></tr>
      <tr><td>PostgreSQL driver not found</td><td>Driver not in Tomcat lib</td><td>Copied JAR from Maven cache to <code>/opt/tomcat/lib/</code></td></tr>
    </table>

    <h2>Key Lessons</h2>
    <ul>
      <li>Text reconstruction quality in <code>readCV</code> determines downstream NLP quality — garbage in, garbage out</li>
      <li>Integrating into an existing servlet is preferable to adding a new one with duplicate mappings</li>
      <li>Heap configuration (<code>-Xmx4g</code>) is mandatory and must be set before Tomcat starts</li>
      <li><code>-Dmaven.test.skip=true</code> skips both test compilation and execution — critical when test dependencies are removed</li>
    </ul>

  </article>

  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <a href="<%= request.getContextPath() %>/blog/corenlp-cv-feasibility.jsp" class="text-green-700 font-semibold text-sm hover:underline">← CV Parsing Feasibility</a>
    <a href="<%= request.getContextPath() %>/blog/corenlp-full-replacement.jsp" class="text-green-700 font-semibold text-sm hover:underline">Next: Full NLP Replacement →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
