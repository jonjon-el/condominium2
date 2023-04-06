program condominium2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unit_form_base, unit_form_root, unit_form_table, unit_datamodule_main,
  unit_datamodule_table, unit_form_selection, unit_form_item;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TDataModule_main, DataModule_main);
  Application.CreateForm(TDataModule_table, DataModule_table);
  Application.CreateForm(TForm_root, Form_root);
  Application.Run;
end.

