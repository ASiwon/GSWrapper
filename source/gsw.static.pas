unit gsw.static;

interface

uses
  gsw.common, gsw.api;

type
    /// <summary>
    /// Static linking for GhostScript library.
    /// </summary>
  TGhostScriptApiStatic = class(TGhostScriptApi)
  public
    class procedure Initialize; override;
    class procedure UseAsCurrent;
  end;

  function gsapi_revision(var pr: TGSAPIrevision; len: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_revision}
  function gsapi_new_instance(var pinstance: Pointer; caller_handle: Pointer): Integer; stdcall;
  {$EXTERNALSYM gsapi_new_instance}
  procedure gsapi_delete_instance(pinstance: Pointer); stdcall;
  {$EXTERNALSYM gsapi_delete_instance}
  function gsapi_set_arg_encoding(pinstance: Pointer; encoding: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_set_arg_encoding}
  function gsapi_set_stdio(pinstance: Pointer;
    stdin_fn: TStdioFunction; stdout_fn: TStdioFunction;
    stderr_fn: TStdioFunction): Integer; stdcall;
  {$EXTERNALSYM gsapi_set_stdio}
  function gsapi_set_poll(pinstance: Pointer; poll_fn: TPollFunction): Integer; stdcall;
  {$EXTERNALSYM gsapi_set_poll}
  function gsapi_set_display_callback(pinstance: Pointer; const callback: TDisplayCallback): Integer; stdcall;
  {$EXTERNALSYM gsapi_set_display_callback}
  function gsapi_init_with_args(pinstance: Pointer; argc: Integer; argv: PPAnsiChar): Integer; stdcall;
  {$EXTERNALSYM gsapi_init_with_args}
  function gsapi_run_string_begin(pinstance: Pointer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_string_begin}
  function gsapi_run_string_continue(pinstance: Pointer; str: PUTF8Char; len: Integer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_string_continue}
  function gsapi_run_string_end(pinstance: Pointer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_string_end}
  function gsapi_run_string_with_length(pinstance: Pointer; str: PUTF8Char; len: Integer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_string_with_length}
  function gsapi_run_string(pinstance: Pointer; str: PUTF8Char; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_string}
  function gsapi_run_file(pinstance: Pointer; file_name: PUTF8Char; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
  {$EXTERNALSYM gsapi_run_file}
  function gsapi_exit(pinstance: Pointer): Integer; stdcall;
  {$EXTERNALSYM gsapi_exit}

implementation

function gsapi_revision; external cGSLibraryFileName name gsapi_revision_name;
function gsapi_new_instance; external cGSLibraryFileName name gsapi_new_instance_name;
procedure gsapi_delete_instance; external cGSLibraryFileName name gsapi_delete_instance_name;
function gsapi_set_arg_encoding; external cGSLibraryFileName name gsapi_set_arg_encoding_name;
function gsapi_set_stdio; external cGSLibraryFileName name gsapi_set_stdio_name;
function gsapi_set_poll; external cGSLibraryFileName name gsapi_set_poll_name;
function gsapi_set_display_callback; external cGSLibraryFileName name gsapi_set_display_callback_name;
function gsapi_init_with_args; external cGSLibraryFileName name gsapi_init_with_args_name;
function gsapi_run_string_begin; external cGSLibraryFileName name gsapi_run_string_begin_name;
function gsapi_run_string_continue; external cGSLibraryFileName name gsapi_run_string_continue_name;
function gsapi_run_string_end; external cGSLibraryFileName name gsapi_run_string_end_name;
function gsapi_run_string_with_length; external cGSLibraryFileName name gsapi_run_string_with_length_name;
function gsapi_run_string; external cGSLibraryFileName name gsapi_run_string_name;
function gsapi_run_file; external cGSLibraryFileName name gsapi_run_file_name;
function gsapi_exit; external cGSLibraryFileName name gsapi_exit_name;

{$REGION 'TGhostScriptApiStatic'}

class procedure TGhostScriptApiStatic.Initialize;
begin
  inherited;
  FCreateNewInstance := gsapi_new_instance;
  FDeleteInstance := gsapi_delete_instance;
  FExit := gsapi_exit;
  FInitWithArgs := gsapi_init_with_args;
  FRevision := gsapi_revision;
  FRunFile := gsapi_run_file;
  FRunString := gsapi_run_string;
  FRunStringBegin := gsapi_run_string_begin;
  FRunStringContinue := gsapi_run_string_continue;
  FRunStringEnd := gsapi_run_string_end;
  FRunStringWithLength := gsapi_run_string_with_length;
  FSetArgsEncoding := gsapi_set_arg_encoding;
  FSetDisplayCallback := gsapi_set_display_callback;
  FSetPoll := gsapi_set_poll;
  FSetStdIO := gsapi_set_stdio;
end;

class procedure TGhostScriptApiStatic.UseAsCurrent;
begin
  FCurrentInstance := Self;
end;

{$ENDREGION}

initialization
  TGhostScriptApiStatic.UseAsCurrent;

end.
