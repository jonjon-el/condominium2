unit unit_form_base;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  DefaultTranslator, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    procedure Open_NextForm(newForm: TForm); virtual; abstract;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

end.

