let address = [];
let education = [];
let employment = [];
let skills = [];
let projects = [];
let referees = [];

function renderEmptyMessage(container) {
  container.html('<p class="text-gray-500 italic">No items found.</p>');
}

function escapeHtml(value) {
  return String(value == null ? "" : value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

let renderCvContentPreview = function (cvDataStr) {
  let resumeExperience = $("#resumeEmployment");
  let resumeSkillsPreview = $("#resumeSkills");
  let resumeRefereesPreview = $("#resumeReferees");

  if (!cvDataStr) {
    renderEmptyMessage(resumeExperience);
    renderEmptyMessage(resumeSkillsPreview);
    renderEmptyMessage(resumeRefereesPreview);
    return;
  }

  let cv;
  try {
    cv = JSON.parse(cvDataStr);
  } catch (err) {
    console.error("Could not parse cv_data:", err);
    return;
  }

  let experience = cv.experience || [];
  if (experience.length > 0) {
    let expHtml = "";
    experience.forEach(function (exp) {
      let role = exp.role || exp.position || "";
      let employer = exp.employer || exp.company || "";
      let description = exp.description || "";

      if (role && employer) {
        expHtml +=
          '<span class="block mb-1 text-gray-700"><strong>' +
          escapeHtml(role) +
          "</strong> at <em>" +
          escapeHtml(employer) +
          "</em></span>";
      } else if (role) {
        expHtml +=
          '<span class="block mb-1 text-gray-700"><strong>' +
          escapeHtml(role) +
          "</strong></span>";
      } else {
        expHtml +=
          '<span class="block mb-1 text-gray-700">' + escapeHtml(description) + "</span>";
      }
    });
    resumeExperience.html(expHtml);
  } else {
    renderEmptyMessage(resumeExperience);
  }

  let cvSkills = cv.skills || [];
  if (cvSkills.length > 0) {
    let hasCategories = cvSkills.some((s) => typeof s === "object" && s.category);
    let skillsHtml = "";

    if (hasCategories) {
      let groups = {};
      cvSkills.forEach(function (s) {
        if (typeof s === "object" && s.category) {
          let cat = s.category.replace(/[^\x20-\x7E]/g, "").trim() || "Other";
          if (!groups[cat]) groups[cat] = [];
          groups[cat].push(s.skill);
        } else if (typeof s === "string") {
          if (!groups["Other"]) groups["Other"] = [];
          groups["Other"].push(s);
        }
      });
      Object.entries(groups).forEach(function ([category, catSkills]) {
        skillsHtml +=
          '<span class="block mb-1 text-gray-700"><strong>' +
          escapeHtml(category) +
          ":</strong> " +
          escapeHtml(catSkills.join(", ")) +
          "</span>";
      });
    } else {
      cvSkills.forEach(function (s) {
        let skillText = typeof s === "string" ? s : (s.skill || "");
        skillsHtml += '<span class="block mb-1 text-gray-700">' + escapeHtml(skillText) + "</span>";
      });
    }
    resumeSkillsPreview.html(skillsHtml);
  } else {
    renderEmptyMessage(resumeSkillsPreview);
  }

  let cvReferees = cv.references || [];
  if (cvReferees.length > 0) {
    let refHtml = "";
    cvReferees.forEach(function (ref) {
      refHtml +=
        '<span class="block mb-1 text-gray-700">' +
        escapeHtml(ref.name || ref["referee-name"] || "—") +
        (ref.organization ? ", " + escapeHtml(ref.organization) : "") +
        (ref.role ? ", " + escapeHtml(ref.role) : "") +
        (ref.contact ? ", " + escapeHtml(ref.contact) : "") +
        "</span>";
    });
    resumeRefereesPreview.html(refHtml);
  } else {
    renderEmptyMessage(resumeRefereesPreview);
  }
};

let displayApplicant = function (applicant) {
  console.log("displayApplicant reached");
  if (applicant.length > 0) {
    let applicantData = applicant.pop();

    for (let field of Object.keys(applicantData)) {
      // Fill form inputs and generic placeholders
      $("[name='" + field + "']").val(applicantData[field]);
      $("[data-display=" + field + "]").text(applicantData[field]);
    }

    if (applicantData.surname) {
      document.getElementById("new_surname").textContent = applicantData.surname;
    }
    if (applicantData.email) {
      document.getElementById("new_applicant_email").textContent =
        applicantData.email;
    }
    if (applicantData.phone) {
      document.getElementById("new_applicant_phone").textContent =
        applicantData.phone;
    }
    if (applicantData.nationality) {
      document.getElementById("new_home_country").textContent =
        applicantData.nationality;
    }

    renderCvContentPreview(applicantData.cv_data);
  }
};

let renderEducation = function () {
  let educationContainer = $("#educationContainer");
  let resumeContainer = $("#resumeEducation");
  let educationList = "";
  let resumeEducation = "";

  if (education.length === 0) {
    renderEmptyMessage(educationContainer);
    resumeContainer.empty(); // clear preview too
    return;
  } else {
    for (let i = 0; i < education.length; i++) {
      let object = education[i];

      let listHtml =
        '<div class="flex justify-between items-start py-3 border-b border-gray-100 last:border-0">' +
        '<div class="flex-1">' +
        '<div class="font-semibold text-gray-800">' +
        escapeHtml(object["institution"]) +
        "</div>" +
        '<div class="text-sm text-gray-600">' +
        escapeHtml(object["edu-from"]) +
        " – " +
        escapeHtml(object["edu-to"]) +
        "</div>" +
        '<div class="text-sm text-gray-700 mt-1">' +
        escapeHtml(object["certification"] || "") +
        "</div>" +
        "</div>" +
        '<div class="flex space-x-2 ml-4">' +
        '<button onClick="editInit(this);" class="p-1.5 text-gray-500 hover:text-blue-600 rounded-full hover:bg-gray-100" ' +
        'data-toggle="modal" data-target="#educationModal" data-value="' +
        i +
        '" data-array="education" title="Edit">' +
        '<i class="fas fa-edit text-sm"></i>' +
        "</button>" +
        '<button onClick="removeInit(this);" class="p-1.5 text-gray-500 hover:text-red-600 rounded-full hover:bg-gray-100" ' +
        'data-id="' +
        object["education_id"] +
        '" data-name="education_id" data-value="' +
        i +
        '" data-array="education" title="Delete">' +
        '<i class="fas fa-trash text-sm"></i>' +
        "</button>" +
        "</div>" +
        "</div>";

      let resumeHtml =
        '<span class="block mb-1 text-gray-700">' +
        escapeHtml(object["institution"]) +
        ", " +
        escapeHtml(object["certification"]) +
        ", " +
        escapeHtml(object["edu-from"]) +
        " – " +
        escapeHtml(object["edu-to"]) +
        "</span>";

      educationList += listHtml;
      resumeEducation += resumeHtml;
    }
  }

  educationContainer.html(educationList);
  resumeContainer.html(resumeEducation);
};

let renderEmployment = function () {
  let employmentContainer = $("#employmentContainer");
  let employmentList = "";

  for (let i = 0; i < employment.length; i++) {
    let object = employment[i];

    let listHtml =
      '<div class="m-widget4__item">' +
      '<div class="m-widget4__info">' +
      '<span class="m-widget4__title">' +
      escapeHtml(object["employer"]) +
      "</span><br> " +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["emp-from"]) +
      " - " +
      escapeHtml(object["emp-to"] || "Present") +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext">' +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["position"]) +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext m--align-right"> ' +
      '<button onClick="editInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-edit" data-toggle="modal" data-target="#employmentModal" data-value="' +
      i +
      '" data-array="employment" title="Edit"><i class="la la-edit"></i></button> ' +
      '<button onClick="removeInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-delete" data-id="' +
      object["employment_id"] +
      '" data-name="employment_id" data-value="' +
      i +
      '" data-array="employment" title="Delete"><i class="la la-trash"></i></button> ' +
      "</div> " +
      "</div>";

    employmentList += listHtml;
  }

  employmentContainer.html(employmentList);
};

let renderProjects = function () {
  let projectsContainer = $("#projectsContainer");
  let resumeContainer = $("#resumeProjects");
  let projectsList = "";
  let resumeProjects = "";

  for (let i = 0; i < projects.length; i++) {
    let object = projects[i];

    let listHtml =
      '<div class="m-widget4__item">' +
      '<div class="m-widget4__info">' +
      '<span class="m-widget4__title">' +
      escapeHtml(object["project-name"]) +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext">' +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["project-date"]) +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext m--align-right"> ' +
      '<button onClick="editInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-edit" data-toggle="modal" data-target="#projectsModal" data-value="' +
      i +
      '" data-array="projects" title="Edit"><i class="la la-edit"></i></button> ' +
      '<button onClick="removeInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-delete" data-id="' +
      object["project_id"] +
      '" data-name="project_id" data-value="' +
      i +
      '" data-array="projects" title="Delete"><i class="la la-trash"></i></button> ' +
      "</div> " +
      "</div>";

    let resumeHtml =
      '<span class="m-widget4__sub">' +
      escapeHtml(object["project-name"]) +
      ", " +
      escapeHtml(object["project-date"]) +
      "</span><br>";

    projectsList += listHtml;
    resumeProjects += resumeHtml;
  }

  projectsContainer.html(projectsList);
  resumeContainer.html(resumeProjects);
};

let renderReferees = function () {
  let refereesContainer = $("#refereesContainer");
  let refereesList = "";

  for (let i = 0; i < referees.length; i++) {
    let object = referees[i];

    let listHtml =
      '<div class="m-widget4__item">' +
      '<div class="m-widget4__info">' +
      '<span class="m-widget4__title">' +
      escapeHtml(object["referee-name"]) +
      " | " +
      escapeHtml(object["referee-company"]) +
      "</span><br> " +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["referee-position"]) +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext">' +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["referee-email"]) +
      "</span><br>" +
      '<span class="m-widget4__sub">' +
      escapeHtml(object["referee-phone"]) +
      "</span>" +
      "</div>" +
      '<div class="m-widget4__ext m--align-right"> ' +
      '<button onClick="editInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-edit" data-toggle="modal" data-target="#refereeModal" data-value="' +
      i +
      '" data-array="referees" title="Edit"><i class="la la-edit"></i></button> ' +
      '<button onClick="removeInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-delete" data-id="' +
      object["referee_id"] +
      '" data-name="referee_id" data-value="' +
      i +
      '" data-array="referees" title="Delete"><i class="la la-trash"></i></button> ' +
      "</div> " +
      "</div>";

    refereesList += listHtml;
  }

  refereesContainer.html(refereesList);
};

