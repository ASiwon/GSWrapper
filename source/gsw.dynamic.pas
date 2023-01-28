unit gsw.dynamic;

interface

uses
  gsw.api, gsw.common;

type
    /// <summary>
    /// Dynamic linking for GhostScript library.
    /// </summary>
  TGhostScriptApiDynamic = class(TGhostScriptApi)
  strict private
  class var
    FLibraryFileName: String;
    FLibraryHandle: THandle;
  public
    class constructor ClassCreate;
    class destructor ClassDestroy;
    class procedure Finalize; override;
    class procedure Initialize; override;
    class procedure UseAsCurrent;
      /// <summary>
      /// Path to the GhostScript library file.
      /// </summary>
    class property LibraryFileName: String read FLibraryFileName write FLibraryFileName;
      /// <summary>
      /// Handle to the GhostScript library.
      /// </summary>
    class property LibraryHandle: THandle read FLibraryHandle;
  end;

implementation

uses
  System.SysUtils,
  Winapi.Windows;

{$REGION 'TGhostScriptApiDynamic'}

class constructor TGhostScriptApiDynamic.ClassCreate;
begin
  FLibraryFileName := cGSLibraryFileName;
end;

class destructor TGhostScriptApiDynamic.ClassDestroy;
begin
  Finalize;
end;

class procedure TGhostScriptApiDynamic.Finalize;
begin
  inherited;
  if LibraryHandle > 0 then
  begin
    FreeLibrary(LibraryHandle);
    FLibraryHandle := 0;
  end;
end;

class procedure TGhostScriptApiDynamic.Initialize;
begin
  inherited;
  if LibraryHandle > 0 then
    System.Exit;
  FLibraryHandle := LoadLibrary(PChar(LibraryFileName));
  if LibraryHandle = 0 then
    raise Exception.CreateFmt('Unable to load library: %s', [LibraryFileName]);
  FCreateNewInstance := GetProcAddress(LibraryHandle, gsapi_new_instance_name);
  FDeleteInstance := GetProcAddress(LibraryHandle, gsapi_delete_instance_name);
  FExit := GetProcAddress(LibraryHandle, gsapi_exit_name);
  FInitWithArgs := GetProcAddress(LibraryHandle, gsapi_init_with_args_name);
  FRevision := GetProcAddress(LibraryHandle, gsapi_revision_name);
  FRunFile := GetProcAddress(LibraryHandle, gsapi_run_file_name);
  FRunString := GetProcAddress(LibraryHandle, gsapi_run_string_name);
  FRunStringBegin := GetProcAddress(LibraryHandle, gsapi_run_string_begin_name);
  FRunStringContinue := GetProcAddress(LibraryHandle, gsapi_run_string_continue_name);
  FRunStringEnd := GetProcAddress(LibraryHandle, gsapi_run_string_end_name);
  FRunStringWithLength := GetProcAddress(LibraryHandle, gsapi_run_string_with_length_name);
  FSetArgsEncoding := GetProcAddress(LibraryHandle, gsapi_set_arg_encoding_name);
  FSetDisplayCallback := GetProcAddress(LibraryHandle, gsapi_set_display_callback_name);
  FSetPoll := GetProcAddress(LibraryHandle, gsapi_set_poll_name);
  FSetStdIO := GetProcAddress(LibraryHandle, gsapi_set_stdio_name);
end;

class procedure TGhostScriptApiDynamic.UseAsCurrent;
begin
  FCurrentInstance := Self;
end;

{$ENDREGION}

initialization
  TGhostScriptApiDynamic.UseAsCurrent;

end.
