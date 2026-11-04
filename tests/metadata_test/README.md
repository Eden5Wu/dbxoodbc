# DBX metadata regression tests

These console tests reference the existing driver source. Build the `.dpr` files
with your Delphi compiler; use separate output directories for Win32 and Win64.

## Local regression

`Dbx4MetadataTester.dpr` takes the absolute path to
`demos/dbms/msaccess/sql/dbdemos.mdb` and opens it read-only. It requires the
Microsoft Access ODBC driver matching the executable's bitness.

The in-memory fixtures validate all 16 combinations of table scope, DBX column
names, catalog/schema preservation, views, synonyms, procedure type/direction
conversions, NULL values, empty results and byte access. The live ODBC checks
exercise metadata routing and ordinary SQL. Unsupported optional Access ODBC
features are reported as `[SKIP]`, not successful feature tests.

## Read-only SQL Server comparison

`SqlServerMetadataTester.dpr` obtains its connection string from the process
environment variable `DBXOODBC_TEST_CONNECTION`. No server address, user name or
password is stored in the test source or sample INIs.

The test compares DBX metadata with read-only queries against the connected
database's `sys.tables`, `sys.views`, `sys.procedures`, `sys.synonyms` and
`sys.objects`. It checks schema filtering, ordinary versus system objects, and
all 16 `TableScope` combinations through both DBX commands and
`TSQLConnection.GetTableNames`. It does not execute stored procedures or read
application table rows.

The connected database's object visibility depends on the login permissions.

`OdbcCatalogProbe.dpr` uses the same environment variable and directly invokes
the ODBC catalog APIs, without DBX metadata conversion. It prints the actual
driver DLL/version and compares unfiltered, dbo and sys table enumeration.
This distinguishes ODBC's object classification from DBXOODBC's filtering.
