
CREATE TABLE disability (
	disability_id			serial primary key,
	is_default				boolean default false not null,
	disability_name			varchar(240) not null
);


CREATE TABLE applicants (
	entity_id				integer references entitys primary key,
	disability_id			integer references disability,
	org_id					integer references orgs,
	person_title			varchar(7),
	surname					varchar(50) not null,
	first_name				varchar(50) not null,
	middle_name				varchar(50),
	applicant_email			varchar(120) not null unique,
	applicant_phone			varchar(50),
	date_of_birth			date,
	gender					varchar(1),
	nationality				char(2) not null references sys_countrys,
	marital_status 			varchar(2),
	picture_file			varchar(64),
	cv_file					varchar(64),
	cv_data					text,
	identity_card			varchar(50),
	language				varchar(320),
	bank_account			varchar(32),
	pay_by_ewallet			boolean default true not null,
	ewallet_number			varchar(32),
	volunteer				boolean default false not null,

	disability				varchar(32) default 'None' not null,
	home_county				varchar(32),
	sub_county				varchar(32),

	location_options		varchar(120),
	years_experience		real,

	bio_metric_number		varchar(32),
	geofence				boolean default false not null,

	applicant_category		integer default 0 not null,
	previous_salary			real default 0,
	expected_salary			real default 0,
	notice_period			integer default 0,
	how_you_heard			varchar(320),
	created					timestamp default current_timestamp,

	consented				integer default 0 not null,
	consent_date			timestamp,
	
	facebook				varchar(100), 
	twitter					varchar(100), 
	google					varchar(100), 
	linkedin				varchar(100),
	website					varchar(100),

	field_of_study			text,
	interests				text,
	objective				text,
	details					text
);
CREATE INDEX applicants_disability_id ON applicants(disability_id);
CREATE INDEX applicants_nationality ON applicants(nationality);
CREATE INDEX applicants_org_id ON applicants(org_id);

CREATE TABLE education_class (
	education_class_id		serial primary key,
	org_id					integer references orgs,
	education_class_name	varchar(50),
	education_level			integer default 1 not null,
	details					text
);
CREATE INDEX education_class_org_id ON education_class(org_id);

CREATE TABLE education (
	education_id			serial primary key,
	entity_id				integer references entitys not null,
	education_class_id		integer references education_class not null,
	org_id					integer references orgs,
	date_from				date not null,
	date_to					date,
	name_of_school			varchar(240),
	examination_taken		varchar(240),
	grades_obtained			varchar(50),
	certificate_number		varchar(50),
	verified				boolean default false not null,
	verification_failed		boolean default false not null,
	verification_date		date,
	verification_details	text,
	verified_by				integer references entitys,
	details					text
);
CREATE INDEX education_entity_id ON education (entity_id);
CREATE INDEX education_education_class_id ON education (education_class_id);
CREATE INDEX education_verified_by ON education (verified_by);
CREATE INDEX education_org_id ON education(org_id);

CREATE TABLE employment (
	employment_id			serial primary key,
	entity_id				integer references entitys not null,
	org_id					integer references orgs,
	date_from				date not null,
	date_to					date,
	employers_name			varchar(240) not null,
	position_held			varchar(240) not null,
	principal_employment	boolean default false not null,
	alternative_address		varchar(240),
	alternative_salary		real,
	verified				boolean default false not null,
	verification_failed		boolean default false not null,
	verification_date		date,
	verification_details	text,
	verified_by				integer references entitys,
	details					text
);
CREATE INDEX employment_entity_id ON employment (entity_id);
CREATE INDEX employment_verified_by ON employment (verified_by);
CREATE INDEX employment_org_id ON employment(org_id);

CREATE TABLE cv_seminars (
	cv_seminar_id			serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	cv_seminar_name			varchar(240),
	cv_seminar_date			date not null,
	details					text
);
CREATE INDEX cv_seminars_entity_id ON cv_seminars (entity_id);
CREATE INDEX cv_seminars_org_id ON cv_seminars(org_id);

CREATE TABLE cv_projects (
	cv_project_id			serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	cv_project_name			varchar(240),
	cv_project_date			date not null,
	details					text
);
CREATE INDEX cv_projects_entity_id ON cv_projects (entity_id);
CREATE INDEX cv_projects_org_id ON cv_projects(org_id);

