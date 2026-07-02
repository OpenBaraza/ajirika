<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Blog | Project Ajirika</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    .blog-card { transition: all 0.3s cubic-bezier(0.4,0,0.2,1); }
    .blog-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(59,130,246,0.12); }
    .tag { display: inline-block; font-size: 0.7rem; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase; padding: 2px 10px; border-radius: 999px; }
  </style>
</head>
<body class="bg-white text-gray-800">

  <jsp:include page="/includes/header.jsp" />

  <!-- Hero -->
  <section class="relative overflow-hidden pt-28 pb-12">
    <div class="absolute inset-0 bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 opacity-60"></div>
    <div class="relative max-w-5xl mx-auto px-6 text-center">

      <h1 class="text-5xl font-bold mb-4">
        Project <span class="gradient-text-blue">Blog</span>
      </h1>
      <p class="text-xl text-gray-600 max-w-2xl mx-auto">
        Technical deep-dives from the Ajirika team NLP, Java, and building a smarter CV ecosystem.
      </p>
    </div>
  </section>

  <!-- Posts Grid -->
  <section class="max-w-6xl mx-auto px-6 py-12">

    <!-- Series label -->
    <div class="mb-8 flex items-center gap-4">
      <div class="h-px flex-1 bg-gray-200"></div>
      <span class="text-sm font-semibold text-gray-400 tracking-widest uppercase">Stanford CoreNLP Series</span>
      <div class="h-px flex-1 bg-gray-200"></div>
    </div>

    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">

      <!-- Post 1 -->
      <a href="<%= request.getContextPath() %>/blog/corenlp-setup.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal">
        <div class="h-3 bg-gradient-to-r from-blue-500 to-indigo-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">

          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">Stanford CoreNLP Local Setup &amp; NLP Pipeline Testing</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">End-to-end setup of CoreNLP 4.5.10 on Kali Linux with Java 25 and Maven, producing a standalone fat JAR with tokenization, POS tagging, lemmatization, and NER.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-blue-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>

      <!-- Post 2 -->
      <a href="<%= request.getContextPath() %>/blog/corenlp-cv-feasibility.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal delay-100">
        <div class="h-3 bg-gradient-to-r from-purple-500 to-pink-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">

          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">CoreNLP CV Parsing Feasibility Evaluation for Ajirika HCM</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">Analysing Ajirika's repository, assessing CoreNLP compatibility, and building a standalone proof-of-concept that processes a real PDF CV document.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-purple-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>

      <!-- Post 3 -->
      <a href="<%= request.getContextPath() %>/blog/corenlp-web-integration.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal delay-200">
        <div class="h-3 bg-gradient-to-r from-green-500 to-teal-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">

          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">CoreNLP CV Parsing Web Integration into Ajirika HCM</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">Two-phase integration: standalone CLI validation then surgical embedding into the live Ajirika servlet, replacing the non-functional OpenNLP pipeline.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-green-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>

      <!-- Post 4 -->
      <a href="<%= request.getContextPath() %>/blog/corenlp-full-replacement.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal">
        <div class="h-3 bg-gradient-to-r from-orange-500 to-amber-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">

          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">CoreNLP Full NLP Engine Replacement for Ajirika HCM</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">Complete removal of OpenNLP, rewrite of readCV text reconstruction, and a full rebuild of the section parser that fixes education, experience, and skills extraction.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-orange-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>

      <!-- Post 5 -->
      <a href="<%= request.getContextPath() %>/blog/corenlp-custom-ner.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal delay-100">
        <div class="h-3 bg-gradient-to-r from-rose-500 to-red-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">

          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">CoreNLP Custom NER Training for African CV Parsing</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">Training a custom CRF model on 5,329 tokens to recognise African names, job titles, degrees, and organisations and integrating it into the live pipeline.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-rose-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>

      <!-- Post 6 
      <a href="<%= request.getContextPath() %>/blog/cv-annotation-interface.jsp" class="block blog-card bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden scroll-reveal delay-200">
        <div class="h-3 bg-gradient-to-r from-cyan-500 to-sky-500"></div>
        <div class="p-6">
          <div class="flex items-center gap-2 mb-3">
            <span class="tag bg-cyan-100 text-cyan-700">Tooling</span>
            <span class="tag bg-gray-100 text-gray-500">Annotation · Dataset · CRF</span>
          </div>
          <h2 class="text-lg font-bold text-gray-800 mb-2 leading-snug">CV Annotation Interface and NER Dataset Expansion</h2>
          <p class="text-sm text-gray-500 leading-relaxed mb-4">A browser-based annotation tool replacing manual TSV editing, an iterative refinement cycle, a targeted dataset expansion batch, and a full retrain that resolves the PERSON false-positive failure mode.</p>
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Samuel Dabaly &amp; Upao Mazibo</span>
            <span class="text-cyan-600 font-semibold">Read →</span>
          </div>
        </div>
      </a>
      -->
    </div>
  </section>

  <jsp:include page="/includes/footer.jsp" />
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
</body>
</html>
