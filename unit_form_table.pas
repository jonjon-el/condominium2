unit unit_form_table;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, unit_form_base;

type

  { TForm_table }

  TForm_table = class(TForm1)
    Button_add: TButton;
    Button_back: TButton;
    Button_delete: TButton;
    Button_modify: TButton;
    Panel_title: TPanel;
    StringGrid_table: TStringGrid;
    procedure Button_addClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Open_NextForm(newForm: TForm); override;
    procedure Set_Form(); override;
  private

  public
    role: integer;
    procedure Try_Fill_grid();
  end;

var
  Form_table: TForm_table;

implementation

uses
  unit_datamodule_table, unit_datamodule_main, unit_form_item, DB;

{$R *.lfm}

{ TForm_table }

procedure TForm_table.FormCreate(Sender: TObject);
begin

end;

procedure TForm_table.Button_addClick(Sender: TObject);
var
  newForm: TForm_item;
  //item: integer;
begin
  newForm:=TForm_item.Create(nil);
  //newForm.role:=ListBox1.ItemIndex;
  Open_NextForm(newForm);
  FreeAndNil(newForm);
end;

procedure TForm_table.FormShow(Sender: TObject);
begin
  Set_Form();
  Try_Fill_grid();
end;

procedure TForm_table.Open_NextForm(newForm: TForm);
var
  resultOfForm: TModalResult;
  form_item: unit_form_item.TForm_item;
begin
  if newForm is TForm_item then
  begin
    form_item:=newForm as TForm_item;
    form_item.description_table:=unit_datamodule_table.DataModule2.description_table_list[role];
    self.Hide();
    resultOfForm:=newForm.ShowModal();
    if resultOfForm=mrClose then
    begin
      StatusBar1.SimpleText:=rstring_ok;
    end
    else
    begin
      StatusBar1.SimpleText:=rstring_cancel;
    end;
    Self.Show();
  end
  else
  begin
    StatusBar1.SimpleText:='ERROR';
  end;

end;

procedure TForm_table.Set_Form;
begin
  Self.Caption:=unit_datamodule_table.DataModule2.description_table_list[role].name;
end;

procedure TForm_table.Try_Fill_grid;
var
  value: string;
  i: integer;
  index_col: integer;
  row_contents: array of string;
  column: TGridColumn;
  field_name: string;
  debug_int: integer;
begin
  StringGrid_table.Clear();

  unit_datamodule_table.DataModule2.Pick_table(role);

  try
    try
      unit_datamodule_table.DataModule2.SQLQuery1.Open();

      //Setting row title.
      row_contents:=unit_datamodule_table.DataModule2.description_table_list[role].name_field.ToStringArray();

      //adding columns.
      StringGrid_table.Columns.Clear();
      index_col:=0;
      while index_col<Length(row_contents) do
      begin
        column:=StringGrid_table.Columns.Add();
        column.Title.Caption:=row_contents[index_col];
        inc(index_col);
      end;

      //Adding contents.
      i:=1;//Number of the starting row.
      while not unit_datamodule_table.DataModule2.SQLQuery1.EOF do
      begin
        index_col:=0;
        while index_col<Length(row_contents) do
        begin
          row_contents[index_col]:=unit_datamodule_table.DataModule2.SQLQuery1.Fields[index_col].AsString;
          inc(index_col);
        end;
        StringGrid_table.InsertRowWithValues(i, row_contents);
        inc(i);
        unit_datamodule_table.DataModule2.SQLQuery1.Next();
      end;

      field_name:=unit_datamodule_table.DataModule2.description_table_list[role].field_id;

      //If query has column ID then mark as non required and hide it.
      debug_int:=CompareStr(field_name, 'id');
      if CompareStr(field_name, 'id')=0 then
      begin
        unit_datamodule_table.DataModule2.SQLQuery1.FieldByName(field_name).Required:=False;
        StringGrid_table.Columns[0].Visible:=False;
      end;

      unit_datamodule_main.DataModule1.SQLTransaction1.Commit();//Closing transaction.

    except
      on E: EDatabaseError do
      begin
        StatusBar1.SimpleText:=E.Message;
        if unit_datamodule_table.DataModule2.SQLQuery1.Active then
        begin
          unit_datamodule_main.DataModule1.SQLTransaction1.Rollback();
        end;
      end;
    end;
  finally
    unit_datamodule_table.DataModule2.SQLQuery1.Close();
  end;
end;

end.