CREATE TABLE cv_certifications (
	cv_certification_id		serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	cv_certification_name	varchar(240) not null,
	cv_certification_date	date not null,
	details					text
);
CREATE INDEX cv_certifications_entity_id ON cv_certifications (entity_id);
CREATE INDEX cv_certifications_org_id ON cv_certifications(org_id);

CREATE TABLE skill_category (
	skill_category_id		serial primary key,
	org_id					integer references orgs,
	skill_category_name		varchar(50) not null,
	details					text
);
CREATE INDEX skill_category_org_id ON skill_category(org_id);

CREATE TABLE skill_types (
	skill_type_id			serial primary key,
	skill_category_id		integer references skill_category,
	org_id					integer references orgs,
	skill_type_name			varchar(50) not null,
	stated_skill			boolean default false not null,
	basic					varchar(50),
	intermediate 			varchar(50),
	advanced				varchar(50),
	details					text
);
CREATE INDEX skill_types_skill_category_id ON skill_types (skill_category_id);
CREATE INDEX skill_types_org_id ON skill_types(org_id);

CREATE TABLE skill_levels (
	skill_level_id			serial primary key,
	org_id					integer references orgs,
	skill_level_name		varchar(50),
	details					text
);
CREATE INDEX skill_levels_org_id ON skill_levels(org_id);

CREATE TABLE skills (
	skill_id				serial primary key,
	entity_id				integer references entitys,
	skill_type_id			integer not null references skill_types,
	skill_level_id			integer not null references skill_levels,
	org_id					integer references orgs,
	state_skill				varchar(120),
	aquired					boolean default false not null,
	training_date			date,
	trained					boolean default false not null,
	training_institution	varchar(240),
	training_cost			real,
	details					text,
	UNIQUE(entity_id, skill_type_id, state_skill)
);
CREATE INDEX skills_entity_id ON skills (entity_id);
CREATE INDEX skills_skill_type_id ON skills (skill_type_id);
CREATE INDEX skills_skill_level_id ON skills (skill_level_id);
CREATE INDEX skills_org_id ON skills(org_id);

CREATE TABLE identification_types (
	identification_type_id	serial primary key,
	org_id					integer references orgs,
	identification_type_name	varchar(50),
	passport				boolean default false not null,
	details					text
);
CREATE INDEX identification_types_org_id ON identification_types(org_id);

CREATE TABLE identifications (
	identification_id		serial primary key,
	entity_id				integer references entitys,
	identification_type_id	integer references identification_types,
	nationality				char(2) not null references sys_countrys,
	org_id					integer references orgs,
	identification			varchar(64),
	is_active				boolean default true not null,
	starting_from			date,
	expiring_at				date,
	place_of_issue			varchar(50),
	details					text,
	UNIQUE(entity_id, identification_type_id, nationality)
);
CREATE INDEX identifications_entity_id ON identifications(entity_id);
CREATE INDEX identifications_identification_type_id ON identifications(identification_type_id);
CREATE INDEX identifications_nationality ON identifications(nationality);
CREATE INDEX identifications_org_id ON identifications(org_id);


CREATE VIEW vw_education AS
	SELECT education_class.education_class_id, education_class.education_class_name, education_class.education_level,
		entitys.entity_id, entitys.entity_name,
		education.org_id, education.education_id, education.date_from, education.date_to, education.name_of_school, education.examination_taken,
		education.grades_obtained, education.certificate_number,
		education.verified, education.verification_failed, education.verified_by,
		education.verification_date, education.verification_details,
		education.details
	FROM education INNER JOIN education_class ON education.education_class_id = education_class.education_class_id
		INNER JOIN entitys ON education.entity_id = entitys.entity_id;

CREATE VIEW vw_education_max AS
	SELECT education_class.education_class_id, education_class.education_class_name, education_class.education_level,
		education.org_id, education.education_id, education.entity_id, education.date_from, education.date_to, 
		education.name_of_school, education.examination_taken,
		education.grades_obtained, education.certificate_number
	FROM (education_class INNER JOIN education ON education_class.education_class_id = education.education_class_id)
	INNER JOIN 
		(SELECT vw_education.entity_id, max(vw_education.education_id) as max_education_id
		FROM vw_education INNER JOIN
			(SELECT entity_id, max(education_level) as max_education_level
			FROM vw_education
			GROUP BY entity_id) as a
			ON (vw_education.entity_id = a.entity_id) AND (vw_education.education_level = a.max_education_level)
		GROUP BY vw_education.entity_id) as b
	ON (education.education_id = b.max_education_id);

