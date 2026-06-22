<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CV Annotation</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="<%=request.getContextPath()%>/javascript/annotateUpload.js?6" defer></script>
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        main { flex: 1; }

        /* Two-column workspace */
        .annotate-workspace { display: flex; gap: 16px; align-items: flex-start; }
        .annotate-left      { flex: 1; min-width: 0; }
        .annotate-sidebar   {
            width: 220px; flex-shrink: 0;
            border-left: 1px solid #e5e7eb;
            padding-left: 16px;
        }

        /* Annotation area */
        .cv-line   { padding: 3px 0; line-height: 2; font-size: 15px; }
        .tok       { cursor: pointer; padding: 1px 3px; border-radius: 3px; transition: background .1s; }
        .tok:hover { filter: brightness(.93); }
        #empty-state {
            display: flex; align-items: center; justify-content: center;
            height: 180px; border: 2px dashed #e5e7eb; border-radius: 8px;
            color: #9ca3af; font-size: 14px; margin-top: 8px;
        }

        /* Floating label menu */
        #labelMenu {
            position: absolute; display: none;
            background: white; border: 1px solid #d1d5db; border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0,0,0,.12); padding: 6px; z-index: 50; min-width: 220px;
        }
        .menu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 3px; }
        #labelMenu button {
            padding: 6px 10px; border: none; border-radius: 5px;
            cursor: pointer; font-size: 13px; font-weight: 500; text-align: center;
        }
        #labelMenu button:hover { filter: brightness(.92); }
        .btn-person { background:#bfdbfe; color:#1e3a5f; }
        .btn-job    { background:#bbf7d0; color:#14532d; }
        .btn-degree { background:#ddd6fe; color:#2e1065; }
        .btn-org    { background:#fed7aa; color:#7c2d12; }
        .btn-clear  { background:#f3f4f6; color:#374151; grid-column: 1/-1; }
        .menu-label { font-size: 11px; color:#6b7280; padding: 2px 4px 4px; text-transform:uppercase; letter-spacing:.05em; }

        /* Summary panel */
        #annotationSummary {
            margin-top: 12px;
            max-height: 60vh;
            overflow-y: auto;
            font-family: monospace;
            font-size: 13px;
        }
        .sum-empty  { color: #9ca3af; font-size: 13px; font-family: sans-serif; }
        .sum-line   { display: flex; align-items: baseline; gap: 6px; padding: 2px 0; border-bottom: 1px solid #f3f4f6; }
        .sum-tok    { flex: 1; color: #111827; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .sum-tag    { font-size: 11px; font-weight: 700; border-radius: 3px; padding: 1px 5px; flex-shrink: 0; }
        .sum-b      { background: #1d4ed8; color: white; }
        .sum-i      { background: #6b7280; color: white; }
        .sum-entity { font-size: 11px; color: #6b7280; flex-shrink: 0; }

        #annotateStatus { font-family: monospace; font-size: 12px; margin-top: 10px; min-height: 16px; color: #374151; }
        .hint { font-size:12px; color:#6b7280; margin-bottom:16px; }
    </style>
</head>
<body class="bg-gray-50">
    <jsp:include page="/includes/header.jsp" />

    <main class="max-w-6xl mx-auto px-6 py-16 mt-24 mb-10 bg-white shadow-lg rounded-lg">
        <h1 class="text-3xl md:text-4xl font-bold mb-6 leading-tight text-center">CV Annotation Tool</h1>

        <div class="annotate-workspace">

            <!-- LEFT: file controls + annotation area -->
            <div class="annotate-left">
                <div class="flex items-center gap-3 mb-4">
                    <input type="file" id="annotateFile" accept=".pdf,.doc,.docx"
                           class="flex-1 text-sm text-gray-600 file:mr-3 file:py-2 file:px-4
                                  file:rounded-lg file:border-0 file:font-medium
                                  file:bg-gray-100 file:text-gray-700 hover:file:bg-gray-200 cursor-pointer" />
                    <button type="button" id="loadBtn" onclick="loadCVForAnnotation()"
                            class="px-5 py-2 rounded-lg font-semibold text-sm bg-gray-700 text-white hover:bg-gray-800 transition whitespace-nowrap">
                        Load
                    </button>
                </div>

                <p class="hint">
                    Click a token to select; shift-click to extend within the same line, then pick a label from the menu.<br>
                    Keys: <b>p</b>=B-PERSON &nbsp;<b>P</b>=I-PERSON &nbsp;<b>j</b>=B-JOB_TITLE &nbsp;<b>J</b>=I-JOB_TITLE &nbsp;<b>d</b>=B-DEGREE &nbsp;<b>D</b>=I-DEGREE &nbsp;<b>g</b>=B-ORG &nbsp;<b>G</b>=I-ORG &nbsp;<b>x</b>=Clear &nbsp;Esc=cancel
                </p>

                <div id="annotateContainer"></div>
                <div id="empty-state">Load a CV to begin annotating</div>
            </div>

            <!-- RIGHT: export button + summary panel -->
            <div class="annotate-sidebar">
                <button type="button" id="exportBtn" onclick="exportAnnotations()" disabled
                        class="w-full px-5 py-2 rounded-lg font-semibold text-sm bg-blue-600 text-white
                               hover:bg-blue-700 transition disabled:opacity-40 disabled:cursor-not-allowed">
                    Export to Training Set
                </button>



                <button type="button" onclick="clearAll()"
                        class="w-full mt-2 px-5 py-2 rounded-lg font-semibold text-sm
                               border border-red-200 text-red-600 hover:bg-red-50 transition">
                    Clear All
                </button>








                <div id="annotationSummary">
                    <p class="sum-empty">No annotations yet.</p>
                </div>
                <div id="annotateStatus"></div>
            </div>

        </div><!-- end workspace -->

        <!-- Floating label menu (position:absolute, sits above everything) -->
        <div id="labelMenu">
            <div class="menu-label">Begin (B)</div>
            <div class="menu-grid">
                <button class="btn-person" data-label="B-PERSON">Person B</button>
                <button class="btn-job"    data-label="B-JOB_TITLE">Job Title B</button>
                <button class="btn-degree" data-label="B-DEGREE">Degree B</button>
                <button class="btn-org"    data-label="B-ORGANIZATION">Org B</button>
            </div>
            <div class="menu-label" style="margin-top:6px">Continue (I)</div>
            <div class="menu-grid">
                <button class="btn-person" data-label="I-PERSON">Person I</button>
                <button class="btn-job"    data-label="I-JOB_TITLE">Job Title I</button>
                <button class="btn-degree" data-label="I-DEGREE">Degree I</button>
                <button class="btn-org"    data-label="I-ORGANIZATION">Org I</button>
            </div>
            <div class="menu-grid" style="margin-top:6px">
                <button class="btn-clear"  data-label="O">Clear (O)</button>
            </div>
        </div>

    </main>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>