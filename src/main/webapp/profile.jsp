<!DOCTYPE html>
<html lang="en">
<!-- begin::Head -->

<head>
    <meta charset="utf-8" />

    <title>Resume Builder</title>
    <meta name="description" content="Resume Builder">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no">
    <meta content="Open Baraza" name="author" />

    <!-- BEGIN GLOBAL MANDATORY STYLES -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700&subset=all" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>

    <link href="assets/resume/vendor/style.bundle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style type="text/css">
        .hidden {
            display: none;
        }
        
        .fade {
            opacity: 1;
        }

        .new-container {
            /*padding-top: 4rem;       pt-16 (16 * 0.25rem = 4rem) */
            display: grid;          /* grid */
            grid-template-columns: 1fr; /* grid-cols-1 by default */
            min-height: 100vh;      /* min-h-screen */
        }

        @media (min-width: 1024px) { /* lg breakpoint */
            .new-container {
                grid-template-columns: 1fr 1fr; /* lg:grid-cols-2 */
            }
        }

        .scroll-container {
            height: 100vh;          /* h-screen */
            overflow: auto;         /* overflow-auto */
            background-color: #f9fafb; /* bg-gray-50 */
            padding: 1.5rem;        /* p-6 (6 * 0.25rem = 1.5rem) */
            padding-top: 2rem;      /* pt-8 (8 * 0.25rem = 2rem) */
        }

        .column {
            padding: 1rem;
            border: 2px solid black;
        }

        .cv-section {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .cv-actions {
            display: flex;
            justify-content: center;
            padding: 12px;
        }
            .cv-add-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 24px;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            background: white;
            font-weight: 500;
            color: #111827;
            cursor: pointer;
            transition: background 0.2s ease;
        }
        .cv-add-btn:hover {
            background: #f9fafb;
        }
        .card-container {
            position: relative;         /* relative */
            background-color: #ffffff;  /* bg-white */
            border-radius: 1rem;        /* rounded-2xl → 16px */
            box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05); /* shadow-sm */
            padding: 1.5rem;            /* p-6 → 24px */
            border: 2px solid black;
            margin-bottom: 50px;
        }

        .new-edit-btn {
        position: absolute;                  /* absolute */
        top: 1rem;                           /* top-4 → 16px */
        right: 1rem;                         /* right-4 → 16px */
        width: 2rem;                         /* w-8 → 32px */
        height: 2rem;                        /* h-8 → 32px */
        background: linear-gradient(to right, #ec4899, #ef4444); /* from-pink-500 to-red-500 */
        color: white;                        /* text-white */
        border-radius: 9999px;               /* rounded-full */
        display: flex;                       /* flex */
        align-items: center;                 /* items-center */
        justify-content: center;             /* justify-center */
        border: none;                        /* remove default button border */
        cursor: pointer;                     /* pointer cursor */
        transition: opacity 0.2s ease;       /* transition-opacity */
        }

        .new-edit-btn:hover {
        opacity: 0.8;                        /* hover:opacity-80 */
        }

        .new-edit-icon {
        width: 1rem;                         /* w-4 → 16px */
        height: 1rem;                        /* h-4 → 16px */
        }

        .profile-header {
        display: flex;            /* flex */
        align-items: center;      /* items-center */
        gap: 1rem;                /* gap-4 → 16px */
        margin-bottom: 1rem;      /* mb-4 → 16px */
        }

        .avatar {
        width: 4rem;              /* w-16 → 64px */
        height: 4rem;             /* h-16 → 64px */
        background-color: #f3f4f6;/* bg-gray-100 */
        border-radius: 50%;       /* rounded-full */
        display: flex;            
        align-items: center;      
        justify-content: center;  /* flex items-center justify-center */
        }

        .avatar-icon {
        width: 2rem;              /* w-8 → 32px */
        height: 2rem;             /* h-8 → 32px */
        color: #9ca3af;           /* text-gray-400 */
        }

        .profile-name {
        font-size: 1.25rem;       /* text-xl */
        font-weight: bold;        /* font-bold */
        color: #111827;           /* text-gray-900 */
        margin: 0;
        }

        .profile-title {
        font-size: 1.125rem;      /* text-lg */
        color: #6b7280;           /* text-gray-500 */
        margin: 0;
        }

        .contact-info {
        display: flex;
        flex-direction: column;
        gap: 0.75rem; /* space-y-3 = 12px */
        }

        .contact-item {
        display: flex;
        align-items: center;
        color: #374151; /* text-gray-700 */
        font-size: 1rem;
        }

        .contact-icon {
        width: 1.25rem;   /* w-5 = 20px */
        height: 1.25rem;  /* h-5 = 20px */
        margin-right: 0.75rem; /* mr-3 = 12px */
        color: #9ca3af;   /* text-gray-400 */
        }

        #detailsModal .modal-dialog {
            margin-top: 10vh;   /* start 5% down from the top of the screen */
        }

        .bordertest {
            border: 3px solid black;
        }

        @media (max-width: 576px) {
            /* Ensure text like emails wraps on smaller screens */
            #refereesContainer .m-widget4__ext span,
            #refereesContainer .m-widget4__info span {
                word-wrap: break-word;
                word-break: break-all;   
                white-space: normal;     
                max-width: 100%;         
                display: block;
            }
            /* Make the referee item responsive */
            #refereesContainer .m-widget4__item {
                display: flex;
                flex-wrap: wrap;          
                align-items: flex-start;
                justify-content: space-between;
                gap: 10px;
            }
            #refereesContainer .m-widget4__info,
            #refereesContainer .m-widget4__ext {
                flex: 1 1 100%;        
                text-align: left;
            }

            /* Buttons should stay visible */
            #refereesContainer .m-widget4__ext.m--align-right {
                flex: 1 1 100%;
                text-align: right;     
                margin-top: 5px;
            }
        }

        /* Ensure Add Entry button is centered on mobile */
        .cv-actions {
            margin-top: 10px;
            text-align: center;
        }
        /* Modal dialog adjustments */
        .modal-dialog {
            max-width: 700px; /* Similar to modal-lg */
            margin: 1.75rem auto;
        }

        /* Modal content styled like the shadow card */
        .modal-content {
            border: none;
            border-radius: 1rem; /* rounded-2xl */
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* shadow-card */
            background: #fff;
            padding: 1.5rem; /* base padding */
        }

        @media (min-width: 1024px) {
            .modal-content {
                    padding: 1.75rem; /* lg:p-7 */
            }
        }

        /* Header */
        .modal-header {
            border-bottom: none;
            padding: 0 0 1rem 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title {  
            font-size: 1.5rem; /* heading-xl */
            font-weight: 700;
            color: #111827; /* primaryBlack */
            margin: 0;
        }

        .close {
            border: none;
            background: transparent;
            font-size: 1.25rem;
            cursor: pointer;
            color: #374151;
            transition: opacity 0.2s ease-in-out;
        }

        .close:hover {
            opacity: 0.7;
        }

        /* Body */
        .modal-body {
            padding: 0; /* remove default spacing */
            margin-top: 1rem;
        }

        /* Form controls styled */
        .form-control {
            border-radius: 0.5rem; /* rounded-lg */
            border: 1px solid #d1d5db; /* inputBorder */
            background-color: #f9fafb; /* inputBackground */
            color: #111827; /* inputText */
            font-size: 1rem;
            padding: 0.625rem 0.75rem; /* h-12 equivalent */
            outline: none;
            box-shadow: none;
        }

        .form-control:focus {
            border-color: #3b82f6; /* focus border (blue-500) */
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        }

        /* Labels */
        label {
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
            display: inline-block;
            color: #111827;
        }

        /* Footer */
        .modal-footer {
            border-top: none;
            padding-top: 1.25rem;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        /* Buttons */
        .btn {
            border-radius: 0.75rem; /* rounded-xl */
            font-weight: 600;
            padding: 0.5rem 1.25rem;
            font-size: 0.95rem;
            transition: all 0.2s ease-in-out;
        }

        .btn-success {
            background-color: #10b981; /* emerald-500 */
            border: none;
        }

        .btn-success:hover {
            background-color: #059669;
        }

        .btn-outline-brand {
            border: 1px solid #d1d5db;
            color: #374151;
            background: #f9fafb;
        }

        .btn-outline-brand:hover {
            background-color: #f3f4f6;
        }
    </style>

                
</head>
<!-- end::Head -->


<!-- begin::Body -->

<body class="m-page--fluid m--skin- m-content--skin-light2 m-header--fixed m-header--fixed-mobile m-aside-left--enabled m-aside-left--skin-light m-aside-left--fixed m-aside-left--offcanvas m-footer--push m-aside--offcanvas-default">

    <!-- begin:: Page -->
    <div class="resume-container m-grid m-grid--hor m-grid--root m-page">


        <!-- Navigation Bar -->
        <nav id="navbar" class="navbar fixed top-0 left-0 right-0 w-full z-50 bg-white shadow">
            <%-- <div class="max-w-7xl mx-auto px-6 py-4"> --%>
                <div class="flex items-center justify-between w-full px-10 py-4">
                    
                    <!-- Logo -->
                    <a href="index.jsp" class="flex items-center gap-2 group">
                        <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center transform group-hover:scale-110 transition-transform">
                            <span class="text-white font-bold text-xl">A</span>
                        </div>
                        <span class="text-xl font-bold gradient-text-blue">Project Ajirika</span>
                    </a>

                    <!-- Logout Button -->
                    <a href="logout.jsp?logoff=yes"
                    class="px-4 py-2 rounded-lg font-medium text-white bg-red-600 hover:bg-red-700 transition">
                    Log Out
                    </a>

                </div>
            <%-- </div> --%>
        </nav>

        <!-- begin::Body -->
        <section class="py-8">
            <div class="resume-section m-grid__item m-grid__item--fluid m-grid m-grid--ver-desktop m-grid--desktop m-body">

                <!-- BEGIN: Left Aside -->
                <!-- END: Left Aside -->

                <div class="m-grid__item m-grid__item--fluid m-wrapper mb-0">

                    <div class="m-content pt-5 mt-5">
                        <div class="row">
                            <div class="m-portlet m-portlet--head-sm m-portlet--light m-portlet--head-solid-bg col-lg-6 mb-0">

                                <%-- <div class="m-portlet__head">
                                    <div class="m-portlet__head-wrapper">
                                        <div class="m-portlet__head-caption">
                                            <div class="m-portlet__head-title">
                                                <h3 class="m-portlet__head-text" id="progressText">0% profile completeness</h3>
                                            </div>
                                        </div>
                                    </div>
                                </div> --%>

                                <%-- <div class="m-portlet__head-progress mx-4">
                                    <div class="progress m-progress--sm">
                                        <div class="progress-bar" id="progressBar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div> --%>
                                <div class="m--space-10"></div>

                                <div class="m-portlet__body">
                                    
                                    <!-- Begin: Personal Details Card (Tailwind + Font Awesome) -->
                                    <div class="relative bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-6">
                                        <!-- Edit Button -->
                                        <button 
                                            class="absolute top-4 right-4 w-8 h-8 bg-gradient-to-r from-pink-500 to-red-500 text-white rounded-full flex items-center justify-center hover:opacity-80 transition-opacity focus:outline-none"
                                            data-toggle="modal" 
                                            data-target="#detailsModal"
                                            aria-label="Edit personal details">
                                            <i class="fas fa-pencil-alt text-xs"></i>
                                        </button>

                                        <!-- Name -->
                                        <div class="mb-4">
                                            <h2 id="new_surname" class="text-3xl font-bold text-gray-800"></h2>
                                        </div>

                                        <!-- Contact Info -->
                                        <div class="space-y-2">
                                            <!-- Email -->
                                            <div id="new_applicant_email" class="flex items-center text-gray-700">
                                                <i class="fas fa-envelope text-gray-400 mr-3 text-lg"></i>
                                                <span class="text-gray-700"></span>
                                            </div>
                                            
                                            <!-- Phone -->
                                            <div id="new_applicant_phone" class="flex items-center text-gray-700">
                                                <i class="fas fa-phone text-gray-400 mr-3 text-lg"></i>
                                                <span class="text-gray-700"></span>
                                            </div>
                                            
                                            <!-- Country -->
                                            <div id="new_home_country" class="flex items-center text-gray-700">
                                                <i class="fas fa-globe-africa text-gray-400 mr-3 text-lg"></i>
                                                <span class="text-gray-700"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Personal Details Card -->


                                    <!-- Begin: Education Section -->
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
                                        <div class="flex items-center justify-between p-4">
                                            <h3 class="text-lg font-semibold">Education</h3>
                                            <button
                                            class="dropdown-arrow w-8 h-8 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 flex items-center justify-center transition-colors focus:outline-none"
                                            aria-expanded="false"
                                            data-target="#educationPortlet"
                                            aria-controls="educationPortlet">
                                            <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                        <div id="educationPortlet" class="hidden px-4 pb-4 space-y-4">
                                            <!-- Full-width container for education items -->
                                            <div id="educationContainer" class="space-y-3 w-full"></div>
                                            
                                            <!-- Centered button wrapper -->
                                            <div class="text-center pt-2 flex items-center justify-center">
                                            <button
                                                class="cv-add-btn flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-xl bg-white font-medium text-gray-900 hover:bg-gray-50 transition-colors"
                                                data-toggle="modal"
                                                data-target="#educationModal">
                                                <i class="fas fa-plus"></i> Add Entry
                                            </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Education Section -->

                                    <!-- Begin: Employment Section -->
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
                                        <div class="flex items-center justify-between p-4">
                                            <h3 class="text-lg font-semibold">Employment</h3>
                                            <button
                                            class="dropdown-arrow w-8 h-8 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 flex items-center justify-center transition-colors focus:outline-none"
                                            aria-expanded="false" data-target="#employmentPortlet"
                                            aria-controls="employmentPortlet">
                                            <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                        <div id="employmentPortlet" class="hidden px-4 pb-4 space-y-4">
                                            <div id="employmentContainer" class="space-y-3 w-full"></div>
                                            <div class="text-center flex items-center justify-center">
                                            <button
                                                class="cv-add-btn flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-xl bg-white font-medium text-gray-900 hover:bg-gray-50 transition-colors"
                                                data-toggle="modal"
                                                data-target="#employmentModal">
                                                <i class="fas fa-plus"></i> Add Entry
                                            </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Employment Section -->

                                    <!-- Begin: Projects Section -->
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
                                        <div class="flex items-center justify-between p-4">
                                            <h3 class="text-lg font-semibold">Projects</h3>
                                            <button 
                                            class="dropdown-arrow w-8 h-8 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 flex items-center justify-center transition-colors focus:outline-none"
                                            aria-expanded="false" data-target="#projectsPortlet"
                                            aria-controls="projectsPortlet">
                                            <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                        <div id="projectsPortlet" class="hidden px-4 pb-4 space-y-4">
                                            <div id="projectsContainer" class="space-y-3 w-full"></div>
                                            <div class="text-center flex items-center justify-center">
                                                <button
                                                    class="cv-add-btn flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-xl bg-white font-medium text-gray-900 hover:bg-gray-50 transition-colors"
                                                    data-toggle="modal"
                                                    data-target="#projectsModal">
                                                    <i class="fas fa-plus"></i> Add Entry
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Projects Section -->

                                    <!-- Begin: Referees Section -->
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
                                        <div class="flex items-center justify-between p-4">
                                            <h3 class="text-lg font-semibold">Referees</h3>
                                            <button 
                                            class="dropdown-arrow w-8 h-8 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 flex items-center justify-center transition-colors focus:outline-none"
                                            aria-expanded="false" data-target="#refereesPortlet"
                                            aria-controls="refereesPortlet">
                                            <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                        <div id="refereesPortlet" class="hidden px-4 pb-4 space-y-4">
                                            <div id="refereesContainer" class="space-y-3 w-full"></div>
                                            <div class="text-center flex items-center justify-center">
                                            <button
                                                class="cv-add-btn flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-xl bg-white font-medium text-gray-900 hover:bg-gray-50 transition-colors"
                                                data-toggle="modal"
                                                data-target="#refereeModal">
                                                <i class="fas fa-plus"></i> Add Entry
                                            </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Referees Section -->

                                    <!-- Begin: Skills Section -->
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
                                        <div class="flex items-center justify-between p-4">
                                            <h3 class="text-lg font-semibold">Skills</h3>
                                            <button
                                            class="dropdown-arrow w-8 h-8 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 flex items-center justify-center transition-colors focus:outline-none"
                                            aria-expanded="false" data-target="#skillsPortlet"
                                            aria-controls="skillsPortlet">
                                            <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                        <div id="skillsPortlet" class="hidden px-4 pb-4 space-y-4">
                                            <div id="skillsContainer" class="space-y-3 w-full"></div>
                                            <div class="text-center flex items-center justify-center">
                                            <button
                                                class="cv-add-btn flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-xl bg-white font-medium text-gray-900 hover:bg-gray-50 transition-colors"
                                                data-toggle="modal"
                                                data-target="#skillsModal">
                                                <i class="fas fa-plus"></i> Add Entry
                                            </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- End: Skills Section -->
                                </div>

                                <!--begin::Modal-->
                                <div class="modal fade" id="detailsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="detailsTitle">Personal Details</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
												    <span aria-hidden="true">&times;</span>
												</button>
                                            </div>
                                            <form class="m-form m-form--fit m-form--label-align-right" id="detailsForm" name="personalDetails">
                                                <div class="m-portlet__body">
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="title">* Title:</label>
                                                            <select name="title" class="form-control m-input" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="Mr">Mr</option>
                                                                <option value="Miss">Miss</option>
                                                                <option value="Mrs">Mrs</option>
                                                                <option value="Dr">Dr</option>
                                                                <option value="Prof">Prof</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="surname">* Surname:</label>
                                                            <input type="text" name="surname" id="surname" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>

                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="othername">* Other Names:</label>
                                                            <input type="text" name="othername" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="email">* Email:</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend"><span class="input-group-text">@</span></div>
                                                                <input type="text" name="email" class="form-control m-input" placeholder="" required="true">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="phone">* Phone</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend"><span class="input-group-text"><i class="la la-phone"></i></span></div>
                                                                <input type="text" name="phone" class="form-control m-input" placeholder="" required="true">
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="dob">* Date of Birth</label>
                                                            <input type="date" name="dob" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>

                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="gender">* Gender</label>
                                                            <select name="gender" class="form-control m-input" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="M">Male</option>
                                                                <option value="F">Female</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="marital_status">* Marital Status</label>
                                                            <select name="marital_status" class="form-control m-input" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="M">Married</option>
                                                                <option value="S">Single</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="nationality">* Nationality</label>
                                                            <select name="nationality" class="form-control m-input" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="KE">Kenya</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="id_number">* ID Number</label>
                                                            <input type="text" name="id_number" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>


                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label">Language</label>
                                                            <input type="text" name="language" class="form-control m-input" placeholder="">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label">Currency</label>
                                                            <select name="currency" class="form-control m-input">
                                                            <option value="1" selected="selected">Kenyan Shilling</option>
                                                            <option value="3">British Pound</option>
                                                            <option value="2">US Dollar</option>
                                                            <option value="4">Euro</option>
                                                        </select>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="dob">* Previous Salary</label>
                                                            <input class='form-control mask_currency' type='text' name='previous_salary' required=true  value="" size='50'/>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="dob">* Expected Salary</label>
                                                            <input class='form-control mask_currency' type='text' name='expected_salary' required=true  value="" size='50'/>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="dob">* Any Disability</label>
                                                            <input name='disability' type='text' class='form-control' size='150' required=true  value='None'/>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="m-portlet__foot m-portlet__foot--fit">
                                                    <div class="m-form__actions m--align-right py-3">
                                                        <button type="button" class="btn btn-brand" id="saveProfile" data-dismiss="modal" aria-label="Close">Update</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->

                                <!--begin::Modal-->
                                <div class="modal fade" id="educationModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="educationTitle">Education</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
												<span aria-hidden="true">&times;</span>
												</button>
                                            </div>
                                            <form id="educationForm">
                                                <div class="modal-body">
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="edu-level">* Education Level:</label>
                                                            <select name="edu-level" class="form-control m-input" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="1">Primary School</option>
                                                                <option value="2">Secondary School</option>
                                                                <option value="3">High School</option>
                                                                <option value="4">Certificate</option>
                                                                <option value="5">Diploma</option>
                                                                <option value="6">Profesional Qualifications</option>
                                                                <option value="7">Higher Diploma</option>
                                                                <option value="8">Graduate</option>
                                                                <option value="9">Post Graduate</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="institution">* Institution:</label>
                                                            <input type="text" name="institution" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="edu-from">* Date from</label>
                                                            <input type="date" name="edu-from" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="edu-to">* Date to</label>
                                                            <input type="date" name="edu-to" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="certification">Certification *</label>
                                                            <input type="text" name="certification" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label">Grades</label>
                                                            <input type="text" name="grades" class="form-control m-input" placeholder="">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group">
                                                        <label>Details</label>
                                                        <textarea class="form-control m-input" name="educationDetails" rows="4"></textarea>
                                                    </div>

                                                    <input type="hidden" name="education_id" value="">
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="reset" data-cancel="educationModal" class="btn btn-outline-brand m-btn cancel-btn" data-dismiss="modal">Cancel</button>
                                                    <button type="button" data-save="educationForm" class="btn btn-success save-btn">Add</button>
                                                    <button type="button" data-save="educationForm" class="btn btn-brand upd-btn hidden">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->

                                

                                <!--begin::Modal-->
                                <div class="modal fade" id="employmentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Employment</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
												<span aria-hidden="true">&times;</span>
												</button>
                                            </div>
                                            <form id="employmentForm">
                                                <div class="modal-body">
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="employer">* Employer</label>
                                                            <input type="text" name="employer" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="position">* Position</label>
                                                            <input type="text" name="position" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="emp-from">* Date from</label>
                                                            <input type="date" name="emp-from" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="emp-to">* Date to</label>
                                                            <input type="date" name="emp-to" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group">
                                                        <label>Details</label>
                                                        <textarea class="form-control m-input" name="employmentDetails" rows="4"></textarea>
                                                    </div>

                                                    <input type="hidden" name="employment_id" value="">
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="reset" data-cancel="employmentModal" class="btn btn-outline-brand m-btn cancel-btn" data-dismiss="modal">Cancel</button>
                                                    <button type="button" data-save="employmentForm" class="btn btn-success save-btn">Add</button>
                                                    <button type="button" data-save="employmentForm" class="hidden btn btn-brand upd-btn">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->

                                <!--begin::Modal-->
                                <div class="modal fade" id="projectsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="projectModalLabel">Project</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
												<span aria-hidden="true">&times;</span>
												</button>
                                            </div>
                                            <form id="projectForm">
                                                <div class="modal-body">
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="project-name">* Project Name</label>
                                                            <input type="text" name="project-name" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="project-date">* Date</label>
                                                            <input type="date" name="project-date" class="form-control m-input" placeholder="" required="true">
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group">
                                                        <label>Details</label>
                                                        <textarea class="form-control m-input" name="projectDetails" rows="4"></textarea>
                                                    </div>

                                                    <input type="hidden" name="project_id" value="">
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="reset" data-cancel="projectsModal" class="btn btn-outline-brand m-btn cancel-btn" data-dismiss="modal">Cancel</button>
                                                    <button type="button" data-save="projectForm" class="btn btn-success save-btn">Add</button>
                                                    <button type="button" data-save="projectForm" class="hidden btn btn-brand upd-btn">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->


                                <!--begin::Modal-->
                                <div class="modal fade" id="refereeModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Referee</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>

                                            <form id="refereeForm">
                                                <div class="modal-body">
                                                    <!-- Name -->
                                                    <div class="form-group m-form__group">
                                                        <label class="form-control-label" data-name="referee-name">* Name</label>
                                                        <input type="text" class="form-control m-input" name="referee-name" required>
                                                    </div>

                                                    <!-- Company + Position -->
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-12 col-md-6 m-form__group-sub">
                                                        <label class="form-control-label" data-name="referee-company">* Company</label>
                                                        <input type="text" name="referee-company" class="form-control m-input" required>
                                                        </div>
                                                        <div class="col-12 col-md-6 m-form__group-sub">
                                                        <label class="form-control-label" data-name="referee-position">* Position</label>
                                                        <input type="text" name="referee-position" class="form-control m-input" required>
                                                        </div>
                                                    </div>

                                                    <!-- Phone + Email -->
                                                    <div class="form-group row">
                                                        <div class="col-12 col-md-6">
                                                            <label class="form-control-label">Phone</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="la la-phone"></i></span>
                                                                </div>
                                                                <input type="text" name="referee-phone" class="form-control">
                                                            </div>
                                                        </div>

                                                        <div class="col-12 col-md-6">
                                                            <label class="form-control-label">* Email</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text">@</span>
                                                                </div>
                                                                <input type="email" name="referee-email" class="form-control" required>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Country + Town -->
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-12 col-md-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="referee-country">* Country</label>
                                                            <select name="referee-country" class="form-control m-input" required>
                                                                <option value="" selected>Country</option>
                                                                <option value="KE">Kenya</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-12 col-md-6 m-form__group-sub">
                                                            <label class="form-control-label">Town</label>
                                                            <input type="text" name="referee-town" class="form-control m-input">
                                                        </div>
                                                    </div>

                                                    <input type="hidden" name="referee_id" value="">
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="reset" data-cancel="refereeModal" class="btn btn-outline-brand m-btn cancel-btn" data-dismiss="modal">Cancel</button>
                                                    <button type="button" data-save="refereeForm" class="btn btn-success save-btn">Add</button>
                                                    <button type="button" data-save="refereeForm" class="hidden btn btn-brand upd-btn">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->

                                <!--begin::Modal-->
                                <div class="modal fade" id="skillsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Skill</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
													<span aria-hidden="true">&times;</span>
													</button>
                                            </div>
                                            <form id="skillForm">
                                                <div class="modal-body">
                                                    <div class="form-group m-form__group row">
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="skill-name">* Skill Type:</label>
                                                            <select id="skill-name" class="form-control m-input" name="skill-name" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="0">Indicate Your Skill</option>
                                                                <option value="1">Personal Computer</option>
                                                                <option value="2">Dot Matrix Printer</option>
                                                                <option value="3">Ticket Printer</option>
                                                                <option value="4">Hp Printer</option>
                                                                <option value="5">Dos</option>
                                                                <option value="6">Windowsxp</option>
                                                                <option value="7">Linux</option>
                                                                <option value="8">Solaris Unix</option>
                                                                <option value="9">Dialup</option>
                                                                <option value="10">Office</option>
                                                                <option value="11">Browsing</option>
                                                                <option value="12">Galileo Products</option>
                                                                <option value="13">Antivirus</option>
                                                                <option value="21">Dialup</option>
                                                                <option value="22">Lan</option>
                                                                <option value="23">Wan</option>
                                                                <option value="29">Samba</option>
                                                                <option value="30">Mail</option>
                                                                <option value="31">Web</option>
                                                                <option value="32">Application</option>
                                                                <option value="33">Identity Management</option>
                                                                <option value="34">Network Management</option>
                                                                <option value="36">Backup And Storage Services</option>
                                                                <option value="37">Groupware</option>
                                                                <option value="38">Asterix</option>
                                                                <option value="39">Database</option>
                                                                <option value="40">Design</option>
                                                                <option value="41">Baraza</option>
                                                                <option value="42">Coding Java</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-lg-6 m-form__group-sub">
                                                            <label class="form-control-label" data-name="skill-level">* Skill Level:</label>
                                                            <select id="skill-level" class="form-control m-input" name="skill-level" required="true">
                                                                <option value="" selected="selected">Select</option>
                                                                <option value="1">Basic</option>
                                                                <option value="2">Intermediate</option>
                                                                <option value="3">Advanced</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="form-group m-form__group">
                                                        <label>Details</label>
                                                        <textarea class="form-control m-input" name="skill-details" rows="4"></textarea>
                                                    </div>

                                                    <input type="hidden" name="skill_id" value="">
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="reset" data-cancel="skillsModal" class="btn btn-outline-brand m-btn cancel-btn" data-dismiss="modal">Cancel</button>
                                                    <button type="button" data-save="skillForm" class="btn btn-success save-btn">Add</button>
                                                    <button type="button" data-save="skillForm" class="hidden btn btn-brand upd-btn">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Modal-->

                            </div>

                            <div class="col-lg-6">

                                <div class="m-subheader pt-0">
                                    <div class="d-flex align-items-center">
                                        <div class="mr-auto">
                                            <h3 class="m-subheader__title">Resume Preview</h3>
                                        </div>
                                    </div>
                                </div>

                                <div class="m-content py-0">
                                    <!--begin::Portlet-->
                                    <div class="m-portlet m-portlet--info m-portlet--head-solid-bg m-portlet--bordered m-portlet--bordered-semi mb-0">
                                        <div class="m-portlet__body">
                                            <div class="m-portlet__head-caption">
                                                <div class="m-portlet__head-title">
                                                    <h3 class="m-portlet__head-text">
                                                        <span data-display="othername" class="mr-1"></span><span data-display="surname"></span>

                                                    </h3>
                                                </div>
                                            </div>
                                            <div class="tab-content">
                                                <div class="tab-pane active">
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Email : </span>
                                                                <span class="m-widget4__sub"><a href="mailto:" data-display="email"></a></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Phone : </span>
                                                                <span class="m-widget4__sub"><a href="tel:" data-display="phone"></a></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Date of Birth : </span>
                                                                <span class="m-widget4__sub" data-display="dob"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Gender : </span>
                                                                <span class="m-widget4__sub" data-display="gender"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Marital Status : </span>
                                                                <span class="m-widget4__sub" data-display="marital_status"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">ID Number : </span>
                                                                <span class="m-widget4__sub" data-display="id_number"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Nationality : </span>
                                                                <span class="m-widget4__sub" data-display="nationality"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Language : </span>
                                                                <span class="m-widget4__sub" data-display="language"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Previous Salary : </span>
                                                                <span class="m-widget4__sub" data-display="previous_salary"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Expected Salary : </span>
                                                                <span class="m-widget4__sub" data-display="expected_salary"></span>
                                                            </div>
                                                        </div>
                                                        <div class="m-widget4__item py-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Any Disability : </span>
                                                                <span class="m-widget4__sub" data-display="disability"></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item pb-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Address</span><br>
                                                                <div id="resumeAddress"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item pb-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Education</span><br>
                                                                <div id="resumeEducation"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item pb-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Employment</span><br>
                                                                <div id="resumeEmployment"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item pb-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Projects</span><br>
                                                                <div id="resumeProjects"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item pb-0">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Skills</span><br>
                                                                <div id="resumeSkills"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="m-widget4">
                                                        <div class="m-widget4__item">
                                                            <div class="m-widget4__info px-0">
                                                                <span class="m-widget4__title">Referees</span><br>
                                                                <div id="resumeReferees"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="text-center mt-4">
                                         <button id="downloadJsonBtn" class="btn btn-primary">Download JSON Version</button>
                                    </div>
                                    <!--end::Portlet-->
                                </div>
                            </div>

                        </div>
                    </div>
                </div>


            </div>
            <!-- end:: Body -->
        </section>


        <!-- begin::Footer -->
        <!-- end::Footer -->


    </div>
    <!-- end:: Page -->
     <jsp:include page="/includes/footer.jsp" />

    <!--begin::Global Theme Bundle -->
    <script src="assets/resume/vendor/vendors.bundle.js" type="text/javascript"></script>
    <script src="assets/resume/vendor/scripts.bundle.js" type="text/javascript"></script>

    <script src="assets/resume/js/resume.js?1076" type="text/javascript"></script>
    <script src="assets/resume/js/jsonDownload.js" type="text/javascript"></script>
    <script src="assets/resume/js/resume_api.js?1073" type="text/javascript"></script>
    <!--end::Global Theme Bundle -->

    <script type="text/javascript">
        resumeApi.init();
    </script>

    <script type="text/javascript">
        $('.portletArrow').on('click', function () {
            // Find the <i> inside the clicked arrow
            const $icon = $(this).find('i');

            // Toggle classes
            if ($icon.hasClass('la-angle-down')) {
                $icon.removeClass('la-angle-down').addClass('la-angle-up');
            } else {
                $icon.removeClass('la-angle-up').addClass('la-angle-down');
            }
        });

       $(document).on('click', '.dropdown-arrow', function () {
            const $button = $(this);
            const targetSelector = $button.data('target');
            const $target = $(targetSelector);
            const $icon = $button.find('i');

            if ($target.length === 0) return; // safety check

            if ($target.hasClass('hidden')) {
                $target.removeClass('hidden');
                $icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
                $button.attr('aria-expanded', 'true');
            } else {
                $target.addClass('hidden');
                $icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
                $button.attr('aria-expanded', 'false');
            }
        });

        $('#detailsForm .m-input').on('change', function() {
            var textValue = $(this).val();
            var target = $(this).attr('name');
            $("[data-display=" + target + "]").html(textValue);
        });

        $(".m-input").on('change', function() {
            if ($(this).attr('name').includes('email')) {
                const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                if (!re.test(String($(this).val()).toLowerCase())) {
                    $(this).css({
                        "border": "1px solid #ff000087"
                    });
                    $("[data-name='" + $(this).attr('name') + "']").addClass('text-danger');
                } else {
                    $(this).css({
                        "border": "1px solid #ebedf2"
                    });
                    $("[data-name='" + $(this).attr('name') + "']").removeClass('text-danger');
                }
            } else if ($(this).val() == "" && $(this).prop('required') == true) {
                $(this).css({
                    "border": "1px solid #ff000087"
                });
                $("[data-name='" + $(this).attr('name') + "']").addClass('text-danger');
            } else {
                $("[data-name='" + $(this).attr('name') + "']").removeClass('text-danger');
                $(this).css({
                    "border": "1px solid #ebedf2"
                });
            }
        });
    </script>

    <script type="text/javascript">
        $('#saveProfile').on('click', function() {
            calculateProgress();
        });

        $('.modal-toggle').on('click', function() {
            let modalID = $(this).attr('data-target');
            $(modalID).find(".save-btn").removeClass('hidden');
            $(modalID).find(".upd-btn").addClass('hidden');
        });
    </script>
    
  
    <script type="text/javascript">
    
        $(document).ready(function () {
    
            $("#upload_cv").click(function (event) {
		        var bForm = $('#frm_cv_import')[0];
				var bData = new FormData(bForm);
								
                $.ajax({
                    url: 'resume_upload_cv',
                    type: 'POST',
                    data: bData,
                    cache: false,
                    contentType: false,
                    enctype: 'multipart/form-data',
                    processData: false,
                    success: function (data) {
                        console.log(data);
    
                        var textUpdate = document.getElementById('cv_import');
                        textUpdate.value = data.cv_content;
                    }
                });
    
                return false;
            });
        });
       
    </script>
    


</body>
<!-- end::Body -->

</html>

