function escapeHtml(value) {
    return String(value == null ? '' : value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

async function processCV() {
    const fileInput = document.getElementById('cvFile');
    const file = fileInput.files[0];

    if (!file) {
        alert('Please select a CV file.');
        return;
    }

    document.getElementById('logOutput').innerHTML = 'Processing started...\n';

    const formData = new FormData();
    formData.append('cvFile', file);
    const saveCheckbox = document.getElementById('saveToProfile');
    if (saveCheckbox && saveCheckbox.checked) {
        formData.append('save', 'true');
    }

    try {
        const response = await fetch('processCV', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.logs) addLog(data.logs);

        if (data.error) {
            addLog('ERROR: ' + data.error);
            alert('Error: ' + data.error);
            return;
        }

        const result = data.data;

        // Notify if profile was updated from this CV
        if (result.cv_imported) {
            addLog('\n✓ Profile fields saved to your account from this CV.');
        }

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
                const from = edu['edu-from'];
                const to = edu['edu-to'] || '—';
                const dateRange = from ? `${from} – ${to}` : to;
                div.innerHTML = `<strong>${escapeHtml(edu.institution || edu.school || '—')}</strong><br/>
                                 ${escapeHtml(edu.certification || edu.degree || '—')} (${escapeHtml(dateRange)})`;
                eduSection.appendChild(div);
                eduSection.appendChild(document.createElement('hr'));
            });
        } else {
            eduSection.textContent = 'No education found.';
        }

        // Experience — Fix: render description when role/company absent
        const expSection = document.getElementById('experienceContent');
        expSection.innerHTML = '';
        if (result.experience && result.experience.length > 0) {
            result.experience.forEach(exp => {
                const div = document.createElement('div');
                const role = exp.role || exp.position || '';
                const employer = exp.employer || exp.company || '';
                const dates = exp.dates || '';
                const description = exp.description || '';

                if (role && employer) {
                    div.innerHTML = `<strong>${escapeHtml(role)}</strong> at <em>${escapeHtml(employer)}</em><br/>${escapeHtml(dates)}`;
                } else if (role) {
                    const colonIdx = description.indexOf(':');
                    const descBody = colonIdx > 0 ? description.substring(colonIdx + 1).trim() : '';
                    div.innerHTML = descBody
                        ? `<strong>${escapeHtml(role)}</strong><br/>${escapeHtml(descBody)}`
                        : `<strong>${escapeHtml(role)}</strong>`;
                } else {
                    div.innerHTML = escapeHtml(description);
                }

                expSection.appendChild(div);
                expSection.appendChild(document.createElement('hr'));
            });
        } else {
            expSection.textContent = 'No experience found.';
        }

        // Skills — Fix: handle both string and {category, skill} object formats
        const skillsSection = document.getElementById('skillsContent');
        skillsSection.innerHTML = '';
        if (result.skills && result.skills.length > 0) {
            // Group by category if objects, else flat list
            const hasCategories = result.skills.some(s => typeof s === 'object' && s.category);

            if (hasCategories) {
                const groups = {};
                result.skills.forEach(s => {
                    if (typeof s === 'object' && s.category) {
                        // Strip non-printable/non-ASCII garbage from category name
                        const cat = s.category.replace(/[^\x20-\x7E]/g, '').trim() || 'Other';
                        if (!groups[cat]) groups[cat] = [];
                        groups[cat].push(s.skill);
                    } else if (typeof s === 'string') {
                        if (!groups['Other']) groups['Other'] = [];
                        groups['Other'].push(s);
                    }
                });

                Object.entries(groups).forEach(([category, skills]) => {
                    const catDiv = document.createElement('div');
                    catDiv.style.marginBottom = '8px';
                    catDiv.innerHTML = `<strong>${escapeHtml(category)}:</strong> ${escapeHtml(skills.join(', '))}`;
                    skillsSection.appendChild(catDiv);
                });
            } else {
                const list = document.createElement('ul');
                result.skills.forEach(skill => {
                    const li = document.createElement('li');
                    li.textContent = typeof skill === 'string' ? skill : (skill.skill || JSON.stringify(skill));
                    list.appendChild(li);
                });
                skillsSection.appendChild(list);
            }
        } else {
            skillsSection.textContent = 'No skills found.';
        }

        // Referees
        const refsSection = document.getElementById('refereesContent');
        refsSection.innerHTML = '';
        if (result.references && result.references.length > 0) {
            result.references.forEach(ref => {
                const div = document.createElement('div');
                div.innerHTML = `<strong>${escapeHtml(ref.name || ref['referee-name'] || '—')}</strong><br/>
                                 ${escapeHtml(ref.role || ref['referee-position'] || '—')}<br/>
                                 ${escapeHtml(ref.organization || ref['referee-company'] || '—')}<br/>
                                 ${escapeHtml(ref.contact || ref['referee-email'] || ref.phone || '')}`;
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

function addLog(message) {
    const logOutput = document.getElementById('logOutput');
    logOutput.innerHTML += escapeHtml(message) + '\n';
    logOutput.scrollTop = logOutput.scrollHeight;
}