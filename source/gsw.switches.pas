unit gsw.switches;

interface

{$I DelphiVersions.inc}

uses
  System.Rtti;

type
  TStringValueAttribute = class(TCustomAttribute)
  strict private
    FValue: String;
  public
    constructor Create(const AValue: String);
    property Value: String read FValue;
  end;

  StringIndexValueAttribute = class(TCustomAttribute)
  strict private
    FIndex: Integer;
    FValue: String;
  public
    constructor Create(const AIndex: Integer; const AValue: String);
    property Index: Integer read FIndex;
    property Value: String read FValue;
  end;

  SwitchAttribute = class(TStringValueAttribute);

  SwitchValueAttribute = class(TStringValueAttribute);

  SwitchIndexValueAttribute = class(StringIndexValueAttribute);

    /// <summary>
    /// Record which allows to read particular values from set of type.
    /// </summary>
  TSetData = record
    Data: array [0..3] of UInt64;
      /// <summary>
      /// Function returns bit value for the index specified in AIndex argument.
      /// </summary>
    function Bit(const AIndex: Byte): Boolean;
  end;

    /// <summary>
    /// Class to prepare arguments array using attributes.
    /// </summary>
  TSwitchesValues = class
  strict private
    class procedure ReadFromFields(const AInstance: TObject; const AType: TRttiType; out AParams: TArray<String>); static;
    class procedure ReadFromProperties(const AInstance: TObject; const AType: TRttiType; out AParams: TArray<String>);
      static;
    class function ReadItem(const AItem: TRttiMember; const AItemType: TRttiType; const AValue: TValue; out AParamsArray:
      TArray<String>): Boolean; static;
    class function ReadItemValue(const AItemType: TRttiType; const AValue: TValue; out ASwitchValues: TArray<String>):
      Boolean; static;
  public
    class function Generate(const AInstance: TObject): TArray<String>; static;
  end;

{$IFNDEF DELPHI11_Alexandria}
  TCustomAttributeClass = class of TCustomAttribute;

  TRttiObjectHelper = class helper for TRttiObject
  public
    function GetAttribute(AAttrClass: TCustomAttributeClass): TCustomAttribute; overload;
    function GetAttribute<T: TCustomAttribute>: T; overload; inline;
  end;
{$ENDIF}

implementation

uses
  {$IFNDEF DELPHI11_Alexandria}
  System.TypInfo,
  {$ENDIF}
  System.SysUtils, System.Generics.Collections;



{$REGION 'TStringValueAttribute'}

constructor TStringValueAttribute.Create(const AValue: String);
begin
  inherited Create;
  FValue := AValue;
end;

{$ENDREGION}

{$REGION 'StringIndexValueAttribute'}

constructor StringIndexValueAttribute.Create(const AIndex: Integer; const AValue: String);
begin
  inherited Create;
  FIndex := AIndex;
  FValue := AValue;
end;

{$ENDREGION}

{$REGION 'TSetData'}

function TSetData.Bit(const AIndex: Byte): Boolean;
begin
  Result := Self.Data[AIndex shr 3] and UInt64(1 shl (AIndex and $07)) > 0;
end;

{$ENDREGION}

{$REGION 'TSwitchesValues'}

class function TSwitchesValues.Generate(const AInstance: TObject): TArray<String>;
var
  lContext: TRttiContext;
  lInstanceType: TRttiType;
  lParamsArray: TArray<String>;
  lParamsList: TList<String>;
begin
  Assert(AInstance <> nil);
  lContext := TRttiContext.Create;
  lInstanceType := lContext.GetType(AInstance.ClassType);
  lParamsList := TList<String>.Create;
  try
    ReadFromProperties(AInstance, lInstanceType, lParamsArray);
    lParamsList.AddRange(lParamsArray);
    ReadFromFields(AInstance, lInstanceType, lParamsArray);
    lParamsList.AddRange(lParamsArray);
    Result := lParamsList.ToArray;
  finally
    lParamsList.Free;
  end;
end;

class procedure TSwitchesValues.ReadFromFields(const AInstance: TObject; const AType: TRttiType; out AParams:
    TArray<String>);
var
  i: Integer;
  lItems: TArray<TRttiField>;
  lParamsArray: TArray<String>;
  lParamsList: TList<String>;
begin
  lItems := AType.GetFields;
  lParamsList := TList<String>.Create;
  try
    lParamsList.Capacity := Length(lItems);
    for i := Low(lItems) to High(lItems) do
    begin
      if not ReadItem(lItems[i], lItems[i].FieldType, lItems[i].GetValue(AInstance), lParamsArray) then
        Continue;
      lParamsList.AddRange(lParamsArray);
    end;
    AParams := lParamsList.ToArray;
  finally
    lParamsList.Free;
  end;
end;

class procedure TSwitchesValues.ReadFromProperties(const AInstance: TObject; const AType: TRttiType; out AParams:
    TArray<String>);
