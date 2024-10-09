-- Add up migration script here

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE status_enum AS ENUM ('Request received', 'Email sent', 'Email response received', 'Proving', 'Performing on chain transaction', 'Finished');

CREATE TABLE IF NOT EXISTS requests (
    id UUID PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4()),
    status status_enum NOT NULL DEFAULT 'Request received',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS expected_replies (
    message_id VARCHAR(255) PRIMARY KEY,
    request_id VARCHAR(255),
    has_reply BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);