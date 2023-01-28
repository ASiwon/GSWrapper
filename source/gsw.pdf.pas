unit gsw.pdf;

interface

uses
  System.Classes, System.SysUtils,
  gsw.common, gsw.switches;

type
    [
        // BMP format
      SwitchIndexValue(0, 'bmpmono'), SwitchIndexValue(1, 'bmpgray'), SwitchIndexValue(2, 'bmp16'),
      SwitchIndexValue(3, 'bmp256'), SwitchIndexValue(4, 'bmp16m'), SwitchIndexValue(5, 'bmp32b'),
        // JPEG format
      SwitchIndexValue(6, 'jpeg'),
        // PCX format
      SwitchIndexValue(7, 'pcxmono'), SwitchIndexValue(8, 'pcxgray'), SwitchIndexValue(9, 'pcx16'),
      SwitchIndexValue(10, 'pcx256'), SwitchIndexValue(11, 'pcx24b'),
        // PNG format
      SwitchIndexValue(12, 'png16m'), SwitchIndexValue(13, 'png256'), SwitchIndexValue(14, 'png16'),
      SwitchIndexValue(15, 'pngmono'), SwitchIndexValue(16, 'pnggray'),
        // TIFF Format
      SwitchIndexValue(17, 'tiffgray'), SwitchIndexValue(18, 'tiff12nc'), SwitchIndexValue(19, 'tiff24nc'),
      SwitchIndexValue(20, 'tiff32nc')]
  TGSWBitmapFormat = (
      // BMP format
    bfBmpMono, bfBmpGray, bfBmp16, bfBmp256, bfBmp16m, bfBmp32b,
      // JPEG format
    bfJpeg,
      // PCX format
    bfPcxMono, bfPcxGray, bfPcx16, bfPcx256, bfPcx24b,
      // PNG format
    bfPng16m, bfPng256, bfPng16, bfPngMono, bfPngGray,
      // TIFF Format
      // Produces 8-bit gray output.
    bfTiffGray,
      // Produces 12-bit RGB output (4 bits per component).
    bfTiff12nc,
      // Produces 24-bit RGB output (8 bits per component).
    bfTiff24nc,
      // Produces 32-bit CMYK output (8 bits per component).
    bfTiff32nc);

    /// <summary>
    /// GhostScript antialiasing option values.
    /// </summary>
    [ StringIndexValue(1, '1'),
      StringIndexValue(2, '2'),
      StringIndexValue(3, '4')]
  TGSAntialiasingOption = (
    aoDefault,
    ao1,
    ao2,
    ao4);

    /// <summary>
    /// Base interface which allows make conversion pdf file to bitmap.
    /// </summary>
  IGSWPdfToBitmap = interface(IInvokable)
    ['{01F28CB2-D23D-436D-B300-BBEEE1D342F0}']
      /// <summary>
      /// Reference to base interface in descenant interfaces (if needed)
      /// </summary>
    function BasicConverter: IGSWPdfToBitmap;
      /// <summary>
      /// Function creates and returns async converter executor.
      /// </summary>
    function CreateExecutor(const APdfFileName: String; const AAsync: Boolean = True): IGSWExecutor;
      /// <summary>
      /// Executing conversion pdf file.
      /// </summary>
    function Execute(const APdfFileName: string): Boolean;
    function GetAlphaBitsGraphic: TGSAntialiasingOption;
    function GetAlphaBitsText: TGSAntialiasingOption;
    function GetDestFileTempl: string;
    function GetExecuteParams: TGSExecuteParams;
    function GetExecutionProgress: IGSExecutionProgress;
    function GetLastErrorCode: Integer;
    function GetLastErrorMessage: string;
    function GetResolutionX: Integer;
    function GetResolutionY: Integer;
    function GetStdInputCaller: IGSStandardInputCaller;
    function GetStdOutputCaller: IGSStandardOutputCaller;
    procedure SetAlphaBitsGraphic(const Value: TGSAntialiasingOption);
    procedure SetAlphaBitsText(const Value: TGSAntialiasingOption);
    procedure SetDestFileTempl(const AValue: string);
    procedure SetExecuteParams(const AValue: TGSExecuteParams);
    procedure SetExecutionProgress(const AValue: IGSExecutionProgress);
    procedure SetResolutionX(const AValue: Integer);
    procedure SetResolutionY(const AValue: Integer);
    procedure SetStdInputCaller(const AValue: IGSStandardInputCaller);
    procedure SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
      /// <summary>
      /// Subsample antialiasing for graphics option.
      /// </summary>
    property AlphaBitsGraphic: TGSAntialiasingOption read GetAlphaBitsGraphic write SetAlphaBitsGraphic;
      /// <summary>
      /// Subsample antialiasing for text option.
      /// </summary>
    property AlphaBitsText: TGSAntialiasingOption read GetAlphaBitsText write SetAlphaBitsText;
      /// <summary>
      /// Template for the destination file name.
      /// </summary>
    property DestFileTempl: string read GetDestFileTempl write SetDestFileTempl;
      /// <summary>
      /// Common executing parameters.
      /// </summary>
    property ExecuteParams: TGSExecuteParams read GetExecuteParams write SetExecuteParams;
      /// <summary>
      /// Reference to the showing execution progress interface.
      /// </summary>
    property ExecutionProgress: IGSExecutionProgress read GetExecutionProgress write SetExecutionProgress;
      /// <summary>
      /// Code of the last error.
      /// </summary>
    property LastErrorCode: Integer read GetLastErrorCode;
      /// <summary>
      /// Message of the last error.
      /// </summary>
    property LastErrorMessage: String read GetLastErrorMessage;
      /// <summary>
      /// Horizontal resolution of destination bitmap.
      /// </summary>
    property ResolutionX: Integer read GetResolutionX write SetResolutionX;
      /// <summary>
      /// Vertical resolution of destination bitmap. If 0 then horizontal resolution is used.
      /// </summary>
    property ResolutionY: Integer read GetResolutionY write SetResolutionY;
      /// <summary>
      /// Reference to the standard input call interface.
      /// </summary>
    property StdInputCaller: IGSStandardInputCaller read GetStdInputCaller write SetStdInputCaller;
      /// <summary>
      /// Reference to the standard output call interface.
      /// </summary>
    property StdOutputCaller: IGSStandardOutputCaller read GetStdOutputCaller write SetStdOutputCaller;
  end;

  IGSWPdfToBitmapFormat<T> = interface(IGSWPdfToBitmap)
    ['{A490A67A-0D5D-4C36-9314-299CA60C07BD}']
    function GetFormat: T;
    procedure SetFormat(const AValue: T);
    property Format: T read GetFormat write SetFormat;
  end;

  TGSPngFormat = bfPng16m..bfPngGray;

  IGSWPdfToPng = interface(IGSWPdfToBitmapFormat<TGSPngFormat>)
    ['{36FF980D-4123-44EA-B23E-8BBD48CC6B53}']
  end;

  TGSWJpegFormat = bfJpeg..bfJpeg;

  TGSWJpegQuality = 0..100;

  IGSWPdfToJpeg = interface(IGSWPdfToBitmap)
    ['{1966A45B-E96A-4BE3-958F-EB283FAAAE6D}']
    function GetQualityLevel: TGSWJpegQuality;
    procedure SetQualityLevel(const AValue: TGSWJpegQuality);
    property QualityLevel: TGSWJpegQuality read GetQualityLevel write SetQualityLevel;
  end;

  TGSWBmpFormat = bfBmpMono..bfBmp32b;

  IGSWPdfToBmp = interface(IGSWPdfToBitmapFormat<TGSWBmpFormat>)
    ['{89D7218D-8D5B-4482-8105-E5951FFD871E}']
  end;

  TGSWPcxFormat = bfPcxMono..bfPcx24b;

  IGSWPdfToPcx = interface(IGSWPdfToBitmapFormat<TGSWPcxFormat>)
    ['{E1111E11-C3BA-4475-9C9C-0148CDF269F7}']
  end;

  TGSWTiffFormat = bfTiffGray..bfTiff32nc;

  IGSWPdfToTiff = interface(IGSWPdfToBitmapFormat<TGSWTiffFormat>)
    ['{47FA4E75-1B77-43F1-9CA3-44C454F0F6F5}']
  end;

    /// <summary>
    /// PDF to bitmap converters base class.
    /// </summary>
  TGSWPdfToBitmapConverter = class abstract(TGSExecutorBase, IGSWPdfToBitmap)
  strict private
    FAlphaBitsGraphic: TGSAntialiasingOption;
    FAlphaBitsText: TGSAntialiasingOption;
    FDestFileTempl: String;
    FExecuteProgress: IGSExecutionProgress;
    FLastErrorCode: Integer;
    FLastErrorMessage: String;
    FResolutionX: Integer;
    FResolutionY: Integer;
    function GetExecutionProgress: IGSExecutionProgress;
    function GetLastErrorCode: Integer;
    function GetLastErrorMessage: String;
    procedure PrepareIOCalls(const AInstance: IGSInstance);
    procedure SetExecutionProgress(const AValue: IGSExecutionProgress);
  strict protected
    FDefaultExt: String;
      [Switch('sDEVICE=%s')]
    FFormat: TGSWBitmapFormat;
    function GetAlphaBitsGraphic: TGSAntialiasingOption;
    function GetAlphaBitsText: TGSAntialiasingOption;
    function GetDestFileTempl: string;
    function GetDestFileTemplFinal: String;
    function GetResolutionSwitch: String;
    function GetResolutionX: Integer;
    function GetResolutionY: Integer;
    procedure SetAlphaBitsGraphic(const AValue: TGSAntialiasingOption);
    procedure SetAlphaBitsText(const AValue: TGSAntialiasingOption);
    procedure SetDestFileTempl(const AValue: string);
    procedure SetResolutionX(const AValue: Integer);
    procedure SetResolutionY(const AValue: Integer);
  public
    constructor Create;
      /// <summary>
      /// Reference to base interface in descenant interfaces (if needed)
      /// </summary>
    function BasicConverter: IGSWPdfToBitmap;
      /// <summary>
      /// Function creates and returns async converter executor.
      /// </summary>
    function CreateExecutor(const APdfFileName: String; const AAsync: Boolean = True): IGSWExecutor;
      /// <summary>
      /// Executing conversion pdf file.
      /// </summary>
    function Execute(const APdfFileName: string): Boolean;
      /// <summary>
      /// Subsample antialiasing for graphics option.
      /// </summary>
      [Switch('dTextAlphaBits=%s')]
    property AlphaBitsGraphic: TGSAntialiasingOption read GetAlphaBitsGraphic write SetAlphaBitsGraphic;
      /// <summary>
      /// Subsample antialiasing for text option.
      /// </summary>
      [Switch('dGraphicsAlphaBits=%s')]
    property AlphaBitsText: TGSAntialiasingOption read GetAlphaBitsText write SetAlphaBitsText;
      /// <summary>
      /// Template for the destination file name.
      /// </summary>
    property DestFileTempl: string read GetDestFileTempl write SetDestFileTempl;
      /// <summary>
      /// Final template for the destination file name.
      /// </summary>
      [Switch('-sOutputFile=%s')]
    property DestFileTemplFinal: String read GetDestFileTemplFinal;
      /// <summary>
      /// Last error code.
      /// </summary>
    property LastErrorCode: Integer read GetLastErrorCode;
      /// <summary>
      /// Last error code.
      /// </summary>
    property LastErrorMessage: String read GetLastErrorMessage;
      /// <summary>
      /// Resolution for the switch
      /// </summary>
      [Switch('r%s')]
    property ResolutionSwitch: String read GetResolutionSwitch;
      /// <summary>
      /// Horizontal resolution of destination bitmap.
      /// </summary>
    property ResolutionX: Integer read GetResolutionX write SetResolutionX default 300;
      /// <summary>
      /// Vertical resolution of destination bitmap. If 0 then horizontal resolution is used.
      /// </summary>
    property ResolutionY: Integer read GetResolutionY write SetResolutionY;
  end;

    /// <summary>
    /// PDF to PNG converter class.
    /// </summary>
  TGSWPdfToPngConverter = class(TGSWPdfToBitmapConverter, IGSWPdfToPng)
  strict private
    function GetFormat: TGSPngFormat;
    procedure SetFormat(const AValue: TGSPngFormat);
  public
    constructor Create(const AFormat: TGSPngFormat = bfPng16m); reintroduce;
  end;

    /// <summary>
    /// PDF to JPEG converter class.
    /// </summary>
  TGSWPdfToJpegConverter = class(TGSWPdfToBitmapConverter, IGSWPdfToJpeg)
  strict private
    FQualityLevel: TGSWJpegQuality;
  strict protected
    function GetQualityLevel: TGSWJpegQuality;
    procedure SetQualityLevel(const AValue: TGSWJpegQuality);
  public
    constructor Create;
      /// <summary>
      /// JPEG quality level. 0 value means GhostScript default value is used (75)
      /// </summary>
      [Switch('-dJPEGQ=%s')]
    property QualityLevel: TGSWJpegQuality read GetQualityLevel write SetQualityLevel;
  end;

    /// <summary>
    /// PDF to BMP file converter class.
    /// </summary>
  TGSWPdfToBmpConverter = class(TGSWPdfToBitmapConverter, IGSWPdfToBmp)
  strict private
    function GetFormat: TGSWBmpFormat;
    procedure SetFormat(const AValue: TGSWBmpFormat);
  public
    constructor Create(const AFormat: TGSWBmpFormat = bfBmp16m); reintroduce;
  end;

    /// <summary>
    /// PDF to PCX file converter class.
    /// </summary>
  TGSWPdfToPcxConverter = class(TGSWPdfToBitmapConverter, IGSWPdfToPcx)
  strict private
    function GetFormat: TGSWPcxFormat;
    procedure SetFormat(const AValue: TGSWPcxFormat);
  public
    constructor Create(const AFormat: TGSWPcxFormat = bfPcx24b); reintroduce;
  end;

    /// <summary>
    /// PDF to TIFF converter class.
    /// </summary>
  TGSWPdfToTiffConverter = class(TGSWPdfToBitmapConverter, IGSWPdfToTiff)
  strict private
    function GetFormat: TGSWTiffFormat;
    procedure SetFormat(const AValue: TGSWTiffFormat);
  public
    constructor Create(const AFormat: TGSWTiffFormat = bfTiff32nc); reintroduce;
  end;

  TGSWPdfConvertersFactory = class
  public
    class function CreateToBMP(const AFormat: TGSWBmpFormat = bfBmp16m): IGSWPdfToBmp; static;
    class function CreateToFormat(const AFormat: TGSWBitmapFormat): IGSWPdfToBitmap; static;
    class function CreateToJPEG: IGSWPdfToJpeg; static;
    class function CreateToPCX(const AFormat: TGSWPcxFormat = bfPcx24b): IGSWPdfToPcx; static;
    class function CreateToPNG(const AFormat: TGSPngFormat): IGSWPdfToPng; static;
    class function CreateToTIFF(const AFormat: TGSWTiffFormat): IGSWPdfToTiff; static;
  end;

  TGSWPdfToBitmapThread = class(TThread)
  strict private
    FConverter: IGSWPdfToBitmap;
    FConverterExecutionCompleted: IGSExecutionCompleted;
    FConverterExecutionProgress: IGSExecutionProgress;
    FConverterStdOutputCaller: IGSStandardOutputCaller;
    FPdfFileName: string;
    procedure DoExecuteCompleted(const ACorrect: Boolean);
    procedure DoExecutionProgress(const APosition, ATotal: Integer);
    procedure DoStdInputCall(var AText: UTF8String; var ALength: Integer);
    procedure DoStdOutputCall(const AText: UTF8String; var ALength: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(AConverter: IGSWPdfToBitmap; const APdfFileName: String); reintroduce;
      /// <summary>
      /// Reference do the external interface to show execution progress.
      /// </summary>
    property ExecutionProgress: IGSExecutionProgress read FConverterExecutionProgress write FConverterExecutionProgress;
      /// <summary>
      /// Reference to the execution completion information interface.
      /// </summary>
    property ExecutionCompleted: IGSExecutionCompleted read FConverterExecutionCompleted write FConverterExecutionCompleted;
      /// <summary>
      /// Pdf file name to convert.
      /// </summary>
    property PdfFileName: string read FPdfFileName write FPdfFileName;
      /// <summary>
      /// Reference do the external interface to show execution output.
      /// </summary>
    property StdOutputCaller: IGSStandardOutputCaller read FConverterStdOutputCaller write FConverterStdOutputCaller;
  end;

    /// <summary>
    /// Async executor of pdf file conversion class.
    /// </summary>
  TGSWPdfConverterAsyncExecutor = class(TInterfacedObject, IGSWExecutor)
  strict private
    FConverter: IGSWPdfToBitmap;
    FExecutionProgress: IGSExecutionProgress;
    FExecutionCompleted: IGSExecutionCompleted;
    FStdOutputCaller: IGSStandardOutputCaller;
    FThread: TGSWPdfToBitmapThread;
    function GetExecutionProgress: IGSExecutionProgress;
    function GetExecutionCompleted: IGSExecutionCompleted;
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
    procedure SetExecutionCompleted(const AValue: IGSExecutionCompleted);
    procedure SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
  public
    constructor Create(const AConverter: IGSWPdfToBitmap; const APdfFileName: String); reintroduce;
    destructor Destroy; override;
      /// <summary>
      /// Execute process.
      /// </summary>
    procedure Execute;
      /// <summary>
      /// Function returns execution status.
      /// </summary>
    function Executing: Boolean;
      /// <summary>
      /// Stop process.
      /// </summary>
    procedure Stop;
  end;

    /// <summary>
    /// Sync executor of pdf file conversion.
    /// </summary>
  TGSWPdfConverterSyncExecutor = class(TInterfacedObject, IGSWExecutor)
  strict private
    FExecuting: Boolean;
    FExecutionCompleted: IGSExecutionCompleted;
    FPdfConverter: IGSWPdfToBitmap;
    FPdfFileName: String;
    FStopped: Boolean;
    procedure DoStdInputCall(var AText: UTF8String; var ALength: Integer);
    procedure DoExecuteCompleted(const ACorrect: Boolean);
    function GetExecutionProgress: IGSExecutionProgress;
    function GetExecutionCompleted: IGSExecutionCompleted;
    function GetStdOutputCaller: IGSStandardOutputCaller;
    procedure SetExecutionProgress(const AValue: IGSExecutionProgress);
    procedure SetExecutionCompleted(const AValue: IGSExecutionCompleted);
    procedure SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
  public
    constructor Create(const AConverter: IGSWPdfToBitmap; const APdfFileName: String); reintroduce;
      /// <summary>
      /// Execute process.
      /// </summary>
    procedure Execute;
      /// <summary>
      /// Function returns execution status.
      /// </summary>
    function Executing: Boolean;
      /// <summary>
      /// Last error code.
      /// </summary>
    function LastErrorCode: Integer;
      /// <summary>
      /// Last error message.
      /// </summary>
    function LastErrorMessage: String;
      /// <summary>
      /// Stop process.
      /// </summary>
    procedure Stop;
      /// <summary>
      /// Pdf filename to convert.
      /// </summary>
    property PdfFileName: String read FPdfFileName;
  end;

implementation

uses
  System.TypInfo,
  gsw.api, gsw.resources;

constructor TGSWPdfToBitmapConverter.Create;
begin
  inherited;
  FResolutionX := 300;
end;

function TGSWPdfToBitmapConverter.BasicConverter: IGSWPdfToBitmap;
begin
  Result := Self;
end;

function TGSWPdfToBitmapConverter.CreateExecutor(const APdfFileName: String; const AAsync: Boolean = True):
    IGSWExecutor;
begin
  if AAsync then
    Result := TGSWPdfConverterAsyncExecutor.Create(Self, APdfFileName)
  else
    Result := TGSWPdfConverterSyncExecutor.Create(Self, APdfFileName);
end;

function TGSWPdfToBitmapConverter.Execute(const APdfFileName: string): Boolean;
var
  lInstance: IGSInstance;
  lArgsArray: TArray<String>;
  lExitCode: Integer;
begin
  FLastErrorCode := 0;
  FLastErrorMessage := '';
  lArgsArray := TSwitchesValues.Generate(Self);
  lInstance := TGSInstance.Create;
  PrepareIOCalls(lInstance);
  FLastErrorCode := lInstance.CreateInstance;
  try
    if FLastErrorCode <> gs_error_ok then
    begin
      FLastErrorMessage := Format(SErrorWhileCreatingInstance, [FLastErrorCode]);
      Exit(False);
    end;

    if FLastErrorCode <> gs_error_ok then
    begin
      FLastErrorMessage := Format(SErrorWhileCreatingInstance, [FLastErrorCode]);
      Exit(False);
    end;
    FLastErrorCode := lInstance.InitWithArgs(lArgsArray);
    if FLastErrorCode <> gs_error_ok then
    begin
      FLastErrorMessage := Format(SErrorWhileInitializingInstance, [FLastErrorCode]);
      Exit(False);
    end;
    lExitCode := 0;
    FLastErrorCode := lInstance.RunFile(APdfFileName, 0, lExitCode);
    if FLastErrorCode <> gs_error_ok then
    begin
      FLastErrorMessage := Format(SErrorWhileProcessingFile, [FLastErrorCode, APdfFileName]);
      Exit(False);
    end;
    Result := True;
  finally
    lExitCode := lInstance.ExitInstance;
    if (FLastErrorCode = gs_error_ok) or (FLastErrorCode = gs_error_Quit) then
    begin
      FLastErrorCode := lExitCode;
      FLastErrorMessage := Format(SErrorWhileExitingInstance, [FLastErrorCode]);
      Result := False;
    end;
    lInstance.DeleteInstance;
  end;
end;

function TGSWPdfToBitmapConverter.GetAlphaBitsGraphic: TGSAntialiasingOption;
begin
  Result := FAlphaBitsGraphic;
end;

function TGSWPdfToBitmapConverter.GetAlphaBitsText: TGSAntialiasingOption;
begin
  Result := FAlphaBitsText;
end;

function TGSWPdfToBitmapConverter.GetDestFileTempl: string;
begin
  Result := FDestFileTempl;
end;

function TGSWPdfToBitmapConverter.GetDestFileTemplFinal: String;
var
  lExtension: String;
begin
  Result := DestFileTempl;
  if FDefaultExt.Length = 0 then
    Exit;
  lExtension := ExtractFileExt(Result);
  if (lExtension.Length > 4) or (lExtension.Length = 0) then
    Result := Result + FDefaultExt
  else
    if (lExtension = '.') then
      Result := ChangeFileExt(Result, FDefaultExt);
end;

function TGSWPdfToBitmapConverter.GetExecutionProgress: IGSExecutionProgress;
begin
  Result := FExecuteProgress;
end;

function TGSWPdfToBitmapConverter.GetLastErrorCode: Integer;
begin
  Result := FLastErrorCode;
end;

function TGSWPdfToBitmapConverter.GetLastErrorMessage: String;
begin
  Result := FLastErrorMessage;
end;

function TGSWPdfToBitmapConverter.GetResolutionSwitch: String;
begin
  if FResolutionY > 0 then
    Result := Format('%dx%d', [FResolutionX, FResolutionY])
  else
    Result := FResolutionX.ToString;
end;

function TGSWPdfToBitmapConverter.GetResolutionX: Integer;
begin
  Result := FResolutionX;
end;

function TGSWPdfToBitmapConverter.GetResolutionY: Integer;
begin
  Result := FResolutionY;
end;

procedure TGSWPdfToBitmapConverter.PrepareIOCalls(const AInstance: IGSInstance);
var
  lCall, lProgressCall: IGSStandardOutputCaller;
  lCallerArray: TArray<IGSStandardOutputCaller>;
begin
  Assert(AInstance <> nil);
  if FExecuteProgress <> nil then
    lProgressCall := TGSStdOutToProgress.Create(FExecuteProgress);
  lCall := StdOutputCaller;
  if (lProgressCall <> nil) and (lCall <> nil) then
  begin
    SetLength(lCallerArray, 2);
    lCallerArray[0] := lProgressCall;
    lCallerArray[1] := lCall;
    lCall := TGSInstanceIOGroup.Create(lCallerArray);
  end
  else
    if lCall = nil then
      lCall := lProgressCall;
  AInstance.StdOutputCall := lCall;
  AInstance.StdInputCall := StdInputCaller;
  AInstance.StdErrorCall := StdErrorCaller;
end;

procedure TGSWPdfToBitmapConverter.SetAlphaBitsGraphic(const AValue: TGSAntialiasingOption);
begin
  FAlphaBitsGraphic := AValue;
end;

procedure TGSWPdfToBitmapConverter.SetAlphaBitsText(const AValue: TGSAntialiasingOption);
begin
  FAlphaBitsText := AValue;
end;

procedure TGSWPdfToBitmapConverter.SetDestFileTempl(const AValue: string);
begin
  FDestFileTempl := AValue;
end;

procedure TGSWPdfToBitmapConverter.SetExecutionProgress(const AValue: IGSExecutionProgress);
begin
  FExecuteProgress := AValue;
end;

procedure TGSWPdfToBitmapConverter.SetResolutionX(const AValue: Integer);
begin
  FResolutionX := AValue;
end;

procedure TGSWPdfToBitmapConverter.SetResolutionY(const AValue: Integer);
begin
  FResolutionY := AValue;
end;

constructor TGSWPdfToPngConverter.Create(const AFormat: TGSPngFormat = bfPng16m);
begin
  inherited Create;
  FFormat := AFormat;
  FDefaultExt := '.png';
end;

function TGSWPdfToPngConverter.GetFormat: TGSPngFormat;
begin
  Result := FFormat;
end;

procedure TGSWPdfToPngConverter.SetFormat(const AValue: TGSPngFormat);
begin
  FFormat := AValue;
end;

{$REGION 'TGSWPdfToJpegConverter'}

constructor TGSWPdfToJpegConverter.Create;
begin
  inherited Create;
  FFormat := bfJpeg;
  FDefaultExt := '.jpg';
end;

function TGSWPdfToJpegConverter.GetQualityLevel: TGSWJpegQuality;
begin
  Result := FQualityLevel;
end;

procedure TGSWPdfToJpegConverter.SetQualityLevel(const AValue: TGSWJpegQuality);
begin
  FQualityLevel := AValue;
end;

{$ENDREGION}

{$REGION 'TGSWPdfToBmpConverter'}

constructor TGSWPdfToBmpConverter.Create(const AFormat: TGSWBmpFormat = bfBmp16m);
begin
  inherited Create;
  FFormat := AFormat;
  FDefaultExt := '.bmp';
end;

function TGSWPdfToBmpConverter.GetFormat: TGSWBmpFormat;
begin
  Result := FFormat;
end;

procedure TGSWPdfToBmpConverter.SetFormat(const AValue: TGSWBmpFormat);
begin
  FFormat := AValue;
end;

{$ENDREGION}

{$REGION 'TGSWPdfToPcxConverter'}

constructor TGSWPdfToPcxConverter.Create(const AFormat: TGSWPcxFormat);
begin
  inherited Create;
  FFormat := AFormat;
  FDefaultExt := '.pcx';
end;

function TGSWPdfToPcxConverter.GetFormat: TGSWPcxFormat;
begin
  Result := FFormat;
end;

procedure TGSWPdfToPcxConverter.SetFormat(const AValue: TGSWPcxFormat);
begin
  FFormat := AValue;
end;

{$ENDREGION}

{$REGION 'TGSWPdfToTiffConverter'}

constructor TGSWPdfToTiffConverter.Create(const AFormat: TGSWTiffFormat = bfTiff32nc);
begin
  inherited Create;
  FFormat := AFormat;
  FDefaultExt := '.tif';
end;

function TGSWPdfToTiffConverter.GetFormat: TGSWTiffFormat;
begin
  Result := FFormat;
end;

procedure TGSWPdfToTiffConverter.SetFormat(const AValue: TGSWTiffFormat);
begin
  FFormat := AValue;
end;

{$ENDREGION}

{$REGION 'TGSWPdfConvertersFactory'}

class function TGSWPdfConvertersFactory.CreateToBMP(const AFormat: TGSWBmpFormat = bfBmp16m): IGSWPdfToBmp;
begin
  Result := TGSWPdfToBmpConverter.Create(AFormat);
end;

class function TGSWPdfConvertersFactory.CreateToFormat(const AFormat: TGSWBitmapFormat): IGSWPdfToBitmap;
begin
  case AFormat of
    bfBmpMono..bfBmp32b:
      Result := CreateToBMP(AFormat).BasicConverter;
    bfJpeg:
      Result := CreateToJPEG.BasicConverter;
    bfPcxMono..bfPcx24b:
      Result := CreateToPCX(AFormat).BasicConverter;
    bfPng16m..bfPngGray:
      Result := CreateToPNG(AFormat).BasicConverter;
    bfTiffGray..bfTiff32nc:
      Result := CreateToTIFF(AFormat).BasicConverter;
    else
      raise Exception.CreateFmt(SErrorWrongFileFormat, [GetEnumName(TypeInfo(TGSWBitmapFormat), Integer(AFormat))]);
  end;
end;

class function TGSWPdfConvertersFactory.CreateToJPEG: IGSWPdfToJpeg;
begin
  Result := TGSWPdfToJpegConverter.Create;
end;

class function TGSWPdfConvertersFactory.CreateToPCX(const AFormat: TGSWPcxFormat = bfPcx24b): IGSWPdfToPcx;
begin
  Result := TGSWPdfToPcxConverter.Create(AFormat);
end;

class function TGSWPdfConvertersFactory.CreateToPNG(const AFormat: TGSPngFormat): IGSWPdfToPng;
begin
  Result := TGSWPdfToPngConverter.Create(AFormat);
end;

class function TGSWPdfConvertersFactory.CreateToTIFF(const AFormat: TGSWTiffFormat): IGSWPdfToTiff;
begin
  Result := TGSWPdfToTiffConverter.Create(AFormat);
end;

{$ENDREGION}

{$REGION 'TGSWPdfToBitmapThread'}

constructor TGSWPdfToBitmapThread.Create(AConverter: IGSWPdfToBitmap; const APdfFileName: String);
begin
  Assert(AConverter <> nil);
  inherited Create(True);
  FConverter := AConverter;
  FConverterExecutionProgress := FConverter.ExecutionProgress;
  FConverter.ExecutionProgress := TGSWExecutionProgressEventAdapter.Create(DoExecutionProgress);
  FConverterStdOutputCaller := FConverter.StdOutputCaller;
  FConverter.StdOutputCaller := TGSWStdOutputCallEventAdapter.Create(DoStdOutputCall);
    // execution stopping support
  FConverter.StdInputCaller := TGSWStdInputCallEventAdapter.Create(DoStdInputCall);
  FConverter.ExecuteParams := FConverter.ExecuteParams - [gsepBatch, gsepNoPause];
  FPdfFileName := APdfFileName;
end;

procedure TGSWPdfToBitmapThread.DoExecuteCompleted(const ACorrect: Boolean);
begin
  if FConverterExecutionCompleted <> nil then
    Queue(
      procedure
      begin
        FConverterExecutionCompleted.Completed(ACorrect);
      end);
end;

procedure TGSWPdfToBitmapThread.DoExecutionProgress(const APosition, ATotal: Integer);
begin
  Queue(
    procedure
    begin
      if FConverterExecutionProgress <> nil then
        FConverterExecutionProgress.SetProgress(APosition, ATotal);
    end);
end;

procedure TGSWPdfToBitmapThread.DoStdInputCall(var AText: UTF8String; var ALength: Integer);
begin
  if Terminated then
    Abort
  else
    ALength := 0;
end;

procedure TGSWPdfToBitmapThread.DoStdOutputCall(const AText: UTF8String; var ALength: Integer);
var
  lLength: PInteger;
begin
  lLength := @ALength;
  Queue(
    procedure
    begin
      if FConverterStdOutputCaller <> nil then
        FConverterStdOutputCaller.Call(AText, lLength^);
    end);
end;

procedure TGSWPdfToBitmapThread.Execute;
begin
  try
    try
      inherited;
      if FConverter.Execute(PdfFileName) then
        ReturnValue := FConverter.LastErrorCode
      else
        ReturnValue := gs_error_ok;
    except
      on E: Exception do
      begin
        ReturnValue := gs_error_Fatal;
        raise;
      end;
    end;
  finally
    DoExecuteCompleted((ReturnValue = gs_error_ok) and not Terminated);
  end;
end;

{$ENDREGION}

{$REGION 'TGSWPdfConverterAsyncExecutor'}

constructor TGSWPdfConverterAsyncExecutor.Create(const AConverter: IGSWPdfToBitmap; const APdfFileName: String);
begin
  inherited Create;
  FStdOutputCaller := AConverter.StdOutputCaller;
  FExecutionProgress := AConverter.ExecutionProgress;
  FThread := TGSWPdfToBitmapThread.Create(AConverter, APdfFileName);
end;

destructor TGSWPdfConverterAsyncExecutor.Destroy;
begin
  FThread.WaitFor;
  FreeAndNil(FThread);
  inherited;
end;

procedure TGSWPdfConverterAsyncExecutor.Execute;
begin
  FThread.StdOutputCaller := FStdOutputCaller;
  FThread.ExecutionProgress := FExecutionProgress;
  FThread.ExecutionCompleted := FExecutionCompleted;
  FThread.Start;
end;

function TGSWPdfConverterAsyncExecutor.Executing: Boolean;
begin
  Result := not FThread.Suspended and not FThread.Terminated and not FThread.Finished;
end;

function TGSWPdfConverterAsyncExecutor.GetExecutionProgress: IGSExecutionProgress;
begin
  Result := FExecutionProgress;
end;

function TGSWPdfConverterAsyncExecutor.GetExecutionCompleted: IGSExecutionCompleted;
begin
  Result := FExecutionCompleted;
end;

function TGSWPdfConverterAsyncExecutor.GetStdOutputCaller: IGSStandardOutputCaller;
begin
  Result := FStdOutputCaller;
end;

function TGSWPdfConverterAsyncExecutor.LastErrorCode: Integer;
begin
  if not Executing then
    Result := FConverter.LastErrorCode
  else
    Result := gs_error_ok;
end;

function TGSWPdfConverterAsyncExecutor.LastErrorMessage: String;
begin
  if not Executing then
    Result := FConverter.LastErrorMessage
  else
    Result := '';
end;

procedure TGSWPdfConverterAsyncExecutor.SetExecutionProgress(const AValue: IGSExecutionProgress);
begin
  FExecutionProgress := AValue;
end;

procedure TGSWPdfConverterAsyncExecutor.SetExecutionCompleted(const AValue: IGSExecutionCompleted);
begin
  FExecutionCompleted := AValue;
end;

procedure TGSWPdfConverterAsyncExecutor.SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
begin
  FStdOutputCaller := AValue;
end;

procedure TGSWPdfConverterAsyncExecutor.Stop;
begin
  if Executing then
    FThread.Terminate;
end;

{$ENDREGION}

constructor TGSWPdfConverterSyncExecutor.Create(const AConverter: IGSWPdfToBitmap; const APdfFileName: String);
begin
  inherited Create;
  FPdfConverter := AConverter;
  FPdfFileName := APdfFileName;
    // execution stopping support
  FPdfConverter.StdInputCaller := TGSWStdInputCallEventAdapter.Create(DoStdInputCall);
  FPdfConverter.ExecuteParams := FPdfConverter.ExecuteParams - [gsepBatch, gsepNoPause];
end;

procedure TGSWPdfConverterSyncExecutor.DoExecuteCompleted(const ACorrect: Boolean);
begin
  if FExecutionCompleted <> nil then
    FExecutionCompleted.Completed(ACorrect);
end;

procedure TGSWPdfConverterSyncExecutor.DoStdInputCall(var AText: UTF8String; var ALength: Integer);
begin
  if FStopped then
    Abort
  else
    ALength := 0;
end;

procedure TGSWPdfConverterSyncExecutor.Execute;
var
  lCorrect: Boolean;
begin
  lCorrect := False;
  try
    FExecuting := True;
    try
      FStopped := False;
      try
        FPdfConverter.Execute(FPdfFileName);
        lCorrect := FPdfConverter.LastErrorCode = 0;
      except
        on E: EAbort do
          ;
      end;
    finally
      FExecuting := False;
    end;
  finally
    DoExecuteCompleted(lCorrect);
  end;
end;

function TGSWPdfConverterSyncExecutor.Executing: Boolean;
begin
  Result := FExecuting;
end;

function TGSWPdfConverterSyncExecutor.GetExecutionProgress: IGSExecutionProgress;
begin
  Result := FPdfConverter.ExecutionProgress;
end;

function TGSWPdfConverterSyncExecutor.GetExecutionCompleted: IGSExecutionCompleted;
begin
  Result := FExecutionCompleted;
end;

function TGSWPdfConverterSyncExecutor.GetStdOutputCaller: IGSStandardOutputCaller;
begin
  Result := FPdfConverter.StdOutputCaller;
end;

function TGSWPdfConverterSyncExecutor.LastErrorCode: Integer;
begin
  Result := FPdfConverter.LastErrorCode;
end;

function TGSWPdfConverterSyncExecutor.LastErrorMessage: String;
begin
  Result := FPdfConverter.LastErrorMessage;
end;

procedure TGSWPdfConverterSyncExecutor.SetExecutionProgress(const AValue: IGSExecutionProgress);
begin
  FPdfConverter.ExecutionProgress := AValue;
end;

procedure TGSWPdfConverterSyncExecutor.SetExecutionCompleted(const AValue: IGSExecutionCompleted);
begin
  FExecutionCompleted := AValue;
end;

procedure TGSWPdfConverterSyncExecutor.SetStdOutputCaller(const AValue: IGSStandardOutputCaller);
begin
  FPdfConverter.StdOutputCaller := AValue;
end;

procedure TGSWPdfConverterSyncExecutor.Stop;
begin
  FStopped := True;
end;



end.
