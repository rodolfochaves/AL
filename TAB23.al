tableextension 50103 tableextension50103 extends Vendor 
{
  // version NAVW110.00.00.17501,NAVES10.00.00.17501,AB10.01

  fields
  {
    modify("Application Method")
    {
      OptionCaptionML = ENU='Manual, Apply to Oldest',
                        ESP='Manual,Por antigüedad';
    }
    field(7107396;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107397;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='Income Tax Retention %',
                ESP='% IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107398;"Tax Amount Retention";Decimal)
    {
      
      CaptionML=ENU='Tax Amount Retention',
                ESP='Retención IRPF';
      Description='REQ-02';
      Editable=false;
      FieldClass=FlowField;
      CalcFormula=-Sum("Income Tax Entry"."Amount Tax Retention" WHERE ("Vendor No."=FIELD("No."),
                                                  "Posting Date"=FIELD("Date Filter"),
                                                  Open=CONST(true)));
    }
    field(7107399;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-02';
      TableRelation="Perceptores IRPF".Codigo;
          }
    field(7107400;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-02';
      TableRelation="Subclaves IRPF".Codigo WHERE ("Codigo perceptor IRPF"=FIELD("Income Tax Retention Key"));
    }
    field(7107401;"% Tax Amount Retention";Decimal)
    {
      Description='REQ-02';
    }
  }
  keys
  {
  }
}