CREATE VIEW vw_employment_max AS
	SELECT employment.employment_id, employment.entity_id, employment.date_from, employment.date_to, 
		employment.org_id, employment.employers_name, employment.position_held,
		age(COALESCE(employment.date_to, current_date), employment.date_from) as employment_duration,
		c.employment_experince
	FROM employment INNER JOIN 
		(SELECT max(employment_id) as max_employment_id FROM employment INNER JOIN
		(SELECT entity_id, max(date_from) as max_date_from FROM employment GROUP BY entity_id) as a
		ON (employment.entity_id = a.entity_id) AND (employment.date_from = a.max_date_from)
		GROUP BY employment.entity_id) as b
	ON employment.employment_id = b.max_employment_id
		INNER JOIN
	(SELECT entity_id, sum(age(COALESCE(employment.date_to, current_date), employment.date_from)) as employment_experince
		FROM employment GROUP BY entity_id) as c
	ON employment.entity_id = c.entity_id;

CREATE VIEW vw_applicants AS
	SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name,
		orgs.org_id, orgs.org_name, 
		entitys.user_name, entitys.first_password,
		applicants.entity_id, applicants.person_title, applicants.surname, applicants.first_name,
		applicants.middle_name, applicants.applicant_email, applicants.applicant_phone,
		applicants.date_of_birth, applicants.gender, applicants.nationality, applicants.marital_status,
		applicants.picture_file, applicants.identity_card, applicants.language, applicants.bank_account,
		applicants.pay_by_ewallet, applicants.ewallet_number, applicants.volunteer,
		applicants.disability, applicants.home_county, applicants.sub_county,
		applicants.applicant_category, applicants.previous_salary, applicants.expected_salary,
		applicants.how_you_heard, applicants.created,
		applicants.facebook, applicants.twitter, applicants.google, applicants.linkedin,
		applicants.website, applicants.field_of_study, applicants.interests, applicants.objective,
		applicants.consented, applicants.consent_date, applicants.details,

		(CASE WHEN (orgs.order_first_name = true) THEN
			(CASE WHEN (applicants.middle_name is not null) THEN
				(applicants.first_name || ' ' || applicants.middle_name || ' ' || applicants.surname)
			ELSE
				(applicants.first_name || ' ' || applicants.surname) END)
		ELSE
			(CASE WHEN (applicants.middle_name is not null) THEN
				(applicants.surname || ' ' || applicants.middle_name || ' ' || applicants.first_name)
			ELSE
				(applicants.surname || ' ' || applicants.first_name) END)
		END) as applicant_name,

		(applicants.applicant_email || ', ' || applicants.Surname || ' '
			|| applicants.First_name || ' ' || COALESCE(applicants.Middle_name, '')) as applicant_disp,
		to_char(age(applicants.date_of_birth), 'YY') as applicant_age,
		(CASE WHEN applicants.gender = 'M' THEN 'Male' ELSE 'Female' END) as gender_name,
		(CASE WHEN applicants.marital_status = 'M' THEN 'Married' ELSE 'Single' END) as marital_status_name,

		(CASE WHEN applicants.consented = 0 THEN 'Yet to concent'
			WHEN applicants.consented = 1 THEN 'Rejected concent'
			ELSE 'Concented' END) as consent_status,

		vw_education_max.education_class_id, vw_education_max.education_level, vw_education_max.education_class_name,
		vw_education_max.education_id, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken,
		vw_education_max.grades_obtained, vw_education_max.certificate_number,
		
		vw_employment_max.employers_name, vw_employment_max.position_held,
		vw_employment_max.date_from as emp_date_from, vw_employment_max.date_to as emp_date_to, 
		vw_employment_max.employment_duration, vw_employment_max.employment_experince,
		round((date_part('year', vw_employment_max.employment_duration)
			+ date_part('month', vw_employment_max.employment_duration)/12)::numeric, 1) as emp_duration,
		round((date_part('year', vw_employment_max.employment_experince)
			+ date_part('month', vw_employment_max.employment_experince)/12)::numeric, 1) as emp_experince,

		applicants.location_options, applicants.years_experience
		
	FROM applicants INNER JOIN sys_countrys ON applicants.nationality = sys_countrys.sys_country_id
		INNER JOIN entitys ON applicants.entity_id = entitys.entity_id
		LEFT JOIN vw_education_max ON applicants.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON applicants.entity_id = vw_employment_max.entity_id
		INNER JOIN orgs ON applicants.org_id = orgs.org_id;

