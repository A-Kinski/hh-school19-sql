SELECT
      (SELECT
             EXTRACT (MONTH FROM creation_time) as month
      FROM vacancy
      GROUP BY EXTRACT (MONTH FROM creation_time)
      ORDER BY count(*) DESC LIMIT 1
      ) as vacancy,
      (SELECT
             EXTRACT (MONTH FROM create_time) as month
      FROM resume
      GROUP BY EXTRACT (MONTH FROM create_time)
      ORDER BY count(*) DESC LIMIT 1
      ) as resume;