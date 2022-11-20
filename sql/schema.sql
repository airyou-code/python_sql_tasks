----------------------------------------------------------------------------------
-- CREATE TABLE
----------------------------------------------------------------------------------

CREATE TABLE Domain
(
  id SERIAL PRIMARY KEY,
  name CHARACTER VARYING(63) UNIQUE,
  dataReg DATE NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  dataDel DATE CHECK(dataDel > dataReg) 
);

CREATE TABLE Domain_flag
(
  Domain_name CHARACTER VARYING(63) NOT NULL REFERENCES Domain(name) ON DELETE CASCADE,
  id SERIAL PRIMARY KEY,
  expired BOOLEAN DEFAULT false,
  outzone BOOLEAN DEFAULT false,
  delete_candidate BOOLEAN DEFAULT false,
  dataTimeCreate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
  
----------------------------------------------------------------------------------
-- Insert Rows
----------------------------------------------------------------------------------
  
INSERT INTO Domain (name, dataReg, dataDel) VALUES ('tablexia.cz', '2013-05-23', '2023-05-23');
INSERT INTO Domain_flag (Domain_name, expired) VALUES ('tablexia.cz', true);
INSERT INTO Domain_flag (Domain_name, expired) VALUES ('tablexia.cz', false);

INSERT INTO Domain (name) VALUES ('home.cz');
INSERT INTO Domain_flag (Domain_name, outzone, expired) VALUES ('home.cz', false, true);
INSERT INTO Domain_flag (Domain_name, outzone, expired) VALUES ('home.cz', true, false);
INSERT INTO Domain_flag (Domain_name, outzone, expired) VALUES ('home.cz', false, true);

----------------------------------------------------------------------------------
-- Queries
----------------------------------------------------------------------------------

-- Write a SELECT query which will return fully qualified domain name of domains which are currently 
-- (at the time query is run) registered and do not have and active (valid) expiration (EXPIRED) flag.
SELECT Domain_name as not_expired_domain
  FROM (SELECT MAX(D_flag.id) FROM Domain as D, Domain_flag as D_flag WHERE D.name = D_flag.Domain_name GROUP BY D.id) 
    as actual_f, Domain_flag
  WHERE Domain_flag.id = actual_f.max and Domain_flag.expired = false;
  
-- Write a SELECT query which will return fully qualified domain name of domains which have had active (valid) 
-- EXPIRED and OUTZONE flags (means both flags and not necessarily at the same time) in the past (relative to the query run time).
SELECT Domain_name
  FROM (SELECT MAX(D_flag.id) FROM Domain as D, Domain_flag as D_flag WHERE D.name = D_flag.Domain_name GROUP BY D.id) 
    as actual_f, Domain_flag
  WHERE Domain_flag.id = actual_f.max and (Domain_flag.expired = true or Domain_flag.outzone = true); 