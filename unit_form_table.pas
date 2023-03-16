unit unit_form_table;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, unit_form_base;

//resourcestring
//  rstring_grid_person_id = 'ID';
//  rstring_grid_person_nic = 'NIC';
//  rstring_grid_person_firstname = 'Firstname';
//  rstring_grid_person_lastname = 'Lastname';
//  rstring_grid_person_birthday = 'Birthday';

type

  { TForm_table }

  TForm_table = class(TForm1)
    Button_add: TButton;
    Button_back: TButton;
    Button_delete: TButton;
    Button_modify: TButton;
    Panel_title: TPanel;
    StringGrid_table: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Open_NextForm(newForm: TForm); override;
    procedure Set_Form();
  private

  public
    role: integer;
    procedure Try_Fill_grid();
    //procedure Config_grid();
  end;

var
  Form_table: TForm_table;

implementation

uses
  unit_datamodule_table, unit_datamodule_main, DB;

{$R *.lfm}

{ TForm_table }

procedure TForm_table.FormCreate(Sender: TObject);
begin

end;

procedure TForm_table.FormShow(Sender: TObject);
begin
  Set_Form();
  Try_Fill_grid();
end;

procedure TForm_table.Open_NextForm(newForm: TForm);
begin

end;

procedure TForm_table.Set_Form;
var
  debug: string;
begin
  debug:=unit_datamodule_table.DataModule2.description_table_list[role].name;
  Self.Caption:=unit_datamodule_table.DataModule2.description_table_list[role].name;
end;

procedure TForm_table.Try_Fill_grid;
var
  count_cols: integer;
  value: string;
  i: integer;
  index_col: integer;
  row_contents: array of string;
  column: TGridColumn;
  debug_columns: TGridColumns;
  debug_rows: TStrings;

  debug_str: string;
begin
  StringGrid_table.Clear();
  unit_datamodule_table.DataModule2.Pick_table(role);

  try
    unit_datamodule_table.DataModule2.SQLQuery1.Open();
    count_cols:=unit_datamodule_table.DataModule2.SQLQuery1.FieldCount;

    //adding columns.
    //Setting row title for persons.
    row_contents:=unit_datamodule_table.DataModule2.description_table_list[role].name_field.ToStringArray();

    index_col:=0;
    while index_col<Length(row_contents) do
    begin
      column:=StringGrid_table.Columns.Add();
      column.Title.Caption:=row_contents[index_col];
      inc(index_col);
    end;

    //StringGrid_table.InsertRowWithValues(0, row_contents);

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

    unit_datamodule_main.DataModule1.SQLTransaction1.Commit();

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

  //Hiding invisible columns from the Query in the StringGrid.
  if unit_datamodule_table.DataModule2.description_table_list[role].has_ID then
  begin
    StringGrid_table.Columns[0].Visible:=False;
  end;

end;

end.

