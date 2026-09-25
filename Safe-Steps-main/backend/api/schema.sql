CREATE TABLE IF NOT EXISTS visitors (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    purpose VARCHAR(255) NOT NULL DEFAULT '',
    location VARCHAR(150) NOT NULL,
    host_name VARCHAR(150) NOT NULL DEFAULT '',
    contact_number VARCHAR(50) NOT NULL DEFAULT '',
    check_in TIMESTAMPTZ NOT NULL,
    check_out TIMESTAMPTZ NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT valid_visitor_status
        CHECK (
            status IN ('Active', 'Complete')
        )
);

CREATE INDEX IF NOT EXISTS
    idx_visitors_email
ON visitors(email);

CREATE INDEX IF NOT EXISTS
    idx_visitors_check_in
ON visitors(check_in DESC);