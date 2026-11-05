# DBX4 Remastered — Data Explorer Integration

[繁體中文](README_TW.md)

This package contains a shared runtime package project and INI fragments for loading
DbxOpenOdbc into the Delphi IDE. The application's direct runtime usage in
[the main README, section 3](../../README.md) does not require this setup.

## Files

```text
packages/DataExplorer/
├── DbxOpenOdbcDataExplorer.dproj
├── DbxOpenOdbcDataExplorer.dpk
├── DbxOpenOdbcDataExplorer.res
├── ini/
│   ├── dbxdrivers.ini
│   └── dbxconnections.ini
├── tests/DataExplorerLoaderTest.dpr
├── Install.ps1
├── Build.ps1
├── README.md
└── README_TW.md
```

The package references the existing `source/` units and requires `rtl`, `dbrtl`
and `dbexpress` from the same Delphi installation. All supported DBMSs share this
driver BPL; `ConnectionString` selects the installed ODBC driver.

The directory and project are shared across versions. **Real-world IDE Data Explorer live connection, metadata schema inspection, and table browsing have been fully verified on Delphi 12 Athens (Win32).**
Because the RAD Studio IDE (`bds.exe`) itself is a 32-bit Windows process, **the Data Explorer design-time package is explicitly designated for Win32 (32-bit) operation**. Ensure matching 32-bit ODBC drivers are installed on the system (configured via `C:\Windows\SysWOW64\odbcad32.exe`). The table below identifies package names; it does not promise source or IDE compatibility with every listed release. Other compilers may require source changes, project conversion and separate validation.  





## Set LIB suffix for your Delphi version

Open [`DbxOpenOdbcDataExplorer.dproj`](DbxOpenOdbcDataExplorer.dproj),
then set **Project → Options → Description → LIB suffix**:

| Delphi version | LIB suffix | Product / directory version |
| --- | --- | --- |
| D10 Seattle (10.0) | `230` | `17.0` |
| D10.1 Berlin | `240` | `18.0` |
| D10.2 Tokyo | `250` | `19.0` |
| D10.3 Rio | `260` | `20.0` |
| D10.4 Sydney | `270` | `21.0` |
| D11 Alexandria | `280` | `22.0` |
| D12 Athens | `290` | `23.0` |
| D13 Florence | `370` | `37.0` |

