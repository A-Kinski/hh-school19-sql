/* fill specialization table*/
INSERT INTO specialization(name)
SELECT 'spec name'||spec_num FROM generate_series(1,100)
as g(spec_num);

/* fill users table */

INSERT INTO users
(last_name, first_name, sex, citezenship)
SELECT
    (SELECT string_agg(
        substr(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),'')
    FROM generate_series(1, 1 + (random() * 5 + i % 10)::integer) AS last_name),

    (SELECT string_agg(
        substr(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),'')
    FROM generate_series(1, 1 + (random() * 3 + i % 10)::integer) AS first_name),

    (SELECT (random() > 0.5) AS sex),

    (SELECT string_agg(
        substr(
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),'')
    FROM generate_series(1, 1 + (random() * 2 + i % 10)::integer) AS citezenship)
 FROM generate_series(1, 100) AS g(i);

 /* fill vacancy_body table*/

INSERT INTO vacancy_body(
    company_name, name, text, area_id, address_id, work_experience,
    compensation_from, compensation_to, test_solution_required,
    work_schedule_type, employment_type, compensation_gross
)
SELECT
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),
        '')
    FROM generate_series(1, 1 + (random() * 150 + i % 10)::integer)) AS company_name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),
        '')
    FROM generate_series(1, 1 + (random() * 220 + i % 10)::integer)) AS name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            (random() * 77)::integer + 1, 1
        ),
        '')
    FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer)) AS text,

    (random() * 1000)::integer AS area_id,
    (random() * 50000)::integer AS address_id,
    floor(random()*(60-1+1))+1 AS work_experience,
    25000 + (random() * 150000)::int AS compensation_from,
    case when random() > 0.5 then 25000 + (random() * 150000)::int end as compensation_to,
    (random() > 0.5) AS test_solution_required,
    floor(random() * 5)::int AS work_schedule_type,
    floor(random() * 5)::int AS employment_type,
    (random() > 0.5) AS compensation_gross
FROM generate_series(1, 10000) AS g(i);


INSERT INTO vacancy (creation_time, expire_time, employer_id, disabled, visible, vacancy_body_id, area_id)
SELECT
    -- random in last 5 years
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
    (random() * 1000000)::integer AS employer_id,
    (random() > 0.5) AS disabled,
    (random() > 0.5) AS visible,
    floor(random()*(10122-123+1))+123 as vacancy_body_id,
    (random() * 1000)::int AS area_id
FROM generate_series(1, 10000) AS g(i);

DELETE FROM vacancy WHERE expire_time <= creation_time;
alter sequence vacancy_vacancy_id_seq restart with 1;
update vacancy set vacancy_id = nextval('vacancy_vacancy_id_seq');

/* fill resume table */

INSERT INTO resume (user_id, work_experience, work_schedule_type, compensation_from, compensation_to,
                   text, create_time, disabled, visible)
SELECT
      floor(random()*(103-4+1))+4 as user_id,
      floor(random()*(60-1+1))+1 AS work_experience,
      floor(random() * 5)::int AS work_schedule_type,
      25000 + (random() * 150000)::int AS compensation_from,
      case when random() > 0.5 then 25000 + (random() * 150000)::int end as compensation_to,
      (SELECT string_agg(
                  substr(
                   '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer + 1, 1
                   ),
            '')
      FROM generate_series(1, 1 + (random() * 255 + i % 10)::integer)) AS text,
      now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS create_time,
      (random() > 0.5) AS disabled,
      (random() > 0.5) AS visible
FROM generate_series(1, 100000) AS g(i);

/* fill vacancy_resume table */
INSERT INTO vacancy_resume (vacancy_id, resume_id)
SELECT
      floor(random()*(10000-1+1))+1 as vacancy_id,
      floor(random()*(100000-1+1))+1 as resume_id
FROM generate_series(1, 50000) AS g(i);

/* fill resume_specialization table */
INSERT INTO resume_specialization (resume_id, specialization_id)
SELECT
      floor(random()*(100000-1+1))+1 as resume_id,
      floor(random()*(100-1+1))+1 as spezialization_id
FROM generate_series(1, 50000) AS g(i);

/* fill vacancy_body_specialization table */
INSERT INTO vacancy_body_specialization (vacancy_body_id, specialization_id)
SELECT
      floor(random()*(10122-123+1))+123 as vacancy_body_id,
      floor(random()*(100-1+1))+1 as spezialization_id
FROM generate_series(1, 50000) AS g(i);