CREATE VIEW vw_employment AS
	SELECT entitys.entity_id, entitys.entity_name, employment.employment_id, employment.date_from, employment.date_to, 
		employment.org_id, employment.employers_name, employment.position_held, employment.details,
		employment.verified, employment.verification_failed, employment.verified_by,
		employment.verification_date, employment.verification_details,
		age(COALESCE(employment.date_to, current_date), employment.date_from) as employment_duration
	FROM employment INNER JOIN entitys ON employment.entity_id = entitys.entity_id;

CREATE VIEW vw_cv_seminars AS
	SELECT entitys.entity_id, entitys.entity_name, cv_seminars.cv_seminar_id, cv_seminars.cv_seminar_name, 
		cv_seminars.org_id, cv_seminars.cv_seminar_date, cv_seminars.details
	FROM cv_seminars INNER JOIN entitys ON cv_seminars.entity_id = entitys.entity_id;

CREATE VIEW vw_cv_projects AS
	SELECT entitys.entity_id, entitys.entity_name, 
		cv_projects.cv_project_id, cv_projects.cv_project_name, 
		cv_projects.org_id, cv_projects.cv_project_date, cv_projects.details
	FROM cv_projects INNER JOIN entitys ON cv_projects.entity_id = entitys.entity_id;
	
CREATE VIEW vw_cv_certifications AS
	SELECT entitys.entity_id, entitys.entity_name, 
		orgs.org_id, orgs.org_name, 
		cv_certifications.cv_certification_id, cv_certifications.cv_certification_name, 
		cv_certifications.cv_certification_date, cv_certifications.details
	FROM cv_certifications INNER JOIN entitys ON cv_certifications.entity_id = entitys.entity_id
		INNER JOIN orgs ON cv_certifications.org_id = orgs.org_id;

CREATE VIEW vw_skill_types AS
	SELECT skill_category.skill_category_id, skill_category.skill_category_name, skill_types.skill_type_id, 
		skill_types.org_id, skill_types.skill_type_name, skill_types.stated_skill,
		skill_types.basic, skill_types.intermediate, skill_types.advanced, skill_types.details
	FROM skill_types INNER JOIN skill_category ON skill_types.skill_category_id = skill_category.skill_category_id;

CREATE VIEW vw_skills AS
	SELECT vw_skill_types.skill_category_id, vw_skill_types.skill_category_name,
		vw_skill_types.skill_type_id, vw_skill_types.skill_type_name,
		vw_skill_types.basic, vw_skill_types.intermediate, vw_skill_types.advanced, 
		entitys.entity_id, entitys.entity_name, 
		skill_levels.skill_level_id, skill_levels.skill_level_name,
		skills.skill_id, skills.state_skill, skills.aquired, skills.training_date,
		skills.org_id, skills.trained, skills.training_institution, skills.training_cost, 
		skills.details,
		
		(CASE WHEN vw_skill_types.stated_skill = true THEN skills.state_skill 
			ELSE vw_skill_types.skill_type_name END) as skill_disp
		
	FROM skills INNER JOIN entitys ON skills.entity_id = entitys.entity_id
		INNER JOIN vw_skill_types ON skills.skill_type_id = vw_skill_types.skill_type_id
		INNER JOIN skill_levels ON skills.skill_level_id = skill_levels.skill_level_id;

CREATE VIEW vw_identifications AS
	SELECT entitys.entity_id, entitys.entity_name, identification_types.identification_type_id, 
		identification_types.identification_type_name, identification_types.passport,
		identifications.org_id, identifications.identification_id, identifications.identification, identifications.is_active, 
		identifications.starting_from, identifications.expiring_at, identifications.place_of_issue, identifications.details
	FROM identifications INNER JOIN entitys ON identifications.entity_id = entitys.entity_id
	INNER JOIN identification_types ON identifications.identification_type_id = identification_types.identification_type_id;


CREATE OR REPLACE FUNCTION get_referee(int) RETURNS text AS $$
DECLARE
	rec						RECORD;
	v_referee				text;
