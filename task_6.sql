WITH tmp AS (
     SELECT
           resume.resume_id as r_id,
           vacancy_body_specialization.specialization_id as spec_id,
           count(vacancy_body_specialization.specialization_id) as c
      FROM
          resume
          JOIN vacancy_resume USING (resume_id)
          JOIN vacancy USING (vacancy_id)
          JOIN vacancy_body_specialization USING (vacancy_body_id)
      GROUP BY r_id, spec_id)
SELECT
      r_id,
      ARRAY_AGG(resume_specialization.specialization_id) as spec,
      specialization.name,
      max(c)
FROM
      tmp
      JOIN
      resume_specialization ON (tmp.r_id = resume_specialization.resume_id)
      JOIN vacancy_resume ON (tmp.r_id = vacancy_resume.resume_id)
      JOIN specialization ON (spec_id = specialization.specialization_id)
GROUP BY r_id, specialization.name
;