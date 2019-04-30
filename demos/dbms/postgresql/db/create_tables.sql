-- DROP TABLE table_001;

CREATE TABLE table_001
(
  id numeric(9,0) NOT NULL,
  name name NOT NULL,
  txt text,
  CONSTRAINT table_001_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
--ALTER TABLE table_001
--  OWNER TO postgres;

-- Index: table_001_name

-- DROP INDEX table_001_name;

CREATE INDEX table_001_name
  ON table_001
  USING btree
  (name);
