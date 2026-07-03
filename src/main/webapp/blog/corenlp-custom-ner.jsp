<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CoreNLP Custom NER Training | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #9f1239; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #fff1f2; color: #9f1239; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #fff1f2; color: #9f1239; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #fecdd3; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose .note { background: #fff1f2; border-left: 3px solid #f43f5e; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #9f1239; }
    .prose .good { background: #f0fdf4; border-left: 3px solid #22c55e; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #166534; }
    .prose .warn { background: #fef3c7; border-left: 3px solid #f59e0b; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #92400e; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-rose-50 to-red-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-rose-700 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">

      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">CoreNLP Custom NER Training for African CV Parsing</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions Interns</p>
    </div>
  </section>

  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Objective</h2>
    <p>The previous phase established a working CoreNLP integration that correctly extracted emails and applied rule-based section detection, but failed on name recognition — CoreNLP's default models were trained on Western English news corpora and had no exposure to African naming conventions. "UPAO MAZIBO" received no PERSON tag; instead "Nmap" (a security tool) was incorrectly assigned as the candidate name.</p>
    <p>This phase documents the training of a <strong>custom CoreNLP NER model</strong> targeting four entity types specific to CV processing, its validation against test sentences, packaging into the Ajirika WAR, and integration into the live pipeline.</p>

    <h2>Training Overview</h2>
    <p>CoreNLP's NER component uses a <strong>Conditional Random Field (CRF) classifier</strong>. Training does not replace the existing pre-trained models it produces an additional <code>.ser.gz</code> model file loaded alongside the default English models, allowing the custom model to tag entity types the default models do not recognise.</p>
    <table>
      <tr><th>Label</th><th>Rationale</th></tr>
      <tr><td>PERSON</td><td>Default model fails on African names not in its training corpus</td></tr>
      <tr><td>JOB_TITLE</td><td>No equivalent entity type in CoreNLP's default label set</td></tr>
      <tr><td>DEGREE</td><td>No equivalent entity type in CoreNLP's default label set</td></tr>
      <tr><td>ORGANIZATION</td><td>Default model partially works but misses African institution names</td></tr>
    </table>

    <h2>Stage 1: Training Data Preparation</h2>
    <h3>Format</h3>
    <p>CoreNLP NER training requires data in <strong>CoNLL column format</strong>. Each token appears on its own line with its label in a second tab-separated column. Blank lines separate segments. Entity spans use <strong>BIO tagging</strong> (Begin, Inside, Outside).</p>
    <pre><code>UPAO        B-PERSON
MAZIBO      I-PERSON
is          O
a           O
Software    B-JOB_TITLE
Developer   I-JOB_TITLE
Intern      I-JOB_TITLE</code></pre>

    <h3>Dataset</h3>
    <p>The training file <code>cv-train.tsv</code> was built manually by annotating CV text representative of the target demographic — East and Central African candidates in technology fields. It covered:</p>
    <ul>
      <li>African personal names across multiple naming conventions including East African, Central African, and anglicised African names</li>
      <li>Job titles common in Kenyan and East African technology and finance sectors</li>
      <li>Degree qualifications across certificate, diploma, bachelor, master, and PhD levels</li>
      <li>African university and institution names including public universities and polytechnics</li>
    </ul>
    <table>
      <tr><th>Entity Type</th><th>Annotated Instances</th></tr>
      <tr><td>B-PERSON</td><td>307</td></tr>
      <tr><td>B-JOB_TITLE</td><td>309</td></tr>
      <tr><td>B-DEGREE</td><td>308</td></tr>
      <tr><td>B-ORGANIZATION</td><td>312</td></tr>
      <tr><td><strong>Total tokens</strong></td><td><strong>5,329 across 332 documents</strong></td></tr>
    </table>

    <h2>Stage 2 — Training Configuration</h2>
    <p>File: <code>ner-training.properties</code></p>
    <pre><code>trainFile = /path/to/cv-train.tsv
serializeTo = /path/to/cv-ner-model.ser.gz
map = word=0,answer=1

useClassFeature = true
useWord = true
useNGrams = true
maxNGramLeng = 6
usePrev = true
useNext = true
useSequences = true
usePrevSequences = true
maxLeft = 1
wordShape = chris2useLC
useTypeSeqs = true
useTypeSeqs2 = true
useTypeySequences = true</code></pre>
    <p><strong>Key decisions:</strong></p>
    <ul>
      <li><code>useNGrams</code> + <code>maxNGramLeng = 6</code> — allows the model to learn character-level subword patterns; important for African names which share morphological patterns (suffixes like -oti, -eki, -wanjiku, -adhiambo) that help generalise to unseen names</li>
      <li><code>usePrev</code> + <code>useNext</code> gives context from surrounding tokens; a name is more likely after contextual tokens like "Name:" or at document start</li>
      <li><code>wordShape = chris2useLC</code> maps tokens to abstract shape representations (uppercase, lowercase, mixed) helping handle capitalisation patterns in CV formatting</li>
    </ul>

    <h2>Stage 3 — Model Training</h2>
    <p>Training run directly against the CoreNLP JAR from the local Maven cache:</p>
    <pre><code>java -Xmx4g \
  -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -prop /path/to/ner-training.properties</code></pre>
    <pre><code>numClasses: 9 [O, B-PERSON, I-PERSON, B-DEGREE, I-DEGREE,
               B-ORGANIZATION, I-ORGANIZATION, B-JOB_TITLE, I-JOB_TITLE]
numDocuments: 332
numDatums: 5329
numFeatures: 4229
numWeights: 87093</code></pre>
    <div class="good">Optimiser converged after <strong>75 iterations in 2.70 seconds</strong>. Total training time including data loading and serialisation: 3.2 seconds.</div>

    <h2>Stage 4: Standalone Validation</h2>
    <pre><code>echo "UPAO MAZIBO is a Software Developer Intern at Catholic University \
of Eastern Africa with a BSc Computer Science degree" | \
java -Xmx2g \
  -cp ~/.m2/.../stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -loadClassifier cv-ner-model.ser.gz \
  -readStdin</code></pre>
    <p>Output:</p>
    <pre><code>UPAO/B-PERSON MAZIBO/I-PERSON is/O a/O Software/B-JOB_TITLE
Developer/I-JOB_TITLE Intern/I-JOB_TITLE at/O Catholic/B-ORGANIZATION
University/I-ORGANIZATION of/I-ORGANIZATION Eastern/I-ORGANIZATION
Africa/I-ORGANIZATION with/O a/O BSc/B-DEGREE Computer/I-DEGREE
Science/I-DEGREE degree/O</code></pre>
    <div class="good">All four entity types tagged correctly on the first validation run. The model loaded in 0.1 seconds.</div>

    <h2>Stage 5 — Model Packaging</h2>
    <pre><code>cp ~/ner-training/cv-ner-model.ser.gz \
   src/main/resources/models/</code></pre>
    <p>Files in <code>src/main/resources/</code> are included in the WAR during the Maven build and accessible at runtime via <code>Class.getResourceAsStream("/models/cv-ner-model.ser.gz")</code>.</p>

    <h2>Stage 6 — Pipeline Integration</h2>
    <h3>Static Pipeline with Custom Model</h3>
    <pre><code>static {
    Properties props = new Properties();
    props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");
    props.setProperty("ner.model",
        "edu/stanford/nlp/models/ner/english.all.3class.distsim.crf.ser.gz," +
        "edu/stanford/nlp/models/ner/english.muc.7class.distsim.crf.ser.gz," +
        "edu/stanford/nlp/models/ner/english.conll.4class.distsim.crf.ser.gz," +
        "models/cv-ner-model.ser.gz");
    nlpPipeline = new StanfordCoreNLP(props);
}</code></pre>

    <h3>Name Extraction Logic</h3>
    <pre><code>for (CoreEntityMention em : doc.entityMentions()) {
    if (em.entityType().equals("EMAIL") &amp;&amp; !personalInfo.has("email"))
        personalInfo.put("email", em.text());
    if (em.entityType().equals("PERSON") &amp;&amp; !personalInfo.has("corenlp_name"))
        personalInfo.put("corenlp_name", em.text());
}

// Use first-line as primary; CoreNLP as fallback only when suspicious
if (personalInfo.has("corenlp_name")) {
    String firstLineName = personalInfo.optString("name", "");
    if (firstLineName.isEmpty()
            || firstLineName.length() &gt; 40
            || firstLineName.matches(".*\\d.*")) {
        personalInfo.put("name", personalInfo.getString("corenlp_name"));
    }
    personalInfo.remove("corenlp_name");
}</code></pre>
    <div class="note">The first-line heuristic is the primary name source. CoreNLP is used as fallback when the first line is suspicious (contains digits or is too long). This avoids re-introducing the "Nmap" bug via the custom model.</div>

    <h2>Results</h2>
    <p>Both PDF and DOCX CVs now produce correct name extraction:</p>
    <pre><code>PERSON: UPAO MAZIBO
[CoreNLP custom] Assigned name: UPAO MAZIBO
JOB_TITLE: SOC Analyst
JOB_TITLE: Software developer Intern
DEGREE: BSc
DEGREE: High school</code></pre>

    <table>
      <tr><th>Field</th><th>PDF</th><th>DOCX</th></tr>
      <tr><td>Name</td><td> UPAO MAZIBO</td><td> UPAO MAZIBO</td></tr>
      <tr><td>Email</td><td> Correct</td><td> Correct</td></tr>
      <tr><td>Phone</td><td> Not extracted</td><td> Correct</td></tr>
      <tr><td>Skills</td><td> Garbage bytes in category</td><td> 28 items, correct</td></tr>
      <tr><td>Education</td><td> Dates empty</td><td> edu-from unparsed</td></tr>
    </table>

    <h3>Frontend Rendering Issues Identified</h3>
    <ul>
      <li><strong>[object Object] in skills display</strong> frontend JS renders skill objects without accessing the <code>.skill</code> field</li>
      <li><strong>Experience shows " at "</strong> template expects <code>role</code> and <code>company</code> fields; most entries only carry <code>description</code></li>
    </ul>

    <h2>Remaining Issues</h2>
    <table>
      <tr><th>Issue</th><th>Fix Required</th></tr>
      <tr><td><code>[object Object]</code> in skills display</td><td>Access <code>.skill</code> and <code>.category</code> fields in JS</td></tr>
      <tr><td>edu-from stored as "May 2024" unparsed</td><td>Normalise whitespace before <code>DateTimeFormatter</code></td></tr>
      <tr><td>PDF skills category garbage bytes</td><td>Extend <code>stripBullet</code> regex for PDF-specific multi-byte sequences</td></tr>
      <tr><td>PDF experience lines fragmented</td><td>Continuation line merging heuristic in <code>parseExperience</code></td></tr>
      <tr><td>Model overfitting "Currently", "From" tagged as PERSON</td><td>Add more O-labelled training segments and retrain</td></tr>
    </table>

    <div class="warn"><strong>Note on model overfitting:</strong> The entity log shows false positives where common English words ("Currently", "From", "Worked") are tagged as PERSON. This indicates insufficient negative examples in the training data for these tokens. The fix is to add more O-labelled training segments and retrain. This does not affect name extraction because the first-line heuristic takes precedence for clean CVs.</div>

  </article>

  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <a href="<%= request.getContextPath() %>/blog/corenlp-full-replacement.jsp" class="text-rose-700 font-semibold text-sm hover:underline">← Full NLP Replacement</a>
    <a href="<%= request.getContextPath() %>/cv-annotation-interface.jsp" class="text-cyan-700 font-semibold text-sm hover:underline">Next: Annotation Interface →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
