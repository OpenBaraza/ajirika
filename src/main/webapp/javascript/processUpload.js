function processCV() {
    const fileInput = document.getElementById("cvFile");

    if (!fileInput.files.length) {
        alert("Please select a CV file first.");
        return;
    }

    const formData = new FormData();
    formData.append("cvFile", fileInput.files[0]);
    console.log(formData.get("cvFile"));

    fetch("processCV", {  
        method: "POST",
        body: formData
    })
    // .then(response => {
    //     if (!response.ok) {
    //         throw new Error("Failed to process CV");
    //     }
    //     return response.json();
    // })
    // .then(data => {
    //     populateCVData(data);
    // })
    // .catch(error => {
    //     console.error(error);
    //     alert("Error processing CV");
    // });
}

function populateCVData(data) {
    // INFO
    document.getElementById("infoName").textContent = data.info?.name || "";
    document.getElementById("infoEmail").textContent = data.info?.email || "";
    document.getElementById("infoPhone").textContent = data.info?.phone || "";

    // EDUCATION
    renderList("educationContent", data.education);

    // EXPERIENCE
    renderList("experienceContent", data.experience);

    // SKILLS
    renderList("skillsContent", data.skills);

    // REFEREES
    renderList("refereesContent", data.referees);
}

function renderList(containerId, items) {
    const container = document.getElementById(containerId);
    container.innerHTML = "";

    if (!items || items.length === 0) {
        container.innerHTML = "<em>No data</em>";
        return;
    }

    const ul = document.createElement("ul");
    items.forEach(item => {
        const li = document.createElement("li");
        li.textContent = item;
        ul.appendChild(li);
    });

    container.appendChild(ul);
}
