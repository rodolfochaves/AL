tableextension 50117 tableextension50117 extends "Source Code Setup" 
{
  // version NAVW110.00,NAVES10.00,AB.10

  fields
  {
    field(7107393;"Applied Income Tax";Code[10])
    {
      CaptionML=ENU='Applied Income Tax Retention Entry',
                ESP='Liq. mov. IRPF';
      Description='REQ-02';
      TableRelation="Source Code";
    }
  }
  keys
  {
  }
}

