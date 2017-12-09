tableextension 50100 tableextension50100 extends "G/L Account" 
{
  // version NAVW110.00.00.17972,NAVES10.00.00.17972,AB10.01

  fields
  {
    field(7107393;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF".Codigo;
    }
    field(7107394;"Income Tax Retention SubKey";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Subclave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Subclaves IRPF".Codigo WHERE("Codigo perceptor IRPF"=FIELD("Income Tax Retention Key"));
    }
    field(7107395;"Income Tax Retention Class";Code[20])
    {
      Description='REQ-57';
      TableRelation="Several Descriptions".Codigo WHERE (idTabla=CONST(7107998));
  
    }
  }
  keys
  {
  }
}

