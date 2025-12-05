let resumeApi = function () {

	let resumeGetUrl = "resume?fnct=getResume";

	let applicantGetUrl = "resume?fnct=getApplicant";
	let applicantUpdateUrl = "resume?fnct=updateApplicant";

	let educationPostUrl = "resume?fnct=addEducation";
	let educationUpdateUrl = "resume?fnct=updateEducation";
	let educationDeleteUrl = "resume?fnct=deleteEducation";

	let employmentPostUrl = "resume?fnct=addEmployment";
	let employmentUpdateUrl = "resume?fnct=updateEmployment";
	let employmentDeleteUrl = "resume?fnct=deleteEmployment";

	let skillsPostUrl = "resume?fnct=addSkill";
	let skillsUpdateUrl = "resume?fnct=updateSkill";
	let skillsDeleteUrl = "resume?fnct=deleteSkill";

	let projectsPostUrl = "resume?fnct=addProject";
	let projectsUpdateUrl = "resume?fnct=updateProject";
	let projectsDeleteUrl = "resume?fnct=deleteProject";

	let refereePostUrl = "resume?fnct=addReferee";
	let refereeUpdateUrl = "resume?fnct=updateReferee";
	let refereeDeleteUrl = "resume?fnct=deleteReferee";

	let handleGetApplicant = function() {
		let jsonData = {};

		$.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        $.ajax({
            type: 'POST',
            url: applicantGetUrl,
            data: jsonData,
            dataType: 'json',
            success: function (mData) {
                //console.log(mData);
				console.log("handleGetApplicant reached");
                let data = mData.applicant;
                displayApplicant(data);
            },
            error: function (mData) {
                console.log("Error : ");
                console.log(mData);
            }
        });
	};

	let handleEditApplicant = function() {
		$("#saveProfile").click(function () {
            if( !validate($("#detailsForm").serializeArray()) ) {return;}

			let jsonData = {};

			let formArray = $("#detailsForm").serializeArray();
			$.each(formArray, function (i, field) {
		        jsonData[field.name] = field.value;
		    });

			$.ajaxSetup({
	            headers: {
	                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
	            }
	        });

	        $.ajax({
	            type: 'POST',
	            url: applicantUpdateUrl,
	            data: jsonData,
	            dataType: 'json',
	            success: function (mData) {
	                console.log(mData);
					console.log("handleEditApplicant reached");

	                let data = mData.applicant;
	                displayApplicant(data);
	            },
	            error: function (mData) {
	                console.log("Error : ");
	                console.log(mData);
	            }
	        });
	    });
	};


	let handleGetResume = function() {
		let jsonData = {};

		$.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        $.ajax({
            type: 'POST',
            url: resumeGetUrl,
            data: jsonData,
            dataType: 'json',
            success: function (mData) {
                //console.log(mData);

                setRefereeArray(mData.referees);
                setEmploymentArray(mData.employment);
                setEducationArray(mData.education);
                setProjectsArray(mData.projects);
				setSkillsArray(mData.skills);
            },
            error: function (mData) {
                console.log("Error : ");
                console.log(mData);
            }
        });

	};


	let handleInitialize = function() {

		$('.save-btn, .upd-btn').on('click', function () {
			let formId = $(this).attr('data-save');
			let inputForm = $('#'+formId);

            if( !validate(inputForm.serializeArray()) ) {return;}

			let formArray = inputForm.serializeArray();
			let formData = {};
			let formAction = "";

			$.each(formArray, function (i, field) {
		        formData[field.name] = field.value;
		    });

		    let postUrl = "";

		    switch (formId) {
				case 'educationForm':
					postUrl = ( $(this).hasClass('upd-btn') ? educationUpdateUrl : educationPostUrl );
                    education.push(formData);
                    renderEducation();
					break;
				case 'employmentForm':
					postUrl = ( $(this).hasClass('upd-btn') ? employmentUpdateUrl : employmentPostUrl );
                    employment.push(formData);
                    renderEmployment();
					break;
				case 'projectForm':
					postUrl = ( $(this).hasClass('upd-btn') ? projectsUpdateUrl : projectsPostUrl );
                    projects.push(formData);
                    renderProjects();
					break;
				case 'refereeForm':
					postUrl = ( $(this).hasClass('upd-btn') ? refereeUpdateUrl : refereePostUrl );
                    referees.push(formData);
                    renderReferees();
					break;
				case 'skillForm':
					postUrl = ( $(this).hasClass('upd-btn') ? skillsUpdateUrl : skillsPostUrl );
					formAction = ( $(this).hasClass('upd-btn') ? "update" : "post");
                    skills.push(formData);
                    renderSkills();
					break;
			}

            $(this).closest('form').find(".m-input").val("");
            $(this).closest('.modal').modal('toggle');
            calculateProgress();

			$.ajaxSetup({
	            headers: {
	                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
	            }
	        });

	        $.ajax({
	            type: 'POST',
	            url: postUrl,
	            data: formData,
	            dataType: 'json',
	            success: function (mData) {
	               //console.log(mData);
                   
                    switch (formId) {
                        case 'educationForm':
                            setEducationArray(mData.education);
                            break;
                        case 'employmentForm':
                            setEmploymentArray(mData.employment);
                            break;
                        case 'projectForm':
                            setProjectsArray(mData.projects);
                            break;
                        case 'refereeForm':
                            setRefereeArray(mData.referees);
							console.log(formData);
                            break;
						case 'skillForm':
							console.log(formAction +" hence "+ postUrl);
							console.log(formData);
                            setSkillsArray(mData.skills);
                            break;
                    }
	            },
	            error: function (jqXHR, textStatus, errorThrown) {
					console.log("Error : " + textStatus);
					console.log("Details : " + errorThrown);
					console.log("Response : " + jqXHR.responseText);
				}
	        });

		});

	};

	return {
        //main function to initiate the theme
        init: function (Args) {
            args = Args;
	        handleGetResume();
	        handleGetApplicant();
	        handleEditApplicant();
            handleInitialize();
        }
    }

}();