const skillLevels = {
  1: "Basic",
  2: "Intermediate",
  3: "Advanced",
};

let renderSkills = function () {
  let skillsContainer = $("#skillsContainer");
  let skillsList = "";

  for (let i = 0; i < skills.length; i++) {
    let object = skills[i];

    let skillNameText = $(
      "#skill-name option[value='" + object["skill-name"] + "']"
    ).text();
    let skillLevelText = $(
      "#skill-level option[value='" + object["skill-level"] + "']"
    ).text();

    let listHtml =
      '<div class="m-widget4__item">' +
      '<div class="m-widget4__info">' +
      '<span class="m-widget4__title">' +
      skillNameText +
      " | " +
      skillLevelText +
      "</span><br> " +
      "</div>" +
      '<div class="m-widget4__ext m--align-right"> ' +
      '<button onClick="editInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-edit" data-toggle="modal" data-target="#skillsModal" data-value="' +
      i +
      '" data-array="skills" title="Edit"><i class="la la-edit"></i></button> ' +
      '<button onClick="removeInit(this);" class="m-portlet__nav-link btn m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill m-delete" data-id="' +
      object["skill_id"] +
      '" data-name="skill_id" data-value="' +
      i +
      '" data-array="skills" title="Delete"><i class="la la-trash"></i></button> ' +
      "</div> " +
      "</div>";

    skillsList += listHtml;
  }

  skillsContainer.html(skillsList);
};

