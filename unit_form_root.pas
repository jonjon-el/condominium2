unit unit_form_root;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  unit_form_base;

//resourcestring
//  rstring_ok = 'OK';
//  rstring_bad = 'Error';

type

  { TForm_root }

  TForm_root = class(TForm_base)
    Button1: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Open_NextForm();
  private

  public

  end;

var
  Form_root: TForm_root;

implementation

uses
  unit_datamodule_main, unit_form_selection;

{$R *.lfm}

{ TForm_root }

procedure TForm_root.FormCreate(Sender: TObject);
var
  msg: string;
begin
  StatusBar1.SimpleText:=rstring_ok;

  //first load configuration from ini.
  DataModule_main.Initialize_ini_names();
  DataModule_main.Load_ini();

  //then configure SQLconnector and opens connection.
  DataModule_main.Set_SQLConnector();

  //then connect to the database.
  DataModule_main.Connect_database(msg);
  StatusBar1.SimpleText:=msg;
end;

procedure TForm_root.FormDestroy(Sender: TObject);
var
  msg: string;
begin
  DataModule_main.Save_ini();
  DataModule_main.Disconnect_database(msg);
  StatusBar1.SimpleText:=msg;
end;

procedure TForm_root.open_NextForm();
var
  next_form: TForm_selection;
  form_result: TModalResult;
begin
  next_form:=TForm_selection.Create(self);
  //Hide();
  form_result:=next_form.ShowModal();
  if form_result=mrClose then
  begin
    StatusBar1.SimpleText:=rstring_ok;
  end
  else
  begin

  end;
end;

procedure TForm_root.Button1Click(Sender: TObject);
begin
  Open_NextForm();
end;

end.

