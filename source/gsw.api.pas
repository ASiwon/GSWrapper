unit gsw.api;

interface

{$I ..\..\source\DelphiVersions.inc}

const
{$IFDEF WIN32}
  cGSLibraryFileName = 'gsdll32.dll';
{$ELSE}
  cGSLibraryFileName = 'gsdll64.dll';
{$ENDIF}

{$IFNDEF DELPHI11_Alexandria}
type
  FixedUInt = LongWord;
  PUTF8Char = type PAnsiChar;
{$ENDIF}

const
  STDIN_BUF_SIZE = 128;
  {$EXTERNALSYM STDIN_BUF_SIZE}
  STDOUT_BUF_SIZE = 128;
  {$EXTERNALSYM STDOUT_BUF_SIZE}
  STDERR_BUF_SIZE = 128;
  {$EXTERNALSYM STDERR_BUF_SIZE}

  DISPLAY_VERSION_MAJOR = 1;
  {$EXTERNALSYM DISPLAY_VERSION_MAJOR}
  DISPLAY_VERSION_MINOR = 0;
  {$EXTERNALSYM DISPLAY_VERSION_MINOR}

  //* Define the color space alternatives */
  DISPLAY_COLORS_NATIVE = $01;
  {$EXTERNALSYM DISPLAY_COLORS_NATIVE}
  DISPLAY_COLORS_GRAY   = $02;
  {$EXTERNALSYM DISPLAY_COLORS_GRAY}
  DISPLAY_COLORS_RGB    = $04;
  {$EXTERNALSYM DISPLAY_COLORS_RGB}
  DISPLAY_COLORS_CMYK   = $08;
  {$EXTERNALSYM DISPLAY_COLORS_CMYK}

  DISPLAY_COLORS_MASK  = $000f;
  {$EXTERNALSYM DISPLAY_COLORS_MASK}

  //* Define whether alpha information, or an extra unused bytes is included */
  //* DISPLAY_ALPHA_FIRST and DISPLAY_ALPHA_LAST are not implemented */
  DISPLAY_ALPHA_NONE   = $00;
  {$EXTERNALSYM DISPLAY_ALPHA_NONE}
  DISPLAY_ALPHA_FIRST  = $10;
  {$EXTERNALSYM DISPLAY_ALPHA_FIRST}
  DISPLAY_ALPHA_LAST   = $20;
  {$EXTERNALSYM DISPLAY_ALPHA_LAST}
  DISPLAY_UNUSED_FIRST = $40;    //* e.g. Mac xRGB */
  {$EXTERNALSYM DISPLAY_UNUSED_FIRST}
  DISPLAY_UNUSED_LAST  = $80;   //* e.g. Windows BGRx */
  {$EXTERNALSYM DISPLAY_UNUSED_LAST}

  DISPLAY_ALPHA_MASK  = $0070;
  {$EXTERNALSYM DISPLAY_ALPHA_MASK}

  // * Define the depth per component for DISPLAY_COLORS_GRAY,
  // * DISPLAY_COLORS_RGB and DISPLAY_COLORS_CMYK,
  // * or the depth per pixel for DISPLAY_COLORS_NATIVE
  // * DISPLAY_DEPTH_2 and DISPLAY_DEPTH_12 have not been tested.
  // *
  DISPLAY_DEPTH_1   = $0100;
  {$EXTERNALSYM DISPLAY_DEPTH_1}
  DISPLAY_DEPTH_2   = $0200;
  {$EXTERNALSYM DISPLAY_DEPTH_2}
  DISPLAY_DEPTH_4   = $0400;
  {$EXTERNALSYM DISPLAY_DEPTH_4}
  DISPLAY_DEPTH_8   = $0800;
  {$EXTERNALSYM DISPLAY_DEPTH_8}
  DISPLAY_DEPTH_12  = $1000;
  {$EXTERNALSYM DISPLAY_DEPTH_12}
  DISPLAY_DEPTH_16  = $2000;
  {$EXTERNALSYM DISPLAY_DEPTH_16}
  //* unused (1<<14) */
  //* unused (1<<15) */

  DISPLAY_DEPTH_MASK  = $ff00;
  {$EXTERNALSYM DISPLAY_DEPTH_MASK}

  // * Define whether Red/Cyan should come first,
  // * or whether Blue/Black should come first
  // */
  DISPLAY_BIGENDIAN    = $00000;    //* Red/Cyan first */
  {$EXTERNALSYM DISPLAY_BIGENDIAN}
  DISPLAY_LITTLEENDIAN = $10000;    //* Blue/Black first */
  {$EXTERNALSYM DISPLAY_LITTLEENDIAN}

  DISPLAY_ENDIAN_MASK  = $00010000;
  {$EXTERNALSYM DISPLAY_ENDIAN_MASK}

  //* Define whether the raster starts at the top or bottom of the bitmap */
  DISPLAY_TOPFIRST    = $00000; //* Unix, Mac */
  {$EXTERNALSYM DISPLAY_TOPFIRST}
  DISPLAY_BOTTOMFIRST = $20000; //* Windows */
  {$EXTERNALSYM DISPLAY_BOTTOMFIRST}

  DISPLAY_FIRSTROW_MASK = $00020000;
  {$EXTERNALSYM DISPLAY_FIRSTROW_MASK}

  //* Define whether packing RGB in 16-bits should use 555
  // * or 565 (extra bit for green)
  // */
  DISPLAY_NATIVE_555 = $00000;
  {$EXTERNALSYM DISPLAY_NATIVE_555}
  DISPLAY_NATIVE_565 = $40000;
  {$EXTERNALSYM DISPLAY_NATIVE_565}
  DISPLAY_555_MASK  = $00040000;
  {$EXTERNALSYM DISPLAY_555_MASK}

  gs_error_ok = 0;
  {$EXTERNALSYM gs_error_ok}
  gs_error_unknownerror = -1;	// unknown error
  {$EXTERNALSYM gs_error_unknownerror}
  gs_error_dictfull = -2;
  {$EXTERNALSYM gs_error_dictfull}
  gs_error_dictstackoverflow = -3;
  {$EXTERNALSYM gs_error_dictstackoverflow}
  gs_error_dictstackunderflow = -4;
  {$EXTERNALSYM gs_error_dictstackunderflow}
  gs_error_execstackoverflow = -5;
  {$EXTERNALSYM gs_error_execstackoverflow}
  gs_error_interrupt = -6;
  {$EXTERNALSYM gs_error_interrupt}
  gs_error_invalidaccess = -7;
  {$EXTERNALSYM gs_error_invalidaccess}
  gs_error_invalidexit = -8;
  {$EXTERNALSYM gs_error_invalidexit}
  gs_error_invalidfileaccess = -9;
  {$EXTERNALSYM gs_error_invalidfileaccess}
  gs_error_invalidfont = -10;
  {$EXTERNALSYM gs_error_invalidfont}
  gs_error_invalidrestore = -11;
  {$EXTERNALSYM gs_error_invalidrestore}
  gs_error_ioerror = -12;
  {$EXTERNALSYM gs_error_ioerror}
  gs_error_limitcheck = -13;
  {$EXTERNALSYM gs_error_limitcheck}
  gs_error_nocurrentpoint = -14;
  {$EXTERNALSYM gs_error_nocurrentpoint}
  gs_error_rangecheck = -15;
  {$EXTERNALSYM gs_error_rangecheck}
  gs_error_stackoverflow = -16;
  {$EXTERNALSYM gs_error_stackoverflow}
  gs_error_stackunderflow = -17;
  {$EXTERNALSYM gs_error_stackunderflow}
  gs_error_syntaxerror = -18;
  {$EXTERNALSYM gs_error_syntaxerror}
  gs_error_timeout = -19;
  {$EXTERNALSYM gs_error_timeout}
  gs_error_typecheck = -20;
  {$EXTERNALSYM gs_error_typecheck}
  gs_error_undefined = -21;
  {$EXTERNALSYM gs_error_undefined}
  gs_error_undefinedfilename = -22;
  {$EXTERNALSYM gs_error_undefinedfilename}
  gs_error_undefinedresult = -23;
  {$EXTERNALSYM gs_error_undefinedresult}
  gs_error_unmatchedmark = -24;
  {$EXTERNALSYM gs_error_unmatchedmark}
  gs_error_VMerror = -25;		// must be the last Level 1 error
  {$EXTERNALSYM gs_error_VMerror}
    // ------ Additional Level 2 errors (also in DPS, ------
  gs_error_configurationerror = -26;
  {$EXTERNALSYM gs_error_configurationerror}
  gs_error_undefinedresource = -27;
  {$EXTERNALSYM gs_error_undefinedresource}
  gs_error_unregistered = -28;
  {$EXTERNALSYM gs_error_unregistered}
  gs_error_invalidcontext = -29;
  {$EXTERNALSYM gs_error_invalidcontext}
    // invalidid is for the NeXT DPS extension.
  gs_error_invalidid = -30;
  {$EXTERNALSYM gs_error_invalidid}

    (* We need a specific stackoverflow error for the PDF interpreter to avoid dropping into
       the Postscript interpreter's stack extending code; when the PDF interpreter is called from Postscript *)
  gs_error_pdf_stackoverflow = -31;
  {$EXTERNALSYM gs_error_pdf_stackoverflow}

    // Internal error for the C-based PDF interpreter; to indicate a circular PDF reference
  gs_error_circular_reference = -32;
  {$EXTERNALSYM gs_error_circular_reference}

    // ------ Pseudo-errors used internally ------
  gs_error_hit_detected = -99;
  {$EXTERNALSYM gs_error_hit_detected}
  gs_error_Fatal = -100;
  {$EXTERNALSYM gs_error_Fatal}

    (* Internal code for the .quit operator.
       The real quit code is an integer on the operand stack.
       gs_interpret returns this only for a .quit with a zero exit code. *)
  gs_error_Quit = -101;
  {$EXTERNALSYM gs_error_Quit}

    (* Internal code for a normal exit from the interpreter.
       Do not use outside of interp.c. *)
  gs_error_InterpreterExit = -102;
  {$EXTERNALSYM gs_error_InterpreterExit}

    // Need the remap color error for high level pattern support
  gs_error_Remap_Color = -103;
  {$EXTERNALSYM gs_error_Remap_Color}

    // Internal code to indicate we have underflowed the top block of the e-stack.
  gs_error_ExecStackUnderflow = -104;
  {$EXTERNALSYM gs_error_ExecStackUnderflow}

    (* Internal code for the vmreclaim operator with a positive operand.
       We need to handle this as an error because otherwise the interpreter
       won't reload enough of its state when the operator returns. *)
  gs_error_VMreclaim = -105;
  {$EXTERNALSYM gs_error_VMreclaim}

    // Internal code for requesting more input from run_string.
  gs_error_NeedInput = -106;
  {$EXTERNALSYM gs_error_NeedInput}

    // Internal code to all run_string to request that the data is rerun using run_file.
  gs_error_NeedFile = -107;
  {$EXTERNALSYM gs_error_NeedFile}

    // Internal code for a normal exit when usage info is displayed.
    // This allows Window versions of Ghostscript to pause until
    // the message can be read.
  gs_error_Info = -110;
  {$EXTERNALSYM gs_error_Info}

    (* A special 'error'; like reamp color above. This is used by a subclassing
       device to indicate that it has fully processed a device method; and parent
       subclasses should not perform any further action. Currently this is limited
       to compositor creation. *)
  gs_error_handled = -111;
  {$EXTERNALSYM gs_error_handled}

type
  TGSAPIrevision = record
    product: PAnsiChar;
    copyright: PAnsiChar;
    revision: Longint;
    revisiondat: Longint;
  end;

  TStdIOFunction = function(caller_handle: Pointer; const buf: PAnsiChar; len: Integer): Integer; stdcall;
  TPollFunction = function(caller_handle: Pointer): Integer; stdcall;

  TDisplayEvent = function(handle: Pointer; device: Pointer): Integer; cdecl;
  TDisplayPreResizeEvent = function(handle: Pointer; device: Pointer;
         width: Integer; height: Integer; raster: Integer; format: FixedUInt): Integer; cdecl;
  TDisplayResizeEvent = function(handle: Pointer; device: Pointer;
         width: Integer; height: Integer; raster: Integer; format: FixedUInt; pimage: PAnsiChar): Integer; cdecl;
  TDisplayPageEvent = function(handle: Pointer; device: Pointer; copies: Integer; flush: Integer): Integer; cdecl;
  TDisplayUpdateEvent = function(handle: Pointer; device: Pointer; x: Integer; y: Integer; w: Integer; h: Integer): Integer; cdecl;
  TDisplayMemAlloc = procedure(handle: Pointer; device: Pointer; size: UInt64); cdecl;
  TDisplayMemFree = function(handle: Pointer; device: Pointer; mem: Pointer): Integer; cdecl;

  TDisplayCallback = record
    size: Integer;
    version_major: Integer;
    version_minor: Integer;
    // New device has been opened */
    // This is the first event from this device. */
    display_open: TDisplayEvent;
    // Device is about to be closed. */
    // Device will not be closed until this function returns. */
    display_preclose: TDisplayEvent;
    // Device has been closed. */
    // This is the last event from this device. */
    display_close: TDisplayEvent;
    // Device is about to be resized. */
    // Resize will only occur if this function returns 0. */
    // raster is byte count of a row. */
    display_presize: TDisplayPreResizeEvent;
    // Device has been resized. */
    // New pointer to raster returned in pimage */
    display_size: TDisplayResizeEvent;

    // flushpage */
    display_sync: TDisplayEvent;

    // showpage */
    // If you want to pause on showpage, then don't return immediately */
    display_page: TDisplayPageEvent;

    // Notify the caller whenever a portion of the raster is updated. */
    // This can be used for cooperative multitasking or for
    // progressive update of the display.
    // This function pointer may be set to NULL if not required.
    //
    display_update: TDisplayUpdateEvent;

    // Allocate memory for bitmap */
    // This is provided in case you need to create memory in a special
    // way, e.g. shared.  If this is NULL, the Ghostscript memory device
    // allocates the bitmap. This will only called to allocate the
    // image buffer. The first row will be placed at the address
    // returned by display_memalloc.
    //

    display_memalloc: TDisplayMemAlloc;

    // Free memory for bitmap */
    // If this is NULL, the Ghostscript memory device will free the bitmap */
    display_memfree: TDisplayMemFree;
  end;

  PPAnsiChar = ^PAnsiChar;
  {$NODEFINE PPAnsiChar}

    /// API functions and procedures types
  TGSAPIRevisionFunc = function (var pr: TGSAPIrevision; len: Integer): Integer; stdcall;
  TGSAPINewInstanceFunc = function (var pinstance: Pointer; caller_handle: Pointer): Integer; stdcall;
  TGSAPIDeleteInstanceProc = procedure (pinstance: Pointer); stdcall;
  TGSAPISetStdIOFunc = function (pinstance: Pointer; stdin_fn, stdout_fn, stderr_fn: TStdioFunction): Integer; stdcall;
  TGSAPISetPollFunc = function (pinstance: Pointer; poll_fn: TPollFunction): Integer; stdcall;
  TGSAPISetDisplayCallbackFunc = function (pinstance: Pointer; const callback: TDisplayCallback): Integer; stdcall;
  TGSAPISetArgEncodingFunc = function (pinstance: Pointer; encoding: Integer): Integer; stdcall;
  TGSAPIInitWithArgsFunc = function (pinstance: Pointer; argc: Integer; argv: PPAnsiChar): Integer; stdcall;
  TGSAPIRunStringBeginFunc = function (pinstance: Pointer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  TGSAPIRunStringContinueFunc = function (pinstance: Pointer; str: PUTF8Char; len: Integer; user_errors: Integer;
    var pexit_code: Integer): Integer; stdcall;
  TGSAPIRunStringEndFunc = function (pinstance: Pointer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  TGSAPIRunStringWithLengthFunc = function (pinstance: Pointer; str: PUTF8Char; len: Integer; user_errors: Integer;
    var pexit_code: Integer): Integer; stdcall;
  TGSAPIRunStringFunc = function (pinstance: Pointer; str: PUTF8Char; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  TGSAPIRunFileFunc = function (pinstance: Pointer; file_name: PUTF8Char; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  TGSAPIExitFunc = function (pinstance: Pointer): Integer; stdcall;

  TGhostScriptApi = class;

  TGhostScriptApiClass = class of TGhostScriptApi;

  TGhostScriptApi = class abstract
  strict protected
  class var
    FCreateNewInstance: TGSAPINewInstanceFunc;
    FCurrentInstance: TGhostScriptApiClass;
    FDeleteInstance: TGSAPIDeleteInstanceProc;
    FExit: TGSAPIExitFunc;
    FInitWithArgs: TGSAPIInitWithArgsFunc;
    FRevision: TGSAPIRevisionFunc;
    FRunFile: TGSAPIRunFileFunc;
    FRunString: TGSAPIRunStringFunc;
    FRunStringBegin: TGSAPIRunStringBeginFunc;
    FRunStringContinue: TGSAPIRunStringContinueFunc;
    FRunStringEnd: TGSAPIRunStringEndFunc;
    FRunStringWithLength: TGSAPIRunStringWithLengthFunc;
    FSetArgsEncoding: TGSAPISetArgEncodingFunc;
    FSetDisplayCallback: TGSAPISetDisplayCallbackFunc;
    FSetPoll: TGSAPISetPollFunc;
    FSetStdIO: TGSAPISetStdIOFunc;
  public
    class function CurrentInstance: TGhostScriptApiClass; inline;
      /// <summary>
      /// Library finalization
      /// </summary>
    class procedure Finalize; virtual;
      /// <summary>
      /// Library initialization
      /// </summary>
    class procedure Initialize; virtual; abstract;
      /// <summary>
      /// NewInstance in GS API call
      /// </summary>
    class property CreateNewInstance: TGSAPINewInstanceFunc read FCreateNewInstance;
    class property DeleteInstance: TGSAPIDeleteInstanceProc read FDeleteInstance;
    class property Exit: TGSAPIExitFunc read FExit;
    class property InitWithArgs: TGSAPIInitWithArgsFunc read FInitWithArgs;
    class property Revision: TGSAPIRevisionFunc read FRevision;
    class property RunFile: TGSAPIRunFileFunc read FRunFile;
    class property RunString: TGSAPIRunStringFunc read FRunString;
    class property RunStringBegin: TGSAPIRunStringBeginFunc read FRunStringBegin;
    class property RunStringContinue: TGSAPIRunStringContinueFunc read FRunStringContinue;
    class property RunStringEnd: TGSAPIRunStringEndFunc read FRunStringEnd;
    class property RunStringWithLength: TGSAPIRunStringWithLengthFunc read FRunStringWithLength;
    class property SetArgsEncoding: TGSAPISetArgEncodingFunc read FSetArgsEncoding;
    class property SetDisplayCallback: TGSAPISetDisplayCallbackFunc read FSetDisplayCallback;
    class property SetPoll: TGSAPISetPollFunc read FSetPoll;
    class property SetStdIO: TGSAPISetStdIOFunc read FSetStdIO;
  end;

const
  gsapi_new_instance_name = 'gsapi_new_instance';
  gsapi_init_with_args_name = 'gsapi_init_with_args';
  gsapi_exit_name = 'gsapi_exit';
  gsapi_revision_name = 'gsapi_revision';
  gsapi_delete_instance_name = 'gsapi_delete_instance';
  gsapi_set_arg_encoding_name = 'gsapi_set_arg_encoding';
  gsapi_set_stdio_name = 'gsapi_set_stdio';
  gsapi_set_poll_name = 'gsapi_set_poll';
  gsapi_set_display_callback_name = 'gsapi_set_display_callback';
  gsapi_run_string_begin_name = 'gsapi_run_string_begin';
  gsapi_run_string_continue_name = 'gsapi_run_string_continue';
  gsapi_run_string_end_name = 'gsapi_run_string_end';
  gsapi_run_string_with_length_name = 'gsapi_run_string_with_length';
  gsapi_run_string_name = 'gsapi_run_string';
  gsapi_run_file_name = 'gsapi_run_file';


    /// <summary>
    /// Function returns reference to the current (static/dynamic) GhostScript API class.
    /// </summary>
  function GSAPIInstance: TGhostScriptApiClass; inline;

implementation

function GSAPIInstance: TGhostScriptApiClass;
begin
  Result := TGhostScriptApi.CurrentInstance;
end;

{$REGION 'TGhostScriptApi'}

class function TGhostScriptApi.CurrentInstance: TGhostScriptApiClass;
begin
  Result := FCurrentInstance;
end;

class procedure TGhostScriptApi.Finalize;
begin
end;

{$ENDREGION}

end.
