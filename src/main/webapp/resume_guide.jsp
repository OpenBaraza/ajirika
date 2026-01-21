<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | JSON CV Guide</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-gray-100">
  <!-- Header -->
  <jsp:include page="/includes/header.jsp" />

  <div class="max-w-2xl md:max-w-3xl lg:max-w-5xl xl:max-w-6xl mx-auto bg-white shadow-lg rounded-lg p-8 mb-10 mt-24">
    <h1 class="text-3xl md:text-4xl xl:text-5xl font-bold mb-6 leading-tight text-center"><span class="gradient-text-blue">Ajirika</span> Resume in JSON</h1>
    <p class="text-gray-700 mb-4 text-center">
      This page shows how a resume (CV) can be written in a special computer language called <strong>JSON</strong>.
    </p>
    <p class="text-gray-700 mb-8 text-center">
      Think of this like filling in a form, but instead of boxes, everything is written in text that computers can read.
      The left side explains each part in very simple words. The right side shows what it looks like in JSON.
    </p>

    <!-- Two Column Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

      <!-- LEFT COLUMN: SIMPLE EXPLANATIONS -->
      <div class="space-y-6 text-gray-700">

        <section>
          <h2 class="text-xl font-semibold mb-2">Personal Information</h2>
          <p>
            This part tells who you are and how someone can contact you.
          </p>
          <p class="mt-1">
            It includes:
            <ul class="list-disc list-inside">
              <li>Your name</li>
              <li>Your email address</li>
              <li>Your phone number</li>
            </ul>
          </p>
          <p class="mt-1">
            Just like writing your name on the front of your school book, this helps people know the resume belongs to you.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Education</h2>
          <p>
            This part shows where you went to school or college and what you studied.
          </p>
          <p class="mt-1">
            It answers questions like:
            <ul class="list-disc list-inside">
              <li>Which school did you attend?</li>
              <li>What did you study?</li>
              <li>When did you start and finish?</li>
            </ul>
          </p>
          <p class="mt-1">
            Think of it like showing your report card to explain what you have learned.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Work Experience</h2>
          <p>
            This part shows the jobs you have done before.
          </p>
          <p class="mt-1">
            It tells:
            <ul class="list-disc list-inside">
              <li>Where you worked</li>
              <li>What your job was</li>
              <li>How long you worked there</li>
            </ul>
          </p>
          <p class="mt-1">
            This helps employers see what kind of work you already know how to do.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Skills</h2>
          <p>
            Skills are things you are good at.
          </p>
          <p class="mt-1">
            For example:
            <ul class="list-disc list-inside">
              <li>Using a computer</li>
              <li>Building websites</li>
              <li>Writing, teaching, or fixing things</li>
            </ul>
          </p>
          <p class="mt-1">
            This is like telling someone what games you are really good at playing.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Certificates</h2>
          <p>
            Certificates are proof that you learned something and passed a test.
          </p>
          <p class="mt-1">
            They are like medals or trophies that show you did a good job in a course or training.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Languages</h2>
          <p>
            This part shows what languages you can speak.
          </p>
          <p class="mt-1">
            For example: English, Kiswahili, French, or any other language.
          </p>
          <p class="mt-1">
            It also shows how well you can speak each language.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">Projects</h2>
          <p>
            Projects are things you have built or worked on.
          </p>
          <p class="mt-1">
            For example:
            <ul class="list-disc list-inside">
              <li>A school project</li>
              <li>A website you created</li>
              <li>An app you helped build</li>
            </ul>
          </p>
          <p class="mt-1">
            This shows what you can do, not just what you studied.
          </p>
        </section>

        <section>
          <h2 class="text-xl font-semibold mb-2">References</h2>
          <p>
            References are people who can say good things about you.
          </p>
          <p class="mt-1">
            For example, a teacher, a boss, or a manager who knows you well.
          </p>
          <p class="mt-1">
            It is like having someone tell others, “Yes, this person is good at their work.”
          </p>
        </section>

      </div>

      <!-- RIGHT COLUMN: STATIC JSON -->
      <div>
        <h2 class="text-lg md:text-xl font-semibold mb-2">Example Resume Written in JSON</h2>
        <p class="text-gray-600 mb-2 text-sm sm:text-base">
          This is the same information shown on the left, but written in a way that computers understand.
        </p>
        <pre class="bg-gray-100 py-4 rounded overflow-auto text-sm leading-relaxed">
  {
    "profile": {
      "name": "John Doe",
      "email": "john@gmail.com",
      "phone": "(912) 555-4321"
    },
    "education": [
      {
        "institution": "University of Example",
        "education level": "Tertiary",
        "area of study": "Software Development",
        "score": "First Class Honors",
        "startDate": "2011-01-01",
        "endDate": "2013-01-01"
      }
    ],
    "work": [
      {
        "name": "Example Company",
        "position": "Software Engineer",
        "startDate": "2013-01-01",
        "endDate": "2014-01-01"
      }
    ],
    "skills": [
      {
        "name": "Web Development",
        "level": "Advanced",
        "keywords": ["HTML", "CSS", "JavaScript"]
      }
    ],
    "certificates": [
      {
        "name": "Web Development Certificate",
        "date": "2021-11-07",
        "issuer": "Example Institute"
      }
    ],
    "languages": [
      {
        "language": "English",
        "fluency": "Native speaker"
      }
    ],
    "projects": [
      {
        "name": "Ajirika Platform",
        "startDate": "2019-01-01",
        "endDate": "2021-01-01",
        "description": "A platform that helps people share their CVs in a simple digital way.",
        "highlights": ["Helps computers read resumes easily"],
        "url": "https://project.com/"
      }
    ],
    "references": [
      {
        "name": "Jane Doe",
        "reference": "Former manager who knows my work very well."
      }
    ]
  }
        </pre>
      </div>
    </div>
  </div>
  <jsp:include page="/includes/footer.jsp" />
</body>
</html>
