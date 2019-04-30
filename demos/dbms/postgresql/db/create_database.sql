-- Database: dbdemos_utf8

-- DROP DATABASE dbdemos_utf8;

CREATE DATABASE dbdemos_utf8
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Ukrainian, Ukraine'
       LC_CTYPE = 'Ukrainian, Ukraine'
       CONNECTION LIMIT = -1;
