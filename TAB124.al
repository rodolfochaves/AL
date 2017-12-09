tableextension 50115 tableextension50115 extends "Purch. Cr. Memo Hdr." 
{
  // version NAVW110.00.00.17972,NAVES10.00.00.17972,AB10.01

  fields
  {
    field(7107395;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107396;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107397;"Income Tax Base";Decimal)
    {
      CalcFormula=Sum("Purch. Cr. Memo Line"."Income Tax Base" where ("Document No."=field("No."),
                                                                      "Income Tax Retention Code"=filter(<>'')));
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
      FieldClass=FlowField;
    }
    field(7107398;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF".Codigo;
    }
    field(7107399;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Subclaves IRPF".Codigo where ("Codigo perceptor IRPF"=field("Income Tax Retention Key"));
    }
  }
  keys
  {
  }
}

