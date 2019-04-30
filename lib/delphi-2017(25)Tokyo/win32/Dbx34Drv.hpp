// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34Drv.pas' rev: 32.00 (Windows)

#ifndef Dbx34drvHPP
#define Dbx34drvHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Data.DBXClassRegistry.hpp>
#include <Data.DB.hpp>
#include <Data.DBCommonTypes.hpp>
#include <Data.DBXCommon.hpp>
#include <Data.DBXPlatform.hpp>
#include <Data.DBXDynalink.hpp>
#include <Data.DBXDynalinkNative.hpp>
#include <Data.DBXMetaDataReader.hpp>
#include <Data.DBXMetaDataCommandFactory.hpp>
#include <Data.DBXCommonTable.hpp>
#include <Data.DBXMetaDataNames.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbx34drv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EDBXError;
class DELPHICLASS EDbxOODBCDriverError;
class DELPHICLASS TDBXOpenOdbcPropertyNames;
class DELPHICLASS TDBXPropertyNames;
class DELPHICLASS TDbxOpenOdbcDriver;
class DELPHICLASS TDBXOpenOdbcProperties;
class DELPHICLASS TDBXDynalinkDriverLoaderOpenOdbc;
class DELPHICLASS TDBXDynalinkConnectionOpenOdbc;
class DELPHICLASS TDBXMorphicCommandOpenOdbc;
class DELPHICLASS TDBXDataExpressProviderContextOpenOdbc;
class DELPHICLASS TDBXCustomOpenODBCMetaDataReader;
class DELPHICLASS TDBXOpenODBCMetaDataCommand;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactory;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryCustom;
class DELPHICLASS TDBXOpenODBCMetaDataReader;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION EDBXError : public Data::Db::EDatabaseError
{
	typedef Data::Db::EDatabaseError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDBXError(const System::UnicodeString Msg) : Data::Db::EDatabaseError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDBXError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : Data::Db::EDatabaseError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDBXError(NativeUInt Ident)/* overload */ : Data::Db::EDatabaseError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDBXError(System::PResStringRec ResStringRec)/* overload */ : Data::Db::EDatabaseError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDBXError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : Data::Db::EDatabaseError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDBXError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : Data::Db::EDatabaseError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDBXError(const System::UnicodeString Msg, int AHelpContext) : Data::Db::EDatabaseError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDBXError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : Data::Db::EDatabaseError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDBXError(NativeUInt Ident, int AHelpContext)/* overload */ : Data::Db::EDatabaseError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDBXError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Data::Db::EDatabaseError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDBXError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Data::Db::EDatabaseError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDBXError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Data::Db::EDatabaseError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDBXError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDbxOODBCDriverError : public EDBXError
{
	typedef EDBXError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg) : EDBXError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EDBXError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOODBCDriverError(NativeUInt Ident)/* overload */ : EDBXError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec)/* overload */ : EDBXError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOODBCDriverError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EDBXError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EDBXError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, int AHelpContext) : EDBXError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EDBXError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOODBCDriverError(NativeUInt Ident, int AHelpContext)/* overload */ : EDBXError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EDBXError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDBXError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOODBCDriverError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EDBXError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxOODBCDriverError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenOdbcPropertyNames : public Data::Dbxcommon::TDBXPropertyNames
{
	typedef Data::Dbxcommon::TDBXPropertyNames inherited;
	
public:
	/* TObject.Create */ inline __fastcall TDBXOpenOdbcPropertyNames(void) : Data::Dbxcommon::TDBXPropertyNames() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcPropertyNames(void) { }
	
};

#pragma pack(pop)

