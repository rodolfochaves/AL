table 50122 "Subclaves IRPF"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Incorporación de los distintos modelos que se relacionan con cada clave/subclave y la clase de renta relacionada
  DrillDownPageId="Lista Subclaves IRPF";
  LookupPageId="Lista Subclaves IRPF";
  fields
  {
    field(1;Codigo;Code[20])
    {
      NotBlank=true;
    }
    field(2;"Codigo perceptor IRPF";Code[20])
    {
      TableRelation="Perceptores IRPF";
    }
    field(3;Descripcion;Text[50])
    {
    }
    field(4;"Clase renta";Code[20])
    {
      Description='REQ-57';
      TableRelation="Several Descriptions".Codigo WHERE (IdTabla=CONST(7107998));
    }
    field(5;"Descripcion clase renta";Text[50])
    {
      CalcFormula=Lookup("Several Descriptions".Descripcion WHERE (IdTabla=CONST(7107998),
                                                                   Codigo=FIELD("Clase renta")));
      CaptionML=ESP='Descripción clase renta';
      Description='REQ-57';
      Editable=false;
      FieldClass=FlowField;
    }
    field(6;"Modelo 1";Code[20])
    {
      Description='REQ-57';
      TableRelation="Several Descriptions".Codigo WHERE (IdTabla=CONST(7107999));
    }
    field(7;"Modelo 2";Code[20])
    {
      Description='REQ-57';
      TableRelation="Several Descriptions".Codigo WHERE (IdTabla=CONST(7107999));
    }
    field(8;"Modelo 3";Code[20])
    {
      Description='REQ-57';
      TableRelation="Several Descriptions".Codigo WHERE (IdTabla=CONST(7107999));
    }
  }

  keys
  {
    key(Key1;Codigo,"Codigo perceptor IRPF")
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
    fieldgroup(DropDown;"Codigo perceptor IRPF",Codigo)
    {
    }
  }
}

