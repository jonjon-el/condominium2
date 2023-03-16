unit unit_form_root;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  unit_form_base;

resourcestring
  rstring_ok = 'OK';
  rstring_bad = 'Error';

type

  { TForm_root }

  TForm_root = class(TForm1)
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
    procedure Open_NextForm(newForm: TForm); override;
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
  unit_datamodule_main.DataModule1.Initialize_ini_names();
  unit_datamodule_main.DataModule1.Load_ini();

  //then configure SQLconnector and opens connection.
  unit_datamodule_main.DataModule1.Set_SQLConnector();

  //then connect to the database.
  unit_datamodule_main.DataModule1.Connect_database(msg);
  StatusBar1.SimpleText:=msg;
end;

procedure TForm_root.FormDestroy(Sender: TObject);
var
  msg: string;
begin
  unit_datamodule_main.DataModule1.Save_ini();
  unit_datamodule_main.DataModule1.Disconnect_database(msg);
  StatusBar1.SimpleText:=msg;
end;

procedure TForm_root.open_NextForm(newForm: TForm);
var
  resultOfForm: TModalResult;
begin
  self.Hide();
  resultOfForm:=newForm.ShowModal();
  FreeAndNil(newForm);
  if resultOfForm=mrClose then
  begin
    StatusBar1.SimpleText:=rstring_ok;
  end
  else
  begin
    StatusBar1.SimpleText:=rstring_bad;
  end;
  Self.Show();
end;

procedure TForm_root.Button1Click(Sender: TObject);
var
  newForm: TForm1;
begin
  if RadioButton2.Checked then
  begin
    newForm:=unit_form_selection.TForm_selection.Create(nil);
  end
  else
  begin
    StatusBar1.SimpleText:=rstring_bad;
  end;
  Open_NextForm(newForm);
end;

end.

