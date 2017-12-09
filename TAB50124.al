table 50124 "Income Tax Entry"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Incorporación de campo "clave" y "subclave" para poder distinguir cada clase de IRPF para generar los distintos modelos.
  //          Incorporación de las distintas claves para la obtención de los datos en función de "clave" y "subclave"

  CaptionML=ENU='Income Tax Retention Entry',
            ESP='Mov. IRPF';
  DrillDownPageId="Income Tax Entries";
  LookupPageId="Income Tax Entries";
  fields
  {
    field(1;"Entry No.";Integer)
    {
      CaptionML=ENU='Entry No.',
                ESP='Nº mov.';
    }
    field(2;"Posting Date";Date)
    {
      CaptionML=ENU='Posting Date',
                ESP='Fecha registro';
      ClosingDates=true;
    }
    field(3;"Document Type";Option)
    {
      CaptionML=ENU='Document Type',
                ESP='Tipo documento';
      OptionCaptionML=ENU='Invoice,Credit Memo',
                      ESP='Factura,Abono';
      OptionMembers=Invoice,"Credit Memo";
    }
    field(4;"Document No.";Code[20])
    {
      CaptionML=ENU='Document No.',
                ESP='Nº documento';
    }
    field(5;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(6;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7;"Income Tax Base";Decimal)
    {
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(8;"Amount Tax Retention";Decimal)
    {
      CaptionML=ENU='Amount Tax Retention',
                ESP='Importe Ret. IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(9;Open;Boolean)
    {
      CaptionML=ENU='Open',
                ESP='Pendiente';
    }
    field(10;"Closed at Date";Date)
    {
      CaptionML=ENU='Closed at Date',
                ESP='Cerrado a la fecha';
    }
    field(11;"Transaction No.";Integer)
    {
      CaptionML=ENU='Transaction No.',
                ESP='Nº asiento';
    }
    field(12;"Vendor No.";Code[20])
    {
      CaptionML=ENU='Vendor No.',
                ESP='Nº proveedor';
      TableRelation=Vendor;
    }
    field(13;"Customer No.";Code[20])
    {
      CaptionML=ENU='Customer No.',
                ESP='Nº cliente';
      TableRelation=Customer;
    }
    field(14;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF".Codigo;
    }
    field(15;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Subclaves IRPF".Codigo WHERE ("Codigo perceptor IRPF"=FIELD("Income Tax Retention Key"));
    }
  }

  keys
  {
    key(Key1;"Entry No.")
    {
      Clustered=true;
    }
    key(Key2;"Transaction No.")
    {
    }
    key(Key3;"Document No.")
    {
    }
    key(Key4;"Vendor No.")
    {
    }
    key(Key5;"Income Tax Retention %","Vendor No.","Posting Date")
    {
    }
    key(Key6;"Vendor No.","Posting Date",Open)
    {
      SumIndexFields="Amount Tax Retention";
    }
    key(Key7;"Customer No.","Posting Date",Open)
    {
      SumIndexFields="Amount Tax Retention";
    }
    key(Key8;"Income Tax Retention Key","Income Tax Retention SubKey","Vendor No.","Posting Date",Open)
    {
    }
    key(Key9;"Income Tax Retention Key","Income Tax Retention SubKey","Customer No.","Posting Date",Open)
    {
    }
    key(Key10;"Income Tax Retention Key","Income Tax Retention SubKey","Income Tax Retention %","Vendor No.","Posting Date")
    {
    }
    key(Key11;"Income Tax Retention Key","Income Tax Retention SubKey","Income Tax Retention %","Customer No.","Posting Date")
    {
    }
  }

  fieldgroups
  {
  }

  trigger OnInsert();
  var
    GenJnlPostPreview : Codeunit 19;
  begin
  end;
}

