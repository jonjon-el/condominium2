unit unit_form_item;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  unit_form_base, unit_datamodule_table;

type

  { TForm_item }

  TForm_item = class(TForm1)
    description_table: unit_datamodule_table.TDescription_table;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Set_Form(); override;
  private

  public

  end;

var
  Form_item: TForm_item;

implementation

{$R *.lfm}

{ TForm_item }

procedure TForm_item.Set_Form;
var
  control: TLabeledEdit;
  i: integer;

  top_previous: integer=0;
  height_previous: integer=0;

  border_vertical: integer=30;
  width_calculated: integer;
  border_right: integer=80;
begin
  i:=0;

  width_calculated:=ScrollBox1.Width;
  while i<description_table.name_field.Count do
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
    control.EditLabel.Caption:=description_table.name_field[i];
    control.Text:=IntToStr(control.Width);

    inc(i);
  end;
end;

procedure TForm_item.FormCreate(Sender: TObject);
begin

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

