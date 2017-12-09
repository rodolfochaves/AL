tableextension 50110 tableextension50110 extends "Sales Invoice Line" 
{
  // version NAVW110.00.00.16585,NAVES10.00.00.16585,AB10.01

  fields
  {
    field(7107397;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107398;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
    }
    field(7107399;"Income Tax Base";Decimal)
    {
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
    }
  }
  keys
  {
  }
}

