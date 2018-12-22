-- CREATE table tickets (
--   id serial primary key,
--   title varchar(255) not null,
--   description varchar(255) not null,
--   reporter_id integer not null,
--   assignee_id integer not null,
--   archived boolean default false,
--   status integer default 0,
--   expire_date date,
--   creation_date timestamp default NOW(),
--   updated_at timestamp
-- );

-- Table: public.tickets

DROP TABLE public.tickets;

CREATE TABLE public.tickets
(
  id serial primary key,
  title character varying NOT NULL,
  description character varying NOT NULL,
  created_by integer,
  assignees_id integer[],
  expire_date date,
  creation_date timestamp without time zone DEFAULT now(),
  archived boolean DEFAULT false,
  status integer DEFAULT 0,
  updated_at timestamp without time zone,
  updated_by integer
);

insert into tickets (title, description, created_by, assignees_id)
values ('test', 'nuovo ticket', 2, '{3,4,5}');

update tickets set description = 'old ticket', updated_by = 4 where id = <>;

DROP TABLE public.documents;

CREATE TABLE public.documents
(
  id serial primary key,
  title varchar,
  body_text text,
  share_with integer[],
  archived boolean default false,
  created_by integer,
  updated_by integer,
  created_at date default now(),
  update_at timestamp
);

-- Table: public.comments

-- DROP TABLE public.comments;

CREATE TABLE public.comments
(
  id serial primary key,
  ticket_id integer,
  account_id integer,
  body_text character varying,
  creation_date date DEFAULT ('now'::text)::date,
  updated_at timestamp without time zone
);

CREATE OR REPLACE FUNCTION notify_ticket_changes()
RETURNS trigger AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    PERFORM pg_notify(
      'tickets_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'tickets',
        'record', row_to_json(OLD)
      )::text
    );
    RETURN OLD;
  ELSE
    PERFORM pg_notify(
      'tickets_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'tickets',
        'record', row_to_json(NEW)
      )::text
    );
    RETURN NEW;
  END IF;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;

-- NEW — Data type RECORD; a variable holding the new database row for INSERT/UPDATE operations in row-level triggers.
-- TG_OP — Data type text; a string of INSERT, UPDATE, DELETE, or TRUNCATE telling for which operation the trigger was fired.

DROP TRIGGER IF EXISTS tickets_changed on tickets;

CREATE TRIGGER tickets_changed
AFTER INSERT OR UPDATE OR DELETE
ON tickets
FOR EACH ROW
EXECUTE PROCEDURE notify_ticket_changes()

CREATE OR REPLACE FUNCTION notify_document_changes()
RETURNS trigger AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    PERFORM pg_notify(
      'documents_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'documents',
        'record', row_to_json(OLD)
      )::text
    );
    RETURN OLD;
  ELSE
    PERFORM pg_notify(
      'documents_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'documents',
        'record', row_to_json(NEW)
      )::text
    );
    RETURN NEW;
  END IF;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;

-- NEW — Data type RECORD; a variable holding the new database row for INSERT/UPDATE operations in row-level triggers.
-- TG_OP — Data type text; a string of INSERT, UPDATE, DELETE, or TRUNCATE telling for which operation the trigger was fired.

DROP TRIGGER IF EXISTS documents_changed on tickets;

CREATE TRIGGER documents_changed
AFTER INSERT OR UPDATE OR DELETE
ON documents
FOR EACH ROW
EXECUTE PROCEDURE notify_document_changes()

CREATE OR REPLACE FUNCTION notify_comment_changes()
RETURNS trigger AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    PERFORM pg_notify(
      'comments_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'comments',
        'record', row_to_json(OLD)
      )::text
    );
    RETURN OLD;
  ELSE
    PERFORM pg_notify(
      'comments_changed',
      json_build_object(
        'operation', TG_OP,
        'table', 'comments',
        'record', row_to_json(NEW)
      )::text
    );
    RETURN NEW;
  END IF;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;

-- NEW — Data type RECORD; a variable holding the new database row for INSERT/UPDATE operations in row-level triggers.
-- TG_OP — Data type text; a string of INSERT, UPDATE, DELETE, or TRUNCATE telling for which operation the trigger was fired.

DROP TRIGGER IF EXISTS comments_changed on comments;

CREATE TRIGGER comments_changed
AFTER INSERT OR UPDATE OR DELETE
ON comments
FOR EACH ROW
EXECUTE PROCEDURE notify_comment_changes();
