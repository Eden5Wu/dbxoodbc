// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34drv.pas' rev: 11.00

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
#include <Dbxplatformutil.hpp>	// Pascal unit
#include <Dbxtablestorage.hpp>	// Pascal unit
#include <Dbxdelegate.hpp>	// Pascal unit
#include <Widestrings.hpp>	// Pascal unit
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
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDBXError(const AnsiString Msg) : Db::EDatabaseError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDBXError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Db::EDatabaseError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDBXError(int Ident)/* overload */ : Db::EDatabaseError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDBXError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Db::EDatabaseError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDBXError(const AnsiString Msg, int AHelpContext) : Db::EDatabaseError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDBXError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Db::EDatabaseError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDBXError(int Ident, int AHelpContext)/* overload */ : Db::EDatabaseError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDBXError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Db::EDatabaseError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDBXError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EDbxOODBCDriverError;
class PASCALIMPLEMENTATION EDbxOODBCDriverError : public EDBXError 
{
	typedef EDBXError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EDbxOODBCDriverError(const AnsiString Msg) : EDBXError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EDbxOODBCDriverError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EDBXError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EDbxOODBCDriverError(int Ident)/* overload */ : EDBXError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EDbxOODBCDriverError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EDBXError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EDbxOODBCDriverError(const AnsiString Msg, int AHelpContext) : EDBXError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EDbxOODBCDriverError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EDBXError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EDbxOODBCDriverError(int Ident, int AHelpContext)/* overload */ : EDBXError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EDbxOODBCDriverError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EDBXError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EDbxOODBCDriverError(void) { }
	#pragma option pop
	
};


typedef WideString UnicodeString;

typedef DynamicArray<WideString >  TDBXStringArray;

;

;

typedef TDBXTableStorage TDBXTable;
;