let calculateProgress = function () {
  let progress = 0;

  let profile = $("#detailsForm").serializeArray();
  for (let field of profile) {
    if (field.value != "") {
      progress += 2;
    }
  }

  if (education.length == 1) {
    progress += 5;
  } else if (education.length == 2) {
    progress += 10;
  } else if (education.length >= 3) {
    progress += 15;
  }

  if (employment.length == 1) {
    progress += 5;
  } else if (employment.length == 2) {
    progress += 10;
  } else if (employment.length >= 3) {
    progress += 15;
  }

  if (skills.length == 3) {
    progress += 5;
  } else if (skills.length >= 4) {
    progress += 10;
  }

  if (projects.length == 1) {
    progress += 5;
  } else if (projects.length == 2) {
    progress += 10;
  } else if (projects.length >= 3) {
    progress += 15;
  }

  if (referees.length >= 1) {
    progress += 10;
  }

  //console.log(progress);
  $("#progressText").html(progress + "% profile completeness");
  $("#progressBar").css("width", `${progress}%`);
};

let queueModal = function (modalId, prefillCallback) {
  if ($("#educationModal").hasClass("show")) {
    $("#educationModal").on("hidden.bs.modal.queueEdu", function () {
      $("#educationModal").off("hidden.bs.modal.queueEdu");
      if (prefillCallback) prefillCallback();
      $(modalId).modal("show");
    });
  } else if ($("#employmentModal").hasClass("show")) {
    $("#employmentModal").on("hidden.bs.modal.queueEmp", function () {
      $("#employmentModal").off("hidden.bs.modal.queueEmp");
      if (prefillCallback) prefillCallback();
      $(modalId).modal("show");
    });
  } else {
    if (prefillCallback) prefillCallback();
    $(modalId).modal("show");
  }
};

