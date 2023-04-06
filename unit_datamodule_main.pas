unit unit_datamodule_main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, Generics.Collections;

const
  string_ini_filename = 'settings.ini';
  string_databaseScript_filename = 'condominium2.sql';
  string_database_name = 'condominium.sqlite';

type

  TConfig = specialize TDictionary<string, string>;

  { TDataModule_main }

  TDataModule_main = class(TDataModule)
    SQLConnector1: TSQLConnector;
    SQLScript1: TSQLScript;
    SQLTransaction1: TSQLTransaction;
  private
    procedure Create_database();
  public
    ini_section_names: TSTringList;
    ini_key_names: TStringList;
    config: TConfig;
    destructor Destroy(); override;
    procedure Initialize_ini_names();
    procedure Load_ini();
    procedure Save_ini();
    procedure Set_SQLConnector();
    procedure Connect_database(out msg: string);
    procedure Disconnect_database(out msg: string);
  end;

var
  DataModule_main: TDataModule_main;

implementation

uses
  IniFiles, DB;

{$R *.lfm}

{ TDataModule_main }

destructor TDataModule_main.Destroy;
begin
  FreeAndNil(ini_section_names);
  FreeAndNil(ini_key_names);
  FreeAndNil(config);
  inherited;
end;

procedure TDataModule_main.Initialize_ini_names;
begin
  ini_section_names:=TStringList.Create();
  ini_section_names.Add('SQLConnector');
  ini_key_names:=TStringList.Create();

  //section SQLConnector.
  ini_key_names.Add('ConnectorType');
  ini_key_names.Add('HostName');
  ini_key_names.Add('DatabaseName');
  ini_key_names.Add('UserName');
  ini_key_names.Add('Password');
end;

procedure TDataModule_main.Load_ini;
var
  iniFile: IniFiles.TIniFile;
  value: string;
  path_folder: string = '.';
begin
  iniFile:=IniFiles.TIniFile.Create(path_folder+DirectorySeparator+string_ini_filename);
  config:=TConfig.Create();

  //reading SQLConnector values
  value:=iniFile.ReadString(ini_section_names[0], ini_key_names[0], '');
  config.AddOrSetValue(ini_key_names[0], value);

  value:=iniFile.ReadString(ini_section_names[0], ini_key_names[1], '');
  config.AddOrSetValue(ini_key_names[1], value);

  value:=iniFile.ReadString(ini_section_names[0], ini_key_names[2], '');
  config.AddOrSetValue(ini_key_names[2], value);

  value:=iniFile.ReadString(ini_section_names[0], ini_key_names[3], '');
  config.AddOrSetValue(ini_key_names[3], value);

  value:=iniFile.ReadString(ini_section_names[0], ini_key_names[4], '');
  config.AddOrSetValue(ini_key_names[4], value);

  FreeAndNil(IniFile);
end;

procedure TDataModule_main.Save_ini;
var
  iniFile: IniFiles.TIniFile;
  value: string;
begin
  iniFile:=IniFiles.TIniFile.Create(string_ini_filename);

  //SQLConnector.
  config.TryGetValue(ini_key_names[0], value);
  iniFile.WriteString(ini_section_names[0], ini_key_names[0], value);

  config.TryGetValue(ini_key_names[1], value);
  iniFile.WriteString(ini_section_names[0], ini_key_names[1], value);

  config.TryGetValue(ini_key_names[2], value);
  iniFile.WriteString(ini_section_names[0], ini_key_names[2], value);

  config.TryGetValue(ini_key_names[3], value);
  iniFile.WriteString(ini_section_names[0], ini_key_names[3], value);

  config.TryGetValue(ini_key_names[4], value);
  iniFile.WriteString(ini_section_names[0], ini_key_names[4], value);

  FreeAndNil(IniFile);
end;

procedure TDataModule_main.Set_SQLConnector;
var
  value: string;
begin
  config.TryGetValue(ini_key_names[0], value);
  SQLConnector1.ConnectorType:=value;

  config.TryGetValue(ini_key_names[1], value);
  SQLConnector1.HostName:=value;

  config.TryGetValue(ini_key_names[2], value);
  SQLConnector1.DatabaseName:=value;

  config.TryGetValue(ini_key_names[3], value);
  SQLConnector1.UserName:=value;

  config.TryGetValue(ini_key_names[4], value);
  SQLConnector1.Password:=value;
end;

procedure TDataModule_main.Connect_database(out msg: string);
var
  path_folder: string='.';
  databaseCreated: Boolean = False;
  database_name: string;
begin
  database_name:=SQLConnector1.DatabaseName;
  databaseCreated:=FileExists(path_folder+DirectorySeparator+database_name);
  try
    if not SQLConnector1.Connected then
    begin
      SQLConnector1.Open();
      if not databaseCreated then
      begin
        Create_database();
      end;
    end;
  except
    on E: EDatabaseError do
    begin
      msg:=E.Message;
      if SQLConnector1.Connected then
      begin
        SQLConnector1.Close();
      end;
    end;
  end;
end;

procedure TDataModule_main.Disconnect_database(out msg: string);
begin
  try
    unit_datamodule_main.DataModule_main.SQLConnector1.Close();
  except
    on E: EDatabaseError do
    msg:=E.Message;
  end;
end;

procedure TDataModule_main.Create_database;
begin
  //SQLConnector1.DatabaseName:=filename_db;
  if not SQLTransaction1.Active then
  begin
    try
      SQLTransaction1.StartTransaction();
      SQLScript1.Script.LoadFromFile(string_databaseScript_filename);
      SQLScript1.Execute();
      SQLTransaction1.Commit();
    except
      on E: EDatabaseError do
      begin
        SQLTransaction1.Rollback();
      end;
    end;

  end;
end;


{ TDataModule_main }



{ TDataModule_main }

initialization

finalization

end.

