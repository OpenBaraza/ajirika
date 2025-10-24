<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <% boolean showToast="true" .equals(request.getParameter("success")); %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Project Ajirika - Data CV Standard</title>
      <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet" />
    </head>

    <body class="bg-gray-50 text-gray-800">
      <!-- Toast Notification -->
    <div id="toast" class="fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg transition-opacity duration-500
    <%= showToast ? "opacity-100" : "opacity-0" %>">
      Form submitted successfully!
    </div>

      <!-- Hero Section -->
      <section class="text-center max-w-4xl mx-auto mt-12 mb-12 p-6">
        <h1 class="text-4xl font-bold mb-4">
          Project Ajirika - Building a Standard for the Data CV
        </h1>
        <p class="text-lg text-gray-600 mb-6">
          We are rethinking how job seekers and employers connect. Instead of filling the same details over and over
          again,
          imagine a world where your CV is a structured data file you can carry anywhere - readable by any job portal.
        </p>
        <button class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-6 rounded-lg">
          Get Involved
        </button>
      </section>

      <!-- Problem Statements -->
      <section class="grid md:grid-cols-2 gap-6 max-w-5xl mx-auto mb-16 p-6">
        <div class="bg-white rounded-xl shadow-md p-6">
          <h3 class="text-xl font-semibold mb-2 text-blue-600">
            Problem 1: Repetitive Resume Entry
          </h3>
          <p>
            Applicants fill the same data for every job portal. We want to create a
            <strong>standard, readable JSON CV file</strong> that applicants can reuse everywhere.
          </p>
        </div>

        <div class="bg-white rounded-xl shadow-md p-6">
          <h3 class="text-xl font-semibold mb-2 text-blue-600">
            Problem 2: No Standardized CV Platform
          </h3>
          <p>
            We are building a <strong>unified platform</strong> for applicants to update their CVs, export in a
            <strong>standard data format</strong>, and easily share across job portals.
          </p>
        </div>

        <div class="bg-white rounded-xl shadow-md p-6">
          <h3 class="text-xl font-semibold mb-2 text-blue-600">
            Problem 3: HR Standardization in Kenya
          </h3>
          <p>
            We aim to <strong>collaborate with the HR community in Kenya</strong> to define and standardize key CV terms
            -
            ensuring interoperability and local relevance.
          </p>
        </div>

        <div class="bg-white rounded-xl shadow-md p-6">
          <h3 class="text-xl font-semibold mb-2 text-blue-600">
            Problem 4: Need for an Open Source Ecosystem
          </h3>
          <p>
            Project Ajirika will be <strong>open source</strong>, inviting developers, HR professionals, and designers
            to
            continuously evolve the CV standard together.
          </p>
        </div>
      </section>

      <!-- History Section -->
      <section class="max-w-5xl mx-auto mb-16 p-6">
        <h2 class="text-2xl font-semibold mb-4 text-center">Project History</h2>
        <p class="text-gray-600 mb-6 text-center">
          A chronological overview of Project Ajirika's journey and milestones.
        </p>

        <!-- Timeline Graphic -->
        <div class="relative border-l-4 border-blue-600 ml-4">
          <div class="mb-10 ml-6">
            <div class="absolute w-4 h-4 bg-blue-600 rounded-full -left-2 border-2 border-white"></div>
            <h3 class="text-lg font-semibold">October 2025</h3>
            <p class="text-gray-700">Initial concept meeting held to explore the idea of a standardized data CV format.
            </p>
          </div>
          <div class="mb-10 ml-6">
            <div class="absolute w-4 h-4 bg-blue-600 rounded-full -left-2 border-2 border-white"></div>
            <h3 class="text-lg font-semibold">October 2025</h3>
            <p class="text-gray-700">Brainstorming and drafting of the problem statement and project goals.</p>
          </div>
          <div class="ml-6">
            <div class="absolute w-4 h-4 bg-blue-600 rounded-full -left-2 border-2 border-white"></div>
            <h3 class="text-lg font-semibold">Ongoing</h3>
            <p class="text-gray-700">Research phase to understand global standards and similar projects like JSON Resume
              and
              HR Open Standards.</p>
          </div>
        </div>
      </section>

      <!-- Action Items Section (Version B: Icons + Illustrations) -->
      <section class="max-w-5xl mx-auto mb-16 p-6 relative">
        <h2 class="text-2xl font-semibold mb-4 text-center">Current Action Items</h2>
        <p class="text-gray-600 mb-6 text-center">
          The steps currently underway to drive Project Ajirika forward.
        </p>
        <div class="grid md:grid-cols-2 gap-6 relative z-10">
          <div
            class="bg-white rounded-xl shadow-lg p-6 text-center relative overflow-hidden border-t-4 border-blue-500">
            <svg class="absolute top-0 left-0 w-full h-full opacity-10 text-blue-300" fill="currentColor"
              viewBox="0 0 200 200">
              <circle cx="100" cy="100" r="100" />
            </svg>
            <i data-lucide="search" class="w-10 h-10 text-blue-500 mx-auto mb-3 relative z-10"></i>
            <h3 class="font-semibold text-lg mb-2 relative z-10">Research CV Standards</h3>
            <p class="relative z-10">Conduct detailed research on Kenyan CV data formats and standards.</p>
          </div>

          <div
            class="bg-white rounded-xl shadow-lg p-6 text-center relative overflow-hidden border-t-4 border-green-500">
            <svg class="absolute top-0 right-0 w-full h-full opacity-10 text-green-300" fill="currentColor"
              viewBox="0 0 200 200">
              <rect width="200" height="200" rx="40" />
            </svg>
            <i data-lucide="users" class="w-10 h-10 text-green-500 mx-auto mb-3 relative z-10"></i>
            <h3 class="font-semibold text-lg mb-2 relative z-10">HR Community Engagement</h3>
            <p class="relative z-10">Engage the HR community in Kenya to discuss CV standardization and metadata.</p>
          </div>

          <div
            class="bg-white rounded-xl shadow-lg p-6 text-center relative overflow-hidden border-t-4 border-yellow-500">
            <svg class="absolute bottom-0 left-0 w-full h-full opacity-10 text-yellow-300" fill="currentColor"
              viewBox="0 0 200 200">
              <polygon points="0,200 200,200 100,0" />
            </svg>
            <i data-lucide="file-text" class="w-10 h-10 text-yellow-500 mx-auto mb-3 relative z-10"></i>
            <h3 class="font-semibold text-lg mb-2 relative z-10">Document Challenges</h3>
            <p class="relative z-10">Document challenges faced by Kenyan job seekers and HR professionals.</p>
          </div>

          <div
            class="bg-white rounded-xl shadow-lg p-6 text-center relative overflow-hidden border-t-4 border-purple-500">
            <svg class="absolute bottom-0 right-0 w-full h-full opacity-10 text-purple-300" fill="currentColor"
              viewBox="0 0 200 200">
              <circle cx="150" cy="50" r="80" />
            </svg>
            <i data-lucide="code" class="w-10 h-10 text-purple-500 mx-auto mb-3 relative z-10"></i>
            <h3 class="font-semibold text-lg mb-2 relative z-10">Open Source Setup</h3>
            <p class="relative z-10">Lay groundwork for the GitHub repository to collaborate on schema design.</p>
          </div>
        </div>
      </section>

      <!-- Next Steps Section -->
      <section class="max-w-5xl mx-auto mb-16 p-6">
        <h2 class="text-2xl font-semibold mb-4 text-center">Next Steps</h2>
        <p class="text-gray-600 mb-6 text-center">
          Our roadmap for the next phase of Project Ajirika's evolution.
        </p>

        <!-- Graphic Representation -->
        <div class="grid md:grid-cols-3 gap-6">
          <div class="bg-white rounded-xl shadow-md p-6 text-center border-t-4 border-green-500">
            <h3 class="text-lg font-semibold mb-2">Survey Adoption</h3>
            <p class="text-gray-700">
              Assess how existing standards like JSON Resume and HR Open Standards are used in Kenya - and whether local
              HR
              systems and job portals support data import/export.
            </p>
          </div>

          <div class="bg-white rounded-xl shadow-md p-6 text-center border-t-4 border-blue-500">
            <h3 class="text-lg font-semibold mb-2">Define Core Schema</h3>
            <p class="text-gray-700">
              Define the <strong>minimum viable schema</strong> for CV data - distinguishing between core, optional, and
              extended fields to ensure broad compatibility.
            </p>
          </div>

          <div class="bg-white rounded-xl shadow-md p-6 text-center border-t-4 border-yellow-500">
            <h3 class="text-lg font-semibold mb-2">Local Customization</h3>
            <p class="text-gray-700">
              Incorporate <strong>Kenyan education and certification standards</strong> to make the schema locally
              relevant
              while maintaining global interoperability.
            </p>
          </div>
        </div>
      </section>

      <!-- Call to Action -->
      <section class="text-center max-w-3xl mx-auto mb-16 p-6">
        <h2 class="text-2xl font-semibold mb-4">Join the Conversation</h2>
        <p class="text-gray-600 mb-6">
          We are looking for HR professionals, developers, and community builders who believe in creating a more
          efficient
          and transparent hiring ecosystem. Let's shape the future of recruitment - together.
        </p>
        <div class="flex justify-center gap-4">
          <button class="bg-green-600 hover:bg-green-700 text-white py-2 px-6 rounded-lg">
            Join the HR Community
          </button>
          <button class="bg-gray-800 hover:bg-gray-900 text-white py-2 px-6 rounded-lg">
            <a href="https://github.com/OpenBaraza/ajirika" target="_blank">Contribute on GitHub</a>
          </button>
        </div>
      </section>

      <!-- Footer -->
      <footer class="text-center text-gray-500 text-sm py-6 border-t">
        ©
        <script>document.write(new Date().getFullYear());</script> Project Ajirika - Open Source CV Standard Initiative
      </footer>

      <script src="https://unpkg.com/lucide@latest"></script>
      <script>lucide.createIcons();</script>
      <!-- Modal -->
      <div id="hrModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
        <div class="bg-white rounded-xl shadow-lg w-11/12 max-w-md p-6 relative">
          <button id="closeModal"
            class="absolute top-3 right-3 text-gray-500 hover:text-gray-800 text-2xl font-bold">&times;</button>
          <h2 class="text-xl font-semibold mb-4 text-center">Join the HR Community</h2>
          <form action="submitForm" method="post" class="space-y-4">
            <div>
              <label class="block mb-1 font-medium">Role</label>
              <select name="role" class="w-full border border-gray-300 rounded-lg p-2" required>
                <option value="developer">Developer</option>
                <option value="hr">HR Personnel</option>
              </select>
            </div>
            <div>
              <label class="block mb-1 font-medium">Full Name</label>
              <input type="text" name="name" class="w-full border border-gray-300 rounded-lg p-2"
                placeholder="Your Name" required>
            </div>
            <div>
              <label class="block mb-1 font-medium">Email Address</label>
              <input type="email" name="email" class="w-full border border-gray-300 rounded-lg p-2"
                placeholder="you@example.com" required>
            </div>
            <div>
              <label class="block mb-1 font-medium">Comments</label>
              <textarea name="comment" class="w-full border border-gray-300 rounded-lg p-2" rows="4"
                placeholder="Your message"></textarea>
            </div>
            <button type="submit"
              class="w-full bg-green-600 hover:bg-green-700 text-white py-2 rounded-lg">Submit</button>
          </form>
        </div>
      </div>
      <script>
        const modal = document.getElementById('hrModal');
        const openBtn = document.querySelector('button.bg-green-600'); // your Join button
        const closeBtn = document.getElementById('closeModal');

        openBtn.addEventListener('click', () => {
          modal.classList.remove('hidden');
        });

        closeBtn.addEventListener('click', () => {
          modal.classList.add('hidden');
        });

        // Close modal if clicking outside the box
        window.addEventListener('click', (e) => {
          if (e.target === modal) {
            modal.classList.add('hidden');
          }
        });
        const toast = document.getElementById('toast');
        if (toast.classList.contains('opacity-100')) {
         setTimeout(() => {
           toast.classList.remove('opacity-100');
           toast.classList.add('opacity-0');
        }, 3000);
  }
      </script>

    </body>

    </html>