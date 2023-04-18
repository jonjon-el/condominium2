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
    procedure Button_cancelClick(Sender: TObject);
    procedure Button_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Initialize();
    procedure Initialize_UI();
  private

  public
    descriptionTable: unit_datamodule_table.TDescription_table;
    row_contents: TStrings;
    procedure Save();
  end;

var
  Form_item: TForm_item;

implementation

uses
  unit_datamodule_main, DB;

{$R *.lfm}

{ TForm_item }

procedure TForm_item.Initialize();
begin

end;

procedure TForm_item.Initialize_UI();
var
  number_columns: integer;

  control: TLabeledEdit;
  i: integer;

  top_previous: integer=0;
  height_previous: integer=0;

  border_vertical: integer=30;
  width_calculated: integer;
  border_right: integer=80;

  debug_str: string;
begin
  number_columns:=descriptionTable.name_field.Count;

  i:=0;

  width_calculated:=ScrollBox1.Width;
  while i<number_columns do
  begin
    if i<>descriptionTable.index_field_id then
    begin
      control:=TLabeledEdit.Create(ScrollBox1);
      control.Parent:=ScrollBox1;
      control.Name:=descriptionTable.name_field[i];

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
      //PENDING. May be unnecesary.
      if row_contents<>nil then
      begin
        //DEBUG: From where is row_contents?
        debug_str:=row_contents[i];
        control.Caption:=row_contents[i];
        //control.Caption:='DEBUG';
      end
      else
      begin
        control.Caption:='';
      end;

    end;
    inc(i);
  end;
end;

procedure TForm_item.Save;
var
  msg: string;
  i: integer;
  debug_str: string;
  labeledEdit: TLabeledEdit;
begin
  //labeledEdit:=TLabeledEdit.Create(self);
  try
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_modify;
    i:=0;
    while i<row_contents.Count do
    begin
      if i<>descriptionTable.index_field_id then
      begin
        labeledEdit:=ScrollBox1.FindChildControl(descriptionTable.name_field[i]) as TLabeledEdit;
        debug_str:=labeledEdit.Text;
        row_contents[i]:=labeledEdit.Text;
        //row_contents[i]:=ScrollBox1.FindChildControl(descriptionTable.name_field[i]).Caption;

        if descriptionTable.dataType_field[i]='string' then
        begin
          debug_str:=row_contents[i];
          unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsString:=row_contents[i];
        end;
        if descriptionTable.dataType_field[i]='integer' then
        begin
          debug_str:=row_contents[i];
          unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsInteger:=StrToInt(row_contents[i]);
        end;
        if descriptionTable.dataType_field[i]='float' then
        begin
          debug_str:=row_contents[i];
          unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsFloat:=StrToFloat(row_contents[i]);
        end;
        if descriptionTable.dataType_field[i]='date' then
        begin
          debug_str:=row_contents[i];
          unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsDate:=StrToDate(row_contents[i]);
        end;

      end
      else
      begin
        debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsInteger:=StrToInt(row_contents[i]);
      end;

      inc(i);
    end;

    unit_datamodule_main.DataModule_main.SQLTransaction1.StartTransaction();

    //Opening.
    debug_str:=unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text;
    unit_datamodule_table.DataModule_table.SQLQuery1.ExecSQL();

    //Closing.

    unit_datamodule_main.DataModule_main.SQLTransaction1.Commit();
    ModalResult:=mrOK;
  except
    on E: EDatabaseError do
    begin
      unit_datamodule_main.DataModule_main.SQLTransaction1.Rollback();
      StatusBar1.SimpleText:=E.Message;
    end;
  end;
end;

procedure TForm_item.FormCreate(Sender: TObject);
begin

end;

procedure TForm_item.Button_okClick(Sender: TObject);
begin
  Save();
end;

procedure TForm_item.Button_cancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TForm_item.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ScrollBox1);
  FreeAndNil(row_contents);
end;

procedure TForm_item.FormShow(Sender: TObject);
begin
  //Choosing what to do according to the role.
  if row_contents=nil then
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_insert;
  end
  else
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_modify;
  end;
  Initialize_UI();
end;

end.

