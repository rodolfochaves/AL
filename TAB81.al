tableextension 50108 tableextension50108 extends "Gen. Journal Line" 
{
  // version NAVW110.00.00.18197,NAVES10.00.00.18197,AB10.01

  fields
  {
    field(7107398;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107399;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107400;"Income Tax Base";Decimal)
    {
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107401;"Amount Tax Retention";Decimal)
    {
      AutoFormatExpression="Currency Code";
      CaptionML=ENU='Amount Tax Retention',
                ESP='Importe Ret. IRPF';
      Description='REQ-02';
    }
    field(7107402;"Income Tax Base (LCY)";Decimal)
    {
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107403;"Amount Tax Retention (LCY)";Decimal)
    {
      AutoFormatExpression="Currency Code";
      CaptionML=ENU='Amount Tax Retention',
                ESP='Importe Ret. IRPF';
      Description='REQ-02';
    }
    field(7107404;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF".Codigo;
    }
    field(7107405;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Subclaves IRPF".Codigo WHERE ("Codigo perceptor IRPF"=FIELD("Income Tax Retention Key"));
    }
  }
  keys
  {
  }
}

