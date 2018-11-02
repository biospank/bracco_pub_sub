CREATE OR REPLACE FUNCTION notify_ticket_changes()
RETURNS trigger AS $$
BEGIN
  PERFORM pg_notify(
    'tickets_changed',
    json_build_object(
      'operation', TG_OP,
      'record', row_to_json(NEW)
    )::text
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- NEW — Data type RECORD; a variable holding the new database row for INSERT/UPDATE operations in row-level triggers.
-- TG_OP — Data type text; a string of INSERT, UPDATE, DELETE, or TRUNCATE telling for which operation the trigger was fired.

CREATE TRIGGER tickets_changed
AFTER INSERT OR UPDATE
ON tickets
FOR EACH ROW
EXECUTE PROCEDURE notify_ticket_changes()