BEGIN
	SELECT address_name, position_held,  company_name, phone_number, email,
		('P.O. Box '::text || post_office_box || ' - '::text || postal_code) as postal_address,
		(town || ', ':: text || sys_country_name) as location
	INTO rec
	FROM vw_referees WHERE address_id = $1;

	v_referee := rec.address_name;
	IF(rec.position_held is not null)THEN
		v_referee := v_referee || E'\n' || rec.position_held;
	END IF;
	IF(rec.company_name is not null)THEN
		v_referee := v_referee || E'\n' || rec.company_name;
	END IF;
	IF(rec.postal_address is not null)THEN
		v_referee := v_referee || E'\n' || rec.postal_address;
	END IF;
	IF(rec.location is not null)THEN
		v_referee := v_referee || E'\n' || rec.location;
	END IF;
	IF(rec.phone_number is not null)THEN
		v_referee := v_referee || E'\n' || rec.phone_number;
	END IF;
	IF(rec.email is not null)THEN
		v_referee := v_referee || E'\n' || rec.email;
	END IF;

	RETURN v_referee;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_referees(int) RETURNS text AS $$
DECLARE
	rec						RECORD;
	v_referee				text;
BEGIN

	v_referee := '';
	FOR rec IN
		SELECT address_name, position_held,  company_name, phone_number, email,
			('P.O. Box '::text || post_office_box || ' - '::text || postal_code) as postal_address,
			(town || ', ':: text || sys_country_name) as location
		FROM vw_referees WHERE table_id = $1
	LOOP

		v_referee := v_referee || rec.address_name || E'\n';

		IF(rec.position_held is not null)THEN
			v_referee := v_referee || E'\n' || rec.position_held;
		END IF;
		IF(rec.company_name is not null)THEN
			v_referee := v_referee || E'\n' || rec.company_name;
		END IF;
		IF(rec.postal_address is not null)THEN
			v_referee := v_referee || E'\n' || rec.postal_address;
		END IF;
		IF(rec.location is not null)THEN
			v_referee := v_referee || E'\n' || rec.location;
		END IF;
		IF(rec.phone_number is not null)THEN
			v_referee := v_referee || E'\n' || rec.phone_number;
		END IF;
		IF(rec.email is not null)THEN
			v_referee := v_referee || E'\n' || rec.email;
		END IF;
	END LOOP;

	RETURN v_referee;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_education(int) RETURNS text AS $$
DECLARE
	rec						RECORD;
	v_education				text;
BEGIN

	v_education := '';
	FOR rec IN
		SELECT education_class_name, date_from, date_to, name_of_school,
			examination_taken, grades_obtained
		FROM vw_education WHERE entity_id = $1
	LOOP
		v_education := v_education || rec.education_class_name || E'\n';

		IF(rec.name_of_school is not null)THEN
			v_education := v_education || E'\n' || rec.name_of_school;
		END IF;
		IF(rec.examination_taken is not null)THEN
			v_education := v_education || E'\n' || rec.examination_taken;
		END IF;
		IF(rec.grades_obtained is not null)THEN
			v_education := v_education || E'\n' || rec.grades_obtained;
		END IF;
		IF(rec.date_from is not null)THEN
			v_education := v_education || E'\n' || rec.date_from;
		END IF;
		IF(rec.date_to is not null)THEN
			v_education := v_education || ' to ' || rec.date_to;
		END IF;

		v_education := v_education || E'\n';
	END LOOP;

	RETURN v_education;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_employment(int) RETURNS text AS $$
DECLARE
	rec						RECORD;
	v_employment			text;
BEGIN

	v_employment := '';
	FOR rec IN
		SELECT employers_name, position_held,  date_from, date_to
		FROM employment WHERE entity_id = $1
	LOOP

		IF(rec.employers_name is not null)THEN
			v_employment := v_employment || rec.employers_name || E'\n';
		END IF;
		IF(rec.position_held is not null)THEN
			v_employment := v_employment || E'\n' || rec.position_held;
		END IF;
		IF(rec.date_from is not null)THEN
			v_employment := v_employment || E'\n' || rec.date_from;
		END IF;
		IF(rec.date_to is not null)THEN
			v_employment := v_employment || ' to ' || rec.date_to;
		END IF;

		v_employment := v_employment || E'\n';
	END LOOP;


	RETURN v_employment;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_certification(int) RETURNS text AS $$
