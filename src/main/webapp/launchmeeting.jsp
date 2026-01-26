<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | Community Event</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-gray-50">

  <!-- Header -->
  <jsp:include page="/includes/header.jsp" />

  <!-- Main Content -->
  <main class="max-w-5xl mx-auto px-6 py-8 mt-24 mb-10 bg-white shadow-lg rounded-lg">

    <!-- Title -->
    <h1 class="text-3xl md:text-4xl xl:text-5xl font-bold mb-6 leading-tight text-center scroll-reveal">
      Rethinking Recruitment at the 
      <span class="gradient-text-blue">Ajirika</span> Community Event
    </h1>

    <p class="text-gray-700 leading-relaxed mb-5 scroll-reveal">
      On <strong>11th December 2025</strong>, the Ajirika community hosted a collaborative engagement at the 
      <strong>Parklands Sports Club</strong>, bringing together software developers and human resource professionals
      to explore how recruitment can evolve in the age of digital transformation and artificial intelligence.
    </p>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      The event served as a collaborative forum to explore the Ajirika project's vision while openly discussing the real-world pain points faced by HR teams and job seekers alike.
    </p>

    <h2 class="text-2xl font-bold leading-tight mb-4 scroll-reveal underline">
      The Recruitment Problem Today
    </h2>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      A central theme of the discussion was the overwhelming burden placed on HR professionals when handling recruitment processes manually. Many employers are forced to sift through hundreds sometimes thousands of CVs for a single role. This approach is not only inefficient but also limits the ability to identify the most suitable candidates effectively.
    </p>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Participants highlighted how poorly optimized CVs make it difficult for recruiters to extract key information such as skills, experience, and achievements. In many cases, essential details are buried in long narratives or omitted entirely.
    </p>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      On the employer side, another challenge emerged: poorly defined job descriptions. Vague or unclear job postings often attract large volumes of irrelevant applications, further increasing the workload for HR teams and frustrating qualified candidates.
    </p>

    <h2 class="text-2xl font-bold leading-tight mb-4 scroll-reveal underline">
      Emerging Challenges in a Changing Job Market
    </h2>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      The discussion also acknowledged newer recruitment challenges driven by technology and shifting work patterns. With the rise of AI-powered tools, many CVs now look strikingly similar, making differentiation increasingly difficult. While these tools help candidates polish their profiles, they also raise concerns around authenticity and originality.
    </p>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Additionally, the traditional CV model struggles to accommodate the gig economy, where employers seek talent based on specific tasks or short-term engagements rather than permanent roles. Existing recruitment processes are not well equipped to support this evolving employment landscape.
    </p>

    <!-- Key Challenges -->
    <p class="text-gray-700 leading-relaxed mb-2 scroll-reveal">
      Other concerns raised included:
    </p>

    <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
      <li class="mb-4">Incomplete biodata and unclear career timelines from applicants</li>
      <li class="mb-4">Difficulty translating personal work stories into measurable achievements</li>
      <li class="mb-4">Challenges in determining actual skill proficiency</li>
      <li class="mb-4">The inability of CVs to capture attitude, character, and work ethic</li>
      <li class="mb-4">Limited integration of psychometric testing into hiring decisions</li>
    </ul>

     <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal">
      Together, these issues paint a clear picture: the traditional recruitment model is no longer sufficient.
    </p>

    <h2 class="text-2xl font-bold leading-tight mb-4 scroll-reveal underline">
      The <span class="gradient-text-blue">Ajirika</span> Vision: Solutions Through Innovation
    </h2>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Despite the challenges, the event was forward-looking and solution-oriented. Three key solutions stood out during the discussions.
    </p>

    <h4 class="text-xl font-bold mb-4 mx-10 scroll-reveal">
      1. Standardizing the CV
    </h4>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Participants emphasized the importance of creating a standardized CV format that can be easily understood by HR professionals across different organizations. Standardization would improve consistency, reduce ambiguity, and make it easier to compare candidates fairly.
    </p>

    <h4 class="text-xl font-bold mb-4 mx-10 scroll-reveal">
      2. Automation and Intelligent Parsing
    </h4>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Automation emerged as a critical component of modern recruitment. By leveraging machine learning models to parse and filter CVs, organizations can dramatically reduce manual effort while improving accuracy. Intelligent systems can identify suitable candidates based on defined job requirements, allowing HR teams to focus on strategic decision-making.
    </p>

    <h4 class="text-xl font-bold mb-4 mx-10 scroll-reveal">
      3. Data-Driven Recruitment Platforms
    </h4>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      The event strongly advocated for a shift away from manual CV reviews conducted via emails and paper documents. Instead, participants envisioned a centralized recruitment portal where CVs are processed automatically, enriched with statistical insights, and used to generate recommended candidate lists for HR professionals.
    </p>

    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal">
      Such platforms would not only improve productivity but also enable more informed, objective, and scalable hiring decisions.
    </p>

    <!-- Image Carousel -->
    <div class="relative mb-14 scroll-reveal">

      <!-- Left Arrow -->
      <button
        id="leftArrow"
        onclick="scrollGallery(-1)"
        class="absolute left-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 hidden text-blue-900"
        aria-label="Scroll left"
      >
        &#10094;
      </button>

      <!-- Carousel Container -->
      <div class="overflow-hidden">
        <div id="launchGallery" class="flex gap-4 transition-transform duration-500" style="transform: translateX(0);">
          <img src="${pageContext.request.contextPath}/images/launch_image%201.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%202.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%203.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%204.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%205.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%206.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%207.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%208.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
        </div>
      </div>

      <!-- Right Arrow -->
      <button
        id="rightArrow"
        onclick="scrollGallery(1)"
        class="absolute right-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900"
        aria-label="Scroll right"
      >
        &#10095;
      </button>

    </div>
    
    <!-- Initial Team section -->
    <h1 class="text-3xl md:text-4xl xl:text-5xl font-bold mb-6 leading-tight text-center scroll-reveal">
      Initial <span class="gradient-text-blue">Team</span>
    </h1>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Ajirika began as a collaborative initiative shaped by conversations between software developers and HR professionals who experience recruitment challenges firsthand. The initial team came together around a shared goal which was to make recruitment fairer, more efficient, and more inclusive by improving how CV data is handled.
    </p>

    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Early contributors from DewCIS Solutions Ltd, independent developers, and HR practitioners worked collectively to define Ajirika's foundations, bringing technical, operational, and human perspectives into the project. From the start, Ajirika was designed as an open-source, community-driven platform, with the initial team acting as facilitators rather than owners, supporting a growing community committed to shaping the future of employability.
    </p>

    <!-- Inception Section -->
    <h1 class="text-3xl md:text-4xl xl:text-5xl font-bold mb-6 leading-tight text-center scroll-reveal">
      The Inception of <span class="gradient-text-blue">Ajirika</span>
    </h1>
    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      Ajirika was conceived at the intersection of real recruitment pressure, open-source thinking, and DewCIS Solutions Ltd's long-standing experience in building technology for social and economic impact.
    </p>
    <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      For over two decades, DewCIS has worked closely with organizations across Kenya and the wider region, delivering systems in education, government, healthcare, and enterprise. Through this work, one recurring challenge became increasingly clear: recruitment processes were struggling to keep up with scale. Ajirika emerged as a response to that reality.
    </p>

    <p class="text-gray-700 leading-relaxed mb-1 scroll-reveal">
      In Kenya, unemployment rates remain high, and job opportunities especially formal employment are highly competitive. When an organization publishes a job advert, it is common to receive thousands of CVs within a very short time.
    </p>

     <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
      For HR professionals, this creates intense pressure. CVs arrive as emails and attachments, often exceeding 2,000 submissions per role, all requiring manual review. Each document must be opened, interpreted, and evaluated individually. This approach does not scale.
    </p>

      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        The result is a recruitment process that is:
      </p>

      <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
        <li class="mb-4">Exhausting for HR teams</li>
        <li class="mb-4">Inefficient for organizations</li>
        <li class="mb-4">Unfair to candidates</li>
      </ul>

      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        Qualified applicants are often overlooked, not because they lack skills, but because manual systems fail under volume. At the heart of the issue lies the CV itself.
      </p>

       <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        Traditional CVs are documents designed for humans, not systems. They vary widely in layout, language, and structure, making them difficult to process consistently especially in an era where recruitment is increasingly supported by digital tools and Applicant Tracking Systems (ATS).
      </p>
      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        During Ajirika's inception, several systemic problems were identified:
      </p>
      <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
        <li class="mb-4">CV data must be extracted manually</li>
        <li class="mb-4">Early applicants receive disproportionate attention</li>
        <li class="mb-4">First-level screening excludes candidates unfairly</li>
        <li class="mb-4">Recruiter fatigue leads to missed opportunities</li>
      </ul>
      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        These challenges highlighted a deeper truth: the problem is not talent scarcity, but data inefficiency.
      </p>
      
      <p class="text-gray-700 leading-relaxed mb-1 scroll-reveal">
        DewCIS Solutions Ltd has long believed that meaningful digital transformation goes beyond proprietary systems. The company has consistently adopted open standards, open collaboration, and community-driven development as a way to build sustainable, reusable solutions. Ajirika was therefore deliberately designed as an open-source initiative.
      </p>

      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        Rather than creating yet another closed recruitment platform, DewCIS envisioned Ajirika as a shared digital infrastructure a public good that HR professionals, developers, job seekers, and institutions could collectively shape. The core idea behind Ajirika is simple but transformative: move the CV from a document to structured data.
      </p>

      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        Instead of forcing HR professionals to manually interpret thousands of files, Ajirika aims to:
      </p>
      <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
        <li class="mb-4">Standardize how CV information is captured</li>
        <li class="mb-4">Convert CVs into machine-readable metadata</li>
        <li class="mb-4">Enable consistent filtering and comparison</li>
        <li class="mb-4">Support fairer and more transparent shortlisting</li>
      </ul>
      <p class="text-gray-700 leading-relaxed mb-1 scroll-reveal">
        By treating CVs as data, recruitment becomes more scalable, objective, and inclusive.
      </p>
    
      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        One important realization during Ajirika's inception was that the users already exist.
      </p>
      <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
        <li class="mb-4">Organizations are hiring</li>
        <li class="mb-4">HR professionals are overwhelmed</li>
        <li class="mb-4">Job seekers are actively applying</li>
      </ul>
      <p class="text-gray-700 leading-relaxed mb-1 scroll-reveal">
        What is missing is not demand, but the right solution. Ajirika positions itself as that missing layer connecting job seekers and employers through standardized, reusable professional data. It reduces friction for applicants while empowering HR teams with clarity, efficiency, and insight.
      </p>

      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        As an open-source project, Ajirika is not owned by a single organization or limited to a single use case. It is designed to evolve through collaboration with:
      </p>
      <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-2 max-w-4xl mx-auto scroll-reveal">
        <li class="mb-4">HR professionals defining real-world requirements</li>
        <li class="mb-4">Developers building parsing, analytics, and APIs</li>
        <li class="mb-4">Institutions promoting employability and skills visibility</li>
      </ul>
      <p class="text-gray-700 leading-relaxed mb-4 scroll-reveal">
        In this way, Ajirika reflects DewCIS's belief that the future of work infrastructure must be shared, transparent, and interoperable.
      </p>

  </main>

  <!-- Footer -->
  <jsp:include page="/includes/footer.jsp" />

  <script src="<%= request.getContextPath() %>/javascript/launchmeeting.js"></script>

  <!-- Lightbox Modal -->
  <div id="lightbox" class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center hidden z-50">
    <button id="lightboxLeft" class="absolute left-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900">&#10094;</button>
    <img id="lightboxImage" class="max-w-[90%] max-h-[90%] rounded-lg shadow-lg" />
    <button id="lightboxRight" class="absolute right-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900">&#10095;</button>
    <button onclick="closeLightbox()" class="absolute top-5 right-5 text-white text-3xl font-bold hover:text-gray-300">&times;</button>
  </div>
</body>
</html>
