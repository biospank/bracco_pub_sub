defmodule BraccoPubSub.Repo.Migrations.AddMessagesTrigger do
  use Ecto.Migration

  def change do

    execute """
      CREATE OR REPLACE FUNCTION notify_message_changes()
      RETURNS trigger AS $$
      BEGIN
        IF (TG_OP = 'INSERT') THEN
          PERFORM pg_notify(
            'messages_changed',
            json_build_object(
              'operation', TG_OP,
              'table', 'messages',
              'record', row_to_json(NEW)
            )::text
          );
          RETURN NEW;
        END IF;

        RETURN NULL;

      END;
      $$ LANGUAGE plpgsql;
    """

    execute """
      CREATE TRIGGER messages_changed
      AFTER INSERT
      ON messages
      FOR EACH ROW
      EXECUTE PROCEDURE notify_message_changes();
    """

  end
end
