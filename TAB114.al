tableextension 50111 tableextension50111 extends "Sales Cr.Memo Header" 
{
  // version NAVW110.00.00.17972,NAVES10.00.00.17972,AB10.01

  fields
  {
    modify("Special Scheme Code")
    {
      OptionCaptionML = ENU='01 General,02 Export,03 Special System,04 Gold,05 Travel Agencies,06 Groups of Entities,07 Special Cash,08  IPSI / IGIC,09 Travel Agency Services,10 Third Party,11 Business Withholding,12 Business not Withholding,13 Business Withholding and not Withholding,14 Invoice Work Certification,15 Invoice of Consecutive Nature,16 First Half 2017',
                        ESP='01 General,02 Exportación,03 Sistema especial,04 Oro,05 Agencias de viajes,06 Grupos de entidades,07 Efectivo especial,08 IPSI / IGIC,09 Servicios de agencias de viajes,10 Terceros,11 Negocio con retención,12 Negocio sin retención,13 Negocio con y sin retención,14 Certificación laboral de factura,15 Factura consecutiva,16 Primera mitad de 2017';
    }
    field(7107400;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='REQ-02';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107401;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='REQ-02';
      Editable=false;
    }
    field(7107402;"Income Tax Base";Decimal)
    {
      CalcFormula=Sum("Sales Cr.Memo Line"."Income Tax Base" where ("Document No."=FIELD("No."),
                                                                    "Income Tax Retention Code"=FILTER(<>'')));
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='REQ-02';
      Editable=false;
      FieldClass=FlowField;
    }
    field(7107403;"Income Tax Retention Key";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Key',
                ESP='Clave perceptor IRPF';
      Description='REQ-57';
      TableRelation="Perceptores IRPF";
    }
    field(7107404;"Income Tax Retention SubKey";Code[20])
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

