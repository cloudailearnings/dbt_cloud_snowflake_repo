select current_role();

create user rd1606 password='abcd' must_change_password=false;

insert into employee values(1,'abc','abc@gmail.com');


CREATE MASKING POLICY email_mask AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('HR','FINANCE') THEN val
    ELSE CONCAT(SUBSTR(val,1,1),'***',RIGHT(val, LENGTH(val) - POSITION('@' IN val) + 1))
  END;

ALTER TABLE EMPLOYEE MODIFY COLUMN email SET MASKING POLICY email_mask;


USE ROLE SECURITYADMIN;

CREATE ROLE HR;

CREATE USER john_hr
  PASSWORD = 'Snowflake#123'
  LOGIN_NAME = 'john_hr'
  DEFAULT_ROLE = HR
  MUST_CHANGE_PASSWORD = false
  COMMENT = 'HR user for masking policy test';

  GRANT ROLE HR TO USER john_hr;

  --Give the Role Access to the Table (Required!)

  --Since HR needs to read the table:

  GRANT USAGE ON DATABASE dwh_db TO ROLE HR;

  GRANT USAGE ON SCHEMA dwh_sch TO ROLE HR;

  GRANT SELECT ON TABLE EMPLOYEE TO ROLE HR;

  GRANT ROLE HR TO USER john_hr;

  USE ROLE HR;
  SELECT email FROM HR.EMPLOYEES;

  USE ROLE PUBLIC;
  
  SELECT email FROM EMPLOYEE;

  

  