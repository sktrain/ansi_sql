/*============================================================================
  File:     Install_HR_DB.sql

  Summary:  Creates the HR sample database.

  Date:     16.11.2013
  Updated:	
===========================================================================*/


-- ****************************************
-- Create Database
-- ****************************************

--CREATE DATABASE HR;


--USE HR;



-- ******************************************************
-- Create tables
-- ******************************************************


-- ********************************************************************
-- Create the REGIONS table to hold region information for locations
-- HR.LOCATIONS table has a foreign key to this table.
-- ********************************************************************

CREATE TABLE regions
    ( region_id      int  NOT NULL,
      region_name    VARCHAR(25),
      CONSTRAINT reg_id_pk
       		 PRIMARY KEY (region_id)
    );
 


-- ********************************************************************
-- Create the COUNTRIES table to hold country information for customers
-- and company locations. 
-- OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.
-- ********************************************************************

CREATE TABLE countries 
    ( country_id      CHAR(2) NOT NULL 
    , country_name    VARCHAR(40) 
    , region_id       int 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id)
    , CONSTRAINT countr_reg_fk
        	 FOREIGN KEY (region_id)
          	  REFERENCES regions(region_id)
    );
 


-- ********************************************************************
-- Create the LOCATIONS table to hold address information for company departments.
-- HR.DEPARTMENTS has a foreign key to this table.
-- ********************************************************************

CREATE TABLE locations
    ( location_id    DECIMAL(4)
    , street_address VARCHAR(40)
    , postal_code    VARCHAR(12)
    , city       VARCHAR(30)  NOT NULL
    , state_province VARCHAR(25)
    , country_id     CHAR(2)
    , CONSTRAINT loc_id_pk
       		 PRIMARY KEY (location_id)
    , CONSTRAINT loc_c_id_fk
       		 FOREIGN KEY (country_id)
        	  REFERENCES countries(country_id) 
    ) ;

-- ********************************************************************
-- Create the DEPARTMENTS table to hold company department information.
-- HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.
-- ********************************************************************

CREATE TABLE departments
    ( department_id    DECIMAL(4)
    , department_name  VARCHAR(30)  NOT NULL
    , manager_id       DECIMAL(6)
    , location_id      DECIMAL(4)
    , CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
    , CONSTRAINT dept_loc_fk
       		 FOREIGN KEY (location_id)
        	  REFERENCES locations (location_id)
    ) ;



-- ********************************************************************
-- Create the JOBS table to hold the different names of job roles within the company.
-- HR.EMPLOYEES has a foreign key to this table.
-- ********************************************************************

CREATE TABLE jobs
    ( job_id         VARCHAR(10)
    , job_title      VARCHAR(35)  NOT NULL
    , min_salary     DECIMAL(6)
    , max_salary     DECIMAL(6)
    , CONSTRAINT job_id_pk
      		 PRIMARY KEY(job_id)
    ) ;



-- ********************************************************************
-- Create the EMPLOYEES table to hold the employee personnel 
-- information for the company.
-- HR.EMPLOYEES has a self referencing foreign key to this table.
-- ********************************************************************

CREATE TABLE employees
    ( employee_id    DECIMAL(6)
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25) NOT NULL
    , email          VARCHAR(25) NOT NULL
    , phone_number   VARCHAR(20)
    , hire_date      DATETIME    NOT NULL
    , job_id         VARCHAR(10) NOT NULL
    , salary         DECIMAL(8,2)
    , commission_pct DECIMAL(2,2)
    , manager_id     DECIMAL(6)
    , department_id  DECIMAL(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    , CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
   , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES departments (department_id)
    , CONSTRAINT     emp_job_fk
                     FOREIGN KEY (job_id)
                      REFERENCES jobs (job_id)
    ) ;



ALTER TABLE employees
ADD  CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees (employee_id);




-- ALTER TABLE departments
-- ADD  CONSTRAINT dept_mgr_fk
--       		 FOREIGN KEY (manager_id)
--       		  REFERENCES employees (employee_id)
--      ;



-- ********************************************************************
-- Create the JOB_HISTORY table to hold the history of jobs that 
-- employees have held in the past.
-- HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.
-- ********************************************************************

CREATE TABLE job_history
    ( employee_id   DECIMAL(6) NOT NULL
    , start_date    DATETIME  NOT NULL
    , end_date      DATETIME  NOT NULL
    , job_id        VARCHAR(10)  NOT NULL
    , department_id DECIMAL(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    , CONSTRAINT jhist_emp_id_st_date_pk
		PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     jhist_job_fk
                     FOREIGN KEY (job_id)
                     REFERENCES jobs (job_id)
    , CONSTRAINT     jhist_emp_fk
                     FOREIGN KEY (employee_id)
                     REFERENCES employees (employee_id)
    , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments (department_id)
    ) ;



-- ********************************************************************
-- Create the EMP_DETAILS_VIEW that joins the employees, jobs, 
-- departments, jobs, countries, and locations table to provide details
-- about employees.
-- ********************************************************************


CREATE VIEW emp_details_view
  (employee_id,
   job_id,
   manager_id,
   department_id,
   location_id,
   country_id,
   first_name,
   last_name,
   salary,
   commission_pct,
   department_name,
   job_title,
   city,
   state_province,
   country_name,
   region_name)
AS SELECT
  e.employee_id, 
  e.job_id, 
  e.manager_id, 
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  employees e,
  departments d,
  jobs j,
  locations l,
  countries c,
  regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id 
;



