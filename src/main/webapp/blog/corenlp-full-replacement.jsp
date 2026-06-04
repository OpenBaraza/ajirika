<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CoreNLP Full NLP Replacement | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #92400e; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #fff7ed; color: #92400e; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #fff7ed; color: #92400e; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #fed7aa; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose .note { background: #fff7ed; border-left: 3px solid #f97316; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #7c2d12; }
    .prose .good { background: #f0fdf4; border-left: 3px solid #22c55e; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #166534; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-orange-50 to-amber-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-orange-700 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-orange-100 text-orange-700 rounded-full">Refactor</span>
        <span class="inline-block text-xs font-bold uppercase tracking-wider px-3 py-1 bg-gray-100 text-gray-500 rounded-full">Parser · Tika · Section Detection</span>
      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">CoreNLP — Full NLP Engine Replacement for Ajirika HCM</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions Internship</p>
    </div>
  </section>

  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Starting Point</h2>
    <p>At the end of the previous phase, the pipeline produced:</p>
    <pre><code>{
  "personal_info": { "name": "Nmap", "email": "mazibohoppo@proton.me" },
  "education": [],
  "experience": [{ "position": "OSINT, Incident Response..." }],
  "skills": [],
  "references": []
}</code></pre>
    <p>Root cause analysis confirmed that name extraction failure, empty education/skills/references arrays, and malformed experience entries were all <strong>upstream of CoreNLP</strong> — attributable to how <code>readCV</code> reconstructed text from the Tika XML output.</p>

    <h2>Phase 6 — Full OpenNLP Removal</h2>
    <p><strong>Decision:</strong> Remove OpenNLP entirely from <code>pom.xml</code>, replace <code>analyzeCV.java</code> and <code>analyzeHeaders.java</code> with CoreNLP and rule-based equivalents, and verify the project compiled without any OpenNLP references.</p>
    <p><strong>Files changed:</strong></p>
    <ul>
      <li><code>analyzeCV.java</code> — rewritten with a static CoreNLP pipeline (initialised once in a static block, not per-request)</li>
      <li><code>analyzeHeaders.java</code> — replaced all four custom OpenNLP header NER models with keyword-based line matching</li>
      <li><code>pom.xml</code> — <code>opennlp-tools</code> dependency block removed</li>
    </ul>

    <h3>Compilation Failures Encountered</h3>
    <p>Removing OpenNLP before fixing all dependent files produced <strong>24 compilation errors</strong>. The errors were in <code>App.java</code> and <code>breakdownCV.java</code>, both of which still imported <code>opennlp.tools.sentdetect</code> classes directly.</p>
    <p><code>App.java</code> retained active imports for <code>SentenceDetectorME</code>, <code>SentenceModel</code>, <code>TrainingParameters</code>, and five more — all used in the <code>trainCustSentModel</code> method. That method was replaced with a no-op and all eight imports were removed.</p>
    <div class="note">The distinction between <code>-DskipTests</code> and <code>-Dmaven.test.skip=true</code> is critical. <code>-DskipTests</code> skips test <em>execution</em> but still compiles test sources. Since <code>AppTest.java</code> referenced JUnit classes that had been removed, compilation still failed. The correct flag is <code>-Dmaven.test.skip=true</code>.</div>

    <h2>Phase 7 — readCV Reconstruction Fix</h2>
    <h3>The Problem</h3>
    <p>The previous <code>readCV</code> used <code>ToXMLContentHandler</code> + Jsoup and applied a heuristic: if the previous element exceeded 55 characters and the current element started with a lowercase letter, they were joined with a space rather than a newline. The effect on CV structure: section headers, institution names, and bullet points were merged into single lines hundreds of characters long.</p>
    <p>Concrete example from logs:</p>
    <pre><code>"A. EDUCATION BSc Computer Science (Cybersecurity Focus). Expected finish in November 2027."</code></pre>
    <p><code>detectSectionHeader</code> rejected it because it exceeded the 60-character limit applied to candidate headers.</p>

    <h3>Fix Applied</h3>
    <p>Rewritten to use <code>BodyContentHandler</code> instead of <code>ToXMLContentHandler</code>. <code>BodyContentHandler</code> produces clean plain text from Tika with natural line breaks preserved — no secondary HTML parsing needed.</p>
    <pre><code>// Before — Jsoup + ToXMLContentHandler
ToXMLContentHandler xmlHandler = new ToXMLContentHandler();
AutoDetectParser parser = new AutoDetectParser();
parser.parse(stream, xmlHandler, metadata, context);
Document doc = Jsoup.parse(xmlHandler.toString());
// ... complex heuristic joining logic

// After — BodyContentHandler (clean plain text)
BodyContentHandler handler = new BodyContentHandler(-1);
AutoDetectParser parser = new AutoDetectParser();
parser.parse(stream, handler, metadata, context);
String rawText = handler.toString();
// Normalise: split on newlines, trim, collapse blank lines
String[] lines = rawText.split("\\n");
// ... reassemble with structural line breaks preserved</code></pre>
    <div class="good">After the fix, "A. EDUCATION" appeared on its own line and was correctly matched as a section header. DOCX support also came for free — <code>BodyContentHandler</code> handles DOCX natively via Tika's <code>AutoDetectParser</code>.</div>

    <h2>Phase 8 — breakdownCV Section Parser Rewrite</h2>
    <h3>Section Detection</h3>
    <p><code>detectSectionHeader</code> was updated to strip leading section prefix patterns before matching. CV headers formatted as "A. EDUCATION", "B. EXPERIENCE" were not being matched because prefix letters remained after the formatting strip.</p>
    <pre><code>// Strip leading prefix: "A. ", "B. ", "1. ", etc.
line = line.replaceAll("^[a-z0-9]{1,3}\\.\\s*", "");
// Then match against keyword lists</code></pre>
    <p>Additional changes:</p>
    <ul>
      <li>65-character length guard — long content lines can never be mistaken for headers</li>
      <li>URL and mailto lines explicitly skipped in the line iteration loop</li>
      <li>A PROJECTS header list added to null the current section on "projects" headers</li>
      <li>Pre-section content (before the first header) intentionally ignored — this was the source of summary paragraph contamination into education/references buckets</li>
    </ul>

    <h3>Education Parsing</h3>
    <p>The previous parser looked for degree terms and school terms on separate lines. This failed on combined lines of the form <em>"CATHOLIC UNIVERSITY OF EASTERN AFRICA - Degree in Computer Science"</em>.</p>
    <p>The new implementation handles the combined-line case explicitly: when a line contains both a degree term and a school term, it is split on the first hyphen, dash, or colon, and the two parts assigned to institution and certificate respectively.</p>
    <p>A bullet stripping function was added to handle garbage byte sequences produced by both the PDF parser and the DOCX parser.</p>

    <h3>Experience Parsing</h3>
    <p>The previous parser attempted to group lines into job blocks by splitting on blank lines. This failed because the test CV had no blank lines between experience entries.</p>
    <p>The new implementation processes <strong>experience line by line</strong>, treating each bullet line as a self-contained entry. This produces one JSON object per experience line rather than attempting to group lines into job blocks — appropriate for CVs where each bullet is an independent activity.</p>

    <h3>Skills Parsing</h3>
    <p>Previous skills parser attempted to split on bullet characters that the PDF parser encoded as multi-byte sequences not in the delimiter list, causing the entire skills section to be treated as one unsplit string.</p>
    <p>New implementation processes skills line by line after bullet stripping, detecting category labels of the form <em>"Security Tools: Nmap, Hydra, Tcpdump"</em>:</p>
    <pre><code>if (line.contains(":")) {
    String category = line.substring(0, colonIdx).trim();
    String[] skills = line.substring(colonIdx + 1).split(",");
    for (String skill : skills) {
        JSONObject item = new JSONObject();
        item.put("category", category);
        item.put("skill", skill.trim());
        skillsArray.put(item);
    }
}</code></pre>

    <h2>Current Results</h2>
    <h3>DOCX Processing</h3>
    <table>
      <tr><th>Field</th><th>Result</th><th>Status</th></tr>
      <tr><td>Name</td><td>UPAO MAZIBO</td><td>✅ Correct</td></tr>
      <tr><td>Email</td><td>mazibohoppo@gmail.com</td><td>✅ Correct</td></tr>
      <tr><td>Phone</td><td>+254746782795</td><td>✅ Correct</td></tr>
      <tr><td>Education</td><td>1 entry, institution + cert populated</td><td>⚠️ Partial — edu-from unparsed</td></tr>
      <tr><td>Experience</td><td>4 entries, role extracted for 2</td><td>⚠️ Partial — company field empty</td></tr>
      <tr><td>Skills</td><td>28 items with category metadata</td><td>✅ Correct</td></tr>
    </table>

    <h3>PDF Processing</h3>
    <table>
      <tr><th>Field</th><th>Result</th><th>Status</th></tr>
      <tr><td>Name</td><td>UPAO MAZIBO</td><td>✅ Correct</td></tr>
      <tr><td>Email</td><td>mazibohoppo@proton.me</td><td>✅ Correct</td></tr>
      <tr><td>Skills</td><td>29 items with category metadata</td><td>⚠️ Garbage bytes in PDF-specific category labels</td></tr>
      <tr><td>Experience</td><td>11 entries, 1 per bullet line</td><td>⚠️ Some lines are continuation fragments from wrapping</td></tr>
    </table>

    <h2>Remaining Challenges</h2>
    <ul>
      <li><strong>edu-from "May 2024" unparsed</strong> — double space between month and year doesn't match <code>DateTimeFormatter</code>; fix: normalise whitespace before parsing</li>
      <li><strong>PDF bullet garbage bytes surviving stripBullet</strong> — extend regex character class for PDF-specific multi-byte bullet sequences</li>
      <li><strong>PDF experience line fragmentation</strong> — wrapped bullet lines produce two separate entries; fix: continuation line merging heuristic</li>
      <li><strong>No summary section captured</strong> — pre-section content is intentionally ignored; capturing it requires explicitly identifying the prose block between header and first section</li>
    </ul>

    <h2>Technical Debt Observations</h2>
    <ul>
      <li>The static CoreNLP pipeline exists in both <code>breakdownCV</code> and <code>analyzeCV</code> independently — two 400MB model loads if both classes are instantiated. Fix: single shared pipeline on a <code>NLPPipeline</code> utility class</li>
      <li>CoreNLP is annotating the full CV text including URLs and mailto strings, which contribute noise. Passing only the first 500–800 characters would reduce annotation time</li>
      <li><code>analyzeHeaders</code> is currently dead code in the web pipeline — it populates four static lists that are not read by <code>uploadProcess</code></li>
    </ul>

  </article>

  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <a href="<%= request.getContextPath() %>/blog/corenlp-web-integration.jsp" class="text-orange-700 font-semibold text-sm hover:underline">← Web Integration</a>
    <a href="<%= request.getContextPath() %>/blog/corenlp-custom-ner.jsp" class="text-orange-700 font-semibold text-sm hover:underline">Next: Custom NER Training →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
