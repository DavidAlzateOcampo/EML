--------------------------------
-- run against systemdb database
--------------------------------

-- check EML AFL component is installed
SELECT * FROM "SYS"."AFL_AREAS" WHERE AREA_NAME = 'EML';
SELECT * FROM "SYS"."AFL_PACKAGES" WHERE AREA_NAME = 'EML';
SELECT * FROM "SYS"."AFL_FUNCTIONS" WHERE AREA_NAME = 'EML';

-- check tenant database exists and is started
SELECT * FROM SYS.M_DATABASES;

-- add script server to tenant database
ALTER DATABASE HXE ADD 'scriptserver';


------------------------------
-- run against tenant database
------------------------------

-- check script server
SELECT * FROM SYS.M_SERVICES;

-- create user
CREATE USER EMLUSER PASSWORD Password1;

-- authorize EML administration
GRANT MONITORING TO EMLUSER;
GRANT CREATE REMOTE SOURCE TO EMLUSER;
GRANT SELECT, UPDATE, INSERT, DELETE ON _SYS_AFL.EML_MODEL_CONFIGURATION TO EMLUSER;

-- authorize creation & removal of EML procedures
GRANT AFLPM_CREATOR_ERASER_EXECUTE TO EMLUSER;

-- authorize execution of EML procedures
GRANT AFL__SYS_AFL_EML_EXECUTE TO EMLUSER;
