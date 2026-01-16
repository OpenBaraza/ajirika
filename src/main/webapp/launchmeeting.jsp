<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | Launch Meeting</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-gray-100 font-[Space_Grotesk]">
  
  <!-- Header -->
  <jsp:include page="/includes/header.jsp" />

  <!-- Main Content -->
  <main class="max-w-5xl mx-auto px-6 py-16 mt-7">
    
    <!-- Title -->
    <h1 class="text-3xl font-bold text-gray-900 mb-2">
  Ajirika Launch Meeting
</h1>

<p class="text-gray-600 mb-6">
  Parklands Sports Club, Nairobi.
</p>

<p class="text-gray-800 leading-relaxed mb-8">
  On the 12th of December 2025, we gathered HR professionals and software developers at
  Parklands Sports Club, Nairobi, for a conversation that's long overdue -
  fixing Kenya's broken job application process.
</p>

<h2 class="text-2xl font-semibold text-gray-900 mb-3">
  The Challenge We Discussed
</h2>

<p class="text-gray-700 leading-relaxed mb-8">
  The recruitment landscape is shifting. Paper CVs and email applications are
  giving way to online portals and Applicant Tracking Systems (ATS). While this
  helps employers manage volume, it has created a new burden for job seekers -
  filling out the same details, over and over, on every single portal.
</p>

<h2 class="text-2xl font-semibold text-gray-900 mb-4">
  What We Heard
</h2>

<h3 class="text-lg font-semibold text-gray-900 mb-2">
  From HR Professionals
</h3>

<p class="text-gray-700 leading-relaxed mb-6">
  Manual screening is exhausting. Portals help, but they've introduced a new
  headache - AI-generated CVs that are polished but lack authenticity. The big
  question remains: how do you find the real candidate behind the keywords?
</p>

<h3 class="text-lg font-semibold text-gray-900 mb-2">
  From Developers
</h3>

<p class="text-gray-700 leading-relaxed mb-8">
  To build smarter, fairer AI-powered hiring tools, developers need clean,
  structured personal data. The current inconsistency across CV formats makes
  this nearly impossible.
</p>

<h2 class="text-2xl font-semibold text-gray-900 mb-3">
  The Ajirika Solution
</h2>

<p class="text-gray-800 leading-relaxed">
  A universal, standardised CV format that benefits everyone - job seekers
  apply once, recruiters receive consistent data, and developers can build
  tools that actually work.
</p>

  </main>

  <!-- Footer -->
  <jsp:include page="/includes/footer.jsp" />

</body>
</html>