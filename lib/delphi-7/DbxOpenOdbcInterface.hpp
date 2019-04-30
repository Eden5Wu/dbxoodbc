// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcInterface.pas' rev: 6.00

#ifndef DbxOpenOdbcInterfaceHPP
#define DbxOpenOdbcInterfaceHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Classes.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcinterface
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TConnectionOption { coSafeMode, coInternalCloneConnection, coBlobChunkSize, coNetwrkPacketSize, coReadOnly, coCatalogPrefix, coConTimeout, coNumericSeparator, coConnectionString, coSupportsMetadata, coSupportsCatalog, coSupportsSchemaFilter, coMapInt64ToBcd, coMapSmallBcdToNative, coIgnoreUnknownFieldType, coMapCharAsBDE, coEnableBCD, coMaxBCD, coEnableUnicode, coSupportsAutoInc, coFldReadOnly, coTrimChar, coEmptyStrParam, coNullStrParam, coNullStrAsEmpty, coParamDateByOdbcLevel3, coBCD2Exp, coMixedFetch, coBlobFragmentation, coBlobNotTerminationChar, coNetTimeout, coLockMode, coSPSN, coTLSTO, coOBPBPL, coCFC, coVendorLib, coMDCase };
#pragma option pop

#pragma option push -b-
enum TConnectionOptionType { cot_Bool, cot_String, cot_Int, cot_UInt, cot_Char };
#pragma option pop

typedef AnsiString TConnectionOptionsNames[38];

typedef TConnectionOptionType TConnectionOptionsTypes[38];

#pragma option push -b-
enum TOptionSwitches { osDefault, osOff, osOn };
#pragma option pop

typedef TOptionSwitches TConnectionOptions[38];

typedef TOptionSwitches *PConnectionOptions;

typedef AnsiString TOptionSwitchesNames[3];

typedef void __fastcall (*TRegisterDbXpressLib)(void);

#pragma option push -b-
enum TXSQLDriverOption { xeDrvBlobSize, xeDrvCallBack, xeDrvCallBackInfo, xeDrvRestrict, xeDrvVersion, xeDrvProductVersion };
#pragma option pop

typedef Set<TXSQLDriverOption, xeDrvBlobSize, xeDrvProductVersion>  TSetOfXSQLDriverOption;

#pragma option push -b-
enum TXSQLConnectionOption { xeConnAutoCommit, xeConnBlockingMode, xeConnBlobSize, xeConnRoleName, xeConnWaitOnLocks, xeConnCommitRetain, xeConnTxnIsoLevel, xeConnNativeHandle, xeConnServerVersion, xeConnCallBack, xeConnHostName, xeConnDatabaseName, xeConnCallBackInfo, xeConnObjectMode, xeConnMaxActiveComm, xeConnServerCharSet, xeConnSqlDialect, xeConnRollbackRetain, xeConnObjectQuoteChar, xeConnConnectionName, xeConnOSAuthentication, xeConnSupportsTransaction, xeConnMultipleTransaction, xeConnServerPort, xeConnOnLine, xeConnTrimChar, xeConnQualifiedName, xeConnCatalogName, xeConnSchemaName, xeConnObjectName, xeConnQuotedObjectName, xeConnCustomInfo, xeConnTimeout, xeConnConnectionString, xeConnTDSPacketSize, xeConnClientHostName, xeConnClientAppName, xeConnCompressed, xeConnEncrypted, xeConnPrepareSQL, xeConnDecimalSeparator, xe41, xeVendorProperty };
#pragma option pop

typedef Set<TXSQLConnectionOption, xeConnAutoCommit, xeVendorProperty>  TSetOfXSQLConnectionOption;

#pragma option push -b-
enum TXSQLCommandOption { xeCommRowsetSize, xeCommBlobSize, xeCommBlockRead, xeCommBlockWrite, xeCommParamCount, xeCommNativeHandle, xeCommCursorName, xeCommStoredProc, xeCommSQLDialect, xeCommTransactionID, xeCommPackageName, xeCommTrimChar, xeCommQualifiedName, xeCommCatalogName, xeCommSchemaName, xeCommObjectName, xeCommQuotedObjectName, xeCommPrepareSQL, xeCommDecimalSeparator };
#pragma option pop

typedef Set<TXSQLCommandOption, xeCommRowsetSize, xeCommDecimalSeparator>  TSetOfXSQLCommandOption;

#pragma option push -b-
enum TXSQLMetaDataOption { xeMetaCatalogName, xeMetaSchemaName, xeMetaDatabaseName, xeMetaDatabaseVersion, xeMetaTransactionIsoLevel, xeMetaSupportsTransaction, xeMetaMaxObjectNameLength, xeMetaMaxColumnsInTable, xeMetaMaxColumnsInSelect, xeMetaMaxRowSize, xeMetaMaxSQLLength, xeMetaObjectQuoteChar, xeMetaSQLEscapeChar, xeMetaProcSupportsCursor, xeMetaProcSupportsCursors, xeMetaSupportsTransactions, xeMetaPackageName, xeMetaDefaultSchemaName };
#pragma option pop

