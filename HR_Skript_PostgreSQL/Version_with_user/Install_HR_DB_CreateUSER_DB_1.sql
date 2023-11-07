/*============================================================================
  File:     Install_HR_DB_CreateUSER_DB_1

  Summary:  Creates the HR sample database -Step1:
		Create User HR und Create Database Kurs

  Date:     16.11.2013
  Updated:  30.08.2022		
===========================================================================*/

-- ****************************************
-- Create User HR
-- ****************************************



CREATE ROLE hr WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:mssMZqgQamtw8FYvi2ixLA==$djvxq6/tQTZZrKkmPBVQtL5h1gYhQDs9xVF7uW+MneQ=:U41D/3O6jRSeas2VxZLvzJ7PT0dF6Oyt1FuVPjJG6jI=';

COMMENT ON ROLE hr IS 'DB-User für Schema';


-- ****************************************
-- Create Database
-- ****************************************


--CREATE DATABASE "HR"
--    WITH
--    OWNER = hr
--    ENCODING = 'UTF8'
--    LC_COLLATE = 'German_Germany.1252'
--    LC_CTYPE = 'German_Germany.1252'
--    TABLESPACE = pg_default
--    CONNECTION LIMIT = -1
--    IS_TEMPLATE = False;

