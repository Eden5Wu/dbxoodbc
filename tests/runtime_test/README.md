# Runtime regression tests

Set `DBXOODBC_TEST_CONNECTION` in the current process to a SQL Server test
connection string, then run:

```powershell
.\Run.ps1 -BdsPath D:\RADStudio\22.0
```

The runner builds and tests Win32 and Win64 separately. The ODBC driver specified
in the connection string must be installed for each tested platform. No credentials
are stored in source files or printed by the test.

Coverage includes date/time parameters, timestamp milliseconds, BCD, NULL versus
empty strings, long ANSI/Unicode text, BLOB length and random/chunked byte access,
row-cache reset, output/input-output parameters, return values, timestamp offsets,
output truncation and command reuse. High-level `TSQLQuery` tests insert and read
back parameters, then verify affected row counts, commit and rollback.
Tests create and drop only SQL Server session-local temporary tables/procedures;
they do not create permanent database objects or modify application table rows.

Output parameters are available after execution without result sets, or after
consuming all result sets with `GetNextReader` until it returns `nil`. Specify
`Size` for variable-length output parameters; truncation is reported as an error.

Variable-length column data is cached for the current row to support DBX byte
offsets. Memory usage therefore scales with the values read from that row.
Unicode SQL types now use DBX Unicode strings/memos. Projects with persistent
ANSI field components for those columns should regenerate their field definitions.
