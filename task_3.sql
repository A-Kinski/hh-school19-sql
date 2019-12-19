SELECT area_id, avg_from_query.avg_from, avg_to_query.avg_to, avg_sum_query.avg_sum
FROM
       (SELECT area_id,
               (sum(
                    case when compensation_gross
                         then compensation_from
                         else compensation_from * 0.87 end
                    ) / count(*)) as avg_from
       FROM vacancy_body WHERE compensation_from IS NOT NULL AND compensation_from <> 0
       GROUP BY area_id) as avg_from_query
       JOIN
       (SELECT area_id,
               (sum(
                    case when compensation_gross
                         then compensation_to
                         else compensation_to * 0.87 end
                    ) / count(*)) as avg_to from vacancy_body WHERE compensation_from IS NOT NULL AND compensation_to <> 0
       GROUP BY area_id) as avg_to_query
       USING (area_id)
       JOIN
       (SELECT area_id,
               (sum(
                    ((case when compensation_gross
                         then compensation_to
                         else compensation_to * 0.87 end) +
                    (case when compensation_gross
                         then compensation_from
                         else compensation_from * 0.87 end)) / 2
                    ) / count(*)) as avg_sum from vacancy_body
                    WHERE compensation_to IS NOT NULL
                          AND compensation_to <> 0
                          AND compensation_from IS NOT NULL
                          AND  compensation_from <> 0
       GROUP BY area_id) as avg_sum_query
       USING (area_id)
ORDER BY area_id;