Source: [Embarcadero compiler versions table](https://docwiki.embarcadero.com/RADStudio/Florence/en/Compiler_Versions_Table).
For later releases, use the official **Package Version**; do not assume the
suffix always increases by 10. D13 changed the numbering to `370`.

The project defaults to `280`. After changing the option and saving, verify both:

- `.dproj`: `<DllSuffix>280</DllSuffix>` (replace `280` with your version).
- `.dpk`: `{$LIBSUFFIX '280'}` (the same value).

The IDE's expected filename and the compiler's actual output must agree. For D11,
the filename is `DbxOpenOdbcDataExplorer280.bpl`; for D12 it is
`DbxOpenOdbcDataExplorer290.bpl`. Renaming an existing BPL does not make it
compatible with another Delphi version.

The platform is designated to match the **IDE process (Win32)**, and 32-bit ODBC drivers must be present. All current RAD Studio IDE versions (including Delphi 10, 11, and 12 Athens) run as **Win32** processes; therefore, the Data Explorer package is exclusively built and registered for **Win32**, even when your target end-user applications compile for Win64 (production Win64 applications compile directly from `source/` units and run independently of the 32-bit IDE Data Explorer).



## One-click Install & Build (Recommended)

Run `Install.bat` (or `Install.ps1`) to automatically detect your RAD Studio installation from the registry, synchronize project DllSuffix, compile the matching BPL, back up your IDE's `dbxdrivers.ini`, and register `DbxOpenOdbc` & `OpenOdbc` with the exact absolute path to the compiled BPL:

```cmd
:: One-click execution (automatically bypasses PowerShell ExecutionPolicy restrictions):
Install.bat

:: With verification:
Install.bat -Verify

:: Cleanly uninstall (remove registration from dbxdrivers.ini):
Install.bat -Uninstall
```

Or via PowerShell directly:

```powershell
# Auto-detect RAD Studio, compile, verify, and register in Data Explorer
.\Install.ps1 -Verify

# Or specify a custom RAD Studio path explicitly
.\Install.ps1 -BdsPath 'D:\RADStudio\22.0' -Verify

# Cleanly uninstall (remove registration from dbxdrivers.ini)
.\Install.ps1 -Uninstall
```

### Handling PowerShell ExecutionPolicy Restrictions

If your Windows environment restricts running `.ps1` scripts by default (`UnauthorizedAccess` error), choose any of the following approaches:

#### Recommended Method: Run the Batch File (Simplest)
Run `Install.bat` directly from Command Prompt or double-click it. It automatically runs PowerShell with safe bypass flags:
```cmd
Install.bat
```

#### Method 1: Single-Command Bypass (Safest, No System Changes)
Execute with the `-ExecutionPolicy Bypass` parameter directly:
```powershell
powershell -ExecutionPolicy Bypass -File .\Install.ps1
```
> **Advantage**: Applies only to this single invocation and does not alter any persistent system or user security policies.

#### Method 2: Scope to Current PowerShell Session
Unlock only the current terminal session before running:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Install.ps1
```
> **Advantage**: Takes effect only in the active window and automatically expires when the window closes.

---

## RAD Studio CLI (radstudio.exe) — Third-Party Build Helper

`Install.ps1` integrates the external open-source utility [Delphier/radstudio](https://github.com/Delphier/radstudio) (`radstudio.exe`) as an automated build and environment discovery helper.

> [!IMPORTANT]
> **Tool Identity Clarification**: `radstudio.exe` is a third-party open-source CLI developed by Delphier. It is **not** Embarcadero's official RAD Studio IDE (`bds.exe`), nor is it an Embarcadero installer.

### Why dbxoodbc Uses It
- **Delphi Community Edition (CE) Support**: Free Community Edition releases often restrict direct command-line compilation via `dcc32.exe` / `dcc64.exe` (raising *"This version of the product does not support command line compiling"*). `radstudio.exe` automatically falls back to driving `bds.exe` in the background for unattended package compilation without manual IDE interaction.
- **Dynamic Suffix & Environment Discovery**: Automatically detects installed BDS versions, installation roots (including custom drive letters like `D:\`), compiler versions, and package suffixes without relying on hardcoded static tables.

### Pinned Release & Integrity Verification
To guarantee reproducible builds and guard against supply-chain risks, `Install.ps1` pins an exact upstream release:
- **Upstream Repository**: https://github.com/Delphier/radstudio
- **Pinned Version**: `v1.0.4`
- **Release Download**: `https://github.com/Delphier/radstudio/releases/download/v1.0.4/radstudio-cli-1.0.4-x64.zip`
- **Release Archive SHA256**: `4a5b165516b7f04b49f4570fa423458a224d941ce3fdb52fbd5cde7c36c09523`

### Cache & Offline Behavior
1. **Local User Cache**: On first run, `Install.ps1` downloads the pinned ZIP, verifies the SHA256 checksum *before* extraction, and caches it under `%LOCALAPPDATA%\dbxoodbc\tools\radstudio-1.0.4\`.
2. **Offline Reuse**: Subsequent runs immediately reuse the cached executable without making network requests.
3. **Explicit CLI Override**: You can pass `-CliPath "C:\path\to\radstudio.exe"` or add it to system `PATH` to use your own binary.
4. **Native Toolchain Fallback**: If GitHub is unreachable (offline environment, proxy restrictions), pass `-SkipCli` or let `Install.ps1` automatically fall back to the native `Build.ps1` (DCC / MSBuild) toolchain.
5. **Manual Installation**: You can manually download the v1.0.4 zip, verify its SHA256, and extract `radstudio.exe` into `%LOCALAPPDATA%\dbxoodbc\tools\radstudio-1.0.4\`.

### Smart Toolchain Routing (Commercial vs Community Edition)
- **Commercial Editions (Professional, Enterprise, Architect)**: `Install.ps1` detects that command-line compilation is supported and routes compilation to the native `Build.ps1` (`dcc32.exe` / `dcc64.exe`) toolchain directly. This delivers sub-second compilation speeds, pure headless execution, and zero GUI popups.
- **Community Edition (CE) & Trial**: Because Embarcadero restricts standalone command-line compiler binaries in Community Edition, `Install.ps1` automatically routes the build to the native RAD Studio `bds.exe -b -ns` background batch build (compiling with the original project name for zero temporary artifacts and zero false alarms), with automatic `radstudio.exe bds` fallback.

### Community Edition (CE) "Save Changes" Prompt Behavior
- **Cause**: When the IDE/compiler loads a project whose format version (`<ProjectVersion>`) differs from the running IDE version (e.g. D11 format opened in D12 CE), Delphi automatically upgrades the project schema in memory, marking the project as modified. Because Embarcadero's `bds.exe` does not provide a command-line flag (such as `-nosave`) to suppress save confirmation dialogs on exit, a prompt appears asking whether to save changes.
- **User Choice**: You may choose either **Yes** or **No**. **Regardless of your choice, the BPL package was already successfully compiled and written to disk before the prompt appeared; your decision does not affect the installation result.**
- **Permanent Solution**: To suppress future prompts, click **Yes** when prompted, or open `DbxOpenOdbcDataExplorer.dproj` once in your Delphi IDE and choose **File → Save All**. Once saved with your IDE's native project version, subsequent background builds will exit silently without prompting.

### Build and verify only (without modifying IDE INI)

In the IDE, select **Release / Win32** and choose **Build**; or invoke `Build.ps1`:
Alternatively, from this package directory in PowerShell:

```powershell
.\Build.ps1 -BdsPath 'D:\RADStudio\22.0' -Platform Win32 -Verify
```

Use your own Delphi installation path and set LIB suffix first. The script checks
that `.dproj` and `.dpk` agree and that the installation has the matching RTL.
(Note: Data Explorer IDE packages only require Win32).

Output directories separate package versions and platforms:

```text
bin/<Platform>/<Configuration>/
build/<Platform>/<Configuration>/
```

For the default D11 Release build:

```text
bin/Win32/Release/DbxOpenOdbcDataExplorer<Suffix>.bpl
```

DCU/DCP files go into `build/`. Generated files are excluded from Git. Build from
source using your own Delphi installation.

`-Verify` loads the BPL through private INI fixtures in a separate host linked
with `rtl`, `dbrtl` and `dbexpress`, without linking the custom driver units. Both
`DbxOpenOdbc` and `OpenOdbc` must reach a normal ODBC error for a deliberately
nonexistent driver. It does not connect to a server, use credentials, or modify
IDE settings. Loading and connection construction are tested; database access and
Data Explorer metadata browsing must be tested separately.

## Configure the IDE

1. Close the IDE before replacing a BPL or editing its INIs.
2. Back up the IDE's `dbxdrivers.ini` and `dbxconnections.ini`. The default D11
   directory is:

   ```text
   C:\Users\Public\Documents\Embarcadero\Studio\dbExpress\22.0\
   ```

   This uses the product/directory version, not LIB suffix. For a customized
   installation, use the files actually configured in the IDE.
3. Keep the built BPL in a stable location. Merge [`ini/dbxdrivers.ini`](ini/dbxdrivers.ini)
   into the IDE file, preserving other drivers. Update existing `DbxOpenOdbc` and
   `OpenOdbc` sections instead of creating duplicates; merge `[Installed Drivers]`.
4. Set one `DriverPackageLoader` line in each driver section used. For D11:

   ```ini
   DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative,<absolute path to DbxOpenOdbcDataExplorer280.bpl>
   ```

   Replace the whole `<...>` part with the real path and filename, without quotes
   or brackets. The template's `280` is the D11 example; change it to your built
   filename for other versions. A filename alone requires its directory on the
   IDE's package/DLL search path. An absolute path avoids a global PATH change.
5. Optionally merge [`ini/dbxconnections.ini`](ini/dbxconnections.ini) and customize
   its server, database and ODBC driver, or create the connection in Data Explorer.
   The example uses Windows authentication.
6. Restart the IDE. Test connecting, then table/column browsing separately.
   A design-time `TSQLConnection.Connected = True` uses this same loaded driver;
   test that separately as well. Full metadata support remains subject to the
   driver's implementation and target database.

This is a runtime package dynamically loaded by DBX. Do not use
**Component → Install Packages** to install it as a component design package.
The BPL must remain at its configured path. Creating a connection entry does not
prove that its driver can load or connect.

## Metadata behavior

- Catalog, schema and object names are kept separate; a schema filter does not
  get reduced to the final object name.
- `TableScope` supports combinations of `tsTable`, `tsView`, `tsSysTable` and
  `tsSynonym`. The normal Delphi default is `[tsTable, tsView]`. An empty DBX
  type filter means all types, not an empty result.
- On SQL Server, read-only native catalog queries through ODBC classify objects
  using `sys.objects` and `is_ms_shipped`. SQL Server ODBC metadata, including
  Driver 17, can classify shipped tables as `TABLE` and procedures as functions;
  this behavior is not limited to the legacy driver.
- Other DBMSs use the standard ODBC catalog APIs, honoring supported namespace
  filters. Unsupported synonym/alias types return no corresponding objects.
- Tables, views, synonyms and procedures expose their DBX collection schemas.
  View definitions and synonym targets not supplied by these queries remain NULL.
  This does not claim full FireDAC feature parity.

See [`tests/metadata_test`](../../tests/metadata_test/README.md) for the regression
tests and the optional read-only SQL Server comparison.

## Troubleshooting

- **IDE requests a filename without the suffix:** check LIB suffix in both
  `.dproj` and `.dpk`, save, close and reopen the `.dproj`, then Build again.
  Do not rename the BPL to hide a name mismatch.
- **Class-only loader AV:** `DriverPackageLoader=TDBXOpenOdbcDriverLoaderNative`
  assumes the loader is already registered. In a fresh D11 host this can load
  `DBXCommonDriver280.bpl`, which lacks our loader, and trigger the reproduced
  `rtl280.bpl` read-of-`FFFFFFF4` AV before connecting. Specify the custom BPL path.
  Absolute crash addresses vary between processes.
- **Do not configure MetaDataPackageLoader (avoids "Parameter incorrect" or expansion AV):**
  `DbxOpenOdbc` uses a native DBX4 architecture where `DbxOpenOdbcDriver` handles protocol metadata
  commands directly, while `DbxOpenOdbcDataExplorerMetadata` registers with `TDBXMetaDataWriterFactory`.
  Configuration files (`dbxdrivers.ini` and `dbxconnections.ini`) must **not** include
  `MetaDataPackageLoader`. Specifying it triggers Win32 error 87 `Can't load package` (when omitting the
  BPL path) or an `Access Violation` when expanding Data Explorer tree nodes (due to a non-existent loader class).
- **Package load failure:** check path, Delphi version, platform, runtime
  dependencies and any older loaded copy.
  If the BPL exists but the error reports only its filename, set its absolute
  path in the `[DbxOpenOdbc]` or `[OpenOdbc]` section. Preserve the official
  `[Odbc]` section; it uses a different driver and loader.
- **Normal ODBC error:** check driver bitness, connection parameters and server
  access. Loading, connecting and metadata browsing are separate checks.

## Remove or update

Close the IDE. Restore backed-up INIs or remove only this demo's additions,
including example connections and `[Installed Drivers]` entries. Restore previous
settings for driver sections that existed before setup. Close all hosts and
remove/update references before deleting or replacing the BPL; then restart.

Official dbExpress deprecation and future compatibility risks are described in
[the main README, section 5](../../README.md).