typedef Set<TXSQLMetaDataOption, xeMetaCatalogName, xeMetaDefaultSchemaName>  TSetOfXSQLMetaDataOption;

#pragma option push -b-
enum TOdbcDriverType { eOdbcDriverTypeUnspecified, eOdbcDriverTypeGupta, eOdbcDriverTypeMsSqlServer, eOdbcDriverTypeMsSqlServer2005Up, eOdbcDriverTypeIbmDb2, eOdbcDriverTypeIbmDb2AS400, eOdbcDriverTypeMsJet, eOdbcDriverTypeMySql, eOdbcDriverTypeMySql3, eOdbcDriverTypeInterbase, eOdbcDriverTypeInformix, eOdbcDriverTypeOracle, eOdbcDriverTypeSybase, eOdbcDriverTypeSQLite, eOdbcDriverTypeThinkSQL, eOdbcDriverTypeMerantOle, eOdbcDriverTypePervasive, eOdbcDriverTypeNexusDbFlashFiler, eOdbcDriverTypePostgreSQL, eOdbcDriverTypeInterSystemCache, eOdbcDriverTypeMerantDBASE, eOdbcDriverTypeSAPDB, eOdbcDriverTypeParadox, eOdbcDriverTypeFoxPro, eOdbcDriverTypeClipper, eOdbcDriverTypeBtrieve, eOdbcDriverTypeOpenIngres, eOdbcDriverTypeProgress, eOdbcDriverTypeOterroRBase };
#pragma option pop

#pragma option push -b-
enum TDbmsType { eDbmsTypeUnspecified, eDbmsTypeGupta, eDbmsTypeMsSqlServer, eDbmsTypeMsSqlServer2005Up, eDbmsTypeIbmDb2, eDbmsTypeIbmDb2AS400, eDbmsTypeMySql, eDbmsTypeMySqlMax, eDbmsTypeMsAccess, eDbmsTypeExcel, eDbmsTypeText, eDbmsTypeDBase, eDbmsTypeParadox, eDbmsTypeOracle, eDbmsTypeInterbase, eDbmsTypeInformix, eDbmsTypeSybase, eDbmsTypeSQLite, eDbmsTypeThinkSQL, eDbmsTypeSapDb, eDbmsTypePervasiveSQL, eDbmsTypeFlashFiler, eDbmsTypePostgreSQL, eDbmsTypeInterSystemCache, eDbmsTypeFoxPro, eDbmsTypeClipper, eDbmsTypeBtrieve, eDbmsTypeOpenIngres, eDbmsTypeProgress, eDbmsTypeOterroRBase };
#pragma option pop

__interface ISqlDriverOdbc;
typedef System::DelphiInterface<ISqlDriverOdbc> _di_ISqlDriverOdbc;
__interface  INTERFACE_UUID("{C623831B-3006-41F1-B151-08FB9F0E8942}") ISqlDriverOdbc  : public IInterface 
{
	
public:
	virtual bool __stdcall GetOdbcDrivers(WideString &ADriverList) = 0 ;
};

__interface ISqlConnectionOdbc;
typedef System::DelphiInterface<ISqlConnectionOdbc> _di_ISqlConnectionOdbc;
__interface  INTERFACE_UUID("{136DD9D1-9B9C-4355-9AEF-959662CB095E}") ISqlConnectionOdbc  : public IInterface 
{
	
public:
	virtual AnsiString __stdcall GetDbmsName(void) = 0 ;
	virtual TDbmsType __stdcall GetDbmsType(void) = 0 ;
	virtual AnsiString __stdcall GetDbmsVersionString(void) = 0 ;
	virtual int __stdcall GetDbmsVersionMajor(void) = 0 ;
	virtual int __stdcall GetDbmsVersionMinor(void) = 0 ;
	virtual int __stdcall GetDbmsVersionRelease(void) = 0 ;
	virtual char * __stdcall GetLastOdbcSqlState(void) = 0 ;
	virtual void __stdcall GetOdbcConnectStrings(Classes::TStrings* ConnectStringList) = 0 ;
	virtual AnsiString __stdcall GetOdbcDriverName(void) = 0 ;
	virtual TOdbcDriverType __stdcall GetOdbcDriverType(void) = 0 ;
	virtual AnsiString __stdcall GetOdbcDriverVersionString(void) = 0 ;
	virtual int __stdcall GetOdbcDriverVersionMajor(void) = 0 ;
	virtual int __stdcall GetOdbcDriverVersionMinor(void) = 0 ;
	virtual int __stdcall GetOdbcDriverVersionRelease(void) = 0 ;
	virtual int __stdcall GetDbmsVersionBuild(void) = 0 ;
	virtual int __stdcall GetOdbcDriverVersionBuild(void) = 0 ;
	virtual bool __stdcall GetCursorPreserved(void) = 0 ;
	virtual bool __stdcall GetIsSystemODBCManager(void) = 0 ;
	virtual int __stdcall GetOdbcDriverLevel(void) = 0 ;
	virtual bool __stdcall GetSupportsSqlPrimaryKeys(void) = 0 ;
	virtual int __stdcall GetStatementsPerConnection(void) = 0 ;
	virtual void * __stdcall GetEnvironmentHandle(void) = 0 ;
	virtual void * __stdcall GetConnectionHandle(void) = 0 ;
	virtual System::_di_IInterface __stdcall GetOdbcApiIntf(void) = 0 ;
	virtual char __stdcall GetDecimalSeparator(void) = 0 ;
};

