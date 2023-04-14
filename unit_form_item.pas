unit unit_form_item;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  unit_form_base, unit_datamodule_table;

type

  { TForm_item }

  TForm_item = class(TForm_base)
    Button_ok: TButton;
    Button_cancel: TButton;
    ScrollBox1: TScrollBox;
    procedure Button_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Initialize(params: array of TObject); override;
  private

  public
    //index_descriptionTable: integer;
    descriptionTable: unit_datamodule_table.TDescription_table;
    index_role: integer;
    row_contents: TStrings;
    procedure Save();
  end;

var
  Form_item: TForm_item;

implementation

uses
  unit_datamodule_main, unit_datamodule_table;

{$R *.lfm}

{ TForm_item }

procedure TForm_item.Initialize(params: array of TObject);
var
  number_columns: integer;
  //descriptionTable: TDescription_table;

  control: TLabeledEdit;
  i: integer;

  top_previous: integer=0;
  height_previous: integer=0;

  border_vertical: integer=30;
  width_calculated: integer;
  border_right: integer=80;
begin
  descriptionTable:=unit_datamodule_table.DataModule_table.description_table_list[index_descriptionTable];

  //Choosing the proper SQL statement according to the role.
  if index_role=0 then
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_insert;
  end;
  if index_role=1 then
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_modify;
  end;



  number_columns:=descriptionTable.name_field.Count;

  i:=0;

  width_calculated:=ScrollBox1.Width;
  while i<number_columns do
  begin
    if i<>descriptionTable.index_field_id then
    begin
      control:=TLabeledEdit.Create(ScrollBox1);
      control.Parent:=ScrollBox1;

      //Setting position and size.
      control.top:=top_previous+height_previous+border_vertical;
      control.left:=20;
      control.width:=width_calculated-border_right;

      //Storing previous control position and size.
      top_previous:=control.Top;
      height_previous:=control.Height;

      control.Anchors:=[TAnchorKind.akTop, TAnchorKind.akLeft];

      //Setting label and caption.
      control.EditLabel.Caption:=descriptionTable.name_field[i];

      //Choosing whether display empty fields or not according to the role of inserting or modifying.
      if row_contents=nil then
      begin
        control.Text:='';
      end
      else
      begin
        control.Text:=row_contents[i];
      end;
    end;
    inc(i);
  end;
end;

procedure TForm_item.Save;
var
  msg: string;
  i: integer;
  descriptionTable: TDescription_table;
begin
  descriptionTable:=unit_datamodule_table.DataModule_table.description_table_list[index_descriptionTable];
  try

  i:=0;
  while i<descriptionTable.name_field.Count do
  begin
    if descriptionTable.dataType_field[i]='string' then
    begin
      unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsString:=;
    end;
    if descriptionTable.dataType_field[i]='integer' then
    begin

    end;
    if descriptionTable.dataType_field[i]='float' then
    begin

    end;
    if descriptionTable.dataType_field[i]='date' then
    begin

    end;


  end;


  //Start transaction.
  //unit_datamodule_main.DataModule_main.SQLTransaction1.StartTransaction();

  //Open query.
  unit_datamodule_table.DataModule_table.SQLQuery1.Open();



  //Close query.
  //unit_datamodule_table.DataModule_table.SQLQuery1.Close();
  finally
  end;

  //End transaction.
  unit_datamodule_main.DataModule_main.SQLTransaction1.Commit();
end;

procedure TForm_item.FormCreate(Sender: TObject);
begin
end;

procedure TForm_item.Button_okClick(Sender: TObject);
begin
  Save();
end;

procedure TForm_item.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ScrollBox1);
end;

procedure TForm_item.FormShow(Sender: TObject);
begin
  Set_Form();
end;

end.

