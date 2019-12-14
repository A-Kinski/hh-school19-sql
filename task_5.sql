SELECT vacancy_body.name
FROM
    vacancy
    JOIN
    (SELECT vac_id_table.vac_id as selected_vacancy_id FROM
            (
            SELECT COALESCE(count(*), 0) as response_count, vacancy_resume.vacancy_id as vac_id
            FROM
                vacancy
                JOIN
                vacancy_resume
                USING (vacancy_id)
            WHERE date_part('epoch', vacancy_resume.creation_date - vacancy.creation_time) < 7 * 24 * 3600
            GROUP BY vacancy_resume.vacancy_id) as vac_id_table
            WHERE vac_id_table.response_count < 5) as selected_vacancy
    ON (vacancy.vacancy_id = selected_vacancy.selected_vacancy_id)
    JOIN vacancy_body
    ON (vacancy.vacancy_body_id = vacancy_body.vacancy_body_id)
    ORDER BY vacancy_body.name
;