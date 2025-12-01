
CREATE TABLE sys_audit_trail (
	sys_audit_trail_id		serial primary key,
	user_id					varchar(50) not null,
	user_ip					varchar(50),
	change_date				timestamp default now() not null,
	table_name				varchar(50) not null,
	record_id				varchar(50) not null,
	change_type				varchar(50) not null,
	narrative				varchar(240)
);

CREATE TABLE sys_audit_details (
	sys_audit_trail_id		integer references sys_audit_trail primary key,
	old_value				text
);

CREATE TABLE sys_errors (
	sys_error_id			serial primary key,
	sys_error				varchar(240) not null,
	error_message			text not null
);

CREATE TABLE currency (
	currency_id				serial primary key,
	currency_name			varchar(50) not null,
	currency_symbol			varchar(3) not null
);

CREATE TABLE use_keys (
	use_key_id				integer primary key,
	use_key_name			varchar(32) not null,
	use_function			integer
);

CREATE TABLE sys_languages (
	sys_language_id			serial primary key,
	sys_language_name		varchar(50) not null unique
);

CREATE TABLE orgs (
	org_id					serial primary key,
	currency_id				integer,
	default_country_id		char(2),
	parent_org_id			integer references orgs,
	org_name				varchar(50) not null unique,
	org_full_name			varchar(120),
	org_sufix				varchar(32) not null unique,
	is_default				boolean default true not null,
	is_active				boolean default true not null,
	department_filter		boolean default false not null,
	deployment_filter		boolean default false not null,
	group_orgs				boolean default false not null,
	pin 					varchar(50),
	pcc						varchar(12),

	logo					varchar(50),
	letter_head				varchar(50),
	email_from				varchar(120),
	web_logos				boolean default false not null,
	logo_path				varchar(120),

	created					timestamp default current_timestamp not null,
	password_scheme			integer default 1 not null,
	no_of_users				integer default 1 not null,
	lock_phone_login		integer default 1 not null,
	system_key				varchar(64),
	system_identifier		varchar(64),
	MAC_address				varchar(64),
	public_key				bytea,
	license					bytea,

	details					text
);
CREATE INDEX orgs_currency_id ON orgs (currency_id);
CREATE INDEX orgs_parent_org_id ON orgs (parent_org_id);
CREATE INDEX orgs_default_country_id ON orgs(default_country_id);

CREATE TABLE entity_types (
	entity_type_id			serial primary key,
	use_key_id				integer not null references use_keys,
	org_id					integer references orgs,
	entity_type_name		varchar(50) not null,
	entity_role				varchar(240),
	start_view				varchar(120),
	group_email				varchar(120),
	description				text,
	details					text,
	UNIQUE(org_id, entity_type_name)
);
CREATE INDEX entity_types_use_key_id ON entity_types (use_key_id);
CREATE INDEX entity_types_org_id ON entity_types (org_id);

CREATE TABLE entitys (
	entity_id				serial primary key,
	entity_type_id			integer not null references entity_types,
	use_key_id				integer not null references use_keys,
	sys_language_id			integer,
	org_id					integer not null references orgs,
	entity_name				varchar(120) not null,
	user_name				varchar(120) not null unique,
	primary_email			varchar(120),
	primary_telephone		varchar(50),
	entity_tag				varchar(32),
	super_user				boolean default false not null,
	entity_leader			boolean default false not null,
	no_org					boolean default false not null,
	function_role			varchar(240),
	date_enroled			timestamp default now() not null,
	is_active				boolean default true,
	last_login				timestamp,
	entity_password			varchar(64) not null,
	first_password			varchar(64) not null,
	new_password			varchar(64),
	locked_phone_id			varchar(64),
	password_code			varchar(32),
	start_url				varchar(64),
	is_picked				boolean default false not null,
	locked_until			timestamp,
	details					text
);
CREATE INDEX entitys_entity_type_id ON entitys (entity_type_id);
CREATE INDEX entitys_use_key_id ON entitys (use_key_id);
CREATE INDEX entitys_user_name ON entitys (user_name);
CREATE INDEX entitys_sys_language_id ON entitys (sys_language_id);
CREATE INDEX entitys_org_id ON entitys (org_id);

