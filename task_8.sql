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

SELECT resume_id, last_change_time, jsonb_extract_path(old, 'title') as old_title, title
FROM resume
JOIN
resume_archive
USING (resume_id)
WHERE resume_id = 1;
