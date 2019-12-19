CREATE TABLE IF NOT EXISTS resume_archive (
       archive_id serial not null,
       resume_id integer not null,
       operation_type varchar(1) not null,
       last_change_time timestamp not null,
       old jsonb not null);

CREATE OR REPLACE FUNCTION process_resume_change() RETURNS TRIGGER AS $resume_change$
BEGIN
     IF (TG_OP = 'DELETE') THEN
        INSERT INTO resume_archive (resume_id, operation_type, last_change_time, old)
               SELECT
                     OLD.resume_id,
                     'D',
                     now(),
                     to_jsonb(OLD.*);
     ELSIF (TG_OP = 'UPDATE') THEN
           INSERT INTO resume_archive (resume_id, operation_type, last_change_time, old)
               SELECT
                     OLD.resume_id,
                     'U',
                     now(),
                     to_jsonb(OLD.*);
     END IF;
     RETURN NULL;
END;
$resume_change$ LANGUAGE plpgsql;

CREATE TRIGGER tr_resume_change
AFTER UPDATE OR DELETE ON resume
FOR EACH ROW EXECUTE PROCEDURE process_resume_change();

WITH union_table AS
(
 SELECT
       resume_id,
       create_time,
       now() as last_change_time,
       title as old_title,
       NULL as new_title
 FROM resume WHERE resume_id = 1
UNION
 SELECT
       resume_id,
       (jsonb_extract_path(old, 'create_time')->>0)::timestamp as create_time,
       last_change_time,
       (jsonb_extract_path(old, 'title')->>0)::text as old_title,
       NULL AS new_title
 FROM resume_archive WHERE resume_id = 1)
SELECT
      resume_id,
      CASE
          WHEN ROW_NUMBER() OVER (ORDER BY last_change_time) = 1
               THEN create_time
          ELSE LAG(last_change_time) OVER (ORDER BY last_change_time)
      END as last_change_time,
      old_title,
      CASE
          WHEN ROW_NUMBER() OVER (ORDER BY last_change_time) = (SELECT count(*) FROM union_table)
               THEN NULL
          ELSE LEAD(old_title) OVER (ORDER BY last_change_time)
      END AS new_title
FROM union_table;
