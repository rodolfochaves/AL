tableextension 50101 tableextension50101 extends Customer 
{
  // version NAVW110.00.00.18609,NAVES10.00.00.18609,AB10.01

  fields
  {
    modify("Application Method")
    {
      OptionCaptionML = ENU='Manual, Apply to Oldest',
                        ESP='Manual,Por antigüedad';
    }
    field(7107402;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107403;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107404;"Tax Amount Retention";Decimal)
    {
      
      CaptionML=ENU='Tax Amount Retention',
                ESP='Retención IRPF';
      Description='REQ-02';
      Editable=false;
      FieldClass=FlowField;
      CalcFormula=-Sum("Income Tax Entry"."Amount Tax Retention" WHERE ("Customer No."=FIELD("No."),"Posting Date"=FIELD("Date Filter"),Open=CONST(true)));
    }
    field(7107405;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF";
    }
    field(7107406;"Income Tax Retention SubKey";Text[2])
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