class DELPHICLASS TDBXDataTypes;
class PASCALIMPLEMENTATION TDBXDataTypes : public Dbxcommon::TDBXDataTypes 
{
	typedef Dbxcommon::TDBXDataTypes inherited;
	
public:
	Shortint SingleType;
	Shortint Int8Type;
	Shortint Uint8Type;
	Shortint ObjectType;
	Shortint CharArrayType;
	Shortint IntervalType;
	Shortint TimeStampOffsetType;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXDataTypes(void) : Dbxcommon::TDBXDataTypes() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXDataTypes(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenOdbcPropertyNames;
class PASCALIMPLEMENTATION TDBXOpenOdbcPropertyNames : public Dbxcommon::TDBXPropertyNames 
{
	typedef Dbxcommon::TDBXPropertyNames inherited;
	
public:
	AnsiString MetaDataPackageLoader;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenOdbcPropertyNames(void) : Dbxcommon::TDBXPropertyNames() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcPropertyNames(void) { }
	#pragma option pop
	
};


typedef DynamicArray<Dbxtablestorage::TDBXColumnDescriptor* >  TDBXValueTypeArray;

typedef TDBXBaseMetaDataReader.TDBXEmptyTableCursor TDBXEmptyTableCursor;
;

typedef TDBXBaseMetaDataReader.TDBXSanitizedTableCursor TDBXCustomMetaDataTable;
;

class DELPHICLASS TDBXDynalinkPropertyNames;
class PASCALIMPLEMENTATION TDBXDynalinkPropertyNames : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	AnsiString BlobSize;
	AnsiString LocaleCode;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXDynalinkPropertyNames(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXDynalinkPropertyNames(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXPropertyNames;
class PASCALIMPLEMENTATION TDBXPropertyNames : public TDBXOpenOdbcPropertyNames 
{
	typedef TDBXOpenOdbcPropertyNames inherited;
	
public:
	AnsiString ProductVersion;
	AnsiString RowSetSize;
	AnsiString MetaDataDisabled;
	AnsiString MetadataSQL;
	AnsiString MetadataDBX;
	AnsiString UseAnsiStrings;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXPropertyNames(void) : TDBXOpenOdbcPropertyNames() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXPropertyNames(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenOdbcProperties;
class PASCALIMPLEMENTATION TDBXOpenOdbcProperties : public Dbxcommon::TDBXProperties 
{
	typedef Dbxcommon::TDBXProperties inherited;
	
private:
	AnsiString __fastcall GetConnectionString();
	void __fastcall SetConnectionString(const AnsiString Value);
	AnsiString __fastcall GetDatabase();
	void __fastcall SetDatabase(const AnsiString Value);
	AnsiString __fastcall GetUserName();
	void __fastcall SetUserName(const AnsiString Value);
	AnsiString __fastcall GetPassWord();
	void __fastcall SetPassWord(const AnsiString Value);
	int __fastcall GetBlobSize(void);
	void __fastcall SetBlobSize(const int Value);
	AnsiString __fastcall GetOdbcTransIsolation();
	void __fastcall SetOdbcTransIsolation(const AnsiString Value);
	AnsiString __fastcall GetDecimalSeparator();
	void __fastcall SetDecimalSeparator(const AnsiString Value);
	bool __fastcall GetTrimChar(void);
	void __fastcall SetTrimChar(const bool Value);
	AnsiString __fastcall GetCustomString();
	void __fastcall SetCustomString(const AnsiString Value);
	
public:
	AnsiString StrConnectionString;
	AnsiString StrTrimChar;
	AnsiString StrOdbcTransIsolation;
	AnsiString StrDecimalSeparator;
	AnsiString StrCustomString;
	AnsiString StrPrepareSQL;
	__fastcall TDBXOpenOdbcProperties(Dbxcommon::TDBXContext* DBXContext);
	__property AnsiString ConnectionString = {read=GetConnectionString, write=SetConnectionString};
	__property AnsiString Database = {read=GetDatabase, write=SetDatabase};
	__property AnsiString UserName = {read=GetUserName, write=SetUserName};
	__property AnsiString PassWord = {read=GetPassWord, write=SetPassWord};
	__property int BlobSize = {read=GetBlobSize, write=SetBlobSize, nodefault};
	__property AnsiString OdbcTransIsolation = {read=GetOdbcTransIsolation, write=SetOdbcTransIsolation};
	__property AnsiString DecimalSeparator = {read=GetDecimalSeparator, write=SetDecimalSeparator};
	__property bool TrimChar = {read=GetTrimChar, write=SetTrimChar, nodefault};
	__property AnsiString CustomString = {read=GetCustomString, write=SetCustomString};
public:
	#pragma option push -w-inl
	/* TDBXProperties.Destroy */ inline __fastcall virtual ~TDBXOpenOdbcProperties(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXDynalinkDriverLoaderOpenOdbc;
class PASCALIMPLEMENTATION TDBXDynalinkDriverLoaderOpenOdbc : public Dbxdynalinknative::TDBXDynalinkDriverLoader 
{
	typedef Dbxdynalinknative::TDBXDynalinkDriverLoader inherited;
	
public:
	virtual Dbxcommon::TDBXDriver* __fastcall Load(const Dbxcommon::TDBXDriverDef &DriverDef);
	virtual Dbxdynalink::TDBXDynalinkDriver* __fastcall CreateDynalinkDriver(void);
public:
	#pragma option push -w-inl
	/* TDBXDynalinkDriverCommonLoader.Create */ inline __fastcall virtual TDBXDynalinkDriverLoaderOpenOdbc(void) : Dbxdynalinknative::TDBXDynalinkDriverLoader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXDynalinkDriverLoaderOpenOdbc(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXDynalinkDriverNativeOpenOdbc;
class PASCALIMPLEMENTATION TDBXDynalinkDriverNativeOpenOdbc : public Dbxdynalinknative::TDBXDynalinkDriverNative 
{
	typedef Dbxdynalinknative::TDBXDynalinkDriverNative inherited;
	
protected:
	virtual Dbxcommon::TDBXConnection* __fastcall CreateConnection(Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder);
public:
	#pragma option push -w-inl
	/* TDBXDynalinkDriverNative.Create */ inline __fastcall TDBXDynalinkDriverNativeOpenOdbc(Dbxcommon::TDBXDriver* DriverClone, void * DriverHandle, Dbxdynalink::TDBXMethodTable* MethodTable) : Dbxdynalinknative::TDBXDynalinkDriverNative(DriverClone, DriverHandle, MethodTable) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXDynalinkDriver.Destroy */ inline __fastcall virtual ~TDBXDynalinkDriverNativeOpenOdbc(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXDynalinkConnectionOpenOdbc;
class PASCALIMPLEMENTATION TDBXDynalinkConnectionOpenOdbc : public Dbxdynalink::TDBXDynalinkConnection 
{
	typedef Dbxdynalink::TDBXDynalinkConnection inherited;
	
public:
	AnsiString dbxoodbc_version_min;
	
private:
	WideString FDBMSVersion;
	WideString FQuoteChar;
	void __fastcall DoDerivedOpenBefore(void);
	void __fastcall DoDerivedOpenAfter(void);
	
protected:
	virtual WideString __fastcall GetProductVersion();
	virtual WideString __fastcall GetProductName();
	virtual void __fastcall DerivedGetCommands(WideString CommandType, Widestrings::TWideStrings* List);
	virtual void __fastcall DerivedGetCommandTypes(Widestrings::TWideStrings* List);
	virtual void __fastcall DerivedOpen(void);
	virtual Dbxcommon::TDBXCommand* __fastcall DerivedCreateCommand(void)/* overload */;
	virtual Dbxcommon::TDBXDatabaseMetaData* __fastcall GetDatabaseMetaData(void);
	
public:
	virtual void __fastcall Close(void);
	virtual WideString __fastcall GetVendorProperty(const WideString Name);
public:
	#pragma option push -w-inl
	/* TDBXDynalinkConnection.Create */ inline __fastcall TDBXDynalinkConnectionOpenOdbc(Dbxcommon::TDBXConnectionBuilder* ConnectionBuilder, void * ConnectionHandle, Dbxdynalink::TDBXMethodTable* MethodTable) : Dbxdynalink::TDBXDynalinkConnection(ConnectionBuilder, ConnectionHandle, MethodTable) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXConnectionEx.Destroy */ inline __fastcall virtual ~TDBXDynalinkConnectionOpenOdbc(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXMorphicCommandOpenOdbc;
class PASCALIMPLEMENTATION TDBXMorphicCommandOpenOdbc : public Dbxdelegate::TDBXMorphicCommand 
{
	typedef Dbxdelegate::TDBXMorphicCommand inherited;
	
protected:
	virtual Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
	
public:
	__fastcall TDBXMorphicCommandOpenOdbc(Dbxcommon::TDBXContext* DBXContext, Dbxcommon::TDBXConnection* Connection);
public:
	#pragma option push -w-inl
	/* TDBXMorphicCommand.Destroy */ inline __fastcall virtual ~TDBXMorphicCommandOpenOdbc(void) { }
	#pragma option pop
	
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
	#pragma option push -w-inl
	/* TDBXDataExpressProviderContext.Create */ inline __fastcall TDBXDataExpressProviderContextOpenOdbc(void) : Dbxmetadatacommandfactory::TDBXDataExpressProviderContext() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TDBXDataExpressProviderContext.Destroy */ inline __fastcall virtual ~TDBXDataExpressProviderContextOpenOdbc(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXCustomOpenODBCMetaDataReader;
class PASCALIMPLEMENTATION TDBXCustomOpenODBCMetaDataReader : public Dbxmetadatareader::TDBXBaseMetaDataReader 
{
	typedef Dbxmetadatareader::TDBXBaseMetaDataReader inherited;
	
protected:
	char DoubleQuote;
	bool FMetadataInitialized;
	WideString FQuoteChar;
	int FUseAnsiStrings;
	void __fastcall InitMetadata(TDBXDynalinkConnectionOpenOdbc* Connection);
	void __fastcall CheckMetadata(void);
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	HIDESBASE virtual void __fastcall PopulateDataTypes(const Dbxplatformutil::TDBXObjectStore* Hash, const Dbxplatformutil::TDBXArrayList* Types, const Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlIdentifierQuotePrefix();
	virtual WideString __fastcall GetSqlIdentifierQuoteSuffix();
	virtual bool __fastcall IsParameterMetadataSupported(void);
	virtual bool __fastcall IsLowerCaseIdentifiersSupported(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual bool __fastcall IsDescendingIndexSupported(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual WideString __fastcall GetSqlIdentifierQuoteChar();
	virtual WideString __fastcall GetSqlProcedureQuoteChar();
	virtual bool __fastcall IsMultipleCommandsSupported(void);
	virtual bool __fastcall IsTransactionsSupported(void);
	virtual bool __fastcall IsNestedTransactionsSupported(void);
	virtual bool __fastcall IsSetRowSizeSupported(void);
	bool __fastcall GetUseAnsiStrings(void);
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXCustomOpenODBCMetaDataReader(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXCustomOpenODBCMetaDataReader(void) : Dbxmetadatareader::TDBXBaseMetaDataReader() { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommand;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommand : public Dbxmetadatacommand::TDBXMetaDataCommand 
{
	typedef Dbxmetadatacommand::TDBXMetaDataCommand inherited;
	
protected:
	virtual Dbxcommon::TDBXReader* __fastcall DerivedExecuteQuery(void);
public:
	#pragma option push -w-inl
	/* TDBXMetaDataCommand.Create */ inline __fastcall TDBXOpenODBCMetaDataCommand(Dbxcommon::TDBXContext* DBXContext, Dbxcommon::TDBXCommand* MorphicCommand, Dbxmetadatareader::TDBXMetaDataReader* Provider) : Dbxmetadatacommand::TDBXMetaDataCommand(DBXContext, MorphicCommand, Provider) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TDBXMetaDataCommand.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommand(void) { }
	#pragma option pop
	
};


typedef TMetaClass* TDBXOpenODBCMetaDataReaderClass;

#pragma option push -b-
enum Dbx34Drv__51 { mmSQL, mmDBX };
#pragma option pop

typedef Set<Dbx34Drv__51, mmSQL, mmDBX>  TMetadataMode;

class DELPHICLASS TDBXOpenODBCMetaDataCommandFactory;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactory : public Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory 
{
	typedef Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory inherited;
	
protected:
	TMetaClass* FDBXMetaDataReaderClass;
	Dbxcommon::TDBXConnection* FCurrentConnection;
	int fMetadataSupported;
	TMetadataMode fMetadataMode;
	int FUseAnsiStrings;
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
	void __fastcall InitMetaDataReaderClass(Dbxcommon::TDBXConnection* Connection);
	
public:
	virtual Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
	HIDESBASE TDBXCustomOpenODBCMetaDataReader* __fastcall CreateMetaDataReader(Dbxcommon::TDBXConnection* Connection)/* overload */;
	virtual Dbxcommon::TDBXCommand* __fastcall CreateCommand(Dbxcommon::TDBXContext* DbxContext, Dbxcommon::TDBXConnection* Connection, Dbxcommon::TDBXCommand* MorphicCommand);
	WideString __fastcall GetProductName();
	/*         class method */ static void __fastcall RegisterMetaDataCommandFactory(TMetaClass* vmt);
	/*         class method */ static void __fastcall UnRegisterMetaDataCommandFactory(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactory(void) : Dbxmetadatacommandfactory::TDBXMetaDataCommandFactory() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactory(void) { }
	#pragma option pop
	
};


typedef TMetaClass* TDBXOpenODBCMetaDataCommandFactoryClass;

class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryCustom;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryCustom : public TDBXOpenODBCMetaDataCommandFactory 
{
	typedef TDBXOpenODBCMetaDataCommandFactory inherited;
	
public:
	virtual Dbxmetadatareader::TDBXMetaDataReader* __fastcall CreateMetaDataReader(void)/* overload */;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryCustom(void) : TDBXOpenODBCMetaDataCommandFactory() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryCustom(void) { }
	#pragma option pop
	
	
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
	virtual WideString __fastcall GetProductName();
	virtual bool __fastcall IsNestedTransactionsSupported(void);
	virtual bool __fastcall IsSetRowSizeSupported(void);
	virtual WideString __fastcall GetSqlForSchemas();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForViews();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual WideString __fastcall GetSqlForForeignKeys();
	virtual WideString __fastcall GetSqlForForeignKeyColumns();
	virtual WideString __fastcall GetSqlForSynonyms();
	virtual WideString __fastcall GetSqlForProcedures();
	virtual WideString __fastcall GetSqlForProcedureSources();
	virtual WideString __fastcall GetSqlForProcedureParameters();
	virtual WideString __fastcall GetSqlForPackages();
	virtual WideString __fastcall GetSqlForPackageSources();
	virtual WideString __fastcall GetSqlForPackageProcedures();
	virtual WideString __fastcall GetSqlForPackageProcedureParameters();
	virtual WideString __fastcall GetSqlForUsers();
	virtual WideString __fastcall GetSqlForRoles();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	
public:
	__fastcall virtual TDBXOpenODBCMetaDataReader(void);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchDataTypes(void);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchCatalogs(void);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchSchemas(const WideString Catalog);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchTables(const WideString Catalog, const WideString Schema, const WideString TableName, const WideString TableType);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchViews(const WideString Catalog, const WideString Schema, const WideString View);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchColumns(const WideString Catalog, const WideString Schema, const WideString Table);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchColumnConstraints(const WideString Catalog, const WideString Schema, const WideString Table);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchIndexes(const WideString Catalog, const WideString Schema, const WideString Table);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchIndexColumns(const WideString Catalog, const WideString Schema, const WideString Table, const WideString Index);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchForeignKeys(const WideString Catalog, const WideString Schema, const WideString Table);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchForeignKeyColumns(const WideString Catalog, const WideString Schema, const WideString Table, const WideString ForeignKeyName, const WideString PrimaryCatalog, const WideString PrimarySchema, const WideString PrimaryTable, const WideString PrimaryKeyName);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchSynonyms(const WideString Catalog, const WideString Schema, const WideString Synonym);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchProcedures(const WideString Catalog, const WideString Schema, const WideString ProcedureName, const WideString ProcedureType);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchProcedureSources(const WideString Catalog, const WideString Schema, const WideString Procedure);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchProcedureParameters(const WideString Catalog, const WideString Schema, const WideString Procedure, const WideString Parameter);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchPackages(const WideString Catalog, const WideString Schema, const WideString PackageName);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchPackageProcedures(const WideString Catalog, const WideString Schema, const WideString PackageName, const WideString ProcedureName, const WideString ProcedureType);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchPackageProcedureParameters(const WideString Catalog, const WideString Schema, const WideString PackageName, const WideString ProcedureName, const WideString ParameterName);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchPackageSources(const WideString Catalog, const WideString Schema, const WideString PackageName);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchUsers(void);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchRoles(void);
	virtual Dbxtablestorage::TDBXTableStorage* __fastcall FetchReservedWords(void);
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReader(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
#define NullString ""
extern PACKAGE bool bIsDbx34Drv;

}	/* namespace Dbx34drv */
using namespace Dbx34drv;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drv
