unit gsw.common;

interface

uses
  System.SysUtils, System.Generics.Collections,
  gsw.api, gsw.switches;

type
    /// <summary>
    /// Enum type with kind of the encoding GS arguments.
    /// </summary>
  TGSArgEncoding = (gsaeLocal, gsaeUTF8, gsaeUTF16LE);

type
    /// <summary>
    /// GhostScript instance output interface.
    /// </summary>
  IGSStandardOutputCaller = interface(IInvokable)
    ['{BDF45954-A294-4A1C-849A-5EB198C7F13F}']
      /// <summary>
      /// IO procedure call.
      /// </summary>
    procedure Call(const AText: UTF8String; var ALength: Integer);
  end;

    /// <summary>
    /// GhostScript instance input interface.
    /// </summary>
  IGSStandardInputCaller = interface(IInvokable)
    ['{1AB0D4B8-0865-40E9-A07A-DE9BF6899CBF}']
      /// <summary>
      /// Input procedure call.
      /// </summary>
    procedure Call(var AText: UTF8String; var ALength: Integer);
  end;

    /// <summary>
    /// GhostScript instance interface.
    /// </summary>
  IGSInstance = interface(IInvokable)
    ['{60B30EC0-65A7-43E3-A85B-0CD1EC5247F1}']
    function CreateInstance(const AEncoding: TGSArgEncoding = gsaeUTF8): Integer;
    procedure DeleteInstance;
    function ExitInstance: Integer;
    function GetArgEncoding: TGSArgEncoding;
    function GetStdInputCall: IGSStandardInputCaller;
    function GetStdOutputCall: IGSStandardOutputCaller;
    function GetStdErrorCall: IGSStandardOutputCaller;
    function InitWithArgs(const AParams: array of String): Integer;
      /// <summary>
      /// Function return GhostScript instance pointer.
      /// </summary>
    function Instance: Pointer;
    function RunFile(const AFileName: String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunString(const AStr: UTF8String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringBegin(const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringContinue(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer;
      var AExitCode: Integer): Integer;
    function RunStringEnd(const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringWithLength(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer;
      var AExitCode: Integer): Integer;
    function SetDisplayCallback(const ACallback: TDisplayCallback): Integer;
    function SetPoll(const APollFunc: TPollFunction): Integer;
    procedure SetStdInputCall(const AValue: IGSStandardInputCaller);
    function SetStdIO(const AStdInFunc, AStdOutFunc, AStdErrFunc: TStdIOFunction): Integer;
    procedure SetStdOutputCall(const AValue: IGSStandardOutputCaller);
    procedure SetStdErrorCall(const AValue: IGSStandardOutputCaller);
      /// <summary>
      /// Current arguments encoding.
      /// </summary>
    property ArgEncoding: TGSArgEncoding read GetArgEncoding;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdErrorCall: IGSStandardOutputCaller read GetStdErrorCall write SetStdErrorCall;
      /// <summary>
      /// Reference to the standard input call interface.
      /// </summary>
    property StdInputCall: IGSStandardInputCaller read GetStdInputCall write SetStdInputCall;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdOutputCall: IGSStandardOutputCaller read GetStdOutputCall write SetStdOutputCall;
  end;

    /// <summary>
    /// GhostScript execution SetProgress interface.
    /// </summary>
  IGSExecutionProgress = interface(IInvokable)
    ['{1F89A4F4-0BD3-4427-8251-C6E8E4772304}']
      /// <summary>
      /// Current processing progress info.
      /// </summary>
    procedure SetProgress(const APosition, ATotal: Integer);
  end;

    /// <summary>
    /// GhostScript executor execution complete interface.
    /// </summary>
  IGSExecutionCompleted = interface(IInvokable)
    ['{2C75B46C-D5EB-42C3-80A5-51F0E5B34B01}']
      /// <summary>
      /// Execution completion information.
      /// </summary>
    procedure Completed(const ACorrect: Boolean);
  end;

  TGSCallKind = (ckQueued, ckImmediate);

    /// <summary>
    /// Async executor interface.
    /// </summary>
  IGSWExecutor = interface(IInvokable)
    ['{D5A7653E-E49A-43D3-BFB7-E5466A07E9CA}']
      /// <summary>
      /// Execute process.
      /// </summary>
    procedure Execute;
      /// <summary>
      /// Function returns execution status.
      /// </summary>
    function Executing: Boolean;
    function GetExecutionProgress: IGSExecutionProgress;
    function GetExecutionCompleted: IGSExecutionCompleted;
    function GetExecutionCompletedCallKind: TGSCallKind;
    function GetStdOutputCaller: IGSStandardOutputCaller;
      /// <summary>
      /// Last error code.
      /// </summary>
    function LastErrorCode: Integer;
      /// <summary>
      /// Last error message.
      /// </summary>
    function LastErrorMessage: String;
    procedure SetExecutionProgress(const AValue: IGSExecutionProgress);
    procedure SetExecutionCompleted(const Value: IGSExecutionCompleted);
    procedure SetExecutionCompletedCallKind(const AValue: TGSCallKind);
    procedure SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
      /// <summary>
      /// Stop process.
      /// </summary>
    procedure Stop;
      /// <summary>
      /// Reference to the showing execution progress interface.
      /// </summary>
    property ExecutionProgress: IGSExecutionProgress read GetExecutionProgress write SetExecutionProgress;
      /// <summary>
      /// Reference to the execution completion information interface.
      /// </summary>
    property ExecutionCompleted: IGSExecutionCompleted read GetExecutionCompleted write SetExecutionCompleted;
      /// <summary>
      /// The kind of the call execution completion interface. Ignored in sync version.
      /// </summary>
    property ExecutionCompletedCallKind: TGSCallKind read GetExecutionCompletedCallKind write SetExecutionCompletedCallKind;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdOutputCaller: IGSStandardOutputCaller read GetStdOutputCaller write SetStdOutputCaller;
  end;

    /// <summary>
    /// GhostScript errors exception.
    /// </summary>
  GSException = class(Exception)
  private
    FCode: Integer;
  public
    constructor Create(const AMessage: String; const ACode: Integer); reintroduce;
    constructor CreateFmt(const AMessage: String; const AArgs: array of const; const ACode: Integer); reintroduce;
    property Code: Integer read FCode;
  end;

    /// <summary>
    /// IGSInstanceIOCaller interface group.
    /// </summary>
  TGSInstanceIOGroup = class(TInterfacedObject, IGSStandardOutputCaller)
  strict private
    FList: TList<IGSStandardOutputCaller>;
  public
    constructor Create(const AInstances: TArray<IGSStandardOutputCaller>); reintroduce;
    destructor Destroy; override;
    procedure Add(AInstance: IGSStandardOutputCaller);
      /// <summary>
      /// IO procedure call.
      /// </summary>
    procedure Call(const AText: UTF8String; var ALength: Integer);
    procedure Clear;
  end;

    /// <summary>
    /// GhostScript standard output to execution progress facade.
    /// </summary>
  TGSStdOutToProgress = class(TInterfacedObject, IGSStandardOutputCaller)
  strict private
    FProgress: IGSExecutionProgress;
    FLastTotal: Integer;
    procedure ReadProgress(const AText: String);
  public
    constructor Create(AProgress: IGSExecutionProgress); reintroduce;
      /// <summary>
      /// IO procedure call.
      /// </summary>
    procedure Call(const AText: UTF8String; var ALength: Integer);
  end;

    /// <summary>
    /// Execute progress method type.
    /// </summary>
  TGSWExecutionProgressEvent = procedure(const APosition, ATotal: Integer) of object;

  TGSWExecutionProgressEventAdapter = class(TInterfacedObject, IGSExecutionProgress)
  strict private
    FEvent: TGSWExecutionProgressEvent;
  public
    constructor Create(AEvent: TGSWExecutionProgressEvent); overload;
      /// <summary>
      /// Current processing progress info.
      /// </summary>
    procedure SetProgress(const APosition, ATotal: Integer);
    property Event: TGSWExecutionProgressEvent read FEvent write FEvent;
  end;

    /// <summary>
    /// Standard output call event.
    /// </summary>
  TGSWStdOutputCallEvent = procedure(const AText: UTF8String; var ALength: Integer) of object;

  TGSWStdOutputCallEventAdapter = class(TInterfacedObject, IGSStandardOutputCaller)
  strict private
    FEvent: TGSWStdOutputCallEvent;
  public
    constructor Create(const AEvent: TGSWStdOutputCallEvent); overload;
      /// <summary>
      /// IO procedure call.
      /// </summary>
    procedure Call(const AText: UTF8String; var ALength: Integer);
    property Event: TGSWStdOutputCallEvent read FEvent write FEvent;
  end;

  TGSWStdInputCallEvent = procedure (var AText: UTF8String; var ALength: Integer) of object;

  TGSWStdInputCallEventAdapter = class(TInterfacedObject, IGSStandardInputCaller)
  strict private
    FEvent: TGSWStdInputCallEvent;
  public
    constructor Create(const AEvent: TGSWStdInputCallEvent); overload;
      /// <summary>
      /// Input procedure call.
      /// </summary>
    procedure Call(var AText: UTF8String; var ALength: Integer);
    property Event: TGSWStdInputCallEvent read FEvent write FEvent;
  end;


  TGSInstance = class(TInterfacedObject, IGSInstance)
  strict private
    FArgEncoding: TGSArgEncoding;
    FInstance: Pointer;
    FLastErrorCode: Integer;
    FStdErrorCall: IGSStandardOutputCaller;
    FStdInputCall: IGSStandardInputCaller;
    FStdOutputCall: IGSStandardOutputCaller;
    function GetArgEncoding: TGSArgEncoding;
    function GetStdErrorCall: IGSStandardOutputCaller;
    function GetStdInputCall: IGSStandardInputCaller;
    function GetStdOutputCall: IGSStandardOutputCaller;
    procedure SetStdErrorCall(const AValue: IGSStandardOutputCaller);
    procedure SetStdInputCall(const AValue: IGSStandardInputCaller);
    procedure SetStdOutputCall(const AValue: IGSStandardOutputCaller);
    class function StdErrFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer; stdcall; static;
    class function StdInFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer; stdcall; static;
    class function StdOutFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer; stdcall; static;
  private
    procedure StdErrorCall(const AText: UTF8String; var ALength: Integer);
    procedure StdInputCall(var AText: UTF8String; var ALength: Integer);
    procedure StdOutputCall(const AText: UTF8String; var ALength: Integer);
  public
    function CreateInstance(const AEncoding: TGSArgEncoding = gsaeUTF8): Integer;
      /// <summary>
      /// Function return GhostScript Instance pointer.
      /// </summary>
    function Instance: Pointer;
    procedure DeleteInstance;
    function ExitInstance: Integer;
    function InitWithArgs(const AParams: array of String): Integer;
    function RunFile(const AFileName: String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunString(const AStr: UTF8String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringBegin(const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringContinue(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer; var AExitCode:
        Integer): Integer;
    function RunStringEnd(const AUserErrors: Integer; var AExitCode: Integer): Integer;
    function RunStringWithLength(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer; var AExitCode:
        Integer): Integer;
    function SetDisplayCallback(const ACallback: TDisplayCallback): Integer;
    function SetPoll(const APollFunc: TPollFunction): Integer;
    function SetStdIO(const AStdInFunc, AStdOutFunc, AStdErrFunc: TStdIOFunction): Integer;
      /// <summary>
      /// Current arguments encoding.
      /// </summary>
    property ArgEncoding: TGSArgEncoding read GetArgEncoding;
  end;

    /// <summary>
    /// Common execute parameters
    /// </summary>
    [ SwitchIndexValue(0, 'SAFER'),
      SwitchIndexValue(1, 'BATCH'),
      SwitchIndexValue(2, 'NOPAUSE'),
      SwitchIndexValue(3, 'TTYPAUSE')]
  TGSExecuteParam = (
    gsepSafer,
    gsepBatch,
    gsepNoPause,
    gsepTTYPause);

  TGSExecuteParams = set of TGSExecuteParam;

    /// <summary>
    /// GhostScript execute base class.
    /// </summary>
  TGSExecutorBase = class(TInterfacedObject)
  strict private
    FExecuteParams: TGSExecuteParams;
    FStdErrorCaller: IGSStandardOutputCaller;
    FStdInputCaller: IGSStandardInputCaller;
    FStdOutputCaller: IGSStandardOutputCaller;
  strict protected
    function GetExecuteParams: TGSExecuteParams;
    function GetStdErrorCaller: IGSStandardOutputCaller;
    function GetStdInputCaller: IGSStandardInputCaller;
    function GetStdOutputCaller: IGSStandardOutputCaller;
    procedure SetExecuteParams(const AValue: TGSExecuteParams);
    procedure SetStdErrorCaller(const AValue: IGSStandardOutputCaller);
    procedure SetStdInputCaller(const AValue: IGSStandardInputCaller);
    procedure SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
  public
    constructor Create; reintroduce;
      /// <summary>
      /// Common executing parameters.
      /// </summary>
      [Switch('d%s')]
    property ExecuteParams: TGSExecuteParams read GetExecuteParams write SetExecuteParams default [gsepSafer, gsepBatch,
        gsepNoPause];
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdErrorCaller: IGSStandardOutputCaller read GetStdErrorCaller write SetStdErrorCaller;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdInputCaller: IGSStandardInputCaller read GetStdInputCaller write SetStdInputCaller;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdOutputCaller: IGSStandardOutputCaller read GetStdOutputCaller write SetStdOutputCaller;
  end;

implementation

uses
  System.StrUtils, System.Math;

{$REGION 'GSException'}

constructor GSException.Create(const AMessage: String; const ACode: Integer);
begin
  inherited Create(AMessage);
  FCode := ACode;
end;

constructor GSException.CreateFmt(const AMessage: String; const AArgs: array of const; const ACode: Integer);
begin
  inherited CreateFmt(AMessage, AArgs);
  FCode := ACode;
end;

{$ENDREGION}

{$REGION 'TGSInstanceIOGroup'}

constructor TGSInstanceIOGroup.Create(const AInstances: TArray<IGSStandardOutputCaller>);
begin
  inherited Create;
  FList := TList<IGSStandardOutputCaller>.Create;
  FList.AddRange(AInstances);
end;

destructor TGSInstanceIOGroup.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TGSInstanceIOGroup.Add(AInstance: IGSStandardOutputCaller);
begin
  Assert(AInstance <> nil);
  FList.Add(AInstance);
end;

procedure TGSInstanceIOGroup.Call(const AText: UTF8String; var ALength: Integer);
var
  lItem: IGSStandardOutputCaller;
begin
  for lItem in FList do
    lItem.Call(AText, ALength);
end;

procedure TGSInstanceIOGroup.Clear;
begin
  FList.Clear;
end;

{$ENDREGION}

{$REGION 'TGSStdOutToProgress'}

constructor TGSStdOutToProgress.Create(AProgress: IGSExecutionProgress);
begin
  Assert(AProgress <> nil);
  inherited Create;
  FProgress := AProgress;
end;

procedure TGSStdOutToProgress.Call(const AText: UTF8String; var ALength: Integer);
begin
  ReadProgress(String(AText));
end;

procedure TGSStdOutToProgress.ReadProgress(const AText: String);
const
  cProcessingPagesTempl: array [0..2] of String = ('Processing', 'pages', 'through');
  cProcessingPagePrefix = 'Page';
var
  lWords: TArray<String>;
  lPosition: Integer;
begin
  lWords := AText.Split([' ', '.', #$A]);
  lPosition := -1;
  if (Length(lWords) > 2) and SameText(lWords[0], cProcessingPagesTempl[0])
    and SameText(lWords[1], cProcessingPagesTempl[1])
    and SameText(lWords[3], cProcessingPagesTempl[2]) then
  begin
    FLastTotal := StrToIntDef(lWords[4], 0);
    lPosition := StrToIntDef(lWords[2], -1);
  end
  else
    if (Length(lWords) > 1) and SameText(lWords[0], cProcessingPagePrefix) then
      lPosition := StrToIntDef(lWords[1], -1);
  if lPosition < 0 then
    Exit;
  FProgress.SetProgress(lPosition, FLastTotal);
end;

{$ENDREGION}

{$REGION 'TGSWExecutionProgressEventAdapter'}

constructor TGSWExecutionProgressEventAdapter.Create(AEvent: TGSWExecutionProgressEvent);
begin
  inherited Create;
  FEvent := AEvent;
end;

procedure TGSWExecutionProgressEventAdapter.SetProgress(const APosition, ATotal: Integer);
begin
  if Assigned(FEvent) then
    FEvent(APosition, ATotal);
end;

{$ENDREGION}

{$REGION 'TGSWStdOutputCallEvent'}

constructor TGSWStdOutputCallEventAdapter.Create(const AEvent: TGSWStdOutputCallEvent);
begin
  inherited Create;
  FEvent := AEvent;
end;

procedure TGSWStdOutputCallEventAdapter.Call(const AText: UTF8String; var ALength: Integer);
begin
  if Assigned(Event) then
    Event(AText, ALength);
end;

{$ENDREGION}

{$REGION 'TGSWStdInputCallEventAdapter'}

constructor TGSWStdInputCallEventAdapter.Create(const AEvent: TGSWStdInputCallEvent);
begin
  inherited Create;
  FEvent := AEvent;
end;

procedure TGSWStdInputCallEventAdapter.Call(var AText: UTF8String; var ALength: Integer);
begin
  if Assigned(Event) then
    Event(AText, ALength);
end;

{$ENDREGION}

{$REGION 'TGSInstance'}

function TGSInstance.CreateInstance(const AEncoding: TGSArgEncoding = gsaeUTF8): Integer;
begin
  if FInstance <> nil then
    Exit(0);
  Result := GSAPIInstance.CreateNewInstance(FInstance, Self);
  FLastErrorCode := Result;
  if FLastErrorCode <> 0 then
    Exit;
  FArgEncoding := AEncoding;
  Result := GSAPIInstance.SetArgsEncoding(FInstance, Integer(AEncoding));
  FLastErrorCode := Result;
  if FLastErrorCode <> 0 then
    Exit;
    // assigning IO handler functions
  if (FStdErrorCall <> nil) or (FStdInputCall <> nil) or (FStdOutputCall <> nil) then
  begin
    Result := GSAPIInstance.SetStdIO(FInstance, StdInFnc, StdOutFnc, StdErrFnc);
    FLastErrorCode := Result;
  end;
end;

procedure TGSInstance.DeleteInstance;
begin
  if FInstance = nil then
    Exit;
  GSAPIInstance.DeleteInstance(FInstance);
end;

function TGSInstance.ExitInstance: Integer;
begin
  Result := GSAPIInstance.Exit(FInstance);
end;

function TGSInstance.GetArgEncoding: TGSArgEncoding;
begin
  Result := FArgEncoding;
end;

function TGSInstance.GetStdErrorCall: IGSStandardOutputCaller;
begin
  Result := FStdErrorCall;
end;

function TGSInstance.GetStdInputCall: IGSStandardInputCaller;
begin
  Result := FStdInputCall;
end;

function TGSInstance.GetStdOutputCall: IGSStandardOutputCaller;
begin
  Result := FStdOutputCall;
end;

function TGSInstance.InitWithArgs(const AParams: array of String): Integer;
var
  i: Integer;
  lParams: array of UTF8String;
  lArgs: array of PAnsiChar;
begin
  Assert(FInstance <> nil);
  SetLength(lParams, Length(AParams));
  SetLength(lArgs, Length(AParams));
  for i := Low(lParams) to High(lParams) do
  begin
    lParams[i] :=  UTF8String(AParams[i]);
    lArgs[i] := @lParams[i][1];
  end;
  FLastErrorCode := GSAPIInstance.InitWithArgs(FInstance, Length(lParams), @lArgs[Low(lArgs)]);
  Result := FLastErrorCode;
end;

function TGSInstance.Instance: Pointer;
begin
  Result := FInstance;
end;

function TGSInstance.RunFile(const AFileName: String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
var
  lFileName: UTF8String;
begin
  Assert(FInstance <> nil);
  lFileName := UTF8String(AFileName);
  FLastErrorCode := GSAPIInstance.RunFile(FInstance, PUTF8Char(lFileName), AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.RunString(const AStr: UTF8String; const AUserErrors: Integer; var AExitCode: Integer): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.RunString(FInstance, PUTF8Char(AStr), AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.RunStringBegin(const AUserErrors: Integer; var AExitCode: Integer): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.RunStringBegin(FInstance, AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.RunStringContinue(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer; var
    AExitCode: Integer): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.RunStringContinue(FInstance, PUTF8Char(AStr), ALen, AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.RunStringEnd(const AUserErrors: Integer; var AExitCode: Integer): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.RunStringEnd(FInstance, AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.RunStringWithLength(const AStr: UTF8String; const ALen: Integer; const AUserErrors: Integer; var
  AExitCode: Integer): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.RunStringWithLength(FInstance, PUTF8Char(AStr), ALen, AUserErrors, AExitCode);
  Result := FLastErrorCode;
end;

function TGSInstance.SetDisplayCallback(const ACallback: TDisplayCallback): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.SetDisplayCallback(FInstance, ACallback);
  Result := FLastErrorCode;
end;

function TGSInstance.SetPoll(const APollFunc: TPollFunction): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.SetPoll(FInstance, APollFunc);
  Result := FLastErrorCode;
end;

procedure TGSInstance.SetStdErrorCall(const AValue: IGSStandardOutputCaller);
begin
  FStdErrorCall := AValue;
end;

procedure TGSInstance.SetStdInputCall(const AValue: IGSStandardInputCaller);
begin
  FStdInputCall := AValue;
end;

function TGSInstance.SetStdIO(const AStdInFunc, AStdOutFunc, AStdErrFunc: TStdIOFunction): Integer;
begin
  Assert(FInstance <> nil);
  FLastErrorCode := GSAPIInstance.SetStdIO(FInstance, AStdInFunc, AStdOutFunc, AStdErrFunc);
  Result := FLastErrorCode;
end;

procedure TGSInstance.SetStdOutputCall(const AValue: IGSStandardOutputCaller);
begin
  FStdOutputCall := AValue;
end;

class function TGSInstance.StdErrFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer;
begin
  if ACallerHandle = nil then
    Exit(0);
  TGSInstance(ACallerHandle).StdErrorCall(UTF8String(Copy(ABuf, 1, ALength)), ALength);
  Result := ALength;
end;

procedure TGSInstance.StdErrorCall(const AText: UTF8String; var ALength: Integer);
begin
  if FStdErrorCall <> nil then
    FStdErrorCall.Call(AText, ALength);
end;

class function TGSInstance.StdInFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer;
var
  i, lMax: Integer;
  lText: UTF8String;
  lBuf: PAnsiChar;
begin
  if ACallerHandle = nil then
    Exit(0);
  lMax := ALength;
  lBuf := ABuf;
  TGSInstance(ACallerHandle).StdInputCall(lText, ALength);
  i := 0;
  lMax := Min(lMax, Length(lText));
  while i < lMax do
  begin
    Inc(i);
    lBuf^ := lText[i];
    Inc(lBuf);
  end;
  Result := ALength;
end;

procedure TGSInstance.StdInputCall(var AText: UTF8String; var ALength: Integer);
begin
  if FStdInputCall <> nil then
    FStdInputCall.Call(AText, ALength);
end;

class function TGSInstance.StdOutFnc(ACallerHandle: Pointer; const ABuf: PAnsiChar; ALength: Integer): Integer;
begin
  if ACallerHandle = nil then
    Exit(0);
  TGSInstance(ACallerHandle).StdOutputCall(UTF8String(Copy(ABuf, 1, ALength)), ALength);
  Result := ALength;
end;

procedure TGSInstance.StdOutputCall(const AText: UTF8String; var ALength: Integer);
begin
  if FStdOutputCall <> nil then
    FStdOutputCall.Call(AText, ALength);
end;

{$ENDREGION}

{$REGION 'TGSExecutorBase'}

constructor TGSExecutorBase.Create;
begin
  inherited;
  FExecuteParams := [gsepSafer, gsepBatch, gsepNoPause];
end;

function TGSExecutorBase.GetExecuteParams: TGSExecuteParams;
begin
  Result := FExecuteParams;
end;

function TGSExecutorBase.GetStdOutputCaller: IGSStandardOutputCaller;
begin
  Result := FStdOutputCaller;
end;

function TGSExecutorBase.GetStdInputCaller: IGSStandardInputCaller;
begin
  Result := FStdInputCaller;
end;

function TGSExecutorBase.GetStdErrorCaller: IGSStandardOutputCaller;
begin
  Result := FStdErrorCaller;
end;

procedure TGSExecutorBase.SetExecuteParams(const AValue: TGSExecuteParams);
begin
  FExecuteParams := AValue;
end;

procedure TGSExecutorBase.SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
begin
  FStdOutputCaller := AValue;
end;

procedure TGSExecutorBase.SetStdInputCaller(const AValue: IGSStandardInputCaller);
begin
  FStdInputCaller := AValue;
end;

procedure TGSExecutorBase.SetStdErrorCaller(const AValue: IGSStandardOutputCaller);
begin
  FStdErrorCaller := AValue;
end;

{$ENDREGION}

end.
