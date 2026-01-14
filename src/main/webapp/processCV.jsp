<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>CV Processing</title>

    <!-- JS -->
    <script src="<%=request.getContextPath()%>/javascript/processUpload.js?1012" defer></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .section {
            border: 1px solid #ccc;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .section h3 {
            margin-top: 0;
        }
        .field {
            margin-bottom: 8px;
        }
        label {
            font-weight: bold;
        }
    </style>
</head>

<body>

<h2>Upload & Process CV</h2>

<!-- Upload -->
<form id="cvForm" enctype="multipart/form-data">
    <input type="file" id="cvFile" name="cvFile"
           accept=".pdf,.doc,.docx" required />
    <br><br>

    <button type="button" onclick="processCV()">Process CV</button>
</form>

<hr>

<!-- INFO -->
<div class="section" id="infoSection">
    <h3>Info</h3>
    <div class="field">
        <label>Name:</label>
        <span id="infoName"></span>
    </div>
    <div class="field">
        <label>Email:</label>
        <span id="infoEmail"></span>
    </div>
    <div class="field">
        <label>Phone:</label>
        <span id="infoPhone"></span>
    </div>
</div>

<!-- EDUCATION -->
<div class="section" id="educationSection">
    <h3>Education</h3>
    <div id="educationContent"></div>
</div>

<!-- EXPERIENCE -->
<div class="section" id="experienceSection">
    <h3>Experience</h3>
    <div id="experienceContent"></div>
</div>

<!-- SKILLS -->
<div class="section" id="skillsSection">
    <h3>Skills</h3>
    <div id="skillsContent"></div>
</div>

<!-- REFEREES -->
<div class="section" id="refereesSection">
    <h3>Referees</h3>
    <div id="refereesContent"></div>
</div>

</body>
</html>