;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXPropertyNames : public TDBXOpenOdbcPropertyNames
{
	typedef TDBXOpenOdbcPropertyNames inherited;
	
public:
	#define TDBXPropertyNames_MetaDataDisabled L"MetaDataDisabled"
	
	#define TDBXPropertyNames_MetadataSQL L"MetadataSQL"
	
	#define TDBXPropertyNames_MetadataDBX L"MetadataDBX"
	
	#define TDBXPropertyNames_UseAnsiStrings L"UseAnsiStrings"
	
public:
	/* TObject.Create */ inline __fastcall TDBXPropertyNames(void) : TDBXOpenOdbcPropertyNames() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXPropertyNames(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDbxOpenOdbcDriver : public Data::Dbxdynalinknative::TDBXDynalinkDriverNative
{
	typedef Data::Dbxdynalinknative::TDBXDynalinkDriverNative inherited;
	
protected:
	virtual Data::Dbxcommon::TDBXConnection* __fastcall CreateConnection(Data::Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder);
	void __fastcall LoadDriverWithConnectionBuilder(Data::Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder);
	Data::Dbxcommon::TDBXCommand* __fastcall CreateCommandOpenOdbc(Data::Dbxcommon::TDBXContext* DbxContext, Data::Dbxcommon::TDBXConnection* Connection, Data::Dbxcommon::TDBXCommand* MorphicCommand);
	
public:
	__fastcall virtual TDbxOpenOdbcDriver(const Data::Dbxcommon::TDBXDriverDef &DriverDef)/* overload */;
	virtual void __fastcall GetDriverPropertyNames(System::Classes::TStrings* List);
	virtual System::UnicodeString __fastcall GetDriverVersion(void);
public:
	/* TDBXDynalinkDriverNative.Create */ inline __fastcall TDbxOpenOdbcDriver(Data::Dbxcommon::TDBXDriver* DriverClone, void * DriverHandle, Data::Dbxdynalink::TDBXMethodTable* MethodTable)/* overload */ : Data::Dbxdynalinknative::TDBXDynalinkDriverNative(DriverClone, DriverHandle, MethodTable) { }
	/* TDBXDynalinkDriverNative.Create */ inline __fastcall TDbxOpenOdbcDriver(const Data::Dbxcommon::TDBXDriverDef &DBXDriverDef, Data::Dbxdynalink::TDBXDynalinkDriverCommonLoaderClass DBXDriverLoader)/* overload */ : Data::Dbxdynalinknative::TDBXDynalinkDriverNative(DBXDriverDef, DBXDriverLoader) { }
	/* TDBXDynalinkDriverNative.Create */ inline __fastcall TDbxOpenOdbcDriver(const Data::Dbxcommon::TDBXDriverDef &DBXDriverDef, Data::Dbxdynalink::TDBXDynalinkDriverCommonLoaderClass DBXDriverLoader, Data::Dbxcommon::TDBXProperties* DriverProps)/* overload */ : Data::Dbxdynalinknative::TDBXDynalinkDriverNative(DBXDriverDef, DBXDriverLoader, DriverProps) { }
	
public:
	/* TDBXDynalinkDriver.Destroy */ inline __fastcall virtual ~TDbxOpenOdbcDriver(void) { }
	
public:
	/* TDBXDriver.Create */ inline __fastcall TDbxOpenOdbcDriver(void)/* overload */ : Data::Dbxdynalinknative::TDBXDynalinkDriverNative() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TDBXOpenOdbcProperties : public Data::Dbxcommon::TDBXProperties
{
	typedef Data::Dbxcommon::TDBXProperties inherited;
	
private:
	System::UnicodeString __fastcall GetConnectionString(void);
	void __fastcall SetConnectionString(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDatabase(void);
	void __fastcall SetDatabase(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetUserName(void);
	void __fastcall SetUserName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetPassWord(void);
	void __fastcall SetPassWord(const System::UnicodeString Value);
	int __fastcall GetBlobSize(void);
	void __fastcall SetBlobSize(const int Value);
	System::UnicodeString __fastcall GetOdbcTransIsolation(void);
	void __fastcall SetOdbcTransIsolation(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDecimalSeparator(void);
	void __fastcall SetDecimalSeparator(const System::UnicodeString Value);
	bool __fastcall GetTrimChar(void);
	void __fastcall SetTrimChar(const bool Value);
	System::UnicodeString __fastcall GetCustomString(void);
	void __fastcall SetCustomString(const System::UnicodeString Value);
	
public:
	#define TDBXOpenOdbcProperties_StrConnectionString L"ConnectionString"
	
	#define TDBXOpenOdbcProperties_StrTrimChar L"Trim Char"
	
	#define TDBXOpenOdbcProperties_StrOdbcTransIsolation L"DbxOpenOdbc TransIsolation"
	
	#define TDBXOpenOdbcProperties_StrDecimalSeparator L"Decimal Separator"
	
	#define TDBXOpenOdbcProperties_StrCustomString L"Custom String"
	
	#define TDBXOpenOdbcProperties_StrPrepareSQL L"Prepare SQL"
	
	__fastcall virtual TDBXOpenOdbcProperties(Data::Dbxcommon::TDBXContext* DBXContext)/* overload */;
	
__published:
	__property System::UnicodeString ConnectionString = {read=GetConnectionString, write=SetConnectionString};
	__property System::UnicodeString Database = {read=GetDatabase, write=SetDatabase};
	__property System::UnicodeString UserName = {read=GetUserName, write=SetUserName};
	__property System::UnicodeString PassWord = {read=GetPassWord, write=SetPassWord};
	__property int BlobSize = {read=GetBlobSize, write=SetBlobSize, nodefault};
	__property System::UnicodeString OdbcTransIsolation = {read=GetOdbcTransIsolation, write=SetOdbcTransIsolation};
	__property System::UnicodeString DecimalSeparator = {read=GetDecimalSeparator, write=SetDecimalSeparator};
	__property bool TrimChar = {read=GetTrimChar, write=SetTrimChar, nodefault};
	__property System::UnicodeString CustomString = {read=GetCustomString, write=SetCustomString};
public:
	/* TDBXProperties.Create */ inline __fastcall virtual TDBXOpenOdbcProperties(void)/* overload */ : Data::Dbxcommon::TDBXProperties() { }
	/* TDBXProperties.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcProperties(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXDynalinkDriverLoaderOpenOdbc : public Data::Dbxdynalinknative::TDBXDynalinkDriverLoader
{
	typedef Data::Dbxdynalinknative::TDBXDynalinkDriverLoader inherited;
	
private:
	HIDESBASE void __fastcall FreeOldLibrary(void);
	HIDESBASE void __fastcall LoadDriverLibraryAndMethodTable(Data::Dbxcommon::TDBXContext* DBXContext, Data::Dbxcommon::TDBXProperties* Properties);
	
protected:
	__property Data::Dbxdynalink::TDBXMethodTable* MethodTable = {read=FMethodTable, write=FMethodTable};
	__property void * DriverHandle = {read=FDriverHandle, write=FDriverHandle};
public:
	/* TDBXDynalinkDriverCommonLoader.Create */ inline __fastcall virtual TDBXDynalinkDriverLoaderOpenOdbc(void) : Data::Dbxdynalinknative::TDBXDynalinkDriverLoader() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXDynalinkDriverLoaderOpenOdbc(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXDynalinkConnectionOpenOdbc : public Data::Dbxdynalink::TDBXDynalinkConnection
{
	typedef Data::Dbxdynalink::TDBXDynalinkConnection inherited;
	
public:
	#define TDBXDynalinkConnectionOpenOdbc_dbxoodbc_version_min L"3.2012.04.07"
	
	
private:
	System::UnicodeString FDBMSVersion;
	System::UnicodeString FQuoteChar;
	void __fastcall DoDerivedOpenBefore(void);
	void __fastcall DoDerivedOpenAfter(void);
	
protected:
	virtual System::UnicodeString __fastcall GetProductVersion(void);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual void __fastcall DerivedGetCommands(const System::UnicodeString CommandType, System::Classes::TStrings* const List);
	virtual void __fastcall DerivedGetCommandTypes(System::Classes::TStrings* const List);
	virtual void __fastcall DerivedOpen(void);
	virtual void __fastcall DerivedClose(void);
	virtual Data::Dbxcommon::TDBXCommand* __fastcall DerivedCreateCommand(void);
	virtual Data::Dbxcommon::TDBXDatabaseMetaData* __fastcall GetDatabaseMetaData(void);
	
public:
	virtual void __fastcall Close(void);
	virtual System::UnicodeString __fastcall GetVendorProperty(const System::UnicodeString Name);
public:
	/* TDBXDynalinkConnection.Create */ inline __fastcall TDBXDynalinkConnectionOpenOdbc(Data::Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder, void * ConnectionHandle, Data::Dbxdynalink::TDBXMethodTable* MethodTable) : Data::Dbxdynalink::TDBXDynalinkConnection(ConnectionBuilder, ConnectionHandle, MethodTable) { }
	
public:
	/* TDBXConnection.Destroy */ inline __fastcall virtual ~TDBXDynalinkConnectionOpenOdbc(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TDBXMorphicCommandOpenOdbc : public Data::Dbxcommon::TDBXMorphicCommand
{
	typedef Data::Dbxcommon::TDBXMorphicCommand inherited;
	
protected:
	virtual Data::Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
	
public:
	__fastcall TDBXMorphicCommandOpenOdbc(Data::Dbxcommon::TDBXContext* DBXContext, Data::Dbxcommon::TDBXConnection* Connection);
public:
	/* TDBXMorphicCommand.Destroy */ inline __fastcall virtual ~TDBXMorphicCommandOpenOdbc(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXDataExpressProviderContextOpenOdbc : public Data::Dbxmetadatacommandfactory::TDBXDataExpressProviderContext
{
	typedef Data::Dbxmetadatacommandfactory::TDBXDataExpressProviderContext inherited;
	
public:
	/* TDBXDataExpressProviderContext.Create */ inline __fastcall TDBXDataExpressProviderContextOpenOdbc(void) : Data::Dbxmetadatacommandfactory::TDBXDataExpressProviderContext() { }
	/* TDBXDataExpressProviderContext.Destroy */ inline __fastcall virtual ~TDBXDataExpressProviderContextOpenOdbc(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXCustomOpenODBCMetaDataReader : public Data::Dbxmetadatareader::TDBXBaseMetaDataReader
{
	typedef Data::Dbxmetadatareader::TDBXBaseMetaDataReader inherited;
	
protected:
	static const System::WideChar DoubleQuote = (System::WideChar)(0x22);
	
	bool FMetadataInitialized;
	System::UnicodeString FQuoteChar;
	int FUseAnsiStrings;
	void __fastcall InitMetadata(TDBXDynalinkConnectionOpenOdbc* Connection);
	void __fastcall CheckMetadata(void);
	virtual void __fastcall SetContext(Data::Dbxmetadatareader::TDBXProviderContext* const Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuotePrefix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteSuffix(void);
	virtual bool __fastcall IsParameterMetadataSupported(void);
	virtual bool __fastcall IsLowerCaseIdentifiersSupported(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual bool __fastcall IsDescendingIndexSupported(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteChar(void);
	virtual System::UnicodeString __fastcall GetSqlProcedureQuoteChar(void);
	virtual bool __fastcall IsMultipleCommandsSupported(void);
	virtual bool __fastcall IsTransactionsSupported(void);
	virtual bool __fastcall IsNestedTransactionsSupported(void);
	virtual bool __fastcall IsSetRowSizeSupported(void);
	bool __fastcall GetUseAnsiStrings(void);
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXCustomOpenODBCMetaDataReader(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TDBXCustomOpenODBCMetaDataReader(void) : Data::Dbxmetadatareader::TDBXBaseMetaDataReader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommand : public Data::Dbxmetadatacommandfactory::TDBXMetaDataCommand
{
	typedef Data::Dbxmetadatacommandfactory::TDBXMetaDataCommand inherited;
	
protected:
	virtual Data::Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
public:
	/* TDBXMetaDataCommand.Create */ inline __fastcall TDBXOpenODBCMetaDataCommand(Data::Dbxcommon::TDBXContext* DBXContext, Data::Dbxcommon::TDBXCommand* MorphicCommand, Data::Dbxmetadatareader::TDBXMetaDataReader* Provider) : Data::Dbxmetadatacommandfactory::TDBXMetaDataCommand(DBXContext, MorphicCommand, Provider) { }
	/* TDBXMetaDataCommand.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommand(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TDBXOpenODBCMetaDataReaderClass;

enum DECLSPEC_DENUM Dbx34drv__31 : unsigned char { mmSQL, mmDBX };

typedef System::Set<Dbx34drv__31, Dbx34drv__31::mmSQL, Dbx34drv__31::mmDBX> TMetadataMode;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactory : public Data::Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory
{
	typedef Data::Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory inherited;
	
protected:
	TDBXOpenODBCMetaDataReaderClass FDBXMetaDataReaderClass;
	Data::Dbxcommon::TDBXConnection* FCurrentConnection;
	int fMetadataSupported;
	TMetadataMode fMetadataMode;
	int FUseAnsiStrings;
	__classmethod virtual TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
	void __fastcall InitMetaDataReaderClass(Data::Dbxcommon::TDBXConnection* Connection);
	
public:
	virtual Data::Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
	HIDESBASE TDBXCustomOpenODBCMetaDataReader* __fastcall CreateMetaDataReader(Data::Dbxcommon::TDBXConnection* Connection)/* overload */;
	virtual Data::Dbxcommon::TDBXCommand* __fastcall CreateCommand(Data::Dbxcommon::TDBXContext* DbxContext, Data::Dbxcommon::TDBXConnection* Connection, Data::Dbxcommon::TDBXCommand* MorphicCommand);
	virtual System::UnicodeString __fastcall GetProductName(void);
	__classmethod void __fastcall RegisterMetaDataCommandFactory();
	__classmethod void __fastcall UnRegisterMetaDataCommandFactory();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactory(void) : Data::Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactory(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TDBXOpenODBCMetaDataCommandFactoryClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryCustom : public TDBXOpenODBCMetaDataCommandFactory
{
	typedef TDBXOpenODBCMetaDataCommandFactory inherited;
	
public:
	virtual Data::Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryCustom(void) : TDBXOpenODBCMetaDataCommandFactory() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryCustom(void) { }
	
	/* Hoisted overloads: */
	
public:
	inline TDBXCustomOpenODBCMetaDataReader* __fastcall  CreateMetaDataReader(Data::Dbxcommon::TDBXConnection* Connection){ return TDBXOpenODBCMetaDataCommandFactory::CreateMetaDataReader(Connection); }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReader : public TDBXCustomOpenODBCMetaDataReader
{
	typedef TDBXCustomOpenODBCMetaDataReader inherited;
	
protected:
	bool fMetadataSupported;
	TMetadataMode fMetadataMode;
	bool fDbxMode;
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual bool __fastcall IsNestedTransactionsSupported(void);
	virtual bool __fastcall IsSetRowSizeSupported(void);
	virtual System::UnicodeString __fastcall GetSqlForSchemas(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForViews(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForForeignKeys(void);
	virtual System::UnicodeString __fastcall GetSqlForForeignKeyColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForSynonyms(void);
	virtual System::UnicodeString __fastcall GetSqlForProcedures(void);
	virtual System::UnicodeString __fastcall GetSqlForProcedureSources(void);
	virtual System::UnicodeString __fastcall GetSqlForProcedureParameters(void);
	virtual System::UnicodeString __fastcall GetSqlForPackages(void);
	virtual System::UnicodeString __fastcall GetSqlForPackageSources(void);
	virtual System::UnicodeString __fastcall GetSqlForPackageProcedures(void);
	virtual System::UnicodeString __fastcall GetSqlForPackageProcedureParameters(void);
	virtual System::UnicodeString __fastcall GetSqlForUsers(void);
	virtual System::UnicodeString __fastcall GetSqlForRoles(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	
public:
	__fastcall virtual TDBXOpenODBCMetaDataReader(void);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchDataTypes(void);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchCatalogs(void);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchSchemas(const System::UnicodeString Catalog);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchTables(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString TableName, const System::UnicodeString TableType);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchViews(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString View);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchColumnConstraints(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchIndexes(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchIndexColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table, const System::UnicodeString Index);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchForeignKeys(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchForeignKeyColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table, const System::UnicodeString ForeignKeyName, const System::UnicodeString PrimaryCatalog, const System::UnicodeString PrimarySchema, const System::UnicodeString PrimaryTable, const System::UnicodeString PrimaryKeyName);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchSynonyms(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Synonym);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchProcedures(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString ProcedureName, const System::UnicodeString ProcedureType);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchProcedureSources(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Procedure);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchProcedureParameters(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Procedure, const System::UnicodeString Parameter);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchPackages(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchPackageProcedures(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName, const System::UnicodeString ProcedureName, const System::UnicodeString ProcedureType);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchPackageProcedureParameters(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName, const System::UnicodeString ProcedureName, const System::UnicodeString ParameterName);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchPackageSources(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchUsers(void);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchRoles(void);
	virtual Data::Dbxcommontable::TDBXTable* __fastcall FetchReservedWords(void);
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReader(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool bIsDbx34Drv;
}	/* namespace Dbx34drv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBX34DRV)
using namespace Dbx34drv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drvHPP