__interface ISqlCommandOdbc;
typedef System::DelphiInterface<ISqlCommandOdbc> _di_ISqlCommandOdbc;
__interface  INTERFACE_UUID("{136DD9D1-9B9C-4355-9AEF-959662CB095F}") ISqlCommandOdbc  : public IInterface 
{
	
public:
	virtual void __stdcall Cancel(void) = 0 ;
	virtual bool __stdcall SetLockTimeout(int TimeoutSeconds) = 0 ;
	virtual int __stdcall GetLockTimeout(void) = 0 ;
};

__interface ISequentialStream;
typedef System::DelphiInterface<ISequentialStream> _di_ISequentialStream;
__interface  INTERFACE_UUID("{0C733A30-2A1C-11CE-ADE5-00AA0044773D}") ISequentialStream  : public IInterface 
{
	
public:
	virtual HRESULT __stdcall Read(void * pv, int cb, PLongint pcbRead) = 0 ;
	virtual HRESULT __stdcall Write(void * pv, int cb, PLongint pcbWritten) = 0 ;
};

__interface IBlobChunkCollection;
typedef System::DelphiInterface<IBlobChunkCollection> _di_IBlobChunkCollection;
__interface  INTERFACE_UUID("{A4A8C6A2-786D-4DF7-938D-BC9301232BC8}") IBlobChunkCollection  : public IInterface 
{
	
public:
	virtual __int64 __stdcall GetSize(void) = 0 ;
	virtual void __stdcall Read(void * &Buffer) = 0 ;
	virtual __int64 __stdcall ReadBlobToVariant(/* out */ Variant &Data) = 0 ;
	virtual __int64 __stdcall ReadBlobToStream(_di_ISequentialStream Stream) = 0 ;
	virtual void __stdcall Clear(void) = 0 ;
};

#pragma option push -b-
enum TOdbcApiType { oaAnsi, oaAnsiToUnicode, oaUnicode, oaUnicodeToAnsi };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
#pragma error Unsupported symbol type (23, DbxOpenOdbcInterface)
static const Shortint DBXERR_MISSINGPARAMINSQL = 0x1a;
static const Shortint DBXERR_NOTIMPLEMENT = 0x1b;
static const Shortint DBXERR_DRIVERINCOMPATIBLE = 0x1c;
static const Shortint fldWIDESTRING = 0x1a;
static const Shortint fldstWIDEMEMO = 0x20;
#define DECIMALSEPARATOR "Decimal Separator"
extern PACKAGE AnsiString cConnectionOptionsNames[38];
extern PACKAGE TConnectionOptionType cConnectionOptionsTypes[38];
extern PACKAGE AnsiString cConnectionOptionsDescs[38];
extern PACKAGE AnsiString cOptionSwitchesNames[3];
static const char cOptCharDefault = '\x58';
static const char cOptCharFalse = '\x30';
static const char cOptCharTrue = '\x31';
extern PACKAGE TSetOfXSQLDriverOption cXSQLDriverOptionStringTypes;
extern PACKAGE TSetOfXSQLConnectionOption cXSQLConnectionOptionStringTypes;
extern PACKAGE TSetOfXSQLCommandOption cXSQLCommandOptionStringTypes;
extern PACKAGE TSetOfXSQLMetaDataOption cXSQLMetaDataOptionStringTypes;
extern PACKAGE System::ResourceString _rsNotSpecifiedDNSName;
#define Dbxopenodbcinterface_rsNotSpecifiedDNSName System::LoadResourceString(&Dbxopenodbcinterface::_rsNotSpecifiedDNSName)
extern PACKAGE void __fastcall RegisterDbXpressLibA(void);
extern PACKAGE void __fastcall RegisterDbXpressLibAW(void);
extern PACKAGE void __fastcall RegisterDbXpressLibW(void);
extern PACKAGE void __fastcall RegisterDbXpressLibWA(void);
extern PACKAGE void __fastcall RegisterDbXpressLibProc(TRegisterDbXpressLib RegProc, TOdbcApiType OdbcApiType);

}	/* namespace Dbxopenodbcinterface */
using namespace Dbxopenodbcinterface;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxOpenOdbcInterface
