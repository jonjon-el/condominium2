unit unit_datamodule_table;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Generics.Collections;

resourcestring
  rstring_table_persons = 'Persons';
  rstring_table_properties = 'Properties';
  rstring_table_propietaries = 'Propietaries';
  rstring_table_debts = 'Debts';
  rstring_table_payments = 'Payments';
  rstring_table_contractedDebts = 'Contracted Debts';

  rstring_table_id = 'ID';
  rstring_table_nic = 'NIC';
  rstring_table_firstname = 'Firstname';
  rstring_table_lastname = 'Lastname';
  rstring_table_birthday = 'Birthday';
  rstring_table_name = 'Name';
  rstring_table_alicuota = 'Alicuota';
  rstring_table_propertyName = 'Property Name';
  rstring_table_amount = 'Amount';
  rstring_table_date = 'Date';
  rstring_table_kind = 'Kind';
  rstring_table_reason = 'Reason';

type

  TInvisible_column_array = array of integer;
  { TDescription_table }

  TDescription_table = class(TPersistent)
    procedure Assign(Source: TPersistent); override;
    public
    name: string;
    name_field: TStringList;
    dataType_field: TStringList;
    SQL_text: string;
    has_ID: boolean;
    constructor Create();
    constructor Create(source: TDescription_table); virtual;
    destructor Destroy(); override;
  end;

  TDescription_table_List = specialize TObjectList<TDescription_table>;

  { TDataModule2 }

  TDataModule2 = class(TDataModule)
    SQLQuery1: TSQLQuery;
  private

  public
    description_table_list: TDescription_table_List;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Initialize();
    procedure Pick_table(role: integer);
    //SQL_query_show.
    procedure Show_table_persons();
  end;

var
  DataModule2: TDataModule2;

procedure Copy_stringlist(source: TStringList; out destination: TStringList);

implementation

procedure Copy_stringlist(source: TStringList; out destination: TStringList);
var
  i: integer;
begin
  destination.Clear();
  i:=0;
  while i < source.Count do
  begin
    destination.Add(source[i]);
    inc(i);
  end;
end;

{$R *.lfm}

{ TDescription_table }

procedure TDescription_table.Assign(source: TPersistent);
var
  source_description_table: TDescription_table;
begin
  if source is TDescription_table then
  begin
    source_description_table:=TDescription_table(source);
    name:=source_description_table.name;

    name_field.Assign(source_description_table.name_field);

    dataType_field.Assign(source_description_table.dataType_field);

    SQL_text:=source_description_table.SQL_text;

    has_ID:=source_description_table.has_ID;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

{ TDataModule2 }

constructor TDescription_table.Create;
begin
  name_field:=TStringList.Create();
  dataType_field:=TStringList.Create();
end;

constructor TDescription_table.Create(source: TDescription_table);
begin
  name:=source.name;

  name_field:=TStringList.Create();
  name_field.AddStrings(source.name_field);

  dataType_field:=TStringList.Create();
  dataType_field.AddStrings(source.dataType_field);

  SQL_text:=source.SQL_text;

  has_ID:=source.has_ID;
end;

destructor TDescription_table.Destroy;
begin
  FreeAndNil(name_field);
  FreeAndNil(dataType_field);
  inherited;
end;

constructor TDataModule2.Create(AOwner: TComponent);
begin
  inherited;
  Initialize();
end;

destructor TDataModule2.Destroy;
begin
  FreeAndNil(description_table_list);
  inherited Destroy;
end;

procedure TDataModule2.Initialize;
var
  description_table: TDescription_table;
