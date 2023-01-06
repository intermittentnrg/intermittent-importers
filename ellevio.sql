CREATE SCHEMA ellevio;
GRANT USAGE ON SCHEMA ellevio TO readonly;
SET search_path = ellevio;

--ALTER DEFAULT PRIVILEGES FOR ROLE readonly IN SCHEMA intermittency
--GRANT SELECT ON TABLES TO readonly;

CREATE TABLE ellevio (time TIMESTAMP WITHOUT TIME ZONE NOT NULL PRIMARY KEY, value float not null);
SELECT create_hypertable('ellevio', 'time', migrate_data => true);
GRANT SELECT ON TABLE ellevio TO readonly;

\COPY ellevio (time,value) FROM Förbrukning-2022-12-fix.csv DELIMITER ';' CSV;
