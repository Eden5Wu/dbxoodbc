// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34drv.pas' rev: 21.00

#ifndef Dbx34drvHPP
#define Dbx34drvHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Classregistry.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Dbcommontypes.hpp>	// Pascal unit
#include <Dbxcommon.hpp>	// Pascal unit
#include <Dbxplatform.hpp>	// Pascal unit
#include <Dbxdynalink.hpp>	// Pascal unit
#include <Dbxdynalinknative.hpp>	// Pascal unit
#include <Dbxmetadatareader.hpp>	// Pascal unit
#include <Dbxmetadatacommand.hpp>	// Pascal unit
#include <Dbxmetadatacommandfactory.hpp>	// Pascal unit
#include <Dbxcommontable.hpp>	// Pascal unit
#include <Dbxmetadatanames.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbx34drv
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EDBXError;
class PASCALIMPLEMENTATION EDBXError : public Db::EDatabaseError
{
	typedef Db::EDatabaseError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDBXError(const System::UnicodeString Msg) : Db::EDatabaseError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDBXError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Db::EDatabaseError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EDBXError(int Ident)/* overload */ : Db::EDatabaseError(Ident) { }
	/* Exception.CreateResFmt */ inline __fastcall EDBXError(int Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Db::EDatabaseError(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EDBXError(const System::UnicodeString Msg, int AHelpContext) : Db::EDatabaseError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDBXError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Db::EDatabaseError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDBXError(int Ident, int AHelpContext)/* overload */ : Db::EDatabaseError(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDBXError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Db::EDatabaseError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDBXError(void) { }
	
};


class DELPHICLASS EDbxOODBCDriverError;
class PASCALIMPLEMENTATION EDbxOODBCDriverError : public EDBXError
{
	typedef EDBXError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg) : EDBXError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EDBXError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EDbxOODBCDriverError(int Ident)/* overload */ : EDBXError(Ident) { }
	/* Exception.CreateResFmt */ inline __fastcall EDbxOODBCDriverError(int Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EDBXError(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, int AHelpContext) : EDBXError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOODBCDriverError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EDBXError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDbxOODBCDriverError(int Ident, int AHelpContext)/* overload */ : EDBXError(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EDBXError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDbxOODBCDriverError(void) { }
	
};


class DELPHICLASS TDBXOpenOdbcPropertyNames;
class PASCALIMPLEMENTATION TDBXOpenOdbcPropertyNames : public Dbxcommon::TDBXPropertyNames
{
	typedef Dbxcommon::TDBXPropertyNames inherited;
	
public:
	/* TObject.Create */ inline __fastcall TDBXOpenOdbcPropertyNames(void) : Dbxcommon::TDBXPropertyNames() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcPropertyNames(void) { }
	
};


;

class DELPHICLASS TDBXPropertyNames;
class PASCALIMPLEMENTATION TDBXPropertyNames : public TDBXOpenOdbcPropertyNames
{
	typedef TDBXOpenOdbcPropertyNames inherited;
	
public:
	#define TDBXPropertyNames_RowSetSize L"RowSetSize"
	
	#define TDBXPropertyNames_MetaDataDisabled L"MetaDataDisabled"
	
	#define TDBXPropertyNames_MetadataSQL L"MetadataSQL"
	
	#define TDBXPropertyNames_MetadataDBX L"MetadataDBX"
	
	#define TDBXPropertyNames_UseAnsiStrings L"UseAnsiStrings"
	
public:
	/* TObject.Create */ inline __fastcall TDBXPropertyNames(void) : TDBXOpenOdbcPropertyNames() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXPropertyNames(void) { }
	
};


class DELPHICLASS TDbxOpenOdbcDriver;
class PASCALIMPLEMENTATION TDbxOpenOdbcDriver : public Dbxdynalinknative::TDBXDynalinkDriverNative
{
	typedef Dbxdynalinknative::TDBXDynalinkDriverNative inherited;
	
protected:
	virtual Dbxcommon::TDBXConnection* __fastcall CreateConnection(Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder);
	void __fastcall LoadDriverWithConnectionBuilder(Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder);
	Dbxcommon::TDBXCommand* __fastcall CreateCommandOpenOdbc(Dbxcommon::TDBXContext* DbxContext, Dbxcommon::TDBXConnection* Connection, Dbxcommon::TDBXCommand* MorphicCommand);
	
public:
	__fastcall virtual TDbxOpenOdbcDriver(const Dbxcommon::TDBXDriverDef &DriverDef)/* overload */;
	virtual void __fastcall GetDriverPropertyNames(Classes::TStrings* List);
	virtual System::UnicodeString __fastcall GetDriverVersion(void);
public:
	/* TDBXDynalinkDriver.Destroy */ inline __fastcall virtual ~TDbxOpenOdbcDriver(void) { }
	
};


class DELPHICLASS TDBXOpenOdbcProperties;
class PASCALIMPLEMENTATION TDBXOpenOdbcProperties : public Dbxcommon::TDBXProperties
{
	typedef Dbxcommon::TDBXProperties inherited;
	
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
	
	__fastcall virtual TDBXOpenOdbcProperties(Dbxcommon::TDBXContext* DBXContext)/* overload */;
	
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
	/* TDBXProperties.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcProperties(void) { }
	
};


class DELPHICLASS TDBXDynalinkDriverLoaderOpenOdbc;
class PASCALIMPLEMENTATION TDBXDynalinkDriverLoaderOpenOdbc : public Dbxdynalinknative::TDBXDynalinkDriverLoader
{
	typedef Dbxdynalinknative::TDBXDynalinkDriverLoader inherited;
	
private:
	HIDESBASE void __fastcall FreeOldLibrary(void);
	HIDESBASE void __fastcall LoadDriverLibraryAndMethodTable(Dbxcommon::TDBXContext* DBXContext, Dbxcommon::TDBXProperties* Properties);
	
protected:
	__property Dbxdynalink::TDBXMethodTable* MethodTable = {read=FMethodTable, write=FMethodTable};
	__property void * DriverHandle = {read=FDriverHandle, write=FDriverHandle};
public:
	/* TDBXDynalinkDriverCommonLoader.Create */ inline __fastcall virtual TDBXDynalinkDriverLoaderOpenOdbc(void) : Dbxdynalinknative::TDBXDynalinkDriverLoader() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXDynalinkDriverLoaderOpenOdbc(void) { }
	
};


class DELPHICLASS TDBXDynalinkConnectionOpenOdbc;
class PASCALIMPLEMENTATION TDBXDynalinkConnectionOpenOdbc : public Dbxdynalink::TDBXDynalinkConnection
{
	typedef Dbxdynalink::TDBXDynalinkConnection inherited;
	
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
	virtual void __fastcall DerivedGetCommands(const System::UnicodeString CommandType, const Classes::TStrings* List);
	virtual void __fastcall DerivedGetCommandTypes(const Classes::TStrings* List);
	virtual void __fastcall DerivedOpen(void);
	virtual void __fastcall DerivedClose(void);
	virtual Dbxcommon::TDBXCommand* __fastcall DerivedCreateCommand(void);
	virtual Dbxcommon::TDBXDatabaseMetaData* __fastcall GetDatabaseMetaData(void);
	
public:
	virtual void __fastcall Close(void);
	virtual System::UnicodeString __fastcall GetVendorProperty(const System::UnicodeString Name);
public:
	/* TDBXDynalinkConnection.Create */ inline __fastcall TDBXDynalinkConnectionOpenOdbc(Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder, void * ConnectionHandle, Dbxdynalink::TDBXMethodTable* MethodTable) : Dbxdynalink::TDBXDynalinkConnection(ConnectionBuilder, ConnectionHandle, MethodTable) { }
	
public:
	/* TDBXConnection.Destroy */ inline __fastcall virtual ~TDBXDynalinkConnectionOpenOdbc(void) { }
	
};


class DELPHICLASS TDBXMorphicCommandOpenOdbc;
class PASCALIMPLEMENTATION TDBXMorphicCommandOpenOdbc : public Dbxcommon::TDBXMorphicCommand
{
	typedef Dbxcommon::TDBXMorphicCommand inherited;
	
protected:
	virtual Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
	
public:
	__fastcall TDBXMorphicCommandOpenOdbc(Dbxcommon::TDBXContext* DBXContext, Dbxcommon::TDBXConnection* Connection);
public:
	/* TDBXMorphicCommand.Destroy */ inline __fastcall virtual ~TDBXMorphicCommandOpenOdbc(void) { }
	
};


class DELPHICLASS TDBXDataExpressProviderContextOpenOdbc;
class PASCALIMPLEMENTATION TDBXDataExpressProviderContextOpenOdbc : public Dbxmetadatacommandfactory::TDBXDataExpressProviderContext
{
	typedef Dbxmetadatacommandfactory::TDBXDataExpressProviderContext inherited;
	
private:
	Dbxcommon::TDBXConnection* FConnection;
	void __fastcall SetConnection(Dbxcommon::TDBXConnection* Value);
	
public:
	__property Dbxcommon::TDBXConnection* Connection = {read=FConnection, write=SetConnection};
public:
	/* TDBXDataExpressProviderContext.Create */ inline __fastcall TDBXDataExpressProviderContextOpenOdbc(void) : Dbxmetadatacommandfactory::TDBXDataExpressProviderContext() { }
	/* TDBXDataExpressProviderContext.Destroy */ inline __fastcall virtual ~TDBXDataExpressProviderContextOpenOdbc(void) { }
	
};


class DELPHICLASS TDBXCustomOpenODBCMetaDataReader;
class PASCALIMPLEMENTATION TDBXCustomOpenODBCMetaDataReader : public Dbxmetadatareader::TDBXBaseMetaDataReader
{
	typedef Dbxmetadatareader::TDBXBaseMetaDataReader inherited;
	
protected:
	static const WideChar DoubleQuote = (WideChar)(0x22);
	
	bool FMetadataInitialized;
	System::UnicodeString FQuoteChar;
	int FUseAnsiStrings;
	void __fastcall InitMetadata(TDBXDynalinkConnectionOpenOdbc* Connection);
	void __fastcall CheckMetadata(void);
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
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
	/* TObject.Create */ inline __fastcall TDBXCustomOpenODBCMetaDataReader(void) : Dbxmetadatareader::TDBXBaseMetaDataReader() { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommand;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommand : public Dbxmetadatacommand::TDBXMetaDataCommand
{
	typedef Dbxmetadatacommand::TDBXMetaDataCommand inherited;
	
protected:
	virtual Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
public:
	/* TDBXMetaDataCommand.Create */ inline __fastcall TDBXOpenODBCMetaDataCommand(Dbxcommon::TDBXContext* DBXContext, Dbxcommon::TDBXCommand* MorphicCommand, Dbxmetadatareader::TDBXMetaDataReader* Provider) : Dbxmetadatacommand::TDBXMetaDataCommand(DBXContext, MorphicCommand, Provider) { }
	/* TDBXMetaDataCommand.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommand(void) { }
	
};


typedef TMetaClass* TDBXOpenODBCMetaDataReaderClass;

#pragma option push -b-
enum Dbx34drv__31 { mmSQL, mmDBX };
#pragma option pop

typedef Set<Dbx34drv__31, mmSQL, mmDBX>  TMetadataMode;

class DELPHICLASS TDBXOpenODBCMetaDataCommandFactory;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactory : public Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory
{
	typedef Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory inherited;
	
protected:
	TDBXOpenODBCMetaDataReaderClass FDBXMetaDataReaderClass;
	Dbxcommon::TDBXConnection* FCurrentConnection;
	int fMetadataSupported;
	TMetadataMode fMetadataMode;
	int FUseAnsiStrings;
	__classmethod virtual TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
	void __fastcall InitMetaDataReaderClass(Dbxcommon::TDBXConnection* Connection);
	
public:
	virtual Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
	HIDESBASE TDBXCustomOpenODBCMetaDataReader* __fastcall CreateMetaDataReader(Dbxcommon::TDBXConnection* Connection)/* overload */;
	virtual Dbxcommon::TDBXCommand* __fastcall CreateCommand(Dbxcommon::TDBXContext* DbxContext, Dbxcommon::TDBXConnection* Connection, Dbxcommon::TDBXCommand* MorphicCommand);
	virtual System::UnicodeString __fastcall GetProductName(void);
	__classmethod void __fastcall RegisterMetaDataCommandFactory();
	__classmethod void __fastcall UnRegisterMetaDataCommandFactory();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactory(void) : Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactory(void) { }
	
};


typedef TMetaClass* TDBXOpenODBCMetaDataCommandFactoryClass;

class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryCustom;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryCustom : public TDBXOpenODBCMetaDataCommandFactory
{
	typedef TDBXOpenODBCMetaDataCommandFactory inherited;
	
public:
	virtual Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryCustom(void) : TDBXOpenODBCMetaDataCommandFactory() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryCustom(void) { }
	
	
/* Hoisted overloads: */
	
public:
	inline TDBXCustomOpenODBCMetaDataReader* __fastcall  CreateMetaDataReader(Dbxcommon::TDBXConnection* Connection){ return TDBXOpenODBCMetaDataCommandFactory::CreateMetaDataReader(Connection); }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReader;
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
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	
public:
	__fastcall virtual TDBXOpenODBCMetaDataReader(void);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchDataTypes(void);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchCatalogs(void);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchSchemas(const System::UnicodeString Catalog);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchTables(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString TableName, const System::UnicodeString TableType);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchViews(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString View);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchColumnConstraints(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchIndexes(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchIndexColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table, const System::UnicodeString Index);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchForeignKeys(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchForeignKeyColumns(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Table, const System::UnicodeString ForeignKeyName, const System::UnicodeString PrimaryCatalog, const System::UnicodeString PrimarySchema, const System::UnicodeString PrimaryTable, const System::UnicodeString PrimaryKeyName);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchSynonyms(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Synonym);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchProcedures(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString ProcedureName, const System::UnicodeString ProcedureType);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchProcedureSources(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Procedure);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchProcedureParameters(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString Procedure, const System::UnicodeString Parameter);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchPackages(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchPackageProcedures(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName, const System::UnicodeString ProcedureName, const System::UnicodeString ProcedureType);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchPackageProcedureParameters(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName, const System::UnicodeString ProcedureName, const System::UnicodeString ParameterName);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchPackageSources(const System::UnicodeString Catalog, const System::UnicodeString Schema, const System::UnicodeString PackageName);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchUsers(void);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchRoles(void);
	virtual Dbxcommontable::TDBXTable* __fastcall FetchReservedWords(void);
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReader(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE bool bIsDbx34Drv;

}	/* namespace Dbx34drv */
using namespace Dbx34drv;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drvHPP
