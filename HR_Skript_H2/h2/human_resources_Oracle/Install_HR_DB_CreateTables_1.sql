/*============================================================================
  File:     Install_HR_DB_CreateTables_2.sql

  Summary:  Creates the HR sample database - Step 2:
		Create Schema HR und Tabellen in der jeweils aktuellen Database

  Date:     16.11.2013
  Updated:	
===========================================================================*/



-- ****************************************
-- Create Schema
-- ****************************************


CREATE SCHEMA HR;


-- ******************************************************
-- Create tables
-- ******************************************************


-- ********************************************************************
-- Create the REGIONS table to hold region information for locations
-- HR.LOCATIONS table has a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.regions
    ( region_id      DECIMAL  
		CONSTRAINT region_id_nn NOT NULL,
      region_name    VARCHAR(25),
      CONSTRAINT reg_id_pk
       		 PRIMARY KEY (region_id)
    );
 


-- ********************************************************************
-- Create the COUNTRIES table to hold country information for customers
-- and company locations. 
-- OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR(40) 
    , region_id       DECIMAL 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id)
    , CONSTRAINT countr_reg_fk
        	 FOREIGN KEY (region_id)
          	  REFERENCES HR.regions(region_id)
    );
  


-- ********************************************************************
-- Create the LOCATIONS table to hold address information for company departments.
-- HR.DEPARTMENTS has a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.locations
    ( location_id    DECIMAL(4)
    , street_address VARCHAR(40)
    , postal_code    VARCHAR(12)
    , city       VARCHAR(30)
		CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR(25)
    , country_id     CHAR(2)
    , CONSTRAINT loc_id_pk
       		 PRIMARY KEY (location_id)
    , CONSTRAINT loc_c_id_fk
       		 FOREIGN KEY (country_id)
        	  REFERENCES HR.countries(country_id) 
    ) ;


-- ********************************************************************
-- Create the DEPARTMENTS table to hold company department information.
-- HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.departments
    ( department_id    DECIMAL(4)
    , department_name  VARCHAR(30)
		CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       DECIMAL(6)
    , location_id      DECIMAL(4)
    , CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
    , CONSTRAINT dept_loc_fk
       		 FOREIGN KEY (location_id)
        	  REFERENCES HR.locations (location_id)
    ) ;



-- ********************************************************************
-- Create the JOBS table to hold the different names of job roles within the company.
-- HR.EMPLOYEES has a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.jobs
    ( job_id         VARCHAR(10)
    , job_title      VARCHAR(35)
		CONSTRAINT     job_title_nn  NOT NULL
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

CREATE TABLE HR.employees
    ( employee_id    DECIMAL(6)
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25)
		CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR(25)
    , phone_number   VARCHAR(20)
    , hire_date      TIMESTAMP
		CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR(10)
		CONSTRAINT     emp_job_nn  NOT NULL
    , salary         DECIMAL(8,2)
    , commission_pct DECIMAL(2,2)
    , manager_id     DECIMAL(6)
    , department_id  DECIMAL(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES HR.departments
    , CONSTRAINT     emp_job_fk
                     FOREIGN KEY (job_id)
                      REFERENCES HR.jobs (job_id)
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES HR.employees
    ) ;



-- ALTER TABLE HR.departments
-- ADD  CONSTRAINT dept_mgr_fk
--       		 FOREIGN KEY (manager_id)
--       		  REFERENCES HR.employees (employee_id)
--      ;



-- ********************************************************************
-- Create the JOB_HISTORY table to hold the history of jobs that 
-- employees have held in the past.
-- HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.
-- ********************************************************************

CREATE TABLE HR.job_history
    ( employee_id   DECIMAL(6)
		CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    TIMESTAMP
		CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      TIMESTAMP
		CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR(10)
		CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id DECIMAL(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    , CONSTRAINT jhist_emp_id_st_date_pk
		PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     jhist_job_fk
                     FOREIGN KEY (job_id)
                     REFERENCES HR.jobs
    , CONSTRAINT     jhist_emp_fk
                     FOREIGN KEY (employee_id)
                     REFERENCES HR.employees
    , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES HR.departments
    ) ;
 


-- ********************************************************************
-- Create the EMP_DETAILS_VIEW that joins the employees, jobs, 
-- departments, jobs, countries, and locations table to provide details
-- about employees.
-- ********************************************************************


CREATE VIEW HR.emp_details_view
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
  HR.employees e,
  HR.departments d,
  HR.jobs j,
  HR.locations l,
  HR.countries c,
  HR.regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id 
;
