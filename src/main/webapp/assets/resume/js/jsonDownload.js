document.getElementById('downloadJsonBtn').addEventListener('click', function () {
  const data = {
    othername: document.querySelector('[data-display="othername"]').textContent.trim(),
    surname: document.querySelector('[data-display="surname"]').textContent.trim(),
    email: document.querySelector('[data-display="email"]').textContent.trim(),
    phone: document.querySelector('[data-display="phone"]').textContent.trim(),
    dob: document.querySelector('[data-display="dob"]').textContent.trim(),
    gender: document.querySelector('[data-display="gender"]').textContent.trim(),
    marital_status: document.querySelector('[data-display="marital_status"]').textContent.trim(),
    id_number: document.querySelector('[data-display="id_number"]').textContent.trim(),
    nationality: document.querySelector('[data-display="nationality"]').textContent.trim(),
    language: document.querySelector('[data-display="language"]').textContent.trim(),
    previous_salary: document.querySelector('[data-display="previous_salary"]').textContent.trim(),
    expected_salary: document.querySelector('[data-display="expected_salary"]').textContent.trim(),
    disability: document.querySelector('[data-display="disability"]').textContent.trim(),
    address: document.getElementById('resumeAddress').innerHTML.trim(),
    education: document.getElementById('resumeEducation').innerHTML.trim(),
    employment: document.getElementById('resumeEmployment').innerHTML.trim(),
    projects: document.getElementById('resumeProjects').innerHTML.trim(),
    skills: document.getElementById('resumeSkills').innerHTML.trim(),
    referees: document.getElementById('resumeReferees').innerHTML.trim()
  };

  const jsonStr = JSON.stringify(data, null, 2);

  const blob = new Blob([jsonStr], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'resume.json';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
});