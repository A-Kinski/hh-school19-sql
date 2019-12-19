create or replace function get_explain(in qry text, out r text) returns setof text as $$
begin
  for r in execute qry loop
    raise info '%', r;
    return next;
  end loop;
  return;
end; $$ language plpgsql;

begin;
copy (select get_explain('explain (analyze)
  WITH agg AS (
     SELECT
           resume_id,
           array_agg(name) as arr
     FROM
         resume_specialization
     JOIN
         specialization
     USING (specialization_id)
     GROUP BY resume_id
), tmp AS (
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
), tmp2 AS (
	SELECT
	   resume_id,
	   specialization_id,
	   ROW_NUMBER() OVER (PARTITION BY resume_id ORDER BY tmp.c DESC) as rank
    FROM tmp
	ORDER BY resume_id, specialization_id
), often AS (
	SELECT
          resume_id,
          specialization.name as name
    FROM tmp2
    JOIN specialization USING (specialization_id)
    WHERE rank = 1
)
SELECT often.resume_id, agg.arr, often.name
FROM agg RIGHT JOIN often ON agg.resume_id = often.resume_id
ORDER BY often.resume_id;
')) to '/tmp/task_6_plan.txt';
select get_explain('explain (analyze, format xml) select 1;');
rollback;