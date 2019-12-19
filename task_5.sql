WITH non_response_vacancy AS (
     SELECT vacancy_id
     FROM
         vacancy
         LEFT JOIN
         vacancy_resume
         USING (vacancy_id)
    GROUP BY vacancy.vacancy_id
    HAVING count(vacancy_resume.vacancy_id) = 0),
less_five_response_vacancy AS (
    SELECT vacancy_id
    FROM
        vacancy
        JOIN
        vacancy_resume
        USING (vacancy_id)
    WHERE date_part('day', vacancy_resume.creation_date - vacancy.creation_time) < 7 * 24 * 3600
    GROUP BY vacancy_id
    HAVING count(*) < 5
)
SELECT vacancy_body.name
FROM non_response_vacancy
     FULL JOIN
     less_five_response_vacancy
     USING (vacancy_id)
     JOIN
     vacancy
     USING (vacancy_id)
     JOIN vacancy_body
     USING (vacancy_body_id)
ORDER BY vacancy_body.name;