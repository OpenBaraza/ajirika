async function processCV() {
    const fileInput = document.getElementById('cvFile');
    const file = fileInput.files[0];

    if (!file) {
        alert('Please select a CV file.');
        return;
    }

    const formData = new FormData();
    formData.append('cvFile', file);

    try {
        const response = await fetch('processCV', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.error) {
            alert('Error: ' + data.error);
            return;
        }

        // === Update UI ===
        // Personal Info
        const info = data.personal_info || {};
        document.getElementById('infoName').textContent = info.name || '—';
        document.getElementById('infoEmail').textContent = info.email || '—';
        document.getElementById('infoPhone').textContent = info.phone || '—';

        // Education
        const eduSection = document.getElementById('educationContent');
        eduSection.innerHTML = '';
        if (data.education && data.education.length > 0) {
            data.education.forEach(edu => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${edu.institution}</strong><br/>
                                 ${edu.certification} (${edu['edu-from']} – ${edu['edu-to']})`;
                eduSection.appendChild(div);
                eduSection.appendChild(document.createElement('hr'));
            });
        } else {
            eduSection.textContent = 'No education found.';
        }

        // Experience
        const expSection = document.getElementById('experienceContent');
        expSection.innerHTML = '';
        if (data.experience && data.experience.length > 0) {
            data.experience.forEach(exp => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${exp.role || exp.position}</strong> at <em>${exp.employer || exp.company}</em><br/>
                                 ${exp.dates || ''}`;
                expSection.appendChild(div);
                expSection.appendChild(document.createElement('hr'));
            });
        } else {
            expSection.textContent = 'No experience found.';
        }

        // Skills
        const skillsSection = document.getElementById('skillsContent');
        skillsSection.innerHTML = '';
        if (data.skills && data.skills.length > 0) {
            const list = document.createElement('ul');
            data.skills.forEach(skill => {
                const li = document.createElement('li');
                li.textContent = skill;
                list.appendChild(li);
            });
            skillsSection.appendChild(list);
        } else {
            skillsSection.textContent = 'No skills found.';
        }

        // Referees
        const refsSection = document.getElementById('refereesContent');
        refsSection.innerHTML = '';
        if (data.references && data.references.length > 0) {
            data.references.forEach(ref => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${ref.name || ref['referee-name']}</strong><br/>
                                 ${ref.role || ref['referee-position']}<br/>
                                 ${ref.organization || ref['referee-company']}<br/>
                                 ${ref.contact || ref['referee-email'] || ref.phone || ''}`;
                refsSection.appendChild(div);
                refsSection.appendChild(document.createElement('hr'));
            });
        } else {
            refsSection.textContent = 'No referees found.';
        }

    } catch (err) {
        console.error(err);
        alert('Failed to process CV: ' + err.message);
    }
}