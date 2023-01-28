// Copyright (c) 2001-2002 Alessandro Briosi
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//
// This software was written by Alessandro Briosi with the
// assistance of Russell Lang, as an example of how the
// Ghostscript DLL may be used Delphi.
//

unit gsapi;

interface

uses
  Windows;

// {$HPPEMIT '#include <iminst.h>'}

const
  gsdll32 = 'gsdll32.dll';

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

type
  TGSAPIrevision = record
    product: PAnsiChar;
    copyright: PAnsiChar;
    revision: Longint;
    revisiondat: Longint;
  end;

  TStdioFunction = function(caller_handle: Pointer; buf: PAnsiChar; len: Integer): Integer; stdcall;
  TPollFunction = function(caller_handle: Pointer): Integer; stdcall;

  TDisplayEvent = function(handle: Pointer; device: Pointer): Integer; cdecl;
  TDisplayPreResizeEvent = function(handle: Pointer; device: Pointer;
         width: Integer; height: Integer; raster: Integer; format: UINT): Integer; cdecl;
  TDisplayResizeEvent = function(handle: Pointer; device: Pointer;
         width: Integer; height: Integer; raster: Integer; format: UINT; pimage: PAnsiChar): Integer; cdecl;
  TDisplayPageEvent = function(handle: Pointer; device: Pointer; copies: Integer; flush: Integer): Integer; cdecl;
  TDisplayUpdateEvent = function(handle: Pointer; device: Pointer; x: Integer; y: Integer; w: Integer; h: Integer): Integer; cdecl;
  TDisplayMemAlloc = procedure(handle: Pointer; device: Pointer; size: ulong); cdecl;
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

function gsapi_revision(var pr: TGSAPIrevision; len: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_revision}
function gsapi_new_instance(var pinstance: Pointer; caller_handle: Pointer): Integer; stdcall;
{$EXTERNALSYM gsapi_new_instance}
procedure gsapi_delete_instance(pinstance: Pointer); stdcall;
{$EXTERNALSYM gsapi_delete_instance}
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
function gsapi_run_string_continue(pinstance: Pointer; str: PAnsiChar; len: Integer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_run_string_continue}
function gsapi_run_string_end(pinstance: Pointer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_run_string_end}
function gsapi_run_string_with_length(pinstance: Pointer; str: PAnsiChar; len: Integer; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_run_string_with_length}
function gsapi_run_string(pinstance: Pointer; str: PAnsiChar; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_run_string}
function gsapi_run_file(pinstance: Pointer; file_name: PAnsiChar; user_errors: Integer; var pexit_code: Integer): Integer; stdcall;
{$EXTERNALSYM gsapi_run_file}
function gsapi_exit(pinstance: Pointer): Integer; stdcall;
{$EXTERNALSYM gsapi_exit}

implementation

function gsapi_revision; external gsdll32 name 'gsapi_revision';
function gsapi_new_instance; external gsdll32 name 'gsapi_new_instance';
procedure gsapi_delete_instance; external gsdll32 name 'gsapi_delete_instance';
function gsapi_set_stdio; external gsdll32 name 'gsapi_set_stdio';
function gsapi_set_poll; external gsdll32 name 'gsapi_set_poll';
function gsapi_set_display_callback; external gsdll32 name 'gsapi_set_display_callback';
function gsapi_init_with_args; external gsdll32 name 'gsapi_init_with_args';
function gsapi_run_string_begin; external gsdll32 name 'gsapi_run_string_begin';
function gsapi_run_string_continue; external gsdll32 name 'gsapi_run_string_continue';
function gsapi_run_string_end; external gsdll32 name 'gsapi_run_string_end';
function gsapi_run_string_with_length; external gsdll32 name 'gsapi_run_string_with_length';
function gsapi_run_string; external gsdll32 name 'gsapi_run_string';
function gsapi_run_file; external gsdll32 name 'gsapi_run_file';
function gsapi_exit; external gsdll32 name 'gsapi_exit';

end.