CREATE TABLE entity_subscriptions (
	entity_subscription_id	serial primary key,
	entity_type_id			integer not null references entity_types,
	entity_id				integer not null references entitys,
	org_id					integer references orgs,
	details					text,
	UNIQUE(entity_id, entity_type_id)
);
CREATE INDEX entity_subscriptions_entity_type_id ON entity_subscriptions (entity_type_id);
CREATE INDEX entity_subscriptions_entity_id ON entity_subscriptions (entity_id);
CREATE INDEX entity_subscriptions_org_id ON entity_subscriptions (org_id);

CREATE TABLE entity_reset (
	entity_reset_id			serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	request_email			varchar(320),
	request_time			timestamp default now(),
	login_ip				varchar(64),
	device_serial_number	varchar(50),
	narrative				varchar(240)
);
CREATE INDEX entity_reset_entity_id ON entity_reset (entity_id);
CREATE INDEX entity_reset_org_id ON entity_reset (org_id);

CREATE TABLE sys_logins (
	sys_login_id			serial primary key,
	entity_id				integer references entitys,
	sys_app_id				integer,
	login_time				timestamp default now(),
	login_ip				varchar(64),
	device_serial_number	varchar(50),
	device_settings			varchar(320),
	correct_login			boolean default true not null,
	narrative				varchar(240)
);
CREATE INDEX sys_logins_entity_id ON sys_logins (entity_id);
CREATE INDEX sys_logins_sys_app_id ON sys_logins (sys_app_id);

CREATE TABLE sys_err_logins (
	sys_err_login_id		serial primary key,
	user_name				varchar(50),
	login_time				timestamp default now(),
	login_ip				varchar(64),
	device_serial_number	varchar(50)
);

CREATE TABLE sys_reset (
	sys_reset_id			serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	request_email			varchar(320),
	request_phone			varchar(120),
	password_code			varchar(32),
	request_time			timestamp default now(),
	login_ip				varchar(64),
	narrative				varchar(240)
);
CREATE INDEX sys_reset_entity_id ON sys_reset (entity_id);
CREATE INDEX sys_reset_org_id ON sys_reset (org_id);

CREATE TABLE sys_emails (
	sys_email_id			serial primary key,
	org_id					integer references orgs,
	use_type				integer default 1 not null,
	sys_email_name			varchar(50),
	default_email			varchar(320),
	title					varchar(240) not null,
	details					text,
	UNIQUE(org_id, use_type)
);
CREATE INDEX sys_emails_org_id ON sys_emails (org_id);

CREATE TABLE sys_emailed (
	sys_emailed_id			serial primary key,
	sys_email_id			integer references sys_emails,
	org_id					integer references orgs,
	entity_id				integer references entitys,
	table_id				integer,
	table_name				varchar(50),
	email_type				integer default 1 not null,
	email_code				integer default 1 not null,
	emailed					boolean default false not null,
	send_status				integer default 0 not null,
	created					timestamp default current_timestamp not null,
	narrative				varchar(240),
	mail_body				text
);
CREATE INDEX sys_emailed_sys_email_id ON sys_emailed (sys_email_id);
CREATE INDEX sys_emailed_entity_id ON sys_emailed (entity_id);
CREATE INDEX sys_emailed_org_id ON sys_emailed (org_id);
CREATE INDEX sys_emailed_table_id ON sys_emailed (table_id);
CREATE INDEX sys_emailed_email_type ON sys_emailed (email_type);

CREATE VIEW vw_sys_emailed AS
	SELECT sys_emails.sys_email_id, sys_emails.sys_email_name, 
		sys_emails.use_type, sys_emails.title, sys_emails.details,
		sys_emailed.sys_emailed_id, sys_emailed.org_id, sys_emailed.table_id, sys_emailed.table_name, 
		sys_emailed.email_type, sys_emailed.created, sys_emailed.emailed, sys_emailed.narrative
	FROM sys_emailed LEFT JOIN sys_emails ON sys_emailed.sys_email_id = sys_emails.sys_email_id;

CREATE VIEW vw_entity_types AS
	SELECT use_keys.use_key_id, use_keys.use_key_name, use_keys.use_function,
		entity_types.entity_type_id, entity_types.org_id, entity_types.entity_type_name,
		entity_types.entity_role, entity_types.start_view, entity_types.group_email,
		entity_types.description, entity_types.details
	FROM use_keys INNER JOIN entity_types ON use_keys.use_key_id = entity_types.use_key_id;

