{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is ExceptDlg.pas.                                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Petr Vones.                                        }
{ Portions created by Petr Vones are Copyright (C) of Petr Vones.                                  }
{                                                                                                  }
{**************************************************************************************************}

unit ExceptDlg;

{$I jcl.inc}
{$D+,L+}
{+}

{$DEFINE _JCL_EXCEPTION_COMOBJ_}

{+.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts,
  JclSysUtils,{$IFDEF UNITVERSIONING}JclUnitVersioning, JclUnitVersioningProviders,{$ENDIF}JclDebug,
  cxControls, cxContainer, cxEdit, cxImage, cxTextEdit, cxMemo, cxButtons, cxLabel, Menus, cxLookAndFeelPainters;

const
  UM_CREATEDETAILS = WM_USER + $100;
  {+}
  UM_ADDREPORT = UM_CREATEDETAILS + 1;
  cMaxCycledErrors = 7;
  cMaxErrors = 100; // or = MaxInt

  ReportToLogEnabled   = $00000001; // TExceptionDialog.Tag property
  DisableTextScrollbar = $00000002; // TExceptionDialog.Tag property

  {+.}

type

  {+}
  TExcDialogSystemInfo = (siStackList, siOsInfo, siModuleList, siModule, siUnitVersioning, siActiveControls);
  TExcDialogSystemInfos = set of TExcDialogSystemInfo;
  TExceptionDialog = class;
  TOnShowException = procedure(Sender: TExceptionDialog; E: Exception) of object;
  TSetMemCheckActiveProc = function({new state}Active: Boolean): Boolean; // returned previous state
  {+.}

  TExceptionDialog = class(TForm)
    BevelDetails: TBevel;
    ShapeDetailsMemo: TShape;
    ShapeTextMemo: TShape;
    fImage: TcxImage;
    TextMemo: TcxMemo;
    DetailsMemo: TcxMemo;
    OkBtn: TcxButton;
    CopyButton: TcxButton;
    DetailsBtn: TcxButton;
    LErrorCount: TcxLabel;
    LErrorCountCaption: TcxLabel;
    KillBtn: TcxButton;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure KillBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    FDetailsVisible: Boolean;
    FThreadID: DWORD;
    FIsMainThead: Boolean;
    FLastActiveControl: TWinControl;
    FNonDetailsHeight: Integer;
    FFullHeight: Integer;
    //FSimpleLog: TJclSimpleLog;

    FDetailsCalculated: Boolean;

    {+}
    fEMessage: string;
    fStackListCaption: string;
    fStackListFirst: TJclStackInfoList;
    fExceptAddrFirst: Pointer;
    fLastActiveControlFirst: TWinControl;
    {+.}

    //procedure ReportToLog;
    procedure SaveToLogFile(const FileName: TFileName);
    function GetReportAsText: string;
    procedure SetDetailsVisible(const Value: Boolean);
    procedure UMCreateDetails(var Message: TMessage); message UM_CREATEDETAILS;
    {+}
    procedure MakeStackList(bCreateByExceptAddr: Boolean = False);
    procedure CleanStackList();
    procedure DoCalculateDetails();
    procedure UMAddReport(var Message: TMessage); message UM_ADDREPORT;
    procedure AddReport();
    procedure DoAddReport();
    {+.}
  protected
    procedure AfterCreateDetails; dynamic;
    procedure BeforeCreateDetails; dynamic;
    {+}
    procedure CreateDetailInfo; dynamic;
    {+.}
    procedure CreateDetails; dynamic;
    procedure CreateReport(const SystemInfo: TExcDialogSystemInfos);
    function ReportMaxColumns: Integer; virtual;
    function ReportNewBlockDelimiterChar: Char; virtual;
    procedure NextDetailBlock;
    {+}
    function DelimiterStr: string;
    {+.}
    procedure UpdateTextMemoScrollbars;

  {+}
  protected
    fErrorIcon: HICON;
    fSaveDetailsVisible: Boolean;
    fSaveHeight: Integer;
    fOnShowException: TOnShowException;
    iErrorCount: Integer;

    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure DoOnShowException(E: Exception; var Handled: Boolean); virtual;
    procedure PaintIcon(); virtual;
    procedure PrepareKillBtnVisible;

    procedure SetName(const NewName: TComponentName); override;
  {+.}
  {+} // provision to compatibility with old version:
  public
    Bevel1: TBevel;
    TextLabel: TcxMemo;
    ShapeTextLabel: TShape;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateTextLabelScrollbars;
  {+.}
  public
    procedure CopyReportToClipboard();
    class procedure ExceptionHandler(Sender: TObject; E: Exception);
    class procedure ExceptionThreadHandler(Thread: TJclDebugThread);
    class procedure ShowException(E: TObject; Thread: TJclDebugThread);
    property DetailsVisible: Boolean read FDetailsVisible write SetDetailsVisible;
    property ReportAsText: string read GetReportAsText;
    //property SimpleLog: TJclSimpleLog read FSimpleLog;
  end;

  TExceptionDialogClass = class of TExceptionDialog;

var
  ExceptionDialogClass: TExceptionDialogClass = TExceptionDialog;
  {+}
  FirstExceptionImmediateStackCalculate: Boolean = False;
  RawExceptionTrace: Boolean = True;
  ExcDialogSystemInfos: TExcDialogSystemInfos = [siStackList, siOsInfo, siModule, siModuleList, siActiveControls];
  SimpleExceptionHandler: Boolean = False;
  ShowAllThreadStack: Boolean = True;
  FullStack: Boolean = False;
  ExceptionLogFileName: string = 'filename.log';
  UseAppEvents: Boolean = False;
  ExceptionDialogPersistent: Boolean = False; // AV for typhoon
  UseSystemMemoryManager: Boolean = False; // := IsMemCheck // FREEZE for typhoon
  // MemCheck:
  SetMemCheckActiveProc: TSetMemCheckActiveProc;
  {+.}
  {+}
  {English:}{
  LText_OK: string = '&OK';
  LText_CopyAll: string = '&Copy All';
  LText_Details: string = '&Details';
  LText_Kill: string = '&Kill App';
  {English.}

  {Russian:}
  //{
  LText_OK: string = '&Закрыть';
  LText_CopyAll: string = '&Копировать всё';
  LText_Details: string = '&Детально';
  LText_Kill: string = '&Аварийный выход';
  {Russian.}

  {+.}

  {+}
  procedure InitializeHandler();
  procedure UnInitializeHandler();
  function IsInitialized(): Boolean;
  {+.}

implementation

{$R *.dfm}

uses
  ClipBrd, Math,
{+}
{$IFDEF _JCL_EXCEPTION_COMOBJ_}
  ComObj,
{$ENDIF _JCL_EXCEPTION_COMOBJ_}
{+.}
  JclBase, JclFileUtils, JclHookExcept, JclPeImage, JclStrings, JclSysInfo, JclWin32;

resourcestring
  RsAppError = '%s - application error';
  RsExceptionClass = 'Exception class: %s';
  RsExceptionMessage = 'Exception message: %s';
  RsExceptionAddr = 'Exception address: %p';
  RsStackList = 'Stack list, generated %s';
  RsModulesList = 'List of loaded modules:';
  RsOSVersion = 'System   : %s %s, Version: %d.%d, Build: %x, "%s"';
  RsProcessor = 'Processor: %s, %s, %d MHz';
  RsMemory = 'Memory: %d; free %d';
  RsScreenRes = 'Display  : %dx%d pixels, %d bpp';
  RsActiveControl = 'Active Controls hierarchy:';
  {+}
  RsInvalidAddress = 'Invalid %s Address:';
  {+.}
  RsThread = 'Thread: %s';
  RsMissingVersionInfo = '(no module version info)';
  RsExceptionStack = 'Exception stack';
  RsMainThreadID = 'Main thread ID = %d';
  RsExceptionThreadID = 'Exception thread ID = %d';
  RsMainThreadCallStack = 'Call stack for main thread';
  RsThreadCallStack = 'Call stack for thread %d %s "%s"';
  RsExceptionThreadCallStack = 'Call stack for exception thread %s';
  RsErrorMessage = 'There was an error during the execution of this program.' + NativeLineBreak +
                   'The application might become unstable and even useless.' + NativeLineBreak +
                   'It''s recommended that you save your work and close this application.' + NativeLineBreak + NativeLineBreak;
  RsDetailsIntro = 'Exception log with detailed tech info. Generated on %s.' + NativeLineBreak +
                   'You may send it to the application vendor, helping him to understand what had happened.' + NativeLineBreak +
                   ' Application title: %s' + NativeLineBreak +
                   ' Application file: %s';
  {$IFDEF UNITVERSIONING}
  RsUnitVersioningIntro = 'Unit versioning information:';
  {$ENDIF}

var
  ExceptionDialog: TExceptionDialog;

//============================================================================
// Helper routines
//============================================================================

// SortModulesListByAddressCompare
// sorts module by address
function SortModulesListByAddressCompare(List: TStringList;
  Index1, Index2: Integer): Integer;
var
  Addr1, Addr2: TJclAddr;
begin
  Addr1 := TJclAddr(List.Objects[Index1]);
  Addr2 := TJclAddr(List.Objects[Index2]);
  if Addr1 > Addr2 then
    Result := 1
  else if Addr1 < Addr2 then
    Result := -1
  else
    Result := 0;
end;

//==================================================================================================
// TApplication.HandleException method code hooking for exceptions from DLLs
//==================================================================================================

// We need to catch the last line of TApplication.HandleException method:
// [...]
//   end else
//    SysUtils.ShowException(ExceptObject, ExceptAddr);
// end;

{
 TODO:
   Warning: Symbol 'EStackOverflow' is deprecated
}
{$warnings off}
procedure HookShowException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  {todo: handle stack overflow in other thread}
  if (ExceptObject <> nil) and (ExceptObject.ClassType <> nil)
     and JclValidateModuleAddress(ExceptAddr) and (ExceptObject.InstanceSize >= Exception.InstanceSize)
     and (ExceptObject.ClassType <> EStackOverflow) then
  begin
    TExceptionDialog.ExceptionHandler(nil, Exception(ExceptObject));
  end
  else
    SysUtils.ShowException(ExceptObject, ExceptAddr);
end;
{$warnings on}

//--------------------------------------------------------------------------------------------------

function HookTApplicationHandleException: Boolean;
const
  CallOffset      = $86;   // Until D2007
  CallOffsetDebug = $94;   // Until D2007
  CallOffsetWin32 = $7A;   // D2009 and newer
  CallOffsetWin64 = $95;   // DXE2 for Win64
type
  PCALLInstruction = ^TCALLInstruction;
  TCALLInstruction = packed record
    Call: Byte;
    Address: Integer;
  end;
var
  TApplicationHandleExceptionAddr, SysUtilsShowExceptionAddr: Pointer;
  CALLInstruction: TCALLInstruction;
  CallAddress: Pointer;
  WrittenBytes: Cardinal;

  function CheckAddressForOffset(Offset: Cardinal): Boolean;
  begin
    try
      CallAddress := Pointer(Cardinal(TApplicationHandleExceptionAddr) + Offset);
      CALLInstruction.Call := $E8;
      Result := PCALLInstruction(CallAddress)^.Call = CALLInstruction.Call;
      if Result then
      begin
        if IsCompiledWithPackages then
          Result := PeMapImgResolvePackageThunk(Pointer(SizeInt(CallAddress) + Integer(PCALLInstruction(CallAddress)^.Address) + SizeOf(CALLInstruction))) = SysUtilsShowExceptionAddr
        else
          Result := PCALLInstruction(CallAddress)^.Address = SizeInt(SysUtilsShowExceptionAddr) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      end;
    except
      Result := False;
    end;
  end;

begin
  TApplicationHandleExceptionAddr := PeMapImgResolvePackageThunk(@TApplication.HandleException);
  SysUtilsShowExceptionAddr := PeMapImgResolvePackageThunk(@SysUtils.ShowException);
  if Assigned(TApplicationHandleExceptionAddr) and Assigned(SysUtilsShowExceptionAddr) then
  begin
    Result := CheckAddressForOffset(CallOffset) or CheckAddressForOffset(CallOffsetDebug) or
      CheckAddressForOffset(CallOffsetWin32) or CheckAddressForOffset(CallOffsetWin64);
    if Result then
    begin
      CALLInstruction.Address := SizeInt(@HookShowException) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      Result := WriteProtectedMemory(CallAddress, @CallInstruction, SizeOf(CallInstruction), WrittenBytes);
    end;
  end
  else
    Result := False;
end;

var
  MemCheckDisableUpdateCount: Integer;
  MemCheckActiveSave: Boolean;

procedure MemCheckBeginDisable;
begin
  if (InterlockedIncrement(MemCheckDisableUpdateCount) = 1) then
    if Assigned(SetMemCheckActiveProc) then
      MemCheckActiveSave := SetMemCheckActiveProc(False);
end;

procedure MemCheckEndDisable;
begin
  if (InterlockedDecrement(MemCheckDisableUpdateCount) = 0) then
    if Assigned(SetMemCheckActiveProc) then
      SetMemCheckActiveProc(MemCheckActiveSave);
end;

{$IFNDEF COMPILER10_UP}
type
  TMemoryManagerEx = TMemoryManager;
{$ENDIF}

function RestoreSystemMemoryManager(var OldMemoryManager: TMemoryManagerEx): Boolean;
var
  NewMemoryManager: TMemoryManagerEx;
begin
  Result := UseSystemMemoryManager and IsMemoryManagerSet;
  if Result then
  begin
    GetMemoryManager(OldMemoryManager);
    FillChar(NewMemoryManager, SizeOf(NewMemoryManager), 0);
    NewMemoryManager.FreeMem := SysFreeMem;
    NewMemoryManager.GetMem := SysGetMem;
    {$IFDEF COMPILER10_UP}
    NewMemoryManager.AllocMem := SysAllocMem;
    {$ENDIF}
    NewMemoryManager.ReallocMem := SysReallocMem;
    //{$IFDEF COMPILER10_UP}
    //NewMemoryManager.RegisterExpectedMemoryLeak := SysRegisterExpectedMemoryLeak;
    //NewMemoryManager.UnregisterExpectedMemoryLeak := SysUnregisterExpectedMemoryLeak;
    //{$ENDIF}
    SetMemoryManager(NewMemoryManager);
  end;
end;

//============================================================================
// Exception dialog
//============================================================================

var
  ExceptionShowing: Boolean;

//=== { TExceptionDialog } ===============================================

procedure TExceptionDialog.AfterCreateDetails;
begin
  //SaveBtn.Enabled := True;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.BeforeCreateDetails;
begin
  //SaveBtn.Enabled := False;
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.ReportMaxColumns: Integer;
begin
  Result := {+}100{+.};
end;

//----------------------------------------------------------------------------

{procedure TExceptionDialog.SaveBtnClick(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    DefaultExt := '.log';
    FileName := 'filename.log';
    Filter := 'Log Files (*.log)|*.log|All files (*.*)|*.*';
    Title := 'Save log as...';
    Options := [ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn,ofEnableSizing,ofDontAddToRecent];
    if Execute then
      SaveToLogFile(FileName);
  finally
    Free;
  end;
end;{}

//----------------------------------------------------------------------------

procedure TExceptionDialog.CopyReportToClipboard;
begin
  ClipBoard.AsText := ReportAsText;
end;

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.CreateDetailInfo;
begin
  CreateReport(ExcDialogSystemInfos);
end;
{+.}

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.CreateDetails;
begin
  Screen.Cursor := crHourGlass;
  DetailsMemo.Lines.BeginUpdate;
  try
    CreateDetailInfo;
    {+}
    if iErrorCount = 1 then
    begin
      //ReportToLog;
      if (Tag and ReportToLogEnabled) <> 0 then
        SaveToLogFile(ExceptionLogFileName);
    end;
    {+.}
    DetailsMemo.SelStart := 0;
    SendMessage(DetailsMemo.Handle, EM_SCROLLCARET, 0, 0);
    AfterCreateDetails;
  finally
    DetailsMemo.Lines.EndUpdate;
    OkBtn.Enabled := True;
    DetailsBtn.Enabled := True;
    {+}
    CopyButton.Enabled := True;
    {+.}
    OkBtn.SetFocus;
    Screen.Cursor := crDefault;
  end;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CreateReport(const SystemInfo: TExcDialogSystemInfos);
var
  SL: TStringList;
  I: Integer;
  ModuleName: TFileName;
  NtHeaders32: PImageNtHeaders32;
  NtHeaders64: PImageNtHeaders64;
  ModuleBase: TJclAddr;
  ImageBaseStr: string;
  C: TWinControl;
  CpuInfo: TCpuInfo;
  ProcessorDetails: string;
  StackList: TJclStackInfoList;
  ThreadList: TJclDebugThreadList;
  AThreadID: DWORD;
  PETarget: TJclPeTarget;
  {$IFDEF UNITVERSIONING}
  UnitVersioning: TUnitVersioning;
  UnitVersioningModule: TUnitVersioningModule;
  UnitVersion: TUnitVersion;
  ModuleIndex, UnitIndex: Integer;
  {$ENDIF}

  {+}
  function IsValidBlockAddr(Addr: Pointer; Size: DWord): boolean;
  begin
    Result := (FindHInstance(Pointer(Addr)) <> 0) and
      (not IsBadReadPtr(Pointer(Addr), Size));
  end;
  {+.}

begin
  SL := nil;
  try
    {+}
    DetailsMemo.Lines.BeginUpdate;
    {+.}
    // Stack list
    if siStackList in SystemInfo then
    begin
      {+}
      if fStackListFirst = nil then
        MakeStackList({CreateByExceptAddr:}True);
      if fStackListFirst <> nil then
      begin
        DetailsMemo.Lines.Add(Format(fStackListCaption, [DateTimeToStr(fStackListFirst.TimeStamp)]));
        //
        //procedure TJclStackInfoList.AddToStrings(Strings: TStrings; IncludeModuleName: Boolean = False;
        //  IncludeAddressOffset: Boolean = False; IncludeStartProcLineOffset: Boolean = False;
        //  IncludeVAdress: Boolean = False);
        //
        fStackListFirst.AddToStrings(DetailsMemo.Lines, {Module}siModule in SystemInfo, {AOffs}True, {POffs}True, {VAddr}True);
        NextDetailBlock;
      end;
      {+.}
    end;
    {+}
    if ShowAllThreadStack then
    begin // TODO: Integrate handle FullStack like code: TExceptionDialog.MakeStackList
    {+.}
      // Main thread
      {+}
      if MainThreadID <> FThreadID then
      begin
      {+.}
        StackList := JclCreateThreadStackTraceFromID(True, MainThreadID);
        if Assigned(StackList) then
        begin
          DetailsMemo.Lines.Add(LoadResString(PResStringRec(@RsMainThreadCallStack)));
          DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
          StackList.AddToStrings(DetailsMemo.Lines, {Module}siModule in SystemInfo, {AOffs}True, {POffs}True, {VAddr}True);
          NextDetailBlock;
        end;
      {+}
      end;
      {+.}
      // All threads
      ThreadList := JclDebugThreadList;
      ThreadList.Lock.Enter; // avoid modifications
      try
        for I := 0 to ThreadList.ThreadIDCount - 1 do
        begin
          AThreadID := ThreadList.ThreadIDs[I];
          if (AThreadID <> FThreadID) then
          begin
            StackList := JclCreateThreadStackTrace(True, ThreadList.ThreadHandles[I]);
            if Assigned(StackList) then
            begin
              DetailsMemo.Lines.Add(Format(RsThreadCallStack, [AThreadID, ThreadList.ThreadInfos[AThreadID], ThreadList.ThreadNames[AThreadID]]));
              DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
              StackList.AddToStrings(DetailsMemo.Lines, {Module}siModule in SystemInfo, {AOffs}True, {POffs}True, {VAddr}True);
              NextDetailBlock;
            end;
          end;
        end;
      finally
        ThreadList.Lock.Leave;
      end;
    {+}
    end ; // if ShowAllThreadStack
    {+.}
    {+}
    // Active controls
    if (siActiveControls in SystemInfo) and (FLastActiveControl <> nil) then
    begin
      DetailsMemo.Lines.Add(RsActiveControl);

      {+}
      if fStackListFirst <> nil then
        C := fLastActiveControlFirst
      else
        C := FLastActiveControl;
      {+.}

      while C <> nil do
      begin
        if IsValidBlockAddr(C, SizeOf(C)) then
        begin
          try
            DetailsMemo.Lines.Add(Format('%s "%s"', [C.ClassName, C.Name]));
            C := C.Parent;
          except
            DetailsMemo.Lines.Add(
              Format(RsInvalidAddress, ['parent']) + IntToHex(Integer(C), 0)
            );
            C := nil;
          end;
        end
        else
        begin
          DetailsMemo.Lines.Add(
            Format(RsInvalidAddress, ['parent']) + IntToHex(Integer(C), 0)
          );
          C := nil;
        end;
      end;
      NextDetailBlock;
    end;
    {+.}
    // System and OS information
    if siOsInfo in SystemInfo then
    begin
      DetailsMemo.Lines.Add(Format(RsOSVersion, [GetWindowsVersionString, NtProductTypeString,
        Win32MajorVersion, Win32MinorVersion, Win32BuildNumber, Win32CSDVersion]));
      // CpuInfo:
      GetCpuInfo(CpuInfo);
      ProcessorDetails := Format(RsProcessor, [CpuInfo.Manufacturer, CpuInfo.CpuName,
        RoundFrequency(CpuInfo.FrequencyInfo.NormFreq)]);
      if not CpuInfo.IsFDIVOK then
        ProcessorDetails := ProcessorDetails + ' [FDIV Bug]';
      if CpuInfo.ExMMX then
        ProcessorDetails := ProcessorDetails + ' MMXex';
      if CpuInfo.MMX then
        ProcessorDetails := ProcessorDetails + ' MMX';
      if sse in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE';
      if sse2 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE2';
      if sse3 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE3';
      if ssse3 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSSE3';
      if sse41 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE41';
      if sse42 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE42';
      if sse4A in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE4A';
      if sse5 in CpuInfo.SSE then
        ProcessorDetails := ProcessorDetails + ' SSE5';
      if CpuInfo.Ex3DNow then
        ProcessorDetails := ProcessorDetails + ' 3DNow!ex';
      if CpuInfo._3DNow then
        ProcessorDetails := ProcessorDetails + ' 3DNow!';
      if CpuInfo.Is64Bits then
        ProcessorDetails := ProcessorDetails + ' 64 bits';
      if CpuInfo.DEPCapable then
        ProcessorDetails := ProcessorDetails + ' DEP';
      DetailsMemo.Lines.Add(ProcessorDetails);
      // CpuInfo.
      DetailsMemo.Lines.Add(Format(RsMemory, [GetTotalPhysicalMemory div 1024 div 1024,
      GetFreePhysicalMemory div 1024 div 1024]));
      DetailsMemo.Lines.Add(Format(RsScreenRes, [Screen.Width, Screen.Height, GetBPP]));
      NextDetailBlock;
    end;

    // Modules list
    if (siModuleList in SystemInfo) then
    begin
      SL := TStringList.Create;
      if LoadedModulesList(SL, GetCurrentProcessId) then
      begin
        {+}
        {$IFDEF UNITVERSIONING}
        if (siUnitVersioning in SystemInfo) then
        begin
          UnitVersioning := GetUnitVersioning;
          UnitVersioning.RegisterProvider(TJclDefaultUnitVersioningProvider);
        end
        else
          UnitVersioning := nil;
        {$ENDIF}
        {+.}
        DetailsMemo.Lines.Add(RsModulesList);
        SL.CustomSort(SortModulesListByAddressCompare);
        for I := 0 to SL.Count - 1 do
        begin
          ModuleName := SL[I];
          ModuleBase := TJclAddr(SL.Objects[I]);
          DetailsMemo.Lines.Add(Format('[' + HexDigitFmt + '] %s', [ModuleBase, ModuleName]));
          PETarget := PeMapImgTarget(Pointer(ModuleBase));
          NtHeaders32 := nil;
          NtHeaders64 := nil;
          if PETarget = taWin32 then
            NtHeaders32 := PeMapImgNtHeaders32(Pointer(ModuleBase))
          else
          if PETarget = taWin64 then
            NtHeaders64 := PeMapImgNtHeaders64(Pointer(ModuleBase));
          if (NtHeaders32 <> nil) and (NtHeaders32^.OptionalHeader.ImageBase <> ModuleBase) then
            ImageBaseStr := Format('<' + HexDigitFmt32 + '> ', [NtHeaders32^.OptionalHeader.ImageBase])
          else
          if (NtHeaders64 <> nil) and (NtHeaders64^.OptionalHeader.ImageBase <> ModuleBase) then
            ImageBaseStr := Format('<' + HexDigitFmt64 + '> ', [NtHeaders64^.OptionalHeader.ImageBase])
          else
            ImageBaseStr := StrRepeat(' ', 11);
          if VersionResourceAvailable(ModuleName) then
            with TJclFileVersionInfo.Create(ModuleName) do
            try
              DetailsMemo.Lines.Add(ImageBaseStr + BinFileVersion + ' - ' + FileVersion);
              if FileDescription <> '' then
                DetailsMemo.Lines.Add(StrRepeat(' ', 11) + FileDescription);
            finally
              Free;
            end
          else
            DetailsMemo.Lines.Add(ImageBaseStr + RsMissingVersionInfo);
          {+}
          {$IFDEF UNITVERSIONING}
          if (siUnitVersioning in SystemInfo) then
          {+.}
          begin
            for ModuleIndex := 0 to UnitVersioning.ModuleCount - 1 do
            begin
              UnitVersioningModule := UnitVersioning.Modules[ModuleIndex];
              if UnitVersioningModule.Instance = ModuleBase then
              begin
                if UnitVersioningModule.Count > 0 then
                  DetailsMemo.Lines.Add(StrRepeat(' ', 11) + LoadResString(PResStringRec(@RsUnitVersioningIntro)));
                for UnitIndex := 0 to UnitVersioningModule.Count - 1 do
                begin
                  UnitVersion := UnitVersioningModule.Items[UnitIndex];
                  DetailsMemo.Lines.Add(Format('%s%s %s %s %s', [StrRepeat(' ', 13), UnitVersion.LogPath, UnitVersion.RCSfile, UnitVersion.Revision, UnitVersion.Date]));
                end;
              end;
            end;
          end;
          {$ENDIF}
        end;
        NextDetailBlock;
      end;
    end;
  finally
    {+}
    CleanStackList();
    DetailsMemo.Lines.EndUpdate;
    {+.}
    SL.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.AddReport();
var
  S: string;
begin
  DoCalculateDetails();
  if iErrorCount = 3 then
  begin
    S := DetailsMemo.Text;
    ClipBoard.AsText := S;
  end;
  S := DelimiterStr + #13#10 + LErrorCount.Caption + ')'#13#10 +
    TextMemo.Lines.Text +
    #13#10 + DelimiterStr + #13#10 +
    DetailsMemo.Lines.Text;
  Inc(iErrorCount);
  LErrorCount.Caption := IntToStr(iErrorCount);
  LErrorCount.Visible := True;
  LErrorCountCaption.Visible := True;
  DetailsMemo.Lines.BeginUpdate;
  TextMemo.Lines.BeginUpdate;
  try
    DetailsMemo.Lines.Clear;
    TextMemo.Lines.Clear;
    CreateReport([siStackList, siActiveControls]);
    TextMemo.Lines.Text := fEMessage;
    fEMessage := '';
    DetailsMemo.Lines.Text := DetailsMemo.Lines.Text + S;
    DetailsMemo.SelStart := 0;
    SendMessage(DetailsMemo.Handle, EM_SCROLLCARET, 0, 0);
  finally
    DetailsMemo.Lines.EndUpdate;
    TextMemo.Lines.EndUpdate;
  end;
end;

procedure TExceptionDialog.DoAddReport();
begin
  if FIsMainThead and (GetWindowThreadProcessId(Handle, nil) = MainThreadID) then
    PostMessage(Handle, UM_ADDREPORT, 0, 0)
  else
    AddReport();
end;

procedure TExceptionDialog.MakeStackList(bCreateByExceptAddr: Boolean = False);
var
  i, j: Integer;
  vFirsrCallerAddr: Pointer;
  bRawTrace: Boolean;
  ptrAppHandleExBegin: DWORD;
  ptrAppHandleExEnd: DWORD;
  // ---
  function GetNativeAddr(Ptr: Pointer): DWORD;
  type
    PJumpInstruction = ^TJumpInstruction;
    TJumpInstruction = packed record
      case Byte of
        1: (
          Code: Byte; // jump instruction ($FF)
          Offset: DWord; // jump offset
          UnUsed: Byte;
          );
        2: (
          DW1: DWord;
          DW2: DWord;
          );
    end;
    PPointer = ^Pointer;
    PPPointer = ^PPointer;
  begin
    Result := DWORD(Ptr);
    if (PJumpInstruction(Result)^.Code = $FF) and // long jmp to package_address_5b
      (PJumpInstruction(Integer(Result) + 6)^.Code = $8B) and // mov
      (PJumpInstruction(Integer(Result) + 7)^.Code = $C0) {// eax,eax} then
      Result := DWORD(PPPointer(Integer(Result) + 2)^^);
  end;
  // ---
begin
  FreeAndNil(fStackListFirst);
  // ---
  fExceptAddrFirst := ExceptAddr;
  fLastActiveControlFirst := FLastActiveControl;
  if not bCreateByExceptAddr then
  begin
    fStackListFirst := JclGetExceptStackList(FThreadID);
    if fStackListFirst <> nil then
    begin
      JclRemoveExceptStackList(FThreadID);
      fStackListCaption := RsStackList;
      Exit;
    end;
  end;
  // ---
  fStackListCaption := '#Late ' + RsStackList;
  bRawTrace := RawExceptionTrace;
  if bRawTrace then
    fStackListFirst := JclCreateStackList({Raw=}True, {IgnoreLevels=}7, fExceptAddrFirst{nil})
  else
    fStackListFirst := JclCreateStackList({Raw=}False, {IgnoreLevels=}5, fExceptAddrFirst{nil});
  JclRemoveExceptStackList(fStackListFirst.ThreadID);
  CorrectExceptStackListTop(fStackListFirst, {SkipFirstItem:}True);
  //
  // remove stack items created after exception point
  //
  if (fStackListFirst <> nil) and (fStackListFirst.Count > 0) then
  begin
    if bRawTrace and (not FullStack) then
    begin
      vFirsrCallerAddr := Pointer(DWORD(fStackListFirst.Items[0].CallerAddr) - 5);
      for i := fStackListFirst.Count - 1 downto 1 do
      begin
        if vFirsrCallerAddr = fStackListFirst.Items[i].CallerAddr then
        begin
          fExceptAddrFirst := vFirsrCallerAddr;
          for j := i - 1 downto 0 do
            fStackListFirst.Delete(0);
          Exit;
        end;
      end;
      // ---
      ptrAppHandleExBegin := GetNativeAddr(@TApplication.HandleException);
      ptrAppHandleExEnd := GetNativeAddr(@TApplication.MessageBox);
      for i := 0 to fStackListFirst.Count - 1 do
      begin
        vFirsrCallerAddr := fStackListFirst.Items[i].CallerAddr;
        if ( DWORD(vFirsrCallerAddr) > ptrAppHandleExBegin )
          and ( DWORD(vFirsrCallerAddr) < ptrAppHandleExEnd ) then
        begin
          for j := i downto 0 do
            fStackListFirst.Delete(0);
          Exit;
        end;
      end;
      // ---
      ptrAppHandleExBegin := GetNativeAddr(@SysUtils.ShowException);
      ptrAppHandleExEnd := GetNativeAddr(@SysUtils.Abort);
      for i := 0 to fStackListFirst.Count - 1 do
      begin
        vFirsrCallerAddr := fStackListFirst.Items[i].CallerAddr;
        if ( DWORD(vFirsrCallerAddr) > ptrAppHandleExBegin )
          and ( DWORD(vFirsrCallerAddr) < ptrAppHandleExEnd ) then
        begin
          for j := i downto 0 do
            fStackListFirst.Delete(0);
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TExceptionDialog.CleanStackList();
begin
  if fStackListFirst <> nil then
  begin
    fStackListCaption := '';
    fLastActiveControlFirst := nil;
    fExceptAddrFirst := nil;
    FreeAndNil(fStackListFirst);
  end;
end;
{+.}

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.DetailsBtnClick(Sender: TObject);
begin
  DetailsVisible := not DetailsVisible;
end;

{+}

//--------------------------------------------------------------------------------------------------
procedure TExceptionDialog.KillBtnClick(Sender: TObject);
begin
  TerminateProcess(OpenProcess(PROCESS_TERMINATE, False, GetCurrentProcessID()), 0);
end;

{+.}

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.CopyButtonClick(Sender: TObject);
var
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    {+}
    DoCalculateDetails();
    {+.}
    CopyReportToClipboard;
    MessageBeep(MB_OK);
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;
{+.}

//--------------------------------------------------------------------------------------------------
{+}
var
  LastErrorTime: TDateTime;
  LastErrorTimeCount: Integer;
  ErrorTimeDeltaLimit: Cardinal = 10; // sec
  LastErrorTimeCountLimit: LongInt = 3; // 1..

function FxtDateTimeToSeconds(Value: TDateTime): Cardinal;
var
  vHour, vMin, vSec, vMSec: Word;
begin
  DecodeTime(Value, vHour, vMin, vSec, vMSec);
  Result := vHour * 60 * 60 + vMin * 60 + vSec;
end;

function LastErrorLockName: string;
begin
  Result := '{2F25F98E-B684-4F05-A6AA-453AE1BABD92}' + IntToStr(GetCurrentProcessID);
end;

function BeginLock(const LockName: string; out hLock: THandle; TimeOut: DWORD = INFINITE): Boolean;
var
  S: string;
begin
  S := LockName;
  if S <> '' then
  begin
    S := StringReplace(S, '\', '|', [rfReplaceAll]);
    S := StringReplace(S, #0, '@', [rfReplaceAll]);
    if Length(S) > MAX_PATH  then
      SetLength(S, MAX_PATH);
  end;
  hLock := Windows.CreateMutex(nil, True, PChar(S));
  Result := hLock <> 0;
  if Result then
  begin
    Result := WaitForSingleObject( hLock, TimeOut ) = WAIT_OBJECT_0;
    if not Result then
    begin
      CloseHandle(hLock);
      hLock := 0;
    end;
  end;
  //else
  //  RaiseLastOsError();
end;

procedure EndLock(var hLock: THandle);
begin
  if hLock <> 0 then
  begin
    CloseHandle(hLock);
    hLock := 0;
  end;
end;

procedure TExceptionDialog.PrepareKillBtnVisible;
var
  ErrorTimeDelta: Cardinal;
  hLock: THandle;
begin
  if (not KillBtn.Visible) then
  begin
    BeginLock(LastErrorLockName, hLock, 1000 * 60 *60);
    try
      if (LastErrorTime <> 0) then
      begin
        ErrorTimeDelta := FxtDateTimeToSeconds(Now - LastErrorTime);
        if ErrorTimeDelta < ErrorTimeDeltaLimit then
        begin
          if LastErrorTimeCount < LastErrorTimeCountLimit then
            inc(LastErrorTimeCount)
          else {if LastErrorTimeCount > LastErrorTimeCountLimit then}
            KillBtn.Visible := True;
        end
        else
          LastErrorTimeCount := 0;
      end
      else
      begin
        LastErrorTimeCount := 0;
      end;
    finally
      EndLock(hLock);
    end;
  end;
  LastErrorTime := Now;
end;

{+.}

class procedure TExceptionDialog.ExceptionHandler(Sender: TObject; E: Exception);
var
  S: string;
  {$IFDEF _JCL_EXCEPTION_COMOBJ_}
  eOle: EOleException absolute E;
  {$ENDIF _JCL_EXCEPTION_COMOBJ_}
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  if (E = nil) or (E.ClassType = nil) or IsIgnoredException(E.ClassType) then
    Exit;
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    if ExceptionShowing and (ExceptionDialog <> nil) then
    begin
      //
      // OLD:
      //
      //{ Application.ShowException(E); }

      //
      // NEW:
      //
      if ExceptionDialog.iErrorCount <= cMaxCycledErrors then
      begin
        S := E.Message;
        {$IFDEF _JCL_EXCEPTION_COMOBJ_}
        if E is EOleException then
        begin
          S := S + '. OLE Error details (' +
            'ErrorCode: ' + IntToStr(eOle.ErrorCode) +
            '; Source: "' + eOle.Source + '")';
        end;
        {$ENDIF _JCL_EXCEPTION_COMOBJ_}
        ExceptionDialog.fEMessage := S;
        ExceptionDialog.DoAddReport();
      end
      else
      begin
        if ExceptionDialog.iErrorCount < cMaxErrors then
        begin
          Inc(ExceptionDialog.iErrorCount);
          if ExceptionDialog.iErrorCount < cMaxErrors then
            ExceptionDialog.LErrorCount.Caption := IntToStr(ExceptionDialog.iErrorCount)
          else
          begin
            ExceptionDialog.LErrorCount.Caption := '...';
            ExceptionDialog.LErrorCount.Visible := False;
            ExceptionDialog.KillBtn.Visible := True;
          end;
        end;
        //{ Windows.OutputDebugString( PChar('Exception cycled:' + E.Message) ); }
      end;

      {+}
      ExceptionDialog.PrepareKillBtnVisible;
      {+.}

    end
    else
    begin
      ExceptionShowing := True;
      try
        ShowException(E, nil);
      finally
        ExceptionShowing := False;
      end;
    end;
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ExceptionThreadHandler(Thread: TJclDebugThread);
var
  E: Exception;
begin
  E := Exception(Thread.SyncException);
  if Assigned(E) then
    if ExceptionShowing then
      Application.ShowException(E)
    else
    begin
      ExceptionShowing := True;
      try
        if IsIgnoredException(E.ClassType) then
          Application.ShowException(E)
        else
          ShowException(E, Thread);
      finally
        ExceptionShowing := False;
      end;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormCreate(Sender: TObject);
{+}
var
  iW, i, iDelta, iClientWidth: Integer;
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
{+.}
begin
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    {+}
    // citrix client errors:
    //   Error reading TextMemo.Lines.Strings: Win32 Error.  Code: 2.
    //   Error reading TextMemo.Lines.Strings: A Win32 API function failed.
    if not HandleAllocated then
    try
      HandleNeeded;
    except
    end;
    {+.}
    //FSimpleLog := TJclSimpleLog.Create(ExceptionLogFileName);
    FFullHeight := ClientHeight;
    {+}
    //DetailsVisible := False;
    iErrorCount := 1;
    Caption := Format(RsAppError, [Application.Title]);
    DetailsMemo.Lines.Clear;
    TextMemo.Lines.Clear;

    fErrorIcon := LoadIcon(0, IDI_ERROR);

    OkBtn.Caption := LText_OK;
    iW := Canvas.TextWidth(LText_OK);

    CopyButton.Caption := LText_CopyAll;
    i := Canvas.TextWidth(LText_CopyAll);
    if i > iW then
      iW := i;

    DetailsBtn.Caption := LText_Details;
    DetailsVisible := False;
    i := Canvas.TextWidth(DetailsBtn.Caption);
    if i > iW then
      iW := i;

    KillBtn.Caption := LText_Kill;
    DetailsVisible := False;
    i := Canvas.TextWidth(KillBtn.Caption);
    if i > iW then
      iW := i;

    with ClientRect do
    begin
      iClientWidth := (Right - Left) + 1;
      iDelta := (Self.Width - iClientWidth) div 2;
    end;

    Inc(iW, 4 + iDelta + iDelta);

    if iW < 75 then
      iW := 75;

    i := iClientWidth - iW - 3 - iDelta + 1;
    OkBtn.Left := i;
    CopyButton.Left := i;
    DetailsBtn.Left := i;
    KillBtn.Left := i;

    OkBtn.Width := iW;
    CopyButton.Width := iW;
    DetailsBtn.Width := iW;
    KillBtn.Width := iW;

    TextMemo.Width := OkBtn.Left - 4 - TextMemo.Left;
    {+.}
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormDestroy(Sender: TObject);
var
  hLock: THandle;
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    {+}
    ExceptionShowing := False;
    if Self = ExceptionDialog then
      ExceptionDialog := nil;
    {+.}
    //FreeAndNil(FSimpleLog);
    {+}
    CleanStackList();
    BeginLock(LastErrorLockName, hLock, 1000 * 60 *60);
    begin
      LastErrorTime := Now;
    end;
    EndLock(hLock);
    {+.}
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

destructor TExceptionDialog.Destroy;
var
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    inherited;
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {+}
  if (Key = VK_ESCAPE) and (Shift = []) then
    Close;
  {+.}
end;

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.PaintIcon();
begin
  DrawIcon(Canvas.Handle, TextMemo.Left - GetSystemMetrics(SM_CXICON) - 15,
    TextMemo.Top, fErrorIcon );
end;
{+.}

procedure TExceptionDialog.FormPaint(Sender: TObject);
begin
  {+}
  PaintIcon();
  {+.}
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormResize(Sender: TObject);
begin
  UpdateTextMemoScrollbars;
end;

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.DoCalculateDetails();
begin
  if FDetailsCalculated then
    Exit;
  FDetailsCalculated := True;
  BeforeCreateDetails;
  MessageBeep(MB_ICONERROR);
  if FIsMainThead and (GetWindowThreadProcessId(Handle, nil) <> MainThreadID) then
    PostMessage(Handle, UM_CREATEDETAILS, 0, 0)
  else
    CreateDetails;
end;
{+.}

procedure TExceptionDialog.FormShow(Sender: TObject);
begin
  {+}
  OnShow := nil;
  {+.}
  {+}
  if FirstExceptionImmediateStackCalculate then
  begin
    DetailsBtn.Enabled := False;
    DoCalculateDetails();
  end
  else
    MakeStackList();
  {+.}
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.GetReportAsText: string;
begin
  Result := StrEnsureSuffix(NativeCrLf, TextMemo.Text) + NativeCrLf + DetailsMemo.Text;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.NextDetailBlock;
begin
  DetailsMemo.Lines.Add(StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns));
end;

{+}
function TExceptionDialog.DelimiterStr: string;
begin
  Result := StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns);
end;
{+.}

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.ReportNewBlockDelimiterChar: Char;
begin
  Result := '-';
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.SaveToLogFile(const FileName: TFileName);
var
  SimpleLog: TJclSimpleLog;
begin
  SimpleLog := TJclSimpleLog.Create(FileName);
  try
    SimpleLog.WriteStamp(ReportMaxColumns);
    SimpleLog.Write(ReportAsText);
    SimpleLog.CloseLog;
  finally
    SimpleLog.Free;
  end;
end;

{procedure TExceptionDialog.ReportToLog;
begin
  if Tag and ReportToLogEnabled <> 0 then
  try
    FSimpleLog.WriteStamp(ReportMaxColumns);
    try
      FSimpleLog.Write(ReportAsText);
    finally
      FSimpleLog.CloseLog;
    end;
  except
    //on e: Exception do
    //  OutputDebugString(PChar(e.Message));
  end;
end;{}

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.SetDetailsVisible(const Value: Boolean);
const
  DirectionChars: array [0..1] of Char = ( '<', '>' );
var
  DetailsCaption: string;
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  {+}
  if (FNonDetailsHeight > 0) and (FDetailsVisible = Value) then
  begin
    if not Value then
    begin
      ClientHeight := BevelDetails.Top;
      FNonDetailsHeight := Height;
    end;
    Exit;
  end;
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    if Value then
      DoCalculateDetails();
    {+.}
    FDetailsVisible := Value;
    DetailsCaption := Trim(StrRemoveChars(DetailsBtn.Caption, DirectionChars));
    if Value then
    begin
      Constraints.MinHeight := FNonDetailsHeight + 100;
      Constraints.MaxHeight := Screen.Height;
      DetailsCaption := '<< ' + DetailsCaption;
      ClientHeight := FFullHeight;
      DetailsMemo.Height := FFullHeight - DetailsMemo.Top - 3;
    end
    else
    begin
      FFullHeight := ClientHeight;
      DetailsCaption := DetailsCaption + ' >>';
      if FNonDetailsHeight = 0 then
      begin
        ClientHeight := BevelDetails.Top;
        FNonDetailsHeight := Height;
      end
      else
        Height := FNonDetailsHeight;
      Constraints.MinHeight := FNonDetailsHeight;
      Constraints.MaxHeight := FNonDetailsHeight
    end;
    DetailsBtn.Caption := DetailsCaption;
    DetailsMemo.Enabled := Value;
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.DoOnShowException(E: Exception; var Handled: Boolean);
begin
  if Assigned(fOnShowException) then
    fOnShowException(Self, E);
end;
{+.}

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ShowException(E: TObject; Thread: TJclDebugThread);
var
  S: string;
  bHandled, bIsException: Boolean;
  EObj: Exception absolute E;
  {$IFDEF _JCL_EXCEPTION_COMOBJ_}
  eOle: EOleException absolute E;
  {$ENDIF _JCL_EXCEPTION_COMOBJ_}
  hLock: THandle;
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  if (E = nil) or (E.ClassType = nil) then
    Exit;

  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    if ExceptionDialog = nil then
      ExceptionDialog := ExceptionDialogClass.Create(Application);
    try
      with ExceptionDialog do
      begin
        if Assigned(Thread) then
          FThreadID := Thread.ThreadID
        else
          FThreadID := MainThreadID;
        FIsMainThead := (GetCurrentThreadId = MainThreadID);
        FLastActiveControl := Screen.ActiveControl;
        {+}
        bIsException := E is Exception;
        if bIsException then
        begin
          S := EObj.Message;
          {$IFDEF _JCL_EXCEPTION_COMOBJ_}
          if E is EOleException then
          begin
            S := S + '. OLE Error details (' +
              'ErrorCode: ' + IntToStr(eOle.ErrorCode) +
              '; Source: "' + eOle.Source + '")';
          end;
          {$ENDIF _JCL_EXCEPTION_COMOBJ_}
        end
        else
          S := E.ClassName;
        TextMemo.Text := {RsErrorMessage + }AdjustLineBreaks(StrEnsureSuffix('.', S));
        {+.}
        UpdateTextMemoScrollbars;
        {+}
        PrepareKillBtnVisible;
        //NextDetailBlock;
        //Arioch: some header for possible saving to txt-file/e-mail/clipboard/NTEvent...
        //DetailsMemo.Lines.Add(Format(RsDetailsIntro, [DateTimeToStr(Now), Application.Title, Application.ExeName]));
        //NextDetailBlock;
        DetailsMemo.Lines.Add(Format(RsExceptionClass, [E.ClassName]));
        if Thread = nil then
          DetailsMemo.Lines.Add(Format(RsExceptionAddr, [ExceptAddr]))
        else
          DetailsMemo.Lines.Add(Format(RsThread, [Thread.ThreadInfo]));
        NextDetailBlock;
        if bIsException then
        begin
          bHandled := False;
          DoOnShowException(EObj, bHandled);
          if bHandled then
            Exit;
        end;
        {+.}
        ShowModal;
      end;
    finally
      if ExceptionDialogPersistent then
      begin
        if ExceptionDialog.WindowState = wsMaximized then
          ShowWindow(ExceptionDialog.Handle, SW_RESTORE);
        ExceptionDialog.DetailsVisible := False;
        ExceptionDialog.fSaveDetailsVisible := False;
        ExceptionDialog.iErrorCount := 1;
        ExceptionDialog.FDetailsCalculated := False;
        ExceptionDialog.fEMessage := '';
        ExceptionDialog.CleanStackList();
        ExceptionDialog.FThreadID := 0;
        ExceptionDialog.DetailsMemo.Lines.Clear;
        ExceptionShowing := False;
        BeginLock(LastErrorLockName, hLock, 1000 * 60 *60);
        LastErrorTime := Now;
        EndLock(hLock);
      end
      else
        FreeAndNil(ExceptionDialog);
    end;
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.UMCreateDetails(var Message: TMessage);
begin
  Update;
  CreateDetails;
end;

{+}
procedure TExceptionDialog.UMAddReport(var Message: TMessage);
begin
  Update();
  AddReport();
end;
{+.}

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.UpdateTextMemoScrollbars;
begin
  if Tag and DisableTextScrollbar = 0 then
  begin
    Canvas.Font := TextMemo.Style.Font;
    if TextMemo.Lines.Count * Canvas.TextHeight('Wg') > TextMemo.ClientHeight then
      TextMemo.Properties.ScrollBars := ssVertical
    else
      TextMemo.Properties.ScrollBars := ssNone;
   end;
   {+}
   ShapeTextMemo.Left := TextMemo.Left - 1;
   ShapeTextMemo.Top := OkBtn.Top;
   TextMemo.Height := BevelDetails.Top - TextMemo.Top - 1;
   ShapeTextMemo.Height := TextMemo.Top - ShapeTextMemo.Top + TextMemo.Height + 1;
   ShapeTextMemo.Width := TextMemo.Width + 2;

   ShapeDetailsMemo.Left := 1;
   ShapeDetailsMemo.Top := BevelDetails.Top - 1;
   ShapeDetailsMemo.Width := ClientWidth - 2;
   ShapeDetailsMemo.Height := DetailsMemo.Top + DetailsMemo.Height - ShapeDetailsMemo.Top + 2;
   {+.}
end;

{+}
procedure TExceptionDialog.UpdateTextLabelScrollbars;
begin
  UpdateTextMemoScrollbars;
end;

constructor TExceptionDialog.Create(AOwner: TComponent);
var
  OldMemoryManager: TMemoryManagerEx;
  bIsNotSystemMemoryManager: Boolean;
begin
  bIsNotSystemMemoryManager := RestoreSystemMemoryManager(OldMemoryManager);
  MemCheckBeginDisable;
  try
    inherited;
    Bevel1 := BevelDetails;
    TextLabel := TextMemo;
    ShapeTextLabel := ShapeTextMemo;
  finally
    if bIsNotSystemMemoryManager then
      SetMemoryManager(OldMemoryManager);
    MemCheckEndDisable;
  end;
end;

procedure TExceptionDialog.SetName(const NewName: TComponentName);
begin
  { empty }
end;

{+.}

//--------------------------------------------------------------------------------------------------

{+}
procedure TExceptionDialog.WMSysCommand(var Message: TWMSysCommand);
begin
 case Message.CmdType of
   { not supported }
   //SC_MINIMIZE:
   //  begin
   //  end;
   SC_CLOSE:
     begin
       Close;
     end;
   SC_MAXIMIZE:
     begin
       DoCalculateDetails();
       if DetailsBtn.Enabled then
       begin
         fSaveDetailsVisible := DetailsVisible;
         fSaveHeight := FFullHeight;
         if not fSaveDetailsVisible then
           DetailsVisible := True;
         DetailsBtn.Enabled := False;
       end
       else
       begin
         Exit;
       end;
     end;
   SC_RESTORE:
     begin
       if not fSaveDetailsVisible then
       begin
         DetailsVisible := False;
       end;
       FFullHeight := fSaveHeight;
       DetailsBtn.Enabled := True;
     end;
  end;
 inherited;
end;
{+.}

//==================================================================================================
// Exception handler initialization code
//==================================================================================================

var
  AppEvents: TApplicationEvents = nil;

{+}
var
  bIsInitialized: Boolean = False;

function IsInitialized(): Boolean;
begin
  Result := bIsInitialized;
end;
{+.}

procedure InitializeHandler();
begin
  {+}
  if bIsInitialized then
    exit;
  {+.}
  if AppEvents = nil then
  begin
    {+}
    if UseAppEvents then
    begin
      AppEvents := TApplicationEvents.Create(nil);
      AppEvents.OnException := TExceptionDialog.ExceptionHandler;
    end;

    ExcDialogSystemInfos := [siStackList, siActiveControls, siModule];
    if not SimpleExceptionHandler then
    begin
      ExcDialogSystemInfos := ExcDialogSystemInfos + [siOsInfo, siModuleList];
    end
    else
    begin
      ExcDialogSystemInfos := ExcDialogSystemInfos + [siOsInfo];
      //RawExceptionTrace := False;
    end;
//
//  TJclStackTrackingOption =
//    (stStack, stExceptFrame, stRawMode, stAllModules, stStaticModuleList,
//     stDelayedTrace, stTraceAllExceptions, stMainThreadOnly);
//
    if RawExceptionTrace then
      JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode];
    //else
    //  JclStackTrackingOptions := JclStackTrackingOptions + [stExceptFrame];
    {+.}
    {$IFNDEF HOOK_DLL_EXCEPTIONS}
    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    {$ENDIF HOOK_DLL_EXCEPTIONS}
    JclStackTrackingOptions := JclStackTrackingOptions + [stDelayedTrace, stAllModules];
    JclDebugThreadList.OnSyncException := TExceptionDialog.ExceptionThreadHandler;
//???:
    JclHookThreads;
//???.
    {+}
    if not SimpleExceptionHandler then
      JclStartExceptionTracking;
    {+.}
    {.$IFDEF HOOK_DLL_EXCEPTIONS}
    if HookTApplicationHandleException then
      JclTrackExceptionsFromLibraries;
    {.$ENDIF HOOK_DLL_EXCEPTIONS}
    if not UseAppEvents then
      Application.OnException := TExceptionDialog.ExceptionHandler;
    {+}
    bIsInitialized := True;
    {+.}
  end;
  {+}
  if ExceptionDialogPersistent then
    ExceptionDialog := ExceptionDialogClass.Create(Application);
  {+.}
end;

//--------------------------------------------------------------------------------------------------

procedure UnInitializeHandler();
begin
  {+}
  if not bIsInitialized then
    exit;
  if (not UseAppEvents) or (AppEvents <> nil) then
  begin
    FreeAndNil(AppEvents);
    if {(not UseAppEvents) and} (@Application.OnException = @TExceptionDialog.ExceptionHandler) then
      Application.OnException := nil;
    JclDebugThreadList.OnSyncException := nil;
    JclUnhookExceptions;
    JclStopExceptionTracking;
    JclUnhookThreads;
    {+}
    bIsInitialized := False;
    {+.}
  end;
  {+.}
end;

//--------------------------------------------------------------------------------------------------

(*
{$IFDEF DELPHI6_UP}
function IsDebuggedApp(): Boolean;
var
  IsDebuggerPresent: function: Boolean; stdcall;
  KernelHandle: THandle;
  p: Pointer;
begin
  KernelHandle := GetModuleHandle(kernel32);
  @IsDebuggerPresent := GetProcAddress(KernelHandle, 'IsDebuggerPresent');
  if Assigned(IsDebuggerPresent) then // Win98+/NT4+ only
    Result := IsDebuggerPresent
  else
  begin // Win9x uses thunk pointer outside the module when under a debugger
    p := GetProcAddress(KernelHandle, 'GetProcAddress');
    Result := (DWord(p) < KernelHandle);
  end;
end;
{$ENDIF DELPHI6_UP}
//*)

//--------------------------------------------------------------------------------------------------

function IsInIDE(): Boolean;
  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF Declared(CompilerVersion)}
    {$IF CompilerVersion >= 15.00}
    {$IF RTLVersion >= 17.00}
      {$DEFINE D9_UP}
    {$IFEND}
    {$IFEND}
    {$IFEND}
  {$ENDIF}
const
  IDE_EXE_NAME =
    {$IFDEF D9_UP}
    'bds.exe'
    {$ELSE}
    'delphi32.exe'
    {$ENDIF}
  ;
begin
  if ((GetModuleHandle(IDE_EXE_NAME) <> 0) and (GetModuleHandle('BrcIde.Dll') <> 0)) then
    Result := True
  else
    Result := False;
end;

procedure TExceptionDialog.OkBtnClick(Sender: TObject);
begin
  Visible := True; // !!!
  Close;
end;

initialization
  {+}
  if IsInIDE() then
  begin
    SimpleExceptionHandler := True;
    //UseAppEvents := True;
  end;
  {+.}
  InitializeHandler();

finalization
  UnInitializeHandler();

end.
