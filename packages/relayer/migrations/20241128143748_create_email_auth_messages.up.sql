CREATE TABLE email_auth_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_id TEXT NOT NULL,
    request_id TEXT NOT NULL,
    command_params TEXT[] NOT NULL,
    skipped_command_prefix TEXT NOT NULL,
    domain_name TEXT NOT NULL,
    public_key_hash BYTEA NOT NULL,
    timestamp TEXT NOT NULL,
    masked_command TEXT NOT NULL,
    email_nullifier BYTEA NOT NULL,
    account_salt BYTEA NOT NULL,
    is_code_exist BOOLEAN NOT NULL,
    proof TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_email_auth_messages_request_id ON email_auth_messages(request_id);
CREATE INDEX idx_email_auth_messages_created_at ON email_auth_messages(created_at);