SELECT often.resume_id, agg.arr, often.name
FROM
    (
     SELECT
           resume_id,
           array_agg(name) as arr
     FROM
         resume_specialization
     JOIN
         specialization
     USING (specialization_id)
     GROUP BY resume_id
    ) as agg
FULL JOIN
    (
    SELECT
          resume_id,
          specialization.name as name
    FROM
        (
         SELECT
               resume_id,
               specialization_id,
               rank() OVER (PARTITION BY resume_id ORDER BY tmp.c DESC) as rank
         FROM
             (
              SELECT
                    resume_id,
                    specialization_id,
                    count(specialization_id) as c
              FROM
                  vacancy_resume
                  JOIN vacancy USING (vacancy_id)
                  JOIN vacancy_body USING (vacancy_body_id)
                  JOIN vacancy_body_specialization USING (vacancy_body_id)
                  JOIN specialization USING (specialization_id)
              GROUP BY resume_id, specialization_id
              ) AS tmp
              ORDER BY resume_id, specialization_id
         ) AS tmp2
    JOIN specialization USING (specialization_id)
    WHERE rank = 1
    ) AS often
    ON (agg.resume_id = often.resume_id)
ORDER BY often.resume_id;