/* task 1*/

/* create vacancy_body table*/
CREATE TABLE vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    name varchar(220) DEFAULT ''::varchar NOT NULL,
    text text,
    area_id integer,
    address_id integer,
    work_experience integer DEFAULT 0 NOT NULL,
    compensation_from bigint DEFAULT 0,
    compensation_to bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_gross boolean,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

/* create vacancy table*/
CREATE TABLE vacancy (
    vacancy_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    vacancy_body_id INTEGER REFERENCES vacancy_body(vacancy_body_id),
    area_id integer
);

/* create tabel users*/
CREATE TABLE users (
       user_id serial PRIMARY KEY,
       last_name varchar(255) NOT NULL,
       first_name varchar(255) NOT NULL,
       middle_name varchar(255),
       phone varchar(50),
       email varchar(255),
       city varchar(255),
       area_id INTEGER,
       birthday date,
       sex boolean NOT NULL,
       citezenship varchar(255) NOT NULL
);

/* create table resume */
CREATE TABLE resume (
       resume_id SERIAL PRIMARY KEY,
       title varchar(255) nit null,
       user_id INTEGER REFERENCES users(user_id) NOT NULL,
       work_experience integer DEFAULT 0 NOT NULL,
       work_schedule_type integer DEFAULT 0 NOT NULL,
       compensation_from bigint DEFAULT 0,
       compensation_to bigint DEFAULT 0,
       text text,
       create_time timestamp NOT NULL,
       disabled boolean DEFAULT false NOT NULL,
       visible boolean DEFAULT true NOT NULL,
       CONSTRAINT resume_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

/* create table specialization*/
CREATE TABLE specialization (
       specialization_id SERIAL PRIMARY KEY,
       name varchar(255) NOT NULL
);

/* create communication tables*/
CREATE TABLE vacancy_body_specialization (
    vacancy_body_specialization_id SERIAL PRIMARY KEY,
    vacancy_body_id integer REFERENCES vacancy_body(vacancy_body_id) NOT NULL,
    specialization_id integer REFERENCES specialization(specialization_id) NOT NULL
);

CREATE TABLE resume_specialization (
    resume_specialization_id SERIAL PRIMARY KEY,
    resume_id integer REFERENCES resume(resume_id) NOT NULL,
    specialization_id integer REFERENCES specialization(specialization_id) NOT NULL
);

CREATE TABLE vacancy_resume (
    vacancy_resume_id SERIAL PRIMARY KEY,
    vacancy_id integer REFERENCES vacancy(vacancy_id) NOT NULL,
    resume_id integer REFERENCES resume(resume_id) NOT NULL,
    creation_date timestamp NOT NULL
);