var
  i: Integer;
  lItems: TArray<TRttiProperty>;
  lParamsArray: TArray<String>;
  lParamsList: TList<String>;
begin
  lItems := AType.GetProperties;
  lParamsList := TList<String>.Create;
  try
    lParamsList.Capacity := Length(lItems);
    for i := High(lItems) downto Low(lItems) do
    begin
      if not ReadItem(lItems[i], lItems[i].PropertyType, lItems[i].GetValue(AInstance), lParamsArray) then
        Continue;
      lParamsList.AddRange(lParamsArray);
    end;
    AParams := lParamsList.ToArray;
  finally
    lParamsList.Free;
  end;
end;

class function TSwitchesValues.ReadItem(const AItem: TRttiMember; const AItemType: TRttiType; const AValue: TValue;
    out AParamsArray: TArray<String>): Boolean;
var
  i: Integer;
  lParamTempl: String;
  lAttribute: SwitchAttribute;
begin
  lAttribute := AItem.GetAttribute<SwitchAttribute>;
  if lAttribute = nil then
    Exit(False);
  Result := True;
  lParamTempl := lAttribute.Value;
  if (Length(lParamTempl) > 0) and (lParamTempl[1] <> '-') then
    lParamTempl := '-' + lParamTempl;
  if Pos('%', lParamTempl) = 0 then
  begin
    SetLength(AParamsArray, 1);
    AParamsArray[0] := lParamTempl;
    Exit(True);
  end;
    // reading data from item
  if not ReadItemValue(AItemType, AValue, AParamsArray) then
    Exit;
  for i := Low(AParamsArray) to High(AParamsArray) do
    AParamsArray[i] := Format(lParamTempl, [AParamsArray[i]]);
  Result := True;
end;

class function TSwitchesValues.ReadItemValue(const AItemType: TRttiType; const AValue: TValue; out ASwitchValues:
    TArray<String>): Boolean;
var
  i, j: Integer;
  k: Int64;
  lAttributes: TArray<TCustomAttribute>;
  lIndexValue: SwitchIndexValueAttribute;
  lOrdinalType: TRttiOrdinalType;
  lSetType: TRttiSetType;
  lSetValue: TSetData;
  lTextArray: TArray<String>;
begin
  case AItemType.TypeKind of
    tkEnumeration:
    begin
      lOrdinalType := AItemType.AsOrdinal;
      lAttributes := lOrdinalType.GetAttributes;
      if not AValue.TryAsOrdinal(k) then
        Exit(False);
      for i := Low(lAttributes) to High(lAttributes) do
        if lAttributes[i] is SwitchIndexValueAttribute then
        begin
          lIndexValue := SwitchIndexValueAttribute(lAttributes[i]);
          if lIndexValue.Index = k then
          begin
            SetLength(ASwitchValues, 1);
            ASwitchValues[0] := lIndexValue.Value;
            Exit(True);
          end;
        end;
    end;
    tkSet:
    begin
      AValue.ExtractRawData(@lSetValue);
      lSetType := AItemType.AsSet;
      lOrdinalType := lSetType.ElementType.AsOrdinal;
      SetLength(lTextArray, lOrdinalType.MaxValue - lOrdinalType.MinValue + 1);
      lAttributes := lOrdinalType.GetAttributes;
      for i := Low(lAttributes) to High(lAttributes) do
        if lAttributes[i] is SwitchIndexValueAttribute then
        begin
          lIndexValue := SwitchIndexValueAttribute(lAttributes[i]);
          lTextArray[lIndexValue.Index] := lIndexValue.Value;
        end;
      SetLength(ASwitchValues, Length(lTextArray));
      j := 0;
      for i := lOrdinalType.MinValue to lOrdinalType.MaxValue do
      begin
        if lSetValue.Bit(i) and (lTextArray[i] <> '') then
        begin
          ASwitchValues[j] := lTextArray[i];
          Inc(j);
        end;
      end;
      ASwitchValues := Copy(ASwitchValues, 0, j);
      Exit(j > 0);
    end
    else
    begin
      SetLength(ASwitchValues, 1);
      ASwitchValues[0] := AValue.ToString;
      Exit(True);
    end;
  end;
  Result := False;
end;

{$ENDREGION}

{$IFNDEF DELPHI11_Alexandria}

{$REGION 'TRttiObjectHelper'}

function TRttiObjectHelper.GetAttribute(AAttrClass: TCustomAttributeClass): TCustomAttribute;
var
  LAttr: TCustomAttribute;
begin
  for LAttr in GetAttributes do
    if LAttr is AAttrClass then
      Exit(LAttr);
  Result := nil;
end;

function TRttiObjectHelper.GetAttribute<T>: T;
begin
  Result := T(GetAttribute(T));
end;

{$ENDREGION}

{$ENDIF}

end.
