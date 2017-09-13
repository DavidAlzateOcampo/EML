-- clean up
DROP REMOTE SOURCE "TensorFlowModelServer";
DROP TABLE "PARAMETERS";
DELETE FROM "_SYS_AFL"."EML_MODEL_CONFIGURATION" WHERE "Parameter"='RemoteSource' and "Value"='TensorFlowModelServer';

-- create remote source
CREATE REMOTE SOURCE "TensorFlowModelServer" ADAPTER "grpc" CONFIGURATION 'server=0.0.0.0;port=9000';

-- register model
INSERT INTO "_SYS_AFL"."EML_MODEL_CONFIGURATION" VALUES ('mnist', 'RemoteSource', 'TensorFlowModelServer');
SELECT * FROM "_SYS_AFL"."EML_MODEL_CONFIGURATION";

-- create parameters table (used in subsequent calls)
CREATE TABLE "PARAMETERS" ("Parameter" VARCHAR(100), "Value" VARCHAR(100));

-- apply registered models
CALL "_SYS_AFL"."EML_CTL_PROC" ('UpdateModelConfiguration', "PARAMETERS", ?);

-- verify model is up and running on remote source
INSERT INTO "PARAMETERS" VALUES ('Model', 'mnist');
CALL "_SYS_AFL"."EML_CHECKDESTINATION_PROC" ("PARAMETERS", ?);
