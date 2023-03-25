unit unit_form_selection;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  unit_form_base;

resourcestring
  rstring_persons = 'Persons';
  rstring_properties = 'Properties';
  rstring_propietaries = 'Propietaries';
  rstring_debts = 'Debts';
  rstring_payments = 'Payments';
  rstring_contractedDebts = 'Contracted debts';

  rstring_ok = 'Operation completed successfully';
  rstring_cancel = 'Operation cancelled';

type

  { TForm_selection }

  TForm_selection = class(TForm1)
    button_back: TButton;
    button_next: TButton;
    ListBox1: TListBox;
    procedure button_backClick(Sender: TObject);
    procedure button_nextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Open_NextForm(newForm: TForm); override;
  private

  public

  end;

var
  Form_selection: TForm_selection;

implementation

uses
  unit_form_table, unit_datamodule_table;

procedure TForm_selection.Open_NextForm(newForm: TForm);
var
  resultOfForm: TModalResult;
begin
  self.Hide();
  resultOfForm:=newForm.ShowModal();
  //FreeAndNil(newForm);
  if resultOfForm=mrClose then
  begin
    StatusBar1.SimpleText:=rstring_ok;
  end
  else
  begin
    StatusBar1.SimpleText:=rstring_cancel;
  end;
  Self.Show();
end;

procedure TForm_selection.button_backClick(Sender: TObject);
begin
 ModalResult:=mrRetry;
end;

procedure TForm_selection.button_nextClick(Sender: TObject);
var
  newForm: TForm_table;
  //item: integer;
begin
  newForm:=TForm_table.Create(nil);
  newForm.role:=ListBox1.ItemIndex;;
  Open_NextForm(newForm);
  FreeAndNil(newForm);
end;

procedure TForm_selection.FormCreate(Sender: TObject);
begin
  ListBox1.Items.Add(rstring_persons);
  ListBox1.Items.Add(rstring_properties);
  ListBox1.Items.Add(rstring_propietaries);
  ListBox1.Items.Add(rstring_debts);
  ListBox1.Items.Add(rstring_payments);
  ListBox1.Items.Add(rstring_contractedDebts);
  ListBox1.ItemIndex:=0;
end;

{$R *.lfm}

end.

