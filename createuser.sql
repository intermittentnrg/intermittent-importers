-- Create a group
CREATE ROLE intermittency;

-- Grant access to existing tables
GRANT USAGE ON SCHEMA public TO intermittency;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO intermittency;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO intermittency;

-- Create a final user with password
CREATE USER readonly WITH PASSWORD 'readonly';
GRANT intermittency TO readonly;
