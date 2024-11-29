CREATE TABLE email_auth_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id TEXT NOT NULL,
    response JSONB NOT NULL
);

CREATE INDEX idx_email_auth_messages_request_id ON email_auth_messages(request_id);