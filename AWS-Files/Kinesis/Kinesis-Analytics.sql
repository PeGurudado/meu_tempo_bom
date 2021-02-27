-- Performs a continuous filter based on a WHERE condition.
--          .----------.   .----------.   .----------.              
--          |  SOURCE  |   |  INSERT  |   |  DESTIN. |              
-- Source-->|  STREAM  |-->| & SELECT |-->|  STREAM  |-->Destination
--          |          |   |  (PUMP)  |   |          |              
--          '----------'   '----------'   '----------'               
-- STREAM (in-application): a continuously updated entity that you can SELECT from and INSERT into like a TABLE
-- PUMP: an entity used to continuously 'SELECT ... FROM' a source STREAM, and INSERT SQL results into an output STREAM
-- Create output stream, which can be used to send to a destination



CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (HEAT_INDEX DECIMAL(4,1), DC_NOME VARCHAR(64), TEM_INS DECIMAL(4,1), UMD_INS INTEGER);

-- -- Create pump to insert into output 
CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"


SELECT STREAM HEAT_INDEX, DC_NOME, TEM_INS, UMD_INS FROM SOURCE_SQL_STREAM_001;
