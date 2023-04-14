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
    procedure Button_modifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Open_NextForm(index_role: integer);
    procedure Initialize_UI(); override;
    procedure Update_UI(); override;
  private

  public
    stringGrid_table: TStringGrid;
    //index_descriptionTable: integer;
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
  descrip
end;

procedure TForm_table.FormHide(Sender: TObject);
begin
  FreeAndNil(stringGrid_table);
end;

procedure TForm_table.Button_addClick(Sender: TObject);
begin
  Open_NextForm(0);
end;

procedure TForm_table.Button_modifyClick(Sender: TObject);
begin
  Open_NextForm(1);
end;

procedure TForm_table.FormShow(Sender: TObject);
begin
  Set_Form();
  Update_UI();
  Try_Fill_grid();
end;

procedure TForm_table.open_NextForm(index_role: integer);
var
  next_form: TForm_item;
begin
  next_form:=TForm_item.Create(self);

  //Choose the role of the form item.
  //0 for adding,
  //1 for modifying.
  next_form.index_role:=index_role;

  //next_form.index_descriptionTable:=index_descriptionTable;
  next_form.descriptionTable:=descriptionTable;

  if index_role=0 then
  begin
    next_form.row_contents:=nil;
  end;
  if index_role=1 then
  begin
    next_form.row_contents:=stringGrid_table.Rows[stringGrid_table.Row];
  end;

  next_form.ShowModal();
end;

procedure TForm_table.Set_Form;
begin
  Self.Caption:=unit_datamodule_table.DataModule_table.description_table_list[index_descriptionTable].name;
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
      row_contents:=DataModule_table.description_table_list[index_descriptionTable].name_field.ToStringArray();

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

      currentIndex_fieldId:=DataModule_table.description_table_list[index_descriptionTable].index_field_id;

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

