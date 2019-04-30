procedure TCustomSQLDataSet.SetFCommandText(const Value: string);
begin
  CheckInactive;
  {+}
  ClearIndexDefs;
  {+.}
  FCommandText := Value;
  FNativeCommand := '';
end;













type
  TCustomSQLDataSetAccess = class(TCustomSQLDataSet);

procedure TForm1.SQLQueryAfterClose(DataSet: TDataSet);
begin
  //
  // TODO: fix "SqlExpr.pas" for clear cached IndexDefs;
  //
  if DataSet is TCustomSQLDataSet then
    TCustomSQLDataSetAccess(DataSet).ClearIndexDefs;
end;

or
procedure TCustomSQLDataSet.InternalClose;

-or
procedure TSQLQuery.QueryChanged(Sender: TObject);
begin
  if not (csReading in ComponentState) then
  begin
    Close;
    SetPrepared(False);
?    {+}
    ClearIndexDefs;
    {+.}
    if ParamCheck or (csDesigning in ComponentState) then
    begin
      FCommandText := SQL.Text;
      FText := FCommandText;
      SetParamsFromSQL(nil, False);
    end
    else
      FText := SQL.Text;
{$IF DEFINED(CLR)}
    DataEvent(dePropertyChange, nil);
{$ELSE}
    DataEvent(dePropertyChange, 0);
{$IFEND}
  end
  else
    FText := FParams.ParseSQL(SQL.Text, False);
  SetFCommandText(FText);
end;
