let currentSegments = [];
let currentLabels = [];
let selection = { seg: null, anchor: null, focus: null };
let hasExportedThisLoad = false;

// Lowercase = B (begin), Uppercase = I (continue), x = clear
const LABEL_KEYS = {
    'p': 'B-PERSON',   'P': 'I-PERSON',
    'j': 'B-JOB_TITLE','J': 'I-JOB_TITLE',
    'd': 'B-DEGREE',   'D': 'I-DEGREE',
    'g': 'B-ORGANIZATION','G': 'I-ORGANIZATION',
    'x': 'O'
};
const ENTITY_COLORS = {
    PERSON: '#bfdbfe', JOB_TITLE: '#bbf7d0', DEGREE: '#ddd6fe', ORGANIZATION: '#fed7aa'
};
const TIGHT_BEFORE = /^[.,;:!?)\]}%"''"-]$/;
const TIGHT_AFTER  = /^[(\[{"']$/;

function getColor(label) {
    if (!label || label === 'O') return 'transparent';
    const entity = label.replace(/^[BI]-/, '');
    return ENTITY_COLORS[entity] || 'transparent';
}

async function loadCVForAnnotation() {
    const fileInput = document.getElementById('annotateFile');
    const file = fileInput.files[0];
    if (!file) { alert('Please select a CV file.'); return; }

    const loadBtn   = document.getElementById('loadBtn');
    const exportBtn = document.getElementById('exportBtn');
    loadBtn.disabled   = true;
    exportBtn.disabled = true;

    const formData = new FormData();
    formData.append('cvFile', file);
    const statusEl = document.getElementById('annotateStatus');
    statusEl.textContent = 'Tokenizing...';

    try {
        const response = await fetch('annotateCV/tokenize', { method: 'POST', body: formData });
        const data = await response.json();

        if (data.error) { statusEl.textContent = 'Error: ' + data.error; return; }

        currentSegments = data.data.segments;
        currentLabels   = currentSegments.map(seg => seg.tokens.map(() => 'O'));
        selection = { seg: null, anchor: null, focus: null };
        hasExportedThisLoad = false;
        renderSegments();
        exportBtn.disabled = currentSegments.length === 0;
        statusEl.textContent = 'Loaded ' + currentSegments.length + ' lines.';
    } catch (err) {
        statusEl.textContent = 'Error: ' + err.message;
        exportBtn.disabled = currentSegments.length === 0;
    } finally {
        loadBtn.disabled = false;
    }
}

function renderSegments() {
    const container = document.getElementById('annotateContainer');
    container.innerHTML = '';

    currentSegments.forEach((seg, segIdx) => {
        const row = document.createElement('div');
        row.className = 'cv-line';

        seg.tokens.forEach((tok, tokIdx) => {
            const prevTok    = tokIdx > 0 ? seg.tokens[tokIdx - 1] : null;
            const needsSpace = tokIdx > 0 && !TIGHT_BEFORE.test(tok) && !(prevTok && TIGHT_AFTER.test(prevTok));
            if (needsSpace) row.appendChild(document.createTextNode(' '));

            const chip = document.createElement('span');
            chip.className = 'tok';
            chip.textContent = tok;
            const label = currentLabels[segIdx][tokIdx];
            chip.style.background = isSelected(segIdx, tokIdx) ? '#fde68a' : getColor(label);
            chip.style.outline    = label && label !== 'O' ? '1px solid rgba(0,0,0,.15)' : '';
            chip.addEventListener('click', (e) => handleChipClick(segIdx, tokIdx, e.shiftKey, e.pageX, e.pageY));
            row.appendChild(chip);
        });

        container.appendChild(row);
    });
}

function isSelected(segIdx, tokIdx) {
    if (selection.seg !== segIdx || selection.anchor === null) return false;
    const lo = Math.min(selection.anchor, selection.focus);
    const hi = Math.max(selection.anchor, selection.focus);
    return tokIdx >= lo && tokIdx <= hi;
}

function handleChipClick(segIdx, tokIdx, shiftKey, x, y) {
    if (shiftKey && selection.seg === segIdx && selection.anchor !== null) {
        selection.focus = tokIdx;
    } else {
        selection = { seg: segIdx, anchor: tokIdx, focus: tokIdx };
    }
    renderSegments();
    showLabelMenu(x, y);
}

function showLabelMenu(x, y) {
    const menu = document.getElementById('labelMenu');
    menu.style.left    = x + 'px';
    menu.style.top     = y + 'px';
    menu.style.display = 'block';
}

function hideLabelMenu() {
    document.getElementById('labelMenu').style.display = 'none';
}

function applyLabel(label) {
    if (selection.seg === null) return;
    const lo = Math.min(selection.anchor, selection.focus);
    const hi = Math.max(selection.anchor, selection.focus);
    for (let i = lo; i <= hi; i++) currentLabels[selection.seg][i] = label;
    selection = { seg: null, anchor: null, focus: null };
    hideLabelMenu();
    renderSegments();
}

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('#labelMenu button').forEach(btn => {
        btn.addEventListener('click', () => applyLabel(btn.dataset.label));
    });
});

document.addEventListener('click', (e) => {
    if (!e.target.closest('#labelMenu') && !e.target.classList.contains('tok')) hideLabelMenu();
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        selection = { seg: null, anchor: null, focus: null };
        hideLabelMenu();
        renderSegments();
        return;
    }
    const key = e.shiftKey ? e.key.toUpperCase() : e.key.toLowerCase();
    if (!(key in LABEL_KEYS)) return;
    if (selection.seg === null) return;
    e.preventDefault();
    applyLabel(LABEL_KEYS[key]);
});

async function exportAnnotations() {
    if (currentSegments.length === 0) {
        document.getElementById('annotateStatus').textContent = 'Load a CV first.';
        return;
    }

    const labeledSegments = currentSegments
        .map((seg, segIdx) => ({ tokens: seg.tokens, labels: currentLabels[segIdx] }))
        .filter(seg => seg.labels.some(l => l !== 'O'));

    if (labeledSegments.length === 0) {
        document.getElementById('annotateStatus').textContent = 'No labeled tokens. Label at least one token first.';
        return;
    }

    const totalLabeled = labeledSegments.reduce((n, s) => n + s.labels.filter(l => l !== 'O').length, 0);
    let msg = 'Export ' + labeledSegments.length + ' labeled lines / ' + totalLabeled + ' entity tokens?';
    if (hasExportedThisLoad) msg = 'Already exported once — will ADD A DUPLICATE. ' + msg;
    if (!confirm(msg)) return;

    const exportBtn  = document.getElementById('exportBtn');
    exportBtn.disabled = true;
    const statusEl   = document.getElementById('annotateStatus');
    statusEl.textContent = 'Exporting...';

    try {
        const response = await fetch('annotateCV/export', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ segments: labeledSegments })
        });
        const data = await response.json();

        if (data.error) {
            statusEl.textContent = 'Error: ' + data.error;
        } else {
            hasExportedThisLoad = true;
            statusEl.textContent = 'Appended ' + data.data.appendedTokens + ' tokens ('
                + data.data.appendedSegments + ' segments). Training file now has '
                + data.data.totalFileTokens + ' tokens.';
        }
    } catch (err) {
        statusEl.textContent = 'Error: ' + err.message;
    } finally {
        exportBtn.disabled = false;
    }
}