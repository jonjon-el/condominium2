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
    index_role: integer;
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
  //Initialize with invalid index.
  index_role:=-1;
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

      control.Text:=row_contents[i];
      //Choosing whether display empty fields or not according to the role of inserting or modifying.
      //PENDING. May be unnecesary.
      //if row_contents<>nil then
      //begin
      //  //DEBUG: From where is row_contents?
      //  //debug_str:=row_contents[i];
      //  control.Text:=row_contents[i];
      //  //control.Caption:='DEBUG';
      //end
      //else
      //begin
      //  control.Text:='';
      //end;

    end;
    inc(i);
  end;
end;

//Make sure that every field is feeded to this function.
//The id field came from the member row_contents directly. Watch it is feeded too.
//Otherwise it can fail silently.
procedure TForm_item.Save;
var
  msg: string;
  i: integer;
  debug_str: string;
  labeledEdit: TLabeledEdit;
begin
  //labeledEdit:=TLabeledEdit.Create(self);
  if index_role=0 then
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_insert;

    ////Creating empty row_contents.
    //row_contents:=TStringList.Create();
    //i:=0;
    //while i<descriptionTable.name_field.Count do
    //begin
    //  row_contents.Add('');
    //end;
  end;

  if index_role=1 then
  begin
    unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_modify;
  end;

  i:=0;
  //Iterating over the controls containing the data to assign to the corresponding field in the query.
  while i<descriptionTable.name_field.Count do
  begin
    //Ignoring the field id.
    if i<>descriptionTable.index_field_id then
    begin
      //Treat the control as a TLabeledEdit for using its Text property.
      labeledEdit:=ScrollBox1.FindChildControl(descriptionTable.name_field[i]) as TLabeledEdit;
      //debug_str:=labeledEdit.Text;
      row_contents[i]:=labeledEdit.Text;
      //row_contents[i]:=ScrollBox1.FindChildControl(descriptionTable.name_field[i]).Caption;

      //Assigning each data to the corresponding field according to its datatype as specified in descriptionTable.
      if descriptionTable.dataType_field[i]='string' then
      begin
        //debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsString:=row_contents[i];
      end;
      if descriptionTable.dataType_field[i]='integer' then
      begin
        //debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsInteger:=StrToInt(row_contents[i]);
      end;
      if descriptionTable.dataType_field[i]='float' then
      begin
        //debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsFloat:=StrToFloat(row_contents[i]);
      end;
      if descriptionTable.dataType_field[i]='date' then
      begin
        //debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsDate:=StrToDate(row_contents[i]);
      end;

    end
    //Assigning the field id.
    else
    begin
      //Only assign the id if updating. Does not apply if inserting.
      if index_role=1 then
      begin
        //debug_str:=row_contents[i];
        unit_datamodule_table.DataModule_table.SQLQuery1.Params.ParamByName(descriptionTable.name_field[i]).AsInteger:=StrToInt(row_contents[i]);
      end;
    end;

    inc(i);
  end;

  try
    try
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

  finally
    //FreeAndNil(row_contents);
  end;
end;

procedure TForm_item.FormCreate(Sender: TObject);
begin
  Initialize();
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
  //FreeAndNil(ScrollBox1);
  //Only free if has a valid pointer. That only happen when role is updating.
  //if index_role=1 then
  //begin
  //  FreeAndNil(row_contents);
  //end;
end;

procedure TForm_item.FormShow(Sender: TObject);
begin
  //Choosing what to do according to the role.
  //if row_contents=nil then
  //begin
  //  unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_insert;
  //end
  //else
  //begin
  //  unit_datamodule_table.DataModule_table.SQLQuery1.SQL.Text:=descriptionTable.SQL_modify;
  //end;
  Initialize_UI();
end;

end.

