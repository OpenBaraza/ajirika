<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CoreNLP Local Setup | Ajirika Blog</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    body { font-family: 'Space Grotesk', sans-serif; }
    .prose h2 { font-size: 1.5rem; font-weight: 700; margin: 2.5rem 0 1rem; color: #1e40af; }
    .prose h3 { font-size: 1.15rem; font-weight: 600; margin: 2rem 0 0.75rem; color: #374151; }
    .prose p { color: #4b5563; line-height: 1.8; margin-bottom: 1.1rem; }
    .prose ul { list-style: disc; padding-left: 1.5rem; color: #4b5563; margin-bottom: 1rem; }
    .prose ul li { margin-bottom: 0.4rem; line-height: 1.7; }
    .prose pre { background: #0f172a; color: #e2e8f0; border-radius: 0.75rem; padding: 1.25rem 1.5rem; overflow-x: auto; margin: 1.25rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.82rem; line-height: 1.7; }
    .prose code { background: #eff6ff; color: #1d4ed8; border-radius: 4px; padding: 1px 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.83em; }
    .prose pre code { background: none; color: inherit; padding: 0; }
    .prose table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; font-size: 0.9rem; }
    .prose table th { background: #eff6ff; color: #1d4ed8; font-weight: 600; padding: 0.6rem 1rem; text-align: left; border: 1px solid #dbeafe; }
    .prose table td { padding: 0.55rem 1rem; border: 1px solid #e5e7eb; color: #374151; }
    .prose table tr:nth-child(even) td { background: #f9fafb; }
    .prose strong { color: #1e293b; font-weight: 600; }
    .prose blockquote { border-left: 3px solid #3b82f6; padding-left: 1rem; color: #6b7280; font-style: italic; margin: 1.5rem 0; }
    .prose .note { background: #eff6ff; border-left: 3px solid #3b82f6; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #1e40af; }
    .prose .tip { background: #f0fdf4; border-left: 3px solid #22c55e; padding: 0.75rem 1rem; border-radius: 0 0.5rem 0.5rem 0; margin: 1.25rem 0; font-size: 0.9rem; color: #166534; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <!-- Post Header -->
  <section class="relative overflow-hidden pt-28 pb-10">
    <div class="absolute inset-0 bg-gradient-to-br from-blue-50 to-indigo-50 opacity-70"></div>
    <div class="relative max-w-3xl mx-auto px-6">
      <a href="<%= request.getContextPath() %>/blog.jsp" class="inline-flex items-center gap-2 text-sm text-blue-600 font-semibold mb-6 hover:underline">
        ← Back to Blog
      </a>
      <div class="flex flex-wrap gap-2 mb-4">

      </div>
      <h1 class="text-3xl md:text-4xl font-bold leading-tight mb-4">Stanford CoreNLP Local Setup &amp; NLP Pipeline Testing</h1>
      <p class="text-gray-500 text-sm">By <strong class="text-gray-700">Samuel Dabaly &amp; Upao Mazibo</strong> &nbsp;·&nbsp; Dew CIS Solutions Interns</p>
    </div>
  </section>

  <!-- Post Body -->
  <article class="max-w-3xl mx-auto px-6 py-10 prose">

    <h2>Project Overview</h2>
    <p>This writeup documents the end-to-end setup, configuration, and local execution of <strong>Stanford CoreNLP 4.5.10</strong> on Kali Linux using <strong>Java 25</strong> and <strong>Apache Maven 3.9.12</strong>.</p>
    <p>Stanford CoreNLP is an industry-grade Natural Language Processing toolkit developed by Stanford University. It processes raw text through a sequential annotation pipeline, extracting structured linguistic information including part-of-speech tags, lemmas, named entities, and sentence boundaries.</p>
    <p>The final deliverable is a <strong>standalone executable fat JAR</strong> that runs without requiring Maven, demonstrating a production-ready packaging approach.</p>

    <h2>Environment</h2>
    <table>
      <tr><th>Component</th><th>Details</th></tr>
      <tr><td>Machine</td><td>Lenovo ThinkPad</td></tr>
      <tr><td>OS</td><td>Kali Linux (6.19.14+kali-amd64)</td></tr>
      <tr><td>RAM</td><td>16GB</td></tr>
      <tr><td>IDE</td><td>VSCodium</td></tr>
      <tr><td>Build Tool</td><td>Apache Maven 3.9.12</td></tr>
      <tr><td>Java Version</td><td>OpenJDK 25.0.3-ea</td></tr>
      <tr><td>CoreNLP Version</td><td>4.5.10</td></tr>
    </table>

    <h2>Setup &amp; Configuration</h2>
    <h3>Java Environment</h3>
    <p>The machine runs a <strong>multi-JDK setup</strong> managed via Kali's <code>update-alternatives</code> system. Java 25 was partially registered <code>java</code> pointed to v25 but <code>javac</code> defaulted to v11 due to an incomplete registration. This was resolved manually:</p>
    <pre><code># Register javac for Java 25
sudo update-alternatives --install \
  /usr/bin/javac javac \
  /usr/lib/jvm/java-25-openjdk-amd64/bin/javac 2511

# Set Java 25 as active compiler
sudo update-alternatives --config javac</code></pre>
    <p><code>JAVA_HOME</code> was then synced in <code>~/.zshrc</code>:</p>
    <pre><code>export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH</code></pre>

    <h2>Project Structure</h2>
    <p>Generated using Maven's quickstart archetype:</p>
    <pre><code>mvn archetype:generate \
  -DgroupId=com.demo \
  -DartifactId=corenlp-demo \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DarchetypeVersion=1.4 \
  -DinteractiveMode=false</code></pre>
    <pre><code>corenlp-demo/
├── pom.xml
└── src/
    ├── main/
    │   └── java/com/demo/
    │       └── App.java
    └── test/
        └── java/com/demo/
            └── AppTest.java</code></pre>

    <h2>Dependencies</h2>
    <p>Maven resolves <strong>29 total JARs</strong> transitively from these three declarations:</p>
    <pre><code>&lt;!-- CoreNLP core library --&gt;
&lt;dependency&gt;
  &lt;groupId&gt;edu.stanford.nlp&lt;/groupId&gt;
  &lt;artifactId&gt;stanford-corenlp&lt;/artifactId&gt;
  &lt;version&gt;4.5.10&lt;/version&gt;
&lt;/dependency&gt;

&lt;!-- English language models (~400MB) --&gt;
&lt;dependency&gt;
  &lt;groupId&gt;edu.stanford.nlp&lt;/groupId&gt;
  &lt;artifactId&gt;stanford-corenlp&lt;/artifactId&gt;
  &lt;version&gt;4.5.10&lt;/version&gt;
  &lt;classifier&gt;models&lt;/classifier&gt;
&lt;/dependency&gt;

&lt;!-- SLF4J logging backend --&gt;
&lt;dependency&gt;
  &lt;groupId&gt;org.slf4j&lt;/groupId&gt;
  &lt;artifactId&gt;slf4j-simple&lt;/artifactId&gt;
  &lt;version&gt;2.0.9&lt;/version&gt;
&lt;/dependency&gt;</code></pre>
    <div class="note">CoreNLP ships its <strong>code</strong> and <strong>trained language models</strong> as separate JARs. Both must be declared explicitly. The models JAR alone is ~400MB.</div>

    <h2>Pipeline Implementation</h2>
    <h3>How CoreNLP Works</h3>
    <p>CoreNLP processes text through a <strong>sequential annotator chain</strong>. Each annotator enriches the document and passes it forward:</p>
    <pre><code>Raw Text → tokenize → ssplit → pos → lemma → ner → Annotated CoreDocument</code></pre>
    <ul>
      <li><strong>tokenize</strong> splits text into individual word/punctuation tokens</li>
      <li><strong>ssplit</strong> groups tokens into sentence boundaries</li>
      <li><strong>pos</strong> tags each token with its grammatical role (NNP, VBP, etc.)</li>
      <li><strong>lemma</strong> reduces tokens to dictionary base forms (running → run)</li>
      <li><strong>ner</strong> identifies named entities (PERSON, ORG, CITY, DATE, etc.)</li>
    </ul>

    <h3>Implementation — App.java</h3>
    <pre><code>Properties props = new Properties();
props.setProperty("annotators", "tokenize,ssplit,pos,lemma,ner");

StanfordCoreNLP pipeline = new StanfordCoreNLP(props);

String text = "Samuel Dabaly and Upao Mazibo are students. " +
              "They are in their 3rd year of University. " +
              "Apple Inc. is headquartered in Cupertino, California.";

CoreDocument document = new CoreDocument(text);
pipeline.annotate(document);

for (CoreSentence sentence : document.sentences()) {
    for (CoreLabel token : sentence.tokens()) {
        System.out.printf(
            "Token: %-15s | POS: %-6s | Lemma: %-15s | NER: %s%n",
            token.word(), token.tag(), token.lemma(), token.ner()
        );
    }
}</code></pre>

    <h2>Build &amp; Execution</h2>
    <pre><code># Resolve dependencies
mvn dependency:resolve

# Compile
mvn compile

# Package as fat JAR (skip tests)
mvn package -Dmaven.test.skip=true

# Run
java -jar target/corenlp-demo-1.0-SNAPSHOT.jar</code></pre>

    <h2>Test Output &amp; Analysis</h2>
    <h3>Sentence 1 — Named People</h3>
    <table>
      <tr><th>Token</th><th>POS</th><th>Lemma</th><th>NER</th></tr>
      <tr><td>Samuel</td><td>NNP</td><td>Samuel</td><td>PERSON</td></tr>
      <tr><td>Dabaly</td><td>NNP</td><td>Dabaly</td><td>PERSON</td></tr>
      <tr><td>Upao</td><td>NNP</td><td>Upao</td><td>PERSON</td></tr>
      <tr><td>Mazibo</td><td>NNP</td><td>Mazibo</td><td>PERSON</td></tr>
      <tr><td>are</td><td>VBP</td><td>be</td><td>O</td></tr>
      <tr><td>students</td><td>NNS</td><td>student</td><td>O</td></tr>
    </table>
    <h3>Sentence 3 — Organisation &amp; Location</h3>
    <table>
      <tr><th>Token</th><th>POS</th><th>Lemma</th><th>NER</th></tr>
      <tr><td>Apple</td><td>NNP</td><td>Apple</td><td>ORGANIZATION</td></tr>
      <tr><td>Inc.</td><td>NNP</td><td>Inc.</td><td>ORGANIZATION</td></tr>
      <tr><td>Cupertino</td><td>NNP</td><td>Cupertino</td><td>CITY</td></tr>
      <tr><td>California</td><td>NNP</td><td>California</td><td>STATE_OR_PROVINCE</td></tr>
    </table>
    <div class="tip"><strong>Lemmatization</strong> correctly resolves irregular forms <code>are → be</code>, <code>students → student</code>. The model uses morphological analysis rather than simple suffix stripping.</div>
    <div class="tip"><strong>NER span detection</strong> <code>Apple Inc.</code> is recognised as a single ORGANIZATION entity across two separate tokens, showing the model operates at span level.</div>

    <h2>Challenges &amp; Resolutions</h2>
    <table>
      <tr><th>#</th><th>Challenge</th><th>Resolution</th></tr>
      <tr><td>1</td><td><code>java</code> and <code>javac</code> reporting different versions</td><td>Manually registered <code>javac</code> via <code>update-alternatives</code> at priority 2511</td></tr>
      <tr><td>2</td><td><code>JAVA_HOME</code> pointing at Java 17</td><td>Updated to Java 25 path and re-sourced shell config</td></tr>
      <tr><td>3</td><td>Test compilation failure during <code>mvn package</code></td><td>Used <code>-Dmaven.test.skip=true</code> to bypass test compilation</td></tr>
      <tr><td>4</td><td><code>Unable to access jarfile target/corenlp-demo.jar</code></td><td>Shade plugin appends version string — used full filename</td></tr>
    </table>

    <h2>Key Takeaways</h2>
    <ul>
      <li><code>update-alternatives</code> registers <code>java</code> and <code>javac</code> independently a JDK can be partially registered, causing silent version mismatches</li>
      <li>CoreNLP separates code and models into distinct JARs both must be explicitly declared</li>
      <li>Fat JARs via <code>maven-shade-plugin</code> produce portable single-file executables</li>
      <li><code>-Dmaven.test.skip=true</code> skips both test compilation and execution; <code>-DskipTests</code> only skips execution</li>
      <li>Pipeline build-once, annotate-many model loading (~10s) is amortised across all subsequent annotations</li>
    </ul>

  </article>

  <!-- Nav between posts -->
  <div class="max-w-3xl mx-auto px-6 pb-16 flex justify-between items-center border-t border-gray-100 pt-8">
    <span class="text-gray-400 text-sm">← Previous</span>
    <a href="<%= request.getContextPath() %>/blog/corenlp-cv-feasibility.jsp" class="text-blue-600 font-semibold text-sm hover:underline">Next: CV Parsing Feasibility →</a>
  </div>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