DECLARE
	rec						RECORD;
	v_certification			text;
BEGIN

	v_certification := '';
	FOR rec IN
		SELECT cv_certification_name, cv_certification_date
		FROM cv_certifications WHERE entity_id = $1
	LOOP

		IF(rec.cv_certification_name is not null)THEN
			v_certification := v_certification || rec.cv_certification_name;
		END IF;
		IF(rec.cv_certification_date is not null)THEN
			v_certification := v_certification || ' on ' || rec.cv_certification_date;
		END IF;

		v_certification := v_certification || E'\n';
	END LOOP;

	RETURN v_certification;
END;
$$ LANGUAGE plpgsql;

    
CREATE OR REPLACE FUNCTION ins_applicants() RETURNS trigger AS $$
DECLARE
	v_org_id				integer;
	v_entity_count			integer;
	v_entity_id				integer;
	v_entity_type_id		integer;
	v_sys_email_id			integer;
	v_user_name				varchar(120);
	v_applicant_name		varchar(120);
	v_order_first_name		boolean;
BEGIN
	NEW.First_name := trim(NEW.First_name);
	NEW.Middle_name := trim(NEW.Middle_name);
	NEW.Surname := trim(NEW.Surname);

	NEW.applicant_email := trim(lower(NEW.applicant_email));

	v_org_id := NEW.org_id;
	IF(v_org_id is null)THEN
		SELECT min(org_id) INTO v_org_id
		FROM orgs WHERE (is_default = true);
	END IF;

	SELECT order_first_name INTO v_order_first_name
	FROM orgs WHERE (org_id = v_org_id);

	IF(v_order_first_name = true)THEN
		IF(NEW.Middle_name is null)THEN
			v_applicant_name := NEW.First_name || ' ' || NEW.Surname;
		ELSE
			v_applicant_name := NEW.First_name || ' ' || NEW.Middle_name || ' ' || NEW.Surname;
		END IF;
	ELSE
		IF(NEW.Middle_name is null)THEN
			v_applicant_name := NEW.Surname || ' ' || NEW.First_name;
		ELSE
			v_applicant_name := NEW.Surname || ' ' || NEW.Middle_name || ' ' || NEW.First_name;
		END IF;
	END IF;
	
	IF (TG_OP = 'INSERT') THEN
		IF(NEW.entity_id IS NULL) THEN
			IF(NEW.applicant_email is null)THEN
				NEW.applicant_email := trim(lower(NEW.First_name || '.' || NEW.Surname));
				SELECT count(entity_id) INTO v_entity_count
				FROM entitys WHERE trim(lower(user_name)) ilike (NEW.applicant_email || '%');
				IF(v_entity_count is null)THEN v_entity_count := 0; END IF;
				IF(v_entity_count = 0)THEN
					NEW.applicant_email := trim(lower(NEW.First_name || '.' || NEW.Surname)) || '@applicant.co.ke';
				ELSE
					v_entity_count := v_entity_count;
					NEW.applicant_email := trim(lower(NEW.First_name || '.' || NEW.Surname)) || v_entity_count || '@applicant.co.ke';
				END IF;
			END IF;

			SELECT entity_id INTO v_entity_id
			FROM entitys
			WHERE (trim(lower(user_name)) = NEW.applicant_email);
			
			IF(v_entity_id is null)THEN
				SELECT entity_type_id INTO v_entity_type_id
				FROM entity_types 
				WHERE (org_id = v_org_id) AND (use_key_id = 4);

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id,
					entity_name, user_name, primary_email, 
					primary_telephone, function_role)
				VALUES (NEW.entity_id, v_org_id, v_entity_type_id, 4, 
					v_applicant_name, NEW.applicant_email, NEW.applicant_email,
					NEW.applicant_phone, 'applicant');
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;
		
		SELECT sys_email_id INTO v_sys_email_id
		FROM sys_emails
		WHERE (use_type = 1) AND (org_id = NEW.org_id);

		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name, email_type)
		VALUES (v_sys_email_id, NEW.org_id, NEW.entity_id, 'applicant', 1);
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = v_applicant_name, primary_email = NEW.applicant_email
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_applicants BEFORE INSERT OR UPDATE ON applicants
	FOR EACH ROW EXECUTE PROCEDURE ins_applicants();