let setRefereeArray = function (dataArray) {
  referees = dataArray;
  renderReferees();
};

let setEmploymentArray = function (dataArray) {
  if (!Array.isArray(dataArray)) {
    console.error("Employment data is not a valid array:", dataArray);
    $("#errorContainer").html(
      '<div class="alert alert-danger">Employment data is invalid or missing.</div>'
    );
    return;
  }

  employment = dataArray;
  renderEmployment();
};

let setEducationArray = function (dataArray) {
  education = dataArray;
  renderEducation();
};

let setProjectsArray = function (dataArray) {
  projects = dataArray;
  renderProjects();
};

let setSkillsArray = function (dataArray) {
  skills = dataArray;
  renderSkills();
};

let removeInit = function (e) {
  let objectIndex = $(e).attr("data-value");
  let arrayName = $(e).attr("data-array");

  let itemId = $(e).attr("data-id");
  let itemName = $(e).attr("data-name");
  let formData = {};
  formData[itemName] = itemId;
  let postUrl = null;

  switch (arrayName) {
    case "education":
      education.splice(objectIndex, 1);
      renderEducation();
      postUrl = "resume?fnct=deleteEducation";
      break;
    case "employment":
      employment.splice(objectIndex, 1);
      renderEmployment();
      postUrl = "resume?fnct=deleteEmployment";
      break;
    case "projects":
      projects.splice(objectIndex, 1);
      renderProjects();
      postUrl = "resume?fnct=deleteProject";
      break;
    case "referees":
      referees.splice(objectIndex, 1);
      renderReferees();
      postUrl = "resume?fnct=deleteReferee";
      break;
    case "skills":
      skills.splice(objectIndex, 1);
      renderSkills();
      postUrl = "resume?fnct=deleteSkill";
      break;
  }
  calculateProgress();

  sendAjax(postUrl, formData);
};

let editInit = function (e) {
  let modalID = $(e).attr("data-target");
  $(modalID).find(".save-btn").addClass("hidden");
  $(modalID).find(".upd-btn").removeClass("hidden");

  let objectIndex = $(e).attr("data-value");
  let arrayName = $(e).attr("data-array");
  let dataModal = $(e).closest(".modal");
  let object = {};

  switch (arrayName) {
    case "education":
      object = education[objectIndex];
      break;
    case "employment":
      object = employment[objectIndex];
      break;
    case "projects":
      object = projects[objectIndex];
      break;
    case "referees":
      object = referees[objectIndex];
      break;
    case "skills":
      object = skills[objectIndex];
      break;
  }

  for (let key of Object.keys(object)) {
    $('[name ="' + key + '"]').val(object[key]);
  }
};

$(".cancel-btn").on("click", function () {
  let modalId = $(this).attr("data-cancel");
  $("#" + modalId + " .m-input").val("");
  $("#" + modalId).modal("toggle");
});

function validate(form) {
  let valid = true;
  $.each(form, function (i, field) {
    $("[data-name='" + field.name + "']").removeClass("text-danger");
    if (
      field.value == "" &&
      $("[name='" + field.name + "']").prop("required")
    ) {
      valid = false;
      $("[name='" + field.name + "']").css({ border: "1px solid #ff000087" });
      $("[data-name='" + field.name + "']").addClass("text-danger");
    }
  });
  return valid;
}

function sendAjax(postUrl, formData) {
  $.ajaxSetup({
    headers: {
      "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
    },
  });

  $.ajax({
    type: "POST",
    url: postUrl,
    data: formData,
    dataType: "json",
    success: function (mData) {
      console.log(mData);
    },
    error: function (mData) {
      console.log("Error : ");
      console.log(mData);
    },
  });
}
