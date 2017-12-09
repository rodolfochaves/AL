tableextension 50104 tableextension50104 extends "Vendor Ledger Entry" 
{
  // version NAVW110.00,NAVES10.00,AB10.01

  fields
  {
    field(7107404;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107405;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107406;"Income Tax Base";Decimal)
    {
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107407;"Amount Tax Retention";Decimal)
    {
      AutoFormatExpression="Currency Code";
      CaptionML=ENU='Amount Tax Retention',
                ESP='Importe Ret. IRPF';
      Description='REQ-02';
    }
    field(7107408;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF".Codigo;
    }
    field(7107409;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Subclaves IRPF".Codigo WHERE ("Codigo perceptor IRPF"=FIELD("Income Tax Retention Key"));
    }
  }
  keys
  {
    /*
    key(PK2;"Income Tax Retention Code","Vendor No.",Open,Positive,"Applies-to ID","Due Date")
    {
      
    }*/
  }
}