CREATE VIEW vw_entitys AS
	SELECT orgs.org_id, orgs.org_name, orgs.is_default as org_is_default,
		orgs.is_active as org_is_active, orgs.logo as org_logo,

		entity_types.entity_type_id, entity_types.entity_type_name, entity_types.entity_role,

		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader,
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password,
		entitys.function_role, entitys.use_key_id, entitys.primary_email, entitys.primary_telephone

	FROM entitys INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id
		INNER JOIN orgs ON entitys.org_id = orgs.org_id;

CREATE VIEW vw_entity_subscriptions AS
	SELECT entity_types.entity_type_id, entity_types.entity_type_name, entity_types.entity_role,
		entitys.entity_id, entitys.entity_name, entitys.user_name,
		entitys.primary_email, entitys.primary_telephone,
		eo.org_name as entity_org_name,
		entity_subscriptions.entity_subscription_id, entity_subscriptions.org_id, entity_subscriptions.details
	FROM entity_subscriptions INNER JOIN entity_types ON entity_subscriptions.entity_type_id = entity_types.entity_type_id
		INNER JOIN entitys ON entity_subscriptions.entity_id = entitys.entity_id
		INNER JOIN orgs eo ON entitys.org_id = eo.org_id;

CREATE VIEW tomcat_users AS
	SELECT entitys.user_name, entitys.entity_password, entity_types.entity_role
	FROM (entity_subscriptions INNER JOIN entitys ON entity_subscriptions.entity_id = entitys.entity_id)
		INNER JOIN entity_types ON entity_subscriptions.entity_type_id = entity_types.entity_type_id
	WHERE entitys.is_active = true;
	
CREATE VIEW vw_sys_logins AS
	SELECT entitys.entity_id, entitys.entity_name, 
		orgs.org_id, orgs.org_name,
		sys_logins.sys_login_id, sys_logins.login_time, sys_logins.login_ip, 
		sys_logins.device_serial_number, sys_logins.correct_login, sys_logins.narrative
	FROM sys_logins INNER JOIN entitys ON sys_logins.entity_id = entitys.entity_id
		INNER JOIN orgs ON entitys.org_id = orgs.org_id;

