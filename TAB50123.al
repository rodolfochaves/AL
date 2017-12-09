table 50123 "Income Tax Retention Setup"
{
  // version AB10.01

  // REQ-02 - IRPF
  
  CaptionML=ENU='Income Tax Retention',
            ESP='Configuración IRPF';
  DrillDownPageId="Income Tax Retention Setup";
  LookupPageId="Income Tax Retention Setup";
  fields
  {
    field(1;"Code";Code[20])
    {
      CaptionML=ESP='Código';
    }
    field(2;Description;Text[50])
    {
      CaptionML=ENU='Description',
                ESP='Descripción';
    }
    field(3;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Tax Amount Retention',
                ESP='% Retención IRPF';
      Description='REQ-02';
    }
    field(4;"Income Tax Retention Acc.";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Acc.',
                ESP='Cta. retención IRPF';
      Description='REQ-02';
      TableRelation="G/L Account";
    }
  }

  keys
  {
    key(Key1;"Code")
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
  }
}

