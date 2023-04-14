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
    SQL_query: string;
    SQL_insert: string;
    SQL_modify: string;
    SQL_delete: string;
    index_field_id: integer;
    constructor Create();
    constructor Create(source: TDescription_table); virtual;
    destructor Destroy(); override;
  end;

  TDescription_table_List = specialize TObjectList<TDescription_table>;

  { TDataModule_table }

  TDataModule_table = class(TDataModule)
    SQLQuery1: TSQLQuery;
  private

  public
    description_table_list: TDescription_table_List;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Initialize();
    procedure Pick_table(index_role: integer);
  end;

var
  DataModule_table: TDataModule_table;

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

procedure TDescription_table.Assign(Source: TPersistent);
var
  source_description_table: TDescription_table;
begin
  if source is TDescription_table then
  begin
    source_description_table:=TDescription_table(source);
    name:=source_description_table.name;

    name_field.Assign(source_description_table.name_field);

    dataType_field.Assign(source_description_table.dataType_field);

    SQL_query:=source_description_table.SQL_query;

    index_field_id:=source_description_table.index_field_id;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

{ TDataModule_table }

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

  SQL_query:=source.SQL_query;

  SQL_insert:=source.SQL_insert;

  SQL_modify:=source.SQL_modify;

  SQL_delete:=source.SQL_delete;

  index_field_id:=source.index_field_id;
end;

destructor TDescription_table.Destroy;
begin
  FreeAndNil(name_field);
  FreeAndNil(dataType_field);
  inherited;
end;

constructor TDataModule_table.Create(AOwner: TComponent);
begin
  inherited;
  Initialize();
end;

destructor TDataModule_table.Destroy;
begin
  FreeAndNil(description_table_list);
  inherited Destroy;
end;

procedure TDataModule_table.Initialize;
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

  description_table.SQL_query:='SELECT persons.id, persons.nic, persons.firstname, persons.lastname, persons.birthday' +
    ' FROM persons';

  description_table.SQL_insert:='';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=0;

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

  description_table.SQL_query:='SELECT properties.id, properties.name, properties.alicuota' +
    ' FROM properties';

  description_table.SQL_insert:='';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=0;

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

  description_table.SQL_query:='SELECT persons.nic, persons.firstName, persons.lastName, properties.name' +
  ' FROM persons' +
       ' INNER JOIN propietaries ON propietaries.id_owner = persons.id' +
       ' INNER JOIN properties ON propietaries.id_property = properties.id';

  description_table.SQL_insert:='INSERT INTO persons(nic, firstName, lastName, birthDay) VALUES(:nic, :firstName, :lastName, :birthDay)';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=-1;

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

  description_table.SQL_query:='SELECT debts.id, persons.nic, persons.firstName, persons.lastName, debts.amount, debts.date' +
  ' FROM debts' +
  ' INNER JOIN persons ON debts.id_person=persons.id';

  description_table.SQL_insert:='';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=0;

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

  description_table.SQL_query:='SELECT payments.id, properties.name, persons.nic, persons.firstName, persons.lastName, payments.amount, payments.date, payments.id_bank' +
  ' FROM payments' +
    ' INNER JOIN properties ON payments.id_property=properties.id' +
    ' INNER JOIN persons ON payments.id_person=persons.id';

  description_table.SQL_insert:='';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=0;

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

  description_table.SQL_query:='SELECT debts_contracted.id, persons.nic, persons.firstName, persons.lastName, debts_contracted.amount, debts_contracted.date, debts_contracted.kind, debts_contracted.reason' +
  ' FROM debts_contracted' +
    ' INNER JOIN persons ON debts_contracted.id_person=persons.id';

  description_table.SQL_insert:='';

  description_table.SQL_modify:='';

  description_table.SQL_delete:='';

  description_table.index_field_id:=0;

  description_table_list.Add(TDescription_table.Create(description_table));
  FreeAndNil(description_table);
end;

procedure TDataModule_table.Pick_table(index_role: integer);
begin
  SQLQuery1.SQL.Text:=description_table_list[index_role].SQL_query;
end;

end.

