tableextension 50107 tableextension50107 extends "Purchase Line" 
{
  // version NAVW110.00.00.18197,NAVES10.00.00.18197,AB10.01

  fields
  {
    field(7107396;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107397;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
    }
    field(7107398;"Income Tax Base";Decimal)
    {
      Description='REQ-02';
      Editable=false;
    }
  }
  keys
  {
   /*
    key(Key1;"Document Type","Document No.","Income Tax Retention Code")
    {
      SumIndexFields="Income Tax Base";
    }
    key(Key2;"Shortcut Dimension 2 Code","Shortcut Dimension 1 Code")
    {
    }
    */
  }
}