begin
  //Description of tables.
  description_table_list:=TDescription_table_List.Create(True);

  //Table persons.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_persons;

  description_table.name_field.Add(rstring_table_id);
  description_table.name_field.Add(rstring_table_nic);
  description_table.name_field.Add(rstring_table_firstname);
  description_table.name_field.Add(rstring_table_lastname);
  description_table.name_field.Add(rstring_table_birthday);

  description_table.dataType_field.Add('integer');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('date');

  description_table.SQL_text:='SELECT persons.id, persons.nic, persons.firstname, persons.lastname, persons.birthday' +
    ' FROM persons';

  description_table.has_ID:=True;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

  //Table properties.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_properties;

  description_table.name_field.Add(rstring_table_id);
  description_table.name_field.Add(rstring_table_name);
  description_table.name_field.Add(rstring_table_alicuota);

  description_table.dataType_field.Add('integer');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('double');

  description_table.SQL_text:='SELECT properties.id, properties.name, properties.alicuota' +
    ' FROM properties';

  description_table.has_ID:=True;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

  //Table propietaries.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_propietaries;

  description_table.name_field.Add(rstring_table_nic);
  description_table.name_field.Add(rstring_table_firstname);
  description_table.name_field.Add(rstring_table_lastname);
  description_table.name_field.Add(rstring_table_propertyName);

  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');

  description_table.SQL_text:='SELECT persons.nic, persons.firstName, persons.lastName, properties.name' +
  ' FROM persons' +
       ' INNER JOIN propietaries ON propietaries.id_owner = persons.id' +
       ' INNER JOIN properties ON propietaries.id_property = properties.id';

  description_table.has_ID:=False;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

  //Table debts.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_debts;

  description_table.name_field.Add(rstring_table_id);
  description_table.name_field.Add(rstring_table_nic);
  description_table.name_field.Add(rstring_table_firstname);
  description_table.name_field.Add(rstring_table_lastname);
  description_table.name_field.Add(rstring_table_amount);
  description_table.name_field.Add(rstring_table_date);

  description_table.dataType_field.Add('integer');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('double');
  description_table.dataType_field.Add('date');

  description_table.SQL_text:='SELECT debts.id, persons.nic, persons.firstName, persons.lastName, debts.amount, debts.date' +
  ' FROM debts' +
  ' INNER JOIN persons ON debts.id_person=persons.id';

  description_table.has_ID:=True;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

  //Table payments.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_payments;

  description_table.name_field.Add(rstring_table_id);
  description_table.name_field.Add(rstring_table_propertyName);
  description_table.name_field.Add(rstring_table_nic);
  description_table.name_field.Add(rstring_table_firstname);
  description_table.name_field.Add(rstring_table_lastname);
  description_table.name_field.Add(rstring_table_amount);
  description_table.name_field.Add(rstring_table_date);

  description_table.dataType_field.Add('integer');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('double');
  description_table.dataType_field.Add('date');

  description_table.SQL_text:='SELECT payments.id, properties.name, persons.nic, persons.firstName, persons.lastName, payments.amount, payments.date, payments.id_bank' +
  ' FROM payments' +
    ' INNER JOIN properties ON payments.id_property=properties.id' +
    ' INNER JOIN persons ON payments.id_person=persons.id';

  description_table.has_ID:=True;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

  //Table contracted debts.
  description_table:=TDescription_table.Create();
  description_table.name:=rstring_table_contractedDebts;

  description_table.name_field.Add(rstring_table_id);
  description_table.name_field.Add(rstring_table_nic);
  description_table.name_field.Add(rstring_table_firstname);
  description_table.name_field.Add(rstring_table_lastname);
  description_table.name_field.Add(rstring_table_amount);
  description_table.name_field.Add(rstring_table_date);
  description_table.name_field.Add(rstring_table_kind);
  description_table.name_field.Add(rstring_table_reason);

  description_table.dataType_field.Add('integer');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('double');
  description_table.dataType_field.Add('date');
  description_table.dataType_field.Add('string');
  description_table.dataType_field.Add('string');

  description_table.SQL_text:='SELECT debts_contracted.id, persons.nic, persons.firstName, persons.lastName, debts_contracted.amount, debts_contracted.date, debts_contracted.kind, debts_contracted.reason' +
  ' FROM debts_contracted' +
    ' INNER JOIN persons ON debts_contracted.id_person=persons.id';

  description_table.has_ID:=True;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);

end;

procedure TDataModule2.Pick_table(role: integer);
begin
  SQLQuery1.SQL.Text:=description_table_list[role].SQL_text;
end;

procedure TDataModule2.Show_table_persons();
begin
  SQLQuery1.SQL.Text:='SELECT persons.id, persons.nic, persons.firstname, persons.lastname, persons.birthday' +
    ' FROM persons';
end;

end.

