SELECT
(WITH vacancy_month AS (
SELECT
      EXTRACT (MONTH FROM creation_time) as month,
      count(*) as count_vacancy
FROM vacancy
GROUP BY EXTRACT (MONTH FROM creation_time)
)
SELECT vacancy_month.month FROM vacancy_month ORDER BY vacancy_month.count_vacancy DESC LIMIT 1) as v,
(WITH resume_month AS (
SELECT
      EXTRACT (MONTH FROM create_time) as month,
      count(*) as count_resume
FROM resume
GROUP BY EXTRACT (MONTH FROM create_time)
)
SELECT resume_month.month FROM resume_month ORDER BY resume_month.count_resume DESC LIMIT 1) as r;