CREATE OR REPLACE FUNCTION get_org_name(integer) RETURNS varchar(50) AS $$
	SELECT orgs.org_name
	FROM orgs WHERE (orgs.org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_org_full_name(integer) RETURNS varchar(120) AS $$
	SELECT orgs.org_full_name
	FROM orgs WHERE (orgs.org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_org_logo(integer) RETURNS varchar(50) AS $$
	SELECT orgs.logo
	FROM orgs WHERE (orgs.org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_entity_name(integer) RETURNS varchar(50) AS $$
	SELECT entitys.entity_name
	FROM entitys WHERE (entitys.entity_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_entity_type_id(integer, integer) RETURNS int AS $$
	SELECT max(entity_type_id)
	FROM entity_types 
	WHERE (org_id = $1) AND (use_key_id = $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_org_letter_head(integer) RETURNS varchar(50) AS $$
	SELECT orgs.letter_head
	FROM orgs WHERE (orgs.org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION default_currency(varchar(16)) RETURNS integer AS $$
	SELECT orgs.currency_id
	FROM orgs INNER JOIN entitys ON orgs.org_id = entitys.org_id
	WHERE (entitys.entity_id = $1::int);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_sys_email_id(int, int) RETURNS integer AS $$
	SELECT max(sys_email_id)
	FROM sys_emails WHERE (org_id = $1) AND (use_type = $2);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION first_password() RETURNS varchar(12) AS $$
DECLARE
	rnd integer;
	passchange varchar(12);
BEGIN
	passchange := trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	passchange := passchange || trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);

	RETURN passchange;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION email_credentials(varchar(12), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id			integer;
	v_org_id			integer;
	v_sys_email_id		integer;
	msg					varchar(120);
BEGIN
	SELECT entity_id, org_id INTO v_entity_id, v_org_id
	FROM entitys WHERE (entity_id = $1::int);

	SELECT sys_email_id INTO v_sys_email_id
	FROM sys_emails WHERE (use_type = 3) AND (org_id = v_org_id);

	IF(v_sys_email_id is null)THEN
		msg := 'Ensure you have an email template setup';
	ELSE
		INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name)
		VALUES(v_org_id, v_sys_email_id, v_entity_id, 'entitys');

		msg := 'Emailed the credentials';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION email_to_username(varchar(12), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id			integer;
	v_email				varchar(120);
	v_user_name			varchar(120);
	msg					varchar(120);
BEGIN
	msg := 'Error changing email to username';

	SELECT entity_id, trim(lower(primary_email)) INTO v_entity_id, v_email
	FROM entitys WHERE (entity_id = $1::int);

	SELECT user_name INTO v_user_name
	FROM entitys WHERE (trim(lower(user_name)) = v_email);

	IF(v_email is null)THEN
		msg := 'Ensure you have an email entered';
	ELSIF(v_user_name is not null)THEN
		msg := 'There is an existing user with that email address as username';
	ELSE
		UPDATE entitys SET user_name = v_email WHERE entity_id = v_entity_id;
		msg := 'Email address updated to username';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION change_password(varchar(12), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	old_password 			varchar(64);
	v_entity_id				integer;
	v_pass_change			varchar(120);
	msg						varchar(120);
BEGIN
	msg := 'Password Error';
	v_entity_id := $1::int;

	SELECT Entity_password INTO old_password
	FROM entitys WHERE (entity_id = v_entity_id);

	IF ($2 = '0') THEN
		v_pass_change := first_password();
		UPDATE entitys SET first_password = v_pass_change, Entity_password = md5(v_pass_change)
		WHERE (entity_id = v_entity_id);
		msg := 'New Password Changed';
	ELSIF (old_password = md5($2)) THEN
		UPDATE entitys SET Entity_password = md5($3) WHERE (entity_id = v_entity_id);
		msg := 'Password Changed';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION password_check(varchar(12)) RETURNS integer AS $$
DECLARE
	v_org_id				integer;
	v_password_scheme		integer;
	v_entity_id				integer;
	v_password_okay			integer;
BEGIN

	SELECT org_id INTO v_org_id
	FROM entitys WHERE (entity_id = $1::int);

	SELECT password_scheme INTO v_password_scheme
	FROM orgs WHERE (org_id = v_org_id);

	v_password_okay := 1;

	IF (v_password_scheme = 2) THEN		---- Must change password
		SELECT entity_id INTO v_entity_id
		FROM entitys WHERE (entity_id = $1::int)
		AND (first_password = md5(entity_password));

		IF (v_entity_id is not null) THEN
			v_password_okay := 2;
		END IF;
	END IF;

	RETURN v_password_okay;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION change_password(varchar(12), varchar(32), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	old_password 		varchar(64);
	v_entity_id			integer;
	v_pass_change		varchar(120);
	msg					varchar(120);
BEGIN
	msg := 'Password Error';
	v_entity_id := $1::int;

	SELECT Entity_password INTO old_password
	FROM entitys WHERE (entity_id = v_entity_id);

	IF ($3 = '1') THEN
		v_pass_change := first_password();
		UPDATE entitys SET first_password = v_pass_change, Entity_password = md5(v_pass_change)
		WHERE (entity_id = v_entity_id);
		msg := 'Password Changed';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_password() RETURNS trigger AS $$
DECLARE
	v_entity_id		integer;
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM entitys
	WHERE (trim(lower(user_name)) = trim(lower(NEW.user_name)))
		AND entity_id <> NEW.entity_id;

	IF(v_entity_id is not null)THEN
		RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
	END IF;

	IF(TG_OP = 'INSERT') THEN
		IF(NEW.first_password is null)THEN
			NEW.first_password := first_password();
		END IF;

		IF (NEW.entity_password is null) THEN
			NEW.entity_password := md5(NEW.first_password);
		END IF;
	ELSIF(OLD.first_password <> NEW.first_password) THEN
		NEW.Entity_password := md5(NEW.first_password);
	END IF;

	IF(NEW.user_name is null)THEN
		SELECT lower(trim(org_sufix)) || '.' || lower(trim(replace(NEW.entity_name, ' ', ''))) INTO NEW.user_name
		FROM orgs
		WHERE org_id = NEW.org_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_password BEFORE INSERT OR UPDATE ON entitys
	FOR EACH ROW EXECUTE PROCEDURE ins_password();

CREATE OR REPLACE FUNCTION ins_entitys() RETURNS trigger AS $$
BEGIN

	IF(NEW.org_id is null)THEN
		RAISE EXCEPTION 'You have to select a valid organisation';
	END IF;

	SELECT use_key_id INTO NEW.use_key_id
	FROM entity_types
	WHERE (entity_type_id = NEW.entity_type_id);

	IF(NEW.sys_language_id is null)THEN
		NEW.sys_language_id := 0;
	END IF;
	
	IF(NEW.entity_tag is null)THEN
		NEW.entity_tag := LPAD(NEW.entity_id::text, 5, '0');
	END IF;
	
	NEW.entity_name := trim(NEW.entity_name);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_entitys BEFORE INSERT OR UPDATE ON entitys
	FOR EACH ROW EXECUTE PROCEDURE ins_entitys();

CREATE OR REPLACE FUNCTION aft_entitys() RETURNS trigger AS $$
BEGIN
	IF(NEW.entity_type_id is not null) THEN
		INSERT INTO entity_subscriptions (org_id, entity_type_id, entity_id)
		VALUES (NEW.org_id, NEW.entity_type_id, NEW.entity_id);
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_entitys AFTER INSERT ON entitys
	FOR EACH ROW EXECUTE PROCEDURE aft_entitys();

CREATE OR REPLACE FUNCTION add_sys_reset(varchar(120), varchar(120), varchar(64)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id			integer;
	v_org_id			integer;
	v_msg				varchar(120);
BEGIN

	SELECT entity_id, org_id INTO v_entity_id, v_org_id
	FROM entitys
	WHERE (lower(trim(primary_email)) = lower(trim($1)));

	IF(v_entity_id is null) THEN
		v_msg := 'Email not found';
	ELSE
		INSERT INTO sys_reset (entity_id, org_id, request_email, login_ip)
		VALUES (v_entity_id, v_org_id, $1, $3);

		v_msg := 'The password is being reset';
	END IF;

	return v_msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ins_sys_reset() RETURNS trigger AS $$
DECLARE
	v_sys_email_id		integer;
	v_password			varchar(32);
BEGIN
	SELECT entity_id, org_id INTO NEW.entity_id, NEW.org_id
	FROM entitys
	WHERE (lower(trim(primary_email)) = lower(trim(NEW.request_email)));

	IF(NEW.entity_id is not null) THEN
		v_password := upper(substring(md5(random()::text) from 3 for 9));

		UPDATE entitys SET first_password = v_password, entity_password = md5(v_password)
		WHERE entity_id = NEW.entity_id;

		SELECT sys_email_id INTO v_sys_email_id
		FROM sys_emails WHERE (use_type = 3) AND (org_id = NEW.org_id);

		INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name)
		VALUES(NEW.org_id, v_sys_email_id, NEW.entity_id, 'entitys');
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_sys_reset BEFORE INSERT ON sys_reset
	FOR EACH ROW EXECUTE PROCEDURE ins_sys_reset();

CREATE OR REPLACE FUNCTION password_validate(varchar(64), varchar(32)) RETURNS integer AS $$
DECLARE
	v_entity_id			integer;
	v_entity_password	varchar(64);
BEGIN

	SELECT entity_id, entity_password INTO v_entity_id, v_entity_password
	FROM entitys WHERE (user_name = $1);

	IF(v_entity_id is null)THEN
		v_entity_id = -1;
	ELSIF(md5($2) != v_entity_password) THEN
		v_entity_id = -1;
	END IF;

	return v_entity_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION password_validate(varchar(64), varchar(32), varchar(32), varchar(32)) RETURNS integer AS $$
DECLARE
	v_entity_id			integer;
	v_entity_password	varchar(64);
BEGIN

	SELECT entity_id, entity_password INTO v_entity_id, v_entity_password
	FROM entitys WHERE (user_name = $1);

	IF(v_entity_id is null)THEN
		v_entity_id = -1;
	ELSIF(md5($2) != v_entity_password) THEN
		INSERT INTO sys_logins (entity_id, login_ip, device_serial_number, correct_login)
		VALUES (v_entity_id, $3, $4, false);
		v_entity_id = -1;
	ELSE
		INSERT INTO sys_logins (entity_id, login_ip, device_serial_number, correct_login)
		VALUES (v_entity_id, $3, $4, true);
	END IF;

	return v_entity_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_link_entity(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id				integer;
	v_org_id				integer;
	msg		 				varchar(120);
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM entity_links WHERE (link_to_id = $1::int) AND (entity_id = $3::int);

	IF(v_entity_id is null)THEN
		SELECT org_id INTO v_org_id
		FROM entitys WHERE (entity_id = $3::int);

		INSERT INTO  entity_links (entity_id, link_to_id, org_id)
		VALUES ($3::int, $1::int, v_org_id);

		msg := 'Added a link';
	ELSE
		msg := 'Link already added';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION Emailed(integer, varchar(64)) RETURNS void AS $$
	UPDATE sys_emailed SET emailed = true WHERE (sys_emailed_id = $2::int);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION add_sys_login(varchar(120)) RETURNS integer AS $$
DECLARE
	v_sys_login_id			integer;
	v_entity_id				integer;
BEGIN
	SELECT entity_id INTO v_entity_id
	FROM entitys WHERE user_name = $1;

	v_sys_login_id := nextval('sys_logins_sys_login_id_seq');

	INSERT INTO sys_logins (sys_login_id, entity_id)
	VALUES (v_sys_login_id, v_entity_id);

	UPDATE entitys SET last_login = current_timestamp
	WHERE (entity_id = v_entity_id);

	return v_sys_login_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION err_sys_login(varchar(120), varchar(120)) RETURNS varchar(120) AS $$
BEGIN
	INSERT INTO sys_err_logins (user_name, login_ip)
	VALUES ($1, $2);

	return 'done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_sys_login(varchar(64), varchar(64), int, boolean) RETURNS integer AS $$
DECLARE
	v_sys_login_id			integer;
	v_entity_id				integer;
BEGIN
	SELECT entity_id INTO v_entity_id
	FROM entitys WHERE user_name = $1;
	
	IF($4 = true)THEN
		SELECT sys_login_id INTO v_sys_login_id
		FROM sys_logins
		WHERE (login_time::date = current_date) AND (entity_id = v_entity_id)
			AND (sys_app_id = $3);
	END IF;
	
	IF((v_entity_id is not null) AND (v_sys_login_id is null))THEN
		v_sys_login_id := nextval('sys_logins_sys_login_id_seq');

		INSERT INTO sys_logins (sys_login_id, entity_id, login_ip, sys_app_id)
		VALUES (v_sys_login_id, v_entity_id, $2, $3);
	END IF;

	UPDATE entitys SET last_login = current_timestamp
	WHERE (entity_id = v_entity_id);

	return v_sys_login_id;
END;
$$ LANGUAGE plpgsql;

INSERT INTO orgs (org_id, org_name, org_sufix, currency_id, logo, letter_head) VALUES
(0, 'default', 'dc', 1, 'logo.png', 'letter_head.jpg');

INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES
(0, 'System Admins', 0),
(1, 'Staff', 0),
(2, 'Client', 0),
(3, 'Supplier', 0),
(4, 'Applicant', 0),
(5, 'Subscription', 0),
(6, 'User', 0);

INSERT INTO entity_types (org_id, entity_type_id, entity_type_name, entity_role, use_key_id, start_view) VALUES
(0, 0, 'System Admins', 'sysadmin', 0, null),
(0, 1, 'Staff', 'staff', 1, null),
(0, 2, 'Client', 'client', 2, null),
(0, 3, 'Supplier', 'supplier', 3, null),
(0, 4, 'Applicant', 'applicant', 4, '10:0'),
(0, 5, 'Subscription', 'subscription', 5, null),
(0, 6, 'User', 'user', 6, null),
(0, 11, 'Repository', 'repository', 0, null);
SELECT pg_catalog.setval('entity_types_entity_type_id_seq', 11, true);

INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id, sys_language_id, user_name, entity_name, primary_email, entity_leader, super_user, no_org, first_password) VALUES
(0, 0, 0, 0, 0, 'root', 'root', 'root@localhost', true, true, false, 'baraza'),
(1, 0, 11, 0, 0, 'repository', 'repository', 'repository@localhost', true, false, false, 'baraza');
SELECT pg_catalog.setval('entitys_entity_id_seq', 1, true);

