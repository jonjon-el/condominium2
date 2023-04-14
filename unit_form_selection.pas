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

  TForm_selection = class(TForm_base)
    button_back: TButton;
    button_next: TButton;
    ListBox1: TListBox;
    procedure button_backClick(Sender: TObject);
    procedure button_nextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Initialize_UI(); override;
    procedure Open_NextForm();
  private

  public

  end;

var
  Form_selection: TForm_selection;

implementation

uses
  unit_form_table;

procedure TForm_selection.Open_NextForm;
var
  next_form: TForm_table;
begin
  next_form:=TForm_table.Create(self);
  next_form.index_descriptionTable:=ListBox1.ItemIndex;
  next_form.ShowModal();
end;

procedure TForm_selection.button_backClick(Sender: TObject);
begin
 ModalResult:=mrRetry;
end;

procedure TForm_selection.button_nextClick(Sender: TObject);
begin
  Open_NextForm();
end;

procedure TForm_selection.FormCreate(Sender: TObject);
begin
  Set_Form();
end;

procedure TForm_selection.Set_Form;
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

