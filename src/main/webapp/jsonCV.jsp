<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika JSON Resume Editor</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://cdn.jsdelivr.net/npm/jsoneditor@9.10.0/dist/jsoneditor.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/jsoneditor@9.10.0/dist/jsoneditor.min.js"></script>
  <style>
    #jsonEditor { height: 600px; border: 1px solid #e5e7eb; border-radius: 0.5rem; background-color: white; }
  </style>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-4xl mx-auto">
    <h1 class="text-3xl font-bold mb-4 text-center">Ajirika JSON Resume Editor</h1>
    <p class="text-gray-700 mb-6 text-center">
        Welcome to the Ajirika JSON CV editor! Fill in your CV details directly in the code below.  
        Keys like <span class="font-semibold">basics, name, email, phone, url, image</span> are fixed labels and cannot be removed or renamed.  
        You can edit the values to reflect your own information — for example, update your name, email, job title, summary, or social profiles.  
        Make sure to keep the JSON structure intact so your CV remains valid and shareable.
    </p>

    <div id="jsonEditor"></div>
    </div>

    <script>
        const restrictedKeys = ["basics", "name", "email", "phone", "url", "image"];

        const resume = {
        "basics": {
            "name": "John Doe",
            "label": "Programmer",
            "image": "",
            "email": "john@gmail.com",
            "phone": "(912) 555-4321",
            "url": "https://johndoe.com",
            "summary": "A summary of John Doe…",
            "location": {
                "address": "2712 Broadway St",
                "postalCode": "CA 94115",
                "city": "San Francisco",
                "countryCode": "US",
                "region": "California"
            },
            "profiles": [{
                "network": "Twitter",
                "username": "john",
                "url": "https://twitter.com/john"
            }]
        }
        };

        const container = document.getElementById('jsonEditor');
        const editor = new JSONEditor(container, {
        mode: 'code',           // code mode
        modes: ['code', 'tree'],// allow switching
        onError: (err) => alert(err.toString()),
        onChange: () => {
            // Live validation: check restricted keys exist
            try {
            const current = editor.get();
            const missingKeys = restrictedKeys.filter(key => !hasKey(current, key));
            if(missingKeys.length > 0) {
                // alert("Restricted keys cannot be removed: " + missingKeys.join(", "));
                editor.set(resume); // restore previous JSON
            }
            } catch(e) {
            // Invalid JSON typed
            console.warn("Invalid JSON currently typed");
            }
        }
        });

        // helper to check if a key exists anywhere in JSON
        function hasKey(obj, key) {
        if(obj && typeof obj === 'object') {
            if(obj.hasOwnProperty(key)) return true;
            return Object.values(obj).some(v => hasKey(v, key));
        }
        return false;
        }

        editor.set(resume);
    </script>
</body>
</html>
