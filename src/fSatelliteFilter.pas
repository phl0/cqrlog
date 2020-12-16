(*
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License.        *
 *                                                                         *
 ***************************************************************************
*)


unit fSatelliteFilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, MaskEdit, lcltype, ExtDlgs, EditBtn, inifiles, strutils;

type

  { TfrmSatelliteFilter }

  TfrmSatelliteFilter = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    cmbSatelliteName: TComboBox;
    gbContName: TGroupBox;
    Label1: TLabel;
    procedure btClearClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  public
    tmp : String;
  end;
var
  frmSatelliteFilter: TfrmSatelliteFilter;

implementation
{$R *.lfm}

{ TfrmSatelliteFilter }
uses dData, dUtils, dSatellite;

procedure TfrmSatelliteFilter.btnOKClick(Sender: TObject);
begin
  tmp := 'SELECT * FROM view_cqrlog_main_by_qsodate WHERE `prop_mode` = "SAT"';
  if (cmbSatelliteName.ItemIndex <> 0) then
  begin
     tmp := tmp + ' AND `satellite` = "' + dmSatellite.GetSatShortName(cmbSatelliteName.Text) + '"';
  end;
  if (tmp <> '') then
  begin
    if dmData.DebugLevel>=1 then Writeln(tmp);
    dmData.qCQRLOG.Close;
    dmData.qCQRLOG.SQL.Text := tmp;
    if dmData.DebugLevel >=1 then
      Writeln(tmp);
    if dmData.trCQRLOG.Active then
      dmData.trCQRLOG.Rollback;
    dmData.trCQRLOG.StartTransaction;
    dmData.qCQRLOG.Open;
    dmData.qCQRLOG.Last
  end;
  ModalResult := mrOK;
end;

procedure TfrmSatelliteFilter.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmSatelliteFilter.FormCreate(Sender: TObject);
begin
  cmbSatelliteName.Clear;
  dmSatellite.SetListOfSatellites(cmbSatelliteName);
end;

procedure TfrmSatelliteFilter.FormShow(Sender: TObject);

begin
  dmUtils.LoadFontSettings(self);
end;

procedure TfrmSatelliteFilter.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    btnOK.Click;
    Key := 0
  end
end;

procedure TfrmSatelliteFilter.btnHelpClick(Sender: TObject);
begin
  ShowHelp
end;

procedure TfrmSatelliteFilter.btClearClick(Sender: TObject);
begin
      FormShow(nil);
end;

end.

