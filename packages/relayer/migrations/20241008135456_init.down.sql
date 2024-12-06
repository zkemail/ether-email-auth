-- Add down migration script here

DROP TABLE IF EXISTS requests;

DROP TABLE IF EXISTS expected_replies;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status_enum') THEN
        DROP TYPE status_enum;
    END IF;
END $$;