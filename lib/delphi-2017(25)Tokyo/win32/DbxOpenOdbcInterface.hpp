// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DbxOpenOdbcInterface.pas' rev: 32.00 (Windows)

#ifndef DbxopenodbcinterfaceHPP
#define DbxopenodbcinterfaceHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbxopenodbcinterface
{
//-- forward type declarations -----------------------------------------------
__interface ISqlDriverOdbc;
typedef System::DelphiInterface<ISqlDriverOdbc> _di_ISqlDriverOdbc;
__interface ISqlConnectionOdbc;
typedef System::DelphiInterface<ISqlConnectionOdbc> _di_ISqlConnectionOdbc;
__interface ISqlCommandOdbc;
typedef System::DelphiInterface<ISqlCommandOdbc> _di_ISqlCommandOdbc;
__interface ISequentialStream;
typedef System::DelphiInterface<ISequentialStream> _di_ISequentialStream;
__interface IBlobChunkCollection;
typedef System::DelphiInterface<IBlobChunkCollection> _di_IBlobChunkCollection;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TConnectionOption : unsigned char { coSafeMode, coInternalCloneConnection, coBlobChunkSize, coNetwrkPacketSize, coReadOnly, coCatalogPrefix, coConTimeout, coNumericSeparator, coConnectionString, coSupportsMetadata, coSupportsCatalog, coSupportsSchemaFilter, coMapInt64ToBcd, coMapSmallBcdToNative, coIgnoreUnknownFieldType, coMapCharAsBDE, coEnableBCD, coMaxBCD, coEnableUnicode, coSupportsAutoInc, coFldReadOnly, coTrimChar, coEmptyStrParam, coNullStrParam, coNullStrAsEmpty, coParamDateByOdbcLevel3, coBCD2Exp, coMixedFetch, coBlobFragmentation, coBlobNotTerminationChar, coNetTimeout, coLockMode, coSPSN, coTLSTO, coOBPBPL, coCFC, coVendorLib, coMDCase };

enum DECLSPEC_DENUM TConnectionOptionType : unsigned char { cot_Bool, cot_String, cot_Int, cot_UInt, cot_Char };

typedef System::StaticArray<System::AnsiString, 38> TConnectionOptionsNames;

typedef System::StaticArray<TConnectionOptionType, 38> TConnectionOptionsTypes;

enum DECLSPEC_DENUM TOptionSwitches : unsigned char { osDefault, osOff, osOn };

typedef System::StaticArray<TOptionSwitches, 38> TConnectionOptions;

typedef TConnectionOptions *PConnectionOptions;

typedef System::StaticArray<System::AnsiString, 3> TOptionSwitchesNames;

typedef void __fastcall (*TRegisterDbXpressLib)(void);

enum DECLSPEC_DENUM TXSQLDriverOption : unsigned char { xeDrvBlobSize, xeDrvCallBack, xeDrvCallBackInfo, xeDrvRestrict, xeDrvVersion, xeDrvProductVersion };

typedef System::Set<TXSQLDriverOption, TXSQLDriverOption::xeDrvBlobSize, TXSQLDriverOption::xeDrvProductVersion> TSetOfXSQLDriverOption;

enum DECLSPEC_DENUM TXSQLConnectionOption : unsigned char { xeConnAutoCommit, xeConnBlockingMode, xeConnBlobSize, xeConnRoleName, xeConnWaitOnLocks, xeConnCommitRetain, xeConnTxnIsoLevel, xeConnNativeHandle, xeConnServerVersion, xeConnCallBack, xeConnHostName, xeConnDatabaseName, xeConnCallBackInfo, xeConnObjectMode, xeConnMaxActiveComm, xeConnServerCharSet, xeConnSqlDialect, xeConnRollbackRetain, xeConnObjectQuoteChar, xeConnConnectionName, xeConnOSAuthentication, xeConnSupportsTransaction, xeConnMultipleTransaction, xeConnServerPort, xeConnOnLine, xeConnTrimChar, xeConnQualifiedName, xeConnCatalogName, xeConnSchemaName, xeConnObjectName, xeConnQuotedObjectName, xeConnCustomInfo, xeConnTimeout, xeConnConnectionString, xeConnTDSPacketSize, 
	xeConnClientHostName, xeConnClientAppName, xeConnCompressed, xeConnEncrypted, xeConnPrepareSQL, xeConnDecimalSeparator, xe41, xeVendorProperty };

typedef System::Set<TXSQLConnectionOption, TXSQLConnectionOption::xeConnAutoCommit, TXSQLConnectionOption::xeVendorProperty> TSetOfXSQLConnectionOption;

enum DECLSPEC_DENUM TXSQLCommandOption : unsigned char { xeCommRowsetSize, xeCommBlobSize, xeCommBlockRead, xeCommBlockWrite, xeCommParamCount, xeCommNativeHandle, xeCommCursorName, xeCommStoredProc, xeCommSQLDialect, xeCommTransactionID, xeCommPackageName, xeCommTrimChar, xeCommQualifiedName, xeCommCatalogName, xeCommSchemaName, xeCommObjectName, xeCommQuotedObjectName, xeCommPrepareSQL, xeCommDecimalSeparator };

typedef System::Set<TXSQLCommandOption, TXSQLCommandOption::xeCommRowsetSize, TXSQLCommandOption::xeCommDecimalSeparator> TSetOfXSQLCommandOption;

enum DECLSPEC_DENUM TXSQLMetaDataOption : unsigned char { xeMetaCatalogName, xeMetaSchemaName, xeMetaDatabaseName, xeMetaDatabaseVersion, xeMetaTransactionIsoLevel, xeMetaSupportsTransaction, xeMetaMaxObjectNameLength, xeMetaMaxColumnsInTable, xeMetaMaxColumnsInSelect, xeMetaMaxRowSize, xeMetaMaxSQLLength, xeMetaObjectQuoteChar, xeMetaSQLEscapeChar, xeMetaProcSupportsCursor, xeMetaProcSupportsCursors, xeMetaSupportsTransactions, xeMetaPackageName, xeMetaDefaultSchemaName };

typedef System::Set<TXSQLMetaDataOption, TXSQLMetaDataOption::xeMetaCatalogName, TXSQLMetaDataOption::xeMetaDefaultSchemaName> TSetOfXSQLMetaDataOption;

enum DECLSPEC_DENUM TOdbcDriverType : unsigned char { eOdbcDriverTypeUnspecified, eOdbcDriverTypeGupta, eOdbcDriverTypeMsSqlServer, eOdbcDriverTypeMsSqlServer2005Up, eOdbcDriverTypeIbmDb2, eOdbcDriverTypeIbmDb2AS400, eOdbcDriverTypeMsJet, eOdbcDriverTypeMySql, eOdbcDriverTypeMySql3, eOdbcDriverTypeInterbase, eOdbcDriverTypeInformix, eOdbcDriverTypeOracle, eOdbcDriverTypeSybase, eOdbcDriverTypeSQLite, eOdbcDriverTypeThinkSQL, eOdbcDriverTypeMerantOle, eOdbcDriverTypePervasive, eOdbcDriverTypeNexusDbFlashFiler, eOdbcDriverTypePostgreSQL, eOdbcDriverTypeInterSystemCache, eOdbcDriverTypeMerantDBASE, eOdbcDriverTypeSAPDB, eOdbcDriverTypeParadox, eOdbcDriverTypeFoxPro, eOdbcDriverTypeClipper, eOdbcDriverTypeBtrieve, eOdbcDriverTypeOpenIngres, 
	eOdbcDriverTypeProgress, eOdbcDriverTypeOterroRBase };

enum DECLSPEC_DENUM TDbmsType : unsigned char { eDbmsTypeUnspecified, eDbmsTypeGupta, eDbmsTypeMsSqlServer, eDbmsTypeMsSqlServer2005Up, eDbmsTypeIbmDb2, eDbmsTypeIbmDb2AS400, eDbmsTypeMySql, eDbmsTypeMySqlMax, eDbmsTypeMsAccess, eDbmsTypeExcel, eDbmsTypeText, eDbmsTypeDBase, eDbmsTypeParadox, eDbmsTypeOracle, eDbmsTypeInterbase, eDbmsTypeInformix, eDbmsTypeSybase, eDbmsTypeSQLite, eDbmsTypeThinkSQL, eDbmsTypeSapDb, eDbmsTypePervasiveSQL, eDbmsTypeFlashFiler, eDbmsTypePostgreSQL, eDbmsTypeInterSystemCache, eDbmsTypeFoxPro, eDbmsTypeClipper, eDbmsTypeBtrieve, eDbmsTypeOpenIngres, eDbmsTypeProgress, eDbmsTypeOterroRBase };

__interface  INTERFACE_UUID("{C623831B-3006-41F1-B151-08FB9F0E8942}") ISqlDriverOdbc  : public System::IInterface 
{
	virtual bool __stdcall GetOdbcDrivers(System::WideString &ADriverList) = 0 ;
};

__interface  INTERFACE_UUID("{136DD9D1-9B9C-4355-9AEF-959662CB095E}") ISqlConnectionOdbc  : public System::IInterface 
{
	virtual System::AnsiString __stdcall GetDbmsName(void) = 0 ;
	virtual TDbmsType __stdcall GetDbmsType(void) = 0 ;
	virtual System::AnsiString __stdcall GetDbmsVersionString(void) = 0 ;
	virtual int __stdcall GetDbmsVersionMajor(void) = 0 ;
	virtual int __stdcall GetDbmsVersionMinor(void) = 0 ;
	virtual int __stdcall GetDbmsVersionRelease(void) = 0 ;
	virtual char * __stdcall GetLastOdbcSqlState(void) = 0 ;
	virtual void __stdcall GetOdbcConnectStrings(System::Classes::TStrings* ConnectStringList) = 0 ;
	virtual System::AnsiString __stdcall GetOdbcDriverName(void) = 0 ;
	virtual TOdbcDriverType __stdcall GetOdbcDriverType(void) = 0 ;
	virtual System::AnsiString __stdcall GetOdbcDriverVersionString(void) = 0 ;
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

__interface  INTERFACE_UUID("{136DD9D1-9B9C-4355-9AEF-959662CB095F}") ISqlCommandOdbc  : public System::IInterface 
{
	virtual void __stdcall Cancel(void) = 0 ;
	virtual bool __stdcall SetLockTimeout(int TimeoutSeconds) = 0 ;
	virtual int __stdcall GetLockTimeout(void) = 0 ;
};

__interface  INTERFACE_UUID("{0C733A30-2A1C-11CE-ADE5-00AA0044773D}") ISequentialStream  : public System::IInterface 
{
	virtual HRESULT __stdcall Read(void * pv, int cb, System::PLongInt pcbRead) = 0 ;
	virtual HRESULT __stdcall Write(void * pv, int cb, System::PLongInt pcbWritten) = 0 ;
};

__interface  INTERFACE_UUID("{A4A8C6A2-786D-4DF7-938D-BC9301232BC8}") IBlobChunkCollection  : public System::IInterface 
{
	virtual __int64 __stdcall GetSize(void) = 0 ;
	virtual void __stdcall Read(void * &Buffer) = 0 ;
	virtual __int64 __stdcall ReadBlobToVariant(/* out */ System::Variant &Data) = 0 ;
	virtual __int64 __stdcall ReadBlobToStream(_di_ISequentialStream Stream) = 0 ;
	virtual void __stdcall Clear(void) = 0 ;
};

enum DECLSPEC_DENUM TOdbcApiType : unsigned char { oaAnsi, oaAnsiToUnicode, oaUnicode, oaUnicodeToAnsi };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TConnectionOptionsNames cConnectionOptionsNames;
extern DELPHI_PACKAGE TConnectionOptionsTypes cConnectionOptionsTypes;
extern DELPHI_PACKAGE TConnectionOptionsNames cConnectionOptionsDescs;
extern DELPHI_PACKAGE TOptionSwitchesNames cOptionSwitchesNames;
static const System::WideChar cOptCharDefault = (System::WideChar)(0x58);
static const System::WideChar cOptCharFalse = (System::WideChar)(0x30);
static const System::WideChar cOptCharTrue = (System::WideChar)(0x31);
extern DELPHI_PACKAGE TSetOfXSQLDriverOption cXSQLDriverOptionStringTypes;
extern DELPHI_PACKAGE TSetOfXSQLConnectionOption cXSQLConnectionOptionStringTypes;
extern DELPHI_PACKAGE TSetOfXSQLCommandOption cXSQLCommandOptionStringTypes;
extern DELPHI_PACKAGE TSetOfXSQLMetaDataOption cXSQLMetaDataOptionStringTypes;
extern DELPHI_PACKAGE System::ResourceString _rsNotSpecifiedDNSName;
#define Dbxopenodbcinterface_rsNotSpecifiedDNSName System::LoadResourceString(&Dbxopenodbcinterface::_rsNotSpecifiedDNSName)
extern DELPHI_PACKAGE void __fastcall RegisterDbXpressLibA(void);
extern DELPHI_PACKAGE void __fastcall RegisterDbXpressLibAW(void);
extern DELPHI_PACKAGE void __fastcall RegisterDbXpressLibW(void);
extern DELPHI_PACKAGE void __fastcall RegisterDbXpressLibWA(void);
extern DELPHI_PACKAGE void __fastcall RegisterDbXpressLibProc(TRegisterDbXpressLib RegProc, TOdbcApiType OdbcApiType);
}	/* namespace Dbxopenodbcinterface */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBXOPENODBCINTERFACE)
using namespace Dbxopenodbcinterface;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbxopenodbcinterfaceHPP
