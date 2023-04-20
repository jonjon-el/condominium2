unit unit_form_table;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, unit_form_base, unit_datamodule_table;

type

  { TForm_table }

  TForm_table = class(TForm_base)
    Button_add: TButton;
    Button_back: TButton;
    Button_delete: TButton;
    Button_modify: TButton;
    Panel_title: TPanel;
    procedure Button_addClick(Sender: TObject);
    procedure Button_deleteClick(Sender: TObject);
    procedure Button_modifyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Open_NextForm(index_role: integer);


  private
    procedure Initialize();
    procedure Initialize_UI();
    procedure Update_UI();
  public
    index_descriptionTable: integer;
    stringGrid_table: TStringGrid;
    descriptionTable: unit_datamodule_table.TDescription_table;
    procedure Try_Fill_grid();
  end;

var
  Form_table: TForm_table;

implementation

uses
  unit_datamodule_main, unit_form_item, DB;

{$R *.lfm}

{ TForm_table }

procedure TForm_table.FormCreate(Sender: TObject);
begin

end;

procedure TForm_table.FormDeactivate(Sender: TObject);
begin
  //FreeAndNil(stringGrid_table);
end;

procedure TForm_table.FormHide(Sender: TObject);
begin
  FreeAndNil(stringGrid_table);
end;

procedure TForm_table.Button_addClick(Sender: TObject);
begin
  Open_NextForm(0);
end;

procedure TForm_table.Button_deleteClick(Sender: TObject);
var
  index_field_id: integer;
  index_row: integer;
  name_field_id: string;
  debug_str: string;
begin
  unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_delete;

  index_field_id:=descriptionTable.index_field_id;
  index_row:=stringGrid_table.Row;
  name_field_id:=descriptionTable.name_field[index_field_id];

  debug_str:=stringGrid_table.Cells[index_field_id, index_row];
  unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(name_field_id).AsInteger:=StrToInt(stringGrid_table.Cells[index_field_id, index_row]);

  try
    unit_datamodule_table.DataModule_table.SQLQuery1.ExecSQL();

    unit_datamodule_main.DataModule_main.SQLTransaction1.Commit();
  except
    on E: EDatabaseError do
    begin
      unit_datamodule_main.DataModule_main.SQLTransaction1.Rollback();
    end;
  end;
  FreeAndNil(stringGrid_table);
  Update_UI();
  Try_Fill_grid();
end;

procedure TForm_table.Button_modifyClick(Sender: TObject);
begin
  Open_NextForm(1);
end;

procedure TForm_table.FormActivate(Sender: TObject);
begin
end;

procedure TForm_table.FormShow(Sender: TObject);
begin
  descriptionTable:=unit_datamodule_table.DataModule_table.description_table_list[index_descriptionTable];
  Self.Caption:=descriptionTable.name;
  Update_UI();
  Try_Fill_grid();
end;

procedure TForm_table.Open_NextForm(index_role: integer);
var
  next_form: TForm_item;
  debug_str: string;
  row_buffer: TStringList;
  form_result: TModalResult;
  i: integer;
begin
  next_form:=TForm_item.Create(self);

  row_buffer:=TStringList.Create();

  next_form.descriptionTable:=descriptionTable;
  next_form.index_role:=index_role;
  if next_form.index_role=0 then
  begin
    next_form.row_contents:=TStringList.Create();
    i:=0;
    while i<descriptionTable.name_field.Count do
    begin
      row_buffer.Add('');
      debug_str:=row_buffer[i];
      inc(i);
    end;
  end;
  if next_form.index_role=1 then
  begin
    row_buffer.Assign(stringGrid_table.Rows[stringGrid_table.Row]);
    //debug_str:=next_form.row_contents[1];
  end;
  next_form.row_contents:=row_buffer;
  Hide();
  form_result:=next_form.ShowModal();
  FreeAndNil(next_form);
  FreeAndNil(row_buffer);
  Show();
  if form_result=mrOK then
  begin
    StatusBar1.SimpleText:=rstring_ok;
  end
  else
  begin
    StatusBar1.SimpleText:='Something wrong';
  end;

end;

procedure TForm_table.Initialize();
begin

end;

procedure TForm_table.Initialize_UI;
begin

end;

procedure TForm_table.Update_UI;
begin
  //Create stringGrid.
  stringGrid_table:=TStringGrid.Create(nil);
  stringGrid_table.Parent:=Self;
  stringGrid_table.Name:='StringGrid_table';
  stringGrid_table.Align:=TAlign.alClient;
  stringGrid_table.FixedCols:=0;
  stringGrid_table.FixedRows:=1;
  stringGrid_table.RowCount:=1;
  stringGrid_table.Clear();
  stringGrid_table.Show();
end;

procedure TForm_table.Try_Fill_grid;
var
  i: integer;
  index_col: integer;
  row_contents: array of string;
  column: TGridColumn;
  currentIndex_fieldId: integer;
begin
  DataModule_table.Pick_table(index_descriptionTable);
  try
    try
      DataModule_table.SQLQuery1.Open();
      //Setting row title.
      row_contents:=descriptionTable.name_field.ToStringArray();

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
      while not DataModule_table.SQLQuery1.EOF do
      begin
        index_col:=0;
        while index_col<Length(row_contents) do
        begin
          row_contents[index_col]:=DataModule_table.SQLQuery1.Fields[index_col].AsString;
          inc(index_col);
        end;
        StringGrid_table.InsertRowWithValues(i, row_contents);
        inc(i);
        DataModule_table.SQLQuery1.Next();
      end;

      currentIndex_fieldId:=descriptionTable.index_field_id;

      //If query has column ID then mark as non required and hide it.
      if currentIndex_fieldId >= 0 then
      begin
        DataModule_table.SQLQuery1.Fields[currentIndex_fieldId].Required:=False;
        StringGrid_table.Columns[currentIndex_fieldId].Visible:=False;
      end;

      DataModule_main.SQLTransaction1.Commit();//Closing transaction.

    except
      on E: EDatabaseError do
      begin
        StatusBar1.SimpleText:=E.Message;
        if DataModule_table.SQLQuery1.Active then
        begin
          DataModule_main.SQLTransaction1.Rollback();
        end;
      end;
    end;
  finally
    DataModule_table.SQLQuery1.Close();
  end;
end;

end.

