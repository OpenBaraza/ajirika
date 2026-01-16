async function processCV() {
    const fileInput = document.getElementById('cvFile');
    const file = fileInput.files[0];

    if (!file) {
        alert('Please select a CV file.');
        return;
    }

    // Clear previous logs
    document.getElementById('logOutput').innerHTML = 'Processing started...\n';

    const formData = new FormData();
    formData.append('cvFile', file);

    try {
        const response = await fetch('processCV', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        // Display logs in the logs tab
        if (data.logs) {
            addLog(data.logs);
        }

        if (data.error) {
            addLog('ERROR: ' + data.error);
            alert('Error: ' + data.error);
            return;
        }

        // Switch to results view (optional)
        // openTab('cvForm');

        // Update UI with parsed data
        const result = data.data;
        
        // Personal Info
        const info = result.personal_info || {};
        document.getElementById('infoName').textContent = info.name || '—';
        document.getElementById('infoEmail').textContent = info.email || '—';
        document.getElementById('infoPhone').textContent = info.phone || '—';

        // Education
        const eduSection = document.getElementById('educationContent');
        eduSection.innerHTML = '';
        if (result.education && result.education.length > 0) {
            result.education.forEach(edu => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${edu.institution || edu.school || '—'}</strong><br/>
                                 ${edu.certification || edu.degree || '—'} (${edu['edu-from'] || '—'} – ${edu['edu-to'] || '—'})`;
                eduSection.appendChild(div);
                eduSection.appendChild(document.createElement('hr'));
            });
        } else {
            eduSection.textContent = 'No education found.';
        }

        // Experience
        const expSection = document.getElementById('experienceContent');
        expSection.innerHTML = '';
        if (result.experience && result.experience.length > 0) {
            result.experience.forEach(exp => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${exp.role || exp.position || '—'}</strong> at <em>${exp.employer || exp.company || '—'}</em><br/>
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
        if (result.skills && result.skills.length > 0) {
            const list = document.createElement('ul');
            result.skills.forEach(skill => {
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
        if (result.references && result.references.length > 0) {
            result.references.forEach(ref => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${ref.name || ref['referee-name'] || '—'}</strong><br/>
                                 ${ref.role || ref['referee-position'] || '—'}<br/>
                                 ${ref.organization || ref['referee-company'] || '—'}<br/>
                                 ${ref.contact || ref['referee-email'] || ref.phone || ''}`;
                refsSection.appendChild(div);
                refsSection.appendChild(document.createElement('hr'));
            });
        } else {
            refsSection.textContent = 'No referees found.';
        }

    } catch (err) {
        console.error(err);
        addLog('CLIENT ERROR: ' + err.message);
        alert('Failed to process CV: ' + err.message);
    }
}

// Function to add log messages (accessible globally)
function addLog(message) {
    const logOutput = document.getElementById('logOutput');
    logOutput.innerHTML += message + '\n';
    logOutput.scrollTop = logOutput.scrollHeight;
}