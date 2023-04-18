unit unit_form_base;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  DefaultTranslator, ExtCtrls, StdCtrls;

resourcestring
  rstring_ok='OK';
  rstring_cancel='Cancel';
  rstring_bad='Bad';

type

  TObjectArray = array of TObject;

  { TForm_base }

  TForm_base = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
  private

  public

  end;

var
  Form_base: TForm_base;

implementation

{$R *.lfm}

{ TForm_base }

end.

