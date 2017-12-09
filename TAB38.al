tableextension 50106 tableextension50106 extends "Purchase Header" 
{
  // version NAVW110.00.00.18609,NAVES10.00.00.18609,AB10.01

  fields
  {
    modify("Special Scheme Code")
    {
      OptionCaptionML = ENU='01 General,02 Special System Activities,03 Special System,04 Gold,05 Travel Agencies,06 Groups of Entities,07 Special Cash,08  IPSI / IGIC,09 Intra-Community Acquisition,12 Business Premises Activities,13 Import (Without DUA),14 First Half 2017',
                        ESP='01 General,02 Actividades de sistema especial,03 Sistema especial,04 Oro,05 Agencias de viajes,06 Grupos de entidades,07 Efectivo especial,08 IPSI / IGIC,09 Adquisición intracomunitaria,12 Actividades de instalaciones empresariales,13 Importación (sin DUA),14 Primera mitad de 2017';
    }
    field(7107395;"Income Tax Retention Code";Code[20])
    {
      CaptionML=ENU='Income Tax Retention Code',
                ESP='Código IPRF';
      Description='AFIIRPF';
      TableRelation="Income Tax Retention Setup";
    }
    field(7107396;"Income Tax Retention %";Decimal)
    {
      CaptionML=ENU='% Income Tax Retention',
                ESP='% retención IRPF';
      Description='AFIIRPF';
      Editable=false;
    }
    field(7107397;"Income Tax Base";Decimal)
    {
      
      CaptionML=ENU='Income Tax Base',
                ESP='Base IRPF';
      Description='AFIIRPF';
      Editable=false;
      FieldClass=FlowField;
      CalcFormula=Sum("Purchase Line"."Income Tax Base" WHERE ("Document Type"=FIELD("Document Type"),
                                                               "Document No."=FIELD("No."),
                                                               "Income Tax Retention Code"=FILTER(<>'')));
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
    field(7107400;"Received Not Invoiced";Boolean)
    {
      CalcFormula=Exist("Purchase Line" where ("Document Type"=field("Document Type"),
                                               "Document No."=field("No."),
                                               "Qty. Rcd. Not Invoiced"=filter(<>0)));
      CaptionML=ESP='Recibido no facturado';
      Editable=false;
      FieldClass=FlowField;
    }
  }
  keys
  {
  }
}

