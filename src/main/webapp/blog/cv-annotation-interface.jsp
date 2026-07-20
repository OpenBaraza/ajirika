<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CV Annotation Interface | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #155e75; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #ecfeff; color: #155e75; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #ecfeff; color: #155e75; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #a5f3fc; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose .note { background: #ecfeff; border-left: 3px solid #06b6d4; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #155e75; }
    .prose .good { background: #f0fdf4; border-left: 3px solid #22c55e; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #166534; }
    .prose .warn { background: #fef3c7; border-left: 3px solid #f59e0b; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #92400e; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-cyan-50 to-sky-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-cyan-700 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">
        <!--
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-cyan-100 text-cyan-700 rounded-full"></span>
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-gray-100 text-gray-500 rounded-full"></span>
      -->
      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">CV Annotation Interface and NER Dataset Expansion</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions</p>
    </div>
  </section>

  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Objective</h2>

    <p>The previous phase produced a functional custom NER model covering four entity types (PERSON, JOB_TITLE, DEGREE, ORGANIZATION) that correctly tagged African names, job titles, degrees, and organisation names. However, the model was trained on a manually constructed dataset of 5,329 tokens across 332 documents, authored directly in CoNLL BIO format using a text editor. This approach was not sustainable for the dataset growth needed to improve model accuracy. Three specific failure modes were identified:</p>

    <ul>
      <li>Common English words ("Currently", "From", "Trained", "Worked") tagged as PERSON due to insufficient O-labelled negative examples</li>
      <li>Underrepresentation of African organisation names</li>
      <li>No practical workflow for annotating real CV text at scale</li>
    </ul>

    <p>This phase documents the design and implementation of a browser-based CV annotation interface that replaces manual TSV editing, its iterative refinement through real usage, a synthetic data expansion batch targeting the identified failure modes, and a full retrain cycle validating the improvements.</p>

    <h2>Background and Motivation</h2>

    <p>The training file <code>ner-training/cv-train.tsv</code> is a flat tab-separated file in CoNLL BIO format. Each row contains a token and its label separated by a tab. Blank lines separate segments. Editing this by hand is error-prone: a misplaced space instead of a tab, a missing blank line, or an incorrect BIO prefix corrupts the entire training run. The CRF trainer throws an exception and exits without producing a model.</p>

    <p>The annotation interface addresses this by moving all format responsibility to server-side code. The human annotator works with a visual token interface and selects labels from a menu. The CoNLL BIO output is generated from the annotator's selections in one place, validated before writing, and appended to the training file atomically.</p>

    <h2>Stage 1: Architecture Design</h2>

    <p>The annotation tool was designed as a strictly additive change to the existing codebase. No existing servlet, JSP, or parsing class was modified in a breaking way. The architecture reuses all established patterns.</p>

    <h3>Reuse Decisions</h3>

    <table>
      <tr><th>Component</th><th>Reuse</th><th>Rationale</th></tr>
      <tr><td><code>readCV.java</code></td><td>Unchanged</td><td>Tika extraction already produces clean line-separated plain text</td></tr>
      <tr><td><code>breakdownCV.java</code></td><td>One additive method</td><td>Tokenization via <code>PTBTokenizer</code> added; all existing parsing untouched</td></tr>
      <tr><td><code>@MultipartConfig</code> + <code>Part</code> API</td><td>Mirrored exactly</td><td>Consistent with <code>uploadProcess.java</code> file upload convention</td></tr>
      <tr><td><code>org.json</code></td><td>Used throughout</td><td>Already a project dependency, no new libraries introduced</td></tr>
      <tr><td>Tailwind CDN + <code>style.css</code></td><td>Mirrored from <code>processCV.jsp</code></td><td>Visual consistency with existing pages</td></tr>
    </table>

    <h3>Storage Design</h3>

    <p>No database. The training file is already git tracked at <code>ner-training/cv-train.tsv</code>. Git provides versioning, diff, and rollback at zero additional cost. An append only file with a <code>synchronized</code> write block is sufficient for single annotator use.</p>

    <h3>Endpoints</h3>

    <p>Two actions on one servlet dispatched by path info:</p>

    <pre><code>POST /annotateCV/tokenize   multipart, field: cvFile
POST /annotateCV/export     JSON body: {segments: [{tokens, labels}]}</code></pre>

    <h2>Stage 2: Backend Implementation</h2>

    <h3>Tokenizer Addition breakdownCV.java</h3>

    <p>A <code>tokenizeForAnnotation()</code> method was added using direct <code>PTBTokenizer</code> instantiation. This was a deliberate choice over calling <code>nlpPipeline.annotate()</code>. The full pipeline runs tokenization, sentence splitting, POS tagging, lemmatization, and NER inference all four stacked NER classifiers per line. On a 60 line CV that meant sixty full NER inference passes for what is fundamentally a tokenization task. The <code>PTBTokenizer</code> used here is the same tokenizer the CoreNLP pipeline uses internally but invoked with none of the model overhead.</p>

    <pre><code>public JSONArray tokenizeForAnnotation(String plainText) {
    JSONArray segments = new JSONArray();
    String[] lines = plainText.split("\\r?\\n");
    for (int i = 0; i &lt; lines.length; i++) {
        String trimmed = lines[i].trim();
        if (trimmed.isEmpty()) continue;
        PTBTokenizer&lt;CoreLabel&gt; tokenizer = new PTBTokenizer&lt;&gt;(
            new StringReader(trimmed), new CoreLabelTokenFactory(), "");
        List&lt;CoreLabel&gt; tokenList = tokenizer.tokenize();
        JSONArray tokens = new JSONArray();
        for (CoreLabel tok : tokenList) tokens.put(tok.word());
        JSONObject segment = new JSONObject();
        segment.put("line", i);
        segment.put("tokens", tokens);
        segments.put(segment);
    }
    return segments;
}</code></pre>

    <p>Using the same tokenizer for annotation and inference is important for training data quality. If annotation and inference produce different token boundaries for the same input text, the CRF classifier sees inconsistencies between training labels and the tokens it actually classifies at inference time.</p>

    <h3>Servlet annotateCV.java</h3>

    <p>The servlet handles two actions. The <code>/tokenize</code> action extracts the uploaded file to a temp directory, calls <code>readCV.read()</code>, then <code>breakdownCV.tokenizeForAnnotation()</code>, and returns a JSON array of segment objects. The temp directory is cleaned up after extraction.</p>

    <p>The <code>/export</code> action reads a JSON body containing segments with token arrays and label arrays, validates each label against a pattern, and appends the CoNLL BIO formatted output to <code>cv-train.tsv</code>.</p>

    <p>A defensive check was added after a production bug: if the training file does not end with a newline, the first token of the appended data fuses onto the last line of the existing file, producing a three column row that the CRF trainer rejects with an exception. The fix reads the last byte of the file before writing and prepends a newline if needed. The file path itself is resolved via <code>ServletContext.getRealPath("/WEB-INF/ner-training/cv-train.tsv")</code> in <code>init()</code>, not a hardcoded constant this keeps the servlet portable across machines with different deployment paths.</p>

    <pre><code>synchronized (annotateCV.class) {
    Path trainPath = Paths.get(trainFile);
    String prefix = "";
    if (Files.exists(trainPath) &amp;&amp; Files.size(trainPath) &gt; 0) {
        try (java.io.RandomAccessFile raf = new java.io.RandomAccessFile(trainPath.toFile(), "r")) {
            raf.seek(raf.length() - 1);
            if (raf.read() != '\n') prefix = "\n";
        }
    }
    Files.writeString(trainPath, prefix + tsv.toString(),
        StandardOpenOption.CREATE, StandardOpenOption.APPEND);
}</code></pre>

    <h3>BIO Label Ownership</h3>

    <p>The initial implementation had the server compute B/I prefixes from the client's plain entity-type labels ("PERSON", "JOB_TITLE"). This was revised after real usage revealed it was insufficient. When an annotator labels "SOC" as JOB_TITLE, then "&amp;" as O, then "Vulnerability Assessment Intern" as JOB_TITLE, the auto-computation produces two separate B-JOB_TITLE spans because the O token breaks the run. The annotator had no way to express that "Vulnerability Assessment Intern" continues the same entity span as "SOC".</p>

    <p>The fix moves BIO label ownership to the client entirely. The server validates that each label matches <code>^(O|[BI]-(PERSON|JOB_TITLE|DEGREE|ORGANIZATION|LOCATION|COMPANY|CERTIFICATION))$</code> and writes it directly to TSV without transformation. The annotator selects B (begin) or I (continue) explicitly. LOCATION, COMPANY, and CERTIFICATION were added to this set in a later expansion see Stage 7 below.</p>

    <h2>Stage 3: Frontend Implementation</h2>

    <h3>annotate.jsp</h3>

    <p>A new JSP page consistent with the existing site structure. Includes the Tailwind CDN, <code>style.css</code>, a file input and two action buttons, the token container, a floating label menu, and a status line. The <code>body</code> uses <code>display: flex; flex-direction: column; min-height: 100vh</code> with <code>main</code> set to <code>flex: 1</code> so the footer is always pinned to the bottom of the viewport regardless of content height.</p>

    <h3>annotateUpload.js</h3>

    <p>State is held in three module-level variables: <code>currentSegments</code> (the tokenized CV), <code>currentLabels</code> (a parallel 2D array of label strings indexed by segment and token), and <code>selection</code> (current anchor/focus/segment).</p>

    <p><strong>Rendering:</strong> Tokens are rendered as inline <code>&lt;span&gt;</code> elements with natural spacing. The spacing logic checks each token against regex patterns for punctuation that should be tight-before (<code>.,;:)</code>) or tight-after (<code>(</code>). This produces readable text that resembles the original CV rather than a stream of spaced chips.</p>

    <p><strong>Color coding:</strong> Label colors are looked up by entity type after stripping the B/I prefix, so <code>B-PERSON</code> and <code>I-PERSON</code> share the same blue background. Labeled tokens get a faint border to distinguish them from unlabeled transparent background tokens at a glance.</p>

    <p><strong>Selection:</strong> Click sets anchor and focus to the same token. Shift click extends focus within the same line. Cross-line selection is intentionally not supported it would allow accidentally spanning across unrelated CV lines and producing nonsensical multi line entity labels.</p>

    <p><strong>Label menu:</strong> A floating menu appears at the click coordinates. It is divided into two sections: Begin (B) and Continue (I), each containing all entity types (originally four; expanded to seven see Stage 7). Clicking anywhere outside the menu or a token dismisses it. Keyboard shortcuts assign labels without opening the menu: lowercase (p/j/d/g/l/c/r) assigns B variants, uppercase (P/J/D/G/L/C/R) assigns I variants, x clears to O.</p>

    <p><strong>Export guard:</strong> Only segments containing at least one non-O label are included in the export payload. This prevents accidental all-O dumps when the annotator clicks Export before completing their work. A <code>confirm()</code> dialog shows the count of labeled lines and entity tokens before committing. A <code>hasExportedThisLoad</code> flag triggers a duplicate-export warning if the same loaded document is exported more than once.</p>

    <h3>Navigation</h3>

    <p>An "Annotate" link was added to both the desktop and mobile nav blocks in <code>includes/header.jsp</code>.</p>

    <h2>Stage 4: Iterative Refinement</h2>

    <p>Several issues were identified and resolved through real annotation sessions.</p>

    <h3>Training File Corruption Bug</h3>

    <p>On the first real retrain attempt after the tool was built, the CRF trainer threw:</p>

    <pre><code>Error on line 6221: .   OSamuel O
Exception: Argument array lengths differ: [TextAnnotation, AnswerAnnotation] vs [., OSamuel, O]</code></pre>

    <p>The restored baseline file lacked a trailing newline. The first token of the first appended export (<code>Samuel</code>) fused onto the last line of the baseline (<code>. O</code>), producing a three column row. The one corrupted line was repaired with a Python one-liner and the defensive newline check described in Stage 2 was added to prevent recurrence.</p>

    <h3>Empty Export Bug</h3>

    <p>The first export test returned <code>appendedTokens: 0</code> without error. The export button had no guard against being clicked before the tokenize request completed. When Export fired while <code>currentSegments</code> was still an empty array, the server received an empty payload and correctly wrote nothing. Fixed by disabling the Export button on page load and enabling it only after a successful tokenize response populates <code>currentSegments</code>.</p>

    <h3>Performance: Slow Tokenize Response</h3>

    <p>Early testing required multiple page reloads before tokenization completed reliably. The root cause was the first implementation of <code>tokenizeForAnnotation()</code>, which called <code>nlpPipeline.annotate()</code> per CV line. On a 60 line CV this triggered 60 full NER inference passes (three default English models plus the custom model) instead of the lightweight tokenization the task actually required. Replacing this with direct <code>PTBTokenizer</code> calls reduced tokenize response time from several seconds to under one second.</p>

    <h2>Stage 5: Dataset Expansion</h2>

    <p>With the annotation tool validated, the training dataset was expanded in two ways.</p>

    <h3>Real CV Annotation</h3>

    <p>Samuel's CV (SamuelResume.pdf) was annotated through the browser interface producing 116 segments and 649 tokens. This was the first use of the tool for real data and confirmed the end to end workflow: upload → tokenize → label → confirm dialog → export → TSV append → git diff → commit.</p>

    <h3>Synthetic Batch</h3>

    <p>24 additional segments (243 tokens) were generated programmatically to address the two highest priority gaps in the existing dataset:</p>

    <p><strong>O-label negatives for false positive words:</strong> Eight segments placing "Currently", "From", "Trained", and "Worked" in unambiguous non-name contexts.</p>

    <pre><code>Currently	O
working	O
as	O
a	O
junior	O
developer	O
...</code></pre>

    <p><strong>East African named entities:</strong> Sixteen segments covering African PERSON + JOB_TITLE + ORGANIZATION combinations, and standalone ORGANIZATION examples using Kenyan institutions including Safaricom, Equity Bank, Kenya Revenue Authority, Twiga Foods, Cellulant, Jumia Kenya, KCB Bank, and Andela.</p>

    <p>BIO prefixes for the synthetic batch were computed programmatically using the same algorithm as the export servlet, eliminating manual transcription errors.</p>

    <p>The synthetic data was appended via heredoc and committed alongside the real annotation.</p>

    <h3>Final Dataset Size</h3>

    <table>
      <tr><th>Source</th><th>Documents</th><th>Tokens</th></tr>
      <tr><td>Original baseline</td><td>332</td><td>5,329</td></tr>
      <tr><td>Samuel CV annotation</td><td>116</td><td>649</td></tr>
      <tr><td>Synthetic expansion batch</td><td>24</td><td>243</td></tr>
      <tr><td><strong>Total</strong></td><td><strong>472</strong></td><td><strong>~6,221</strong></td></tr>
    </table>

    <h2>Stage 6: Retrain and Validation</h2>

    <h3>Training Run</h3>

    <pre><code>java -Xmx4g \
  -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -prop ner-training/ner-training.properties</code></pre>

    <p>The optimiser converged after 102 iterations in 15.63 seconds. The longer convergence compared to the original 75 iteration run reflects the larger dataset.</p>

    <pre><code>QNMinimizer terminated due to average improvement
Total time spent in optimization: 15.63s
CRFClassifier training ... done [17.0 sec].
Serializing classifier to .../cv-ner-model.ser.gz ... done.</code></pre>

    <h3>Standalone Validation</h3>

    <p>The retrained model was tested against sentences containing the previously failing tokens before any deployment:</p>

    <pre><code>echo "Currently pursuing a degree. From January to December she worked there. \
Trained on Wireshark and Nmap." | \
java -Xmx2g \
  -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -loadClassifier ner-training/cv-ner-model.ser.gz -readStdin</code></pre>

    <p>Output:</p>

    <pre><code>Currently/O pursuing/O a/O degree/O ./O
From/O January/O to/O December/O she/O worked/O there/O ./O
Trained/O on/O Wireshark/O and/O Nmap/O ./O</code></pre>

    <div class="good">All three previously failing tokens correctly tagged as O. The model was copied to <code>src/main/resources/models/</code> and the project was rebuilt and redeployed.</div>

    <h3>Pipeline Validation: Three CVs</h3>

    <p>After deployment, three CVs were processed through the live <code>/processCV</code> endpoint: Samuel's PDF, Upao's PDF, and Upao's DOCX. Key results:</p>

    <table>
      <tr><th>Check</th><th>Result</th></tr>
      <tr><td><code>Currently</code> tagged as PERSON</td><td>Not observed fixed</td></tr>
      <tr><td><code>From</code> tagged as PERSON</td><td>Not observed fixed</td></tr>
      <tr><td><code>Trained</code> tagged as PERSON</td><td>Not observed fixed</td></tr>
      <tr><td>Name extraction both candidates</td><td>Correct on all three CVs</td></tr>
      <tr><td>Skills extraction</td><td>Correct on all three CVs</td></tr>
      <tr><td>Experience extraction Upao DOCX</td><td>4 entries, correct</td></tr>
      <tr><td>Experience extraction Samuel PDF</td><td>0 entries new issue identified</td></tr>
    </table>

    <p>A new parsing issue was found during validation: Samuel's CV uses the section header "PRACTICAL CYBERSECURITY EXPERIENCE" which did not match the experience keyword list. The keyword check uses prefix matching and "practical cybersecurity experience" does not start with "practical experience" (the ordering differs). Fixed by adding "practical cybersecurity experience" to <code>EXPERIENCE_HEADERS</code> in <code>breakdownCV.java</code>.</p>

    <h2>Current State</h2>

    <p>The annotation interface is fully operational at <code>http://localhost:8080/ajirika/annotate.jsp</code>. The retrained model is deployed and the primary false-positive failure mode (common English words tagged as PERSON) is resolved.</p>

    <h3>Annotation Workflow (Current)</h3>

    <ul>
      <li>Navigate to <code>/annotate.jsp</code></li>
      <li>Select a CV file (PDF or DOCX) and click Load</li>
      <li>Wait for tokenisation (~1 second) CV text appears line by line</li>
      <li>Click a token to select it; shift click another token on the same line to extend the selection</li>
      <li>A label menu appears: choose Begin (B) or Continue (I) for the appropriate entity type, or use keyboard shortcuts (p/P/j/J/d/D/g/G/l/L/c/C/r/R for entity types, x to clear)</li>
      <li>A <code>confirm()</code> dialog shows labeled line and token counts before export</li>
      <li>Clicking OK appends only the labeled segments to <code>ner-training/cv-train.tsv</code></li>
      <li>Verify with <code>tail</code> and <code>git diff</code>, then commit</li>
    </ul>

    <h3>Security Note</h3>

    <p>The <code>sysadmin</code> security constraint that gates the annotation routes (<code>/annotate.jsp</code>, <code>/annotateCV/*</code>) is present in <code>web.xml</code> but is currently commented out a deliberate, tracked decision for local dev testing, not an oversight. Only the <code>applicant</code>/<code>sysadmin</code> constraint on <code>/profile.jsp</code> is active, which is what gates container FORM authentication overall. It must be uncommented before any production deployment; leaving it off means the annotation routes are reachable by anyone, authenticated or not.</p>

    <pre><code>&lt;security-constraint&gt;
    &lt;display-name&gt;Annotation Tool Constraint&lt;/display-name&gt;
    &lt;web-resource-collection&gt;
        &lt;web-resource-name&gt;Annotation Protected Area&lt;/web-resource-name&gt;
        &lt;url-pattern&gt;/annotate.jsp&lt;/url-pattern&gt;
        &lt;url-pattern&gt;/annotateCV/*&lt;/url-pattern&gt;
    &lt;/web-resource-collection&gt;
    &lt;auth-constraint&gt;
        &lt;role-name&gt;sysadmin&lt;/role-name&gt;
    &lt;/auth-constraint&gt;
&lt;/security-constraint&gt;</code></pre>

    <div class="warn">The annotation routes are currently unprotected for local testing. This is a deliberate, documented tradeoff not a bug but must be reverted before production.</div>

    <h2>Stage 7: Entity Type Expansion LOCATION, COMPANY, CERTIFICATION</h2>

    <p>A follow-up audit found the entity type set inconsistent across the annotation stack: three new labels (LOCATION, COMPANY, CERTIFICATION) had training data prepared but were missing from the server-side validator, the client-side keyboard bindings, and <code>breakdownCV.java</code>'s entity extraction meaning the model could never actually be trained or used on them despite the intent being documented earlier.</p>

    <p>Three files required synchronized changes, since a mismatch between any of them silently breaks the pipeline (e.g. a client sending a label the server rejects, or a server accepting a label the client can never produce):</p>

    <ul>
      <li><code>annotateCV.java</code> <code>VALID_LABEL</code> regex extended to accept the three new B/I label pairs</li>
      <li><code>annotateUpload.js</code> <code>LABEL_KEYS</code>, <code>ENTITY_COLORS</code>, <code>ENTITY_DISPLAY</code> extended with <code>l/L</code> (LOCATION), <code>c/C</code> (COMPANY), <code>r/R</code> (CERTIFICATION)</li>
      <li><code>annotate.jsp</code> legend text, label buttons, and CSS classes added to match, since the JS bindings alone had no corresponding UI without this</li>
      <li><code>breakdownCV.java</code> <code>extractPersonalInfo()</code> extended to read LOCATION/COMPANY/CERTIFICATION entities from the NER pipeline's output into <code>personal_info.location</code>, <code>personal_info.current_company</code>, and <code>personal_info.certification</code> respectively</li>
    </ul>

    <div class="note">CERTIFICATION extraction is scoped to the same first-1000-character window as PERSON/EMAIL extraction in <code>extractPersonalInfo()</code>, since that method only scans the CV header. Certifications listed later in the document are not captured by this path full-document CERTIFICATION coverage would need a separate pass in the certifications-section parser.</div>

    <p>A parallel fix, unrelated to entity types but bundled in the same audit: <code>debugExtraction()</code> in <code>breakdownCV.java</code> had two unconditional <code>System.out.println</code> calls that bypassed the existing <code>DEBUG</code> flag whenever the method was called. A defense-in-depth guard (<code>if (!DEBUG) return;</code>) was added directly inside the method, in addition to the existing gated call site.</p>

    <h2>Stage 8: Authentication Debugging Container-Managed Login</h2>

    <p>Signup and CV import worked end-to-end, but login consistently failed with "incorrect email or password" for every newly created account, regardless of correct credentials. This took multiple debugging cycles to isolate because the failure had several independent, stacked causes rather than one.</p>

    <h3>Cause 1: Signup Never Populated the Auth Table</h3>

    <p>Tomcat's <code>DataSourceRealm</code> authenticates against a <code>tomcat_users</code> table. <code>SignUpServlet</code> only ever wrote to <code>applicants</code>. Investigation of <code>tomcat_users</code> revealed it was a Postgres <strong>view</strong>, not a base table a three-way join across <code>entitys</code>, <code>entity_subscriptions</code>, and <code>entity_types</code>. Further inspection found an existing trigger, <code>ins_applicants</code>, that already handled the entire chain automatically on a plain <code>INSERT INTO applicants</code>: it creates the <code>entitys</code> row, hashes the password via <code>md5()</code>, and (via a second trigger, <code>aft_entitys</code>) creates the <code>entity_subscriptions</code> row. The original plain insert in <code>SignUpServlet</code> was already correct; no application-level auth-sync code was needed at all. An interim fix that manually inserted into <code>entitys</code>/<code>entity_subscriptions</code> was written, found to be redundant once the trigger chain was understood, and reverted.</p>

    <h3>Cause 2: LockOutRealm Masking Retest Attempts</h3>

    <p><code>context.xml</code> wrapped the Realm in <code>LockOutRealm failureCount="5" lockOutTime="600"</code>. Repeated failed login attempts during debugging (before Cause 1 was fixed) tripped this lockout, so even after the underlying auth was fixed, further attempts against the same test account continued failing confirmed via a <code>catalina.out</code> line: <code>LockOutRealm.filterLockedAccounts: An attempt was made to authenticate the locked user</code>. Removed for local dev; must be restored before production.</p>

    <h3>Cause 3: Three Divergent context.xml Files</h3>

    <p>The project has three context descriptor locations: the source tree (<code>src/main/webapp/META-INF/context.xml</code>), the deployed exploded webapp copy (<code>~/tomcat/webapps/ajirika/META-INF/context.xml</code>), and an external per-app descriptor (<code>~/tomcat/conf/Catalina/localhost/ajirika.xml</code>). Tomcat loads the external descriptor when present, silently ignoring the other two. Multiple Realm edits were applied to the wrong file across several iterations before this was discovered from a <code>catalina.out</code> startup log line: <code>Deploying deployment descriptor [.../conf/Catalina/localhost/ajirika.xml]</code>. The external descriptor also lacked a <code>Realm</code> block entirely, meaning Tomcat fell back to the global Engine-level <code>Realm</code> in <code>server.xml</code> a stock <code>UserDatabaseRealm</code> against <code>tomcat-users.xml</code>, unrelated to the application's Postgres-backed users. This is the actual final root cause: every login attempt was being checked against an empty default user database, not the application's own data at all.</p>

    <div class="warn">All three context.xml files must currently be kept in sync manually. The external descriptor at <code>conf/Catalina/localhost/ajirika.xml</code> is authoritative at runtime and should be checked first in any future auth/config debugging.</div>

    <h2>Remaining Issues</h2>

    <table>
      <tr><th>Issue</th><th>Location</th><th>Priority</th></tr>
      <tr><td><code>parseDateFlexible</code> double-space</td><td><code>breakdownCV.java</code></td><td>Pre-existing DOCX <code>edu-from</code> stores "May 2024" unparsed</td></tr>
      <tr><td>PDF phone regex (spaced numbers)</td><td><code>breakdownCV.java</code></td><td>Pre-existing  <code>+254 746 782 795</code> not extracted</td></tr>
      <tr><td>Education deduplication (two-column PDFs)</td><td><code>breakdownCV.java</code></td><td>Pre-existing  truncated first entry still renders</td></tr>
      <tr><td>Experience role/description duplication</td><td><code>processUpload.js</code></td><td>Pre-existing role text duplicated in description line</td></tr>
      <tr><td>Bullet garbage bytes in certification field</td><td><code>breakdownCV.java</code></td><td>Pre-existing backend <code>stripBullet</code> incomplete</td></tr>
      <tr><td><code>Hydra</code>/<code>Python</code> tagged as PERSON</td><td>Default CoreNLP models</td><td>Not actionable from pre-trained English news models, overridden by first-line heuristic</td></tr>
      <tr><td>More annotated CVs needed</td><td><code>cv-train.tsv</code></td><td>Ongoing current 472 documents is functional but a larger dataset improves recall on unseen names</td></tr>
    </table>

    <h2>Environment Reference</h2>

    <table>
      <tr><th>Component</th><th>Details</th></tr>
      <tr><td>Machine</td><td>Lenovo ThinkPad</td></tr>
      <tr><td>OS</td><td>Kali Linux (6.19.14+kali-amd64)</td></tr>
      <tr><td>RAM</td><td>16GB</td></tr>
      <tr><td>Java Version</td><td>OpenJDK 25.0.3-ea</td></tr>
      <tr><td>Maven Version</td><td>Apache Maven 3.9.12</td></tr>
      <tr><td>Tomcat Version</td><td>Apache Tomcat 10.1.55</td></tr>
      <tr><td>CoreNLP Version</td><td>4.5.10</td></tr>
      <tr><td>Custom Model</td><td>cv-ner-model.ser.gz, retrained 2026-06-18</td></tr>
      <tr><td>Training Tokens</td><td>~6,221 across 472 documents</td></tr>
      <tr><td>Training Time</td><td>17.0 seconds, 102 iterations</td></tr>
    </table>

  </article>

  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <a href="<%= request.getContextPath() %>/blog/corenlp-custom-ner.jsp" class="text-cyan-700 font-semibold text-sm hover:underline">← Custom NER Training</a>
    <a href="<%= request.getContextPath() %>/blog.jsp" class="text-cyan-700 font-semibold text-sm hover:underline">Back to Blog →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />

  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>

</body>
</html>