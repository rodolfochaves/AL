table 50120 "Several Descriptions"
{
  // version AB10.01

  // REQ-22 - Descripción de formas de pago en diferentes idiomas para la impresión de documentos
  // REQ-57 - Subtabla para los tipos de clases de renta para Clave/Subclave IRPF (IdTabla: 7107999)
  // REQ-57 - Subtabla para los tipos de modelos IRPF (IdTabla: 7107998) (Incorporación de DropDown)
  // REQ-57 - Incorporación Descripcion 2 para detallar las clases de renta y modelos

  CaptionML=ENU='Several Descriptions',
            ESP='Descripciones varias';
  DrillDownPageId="Clases renta";
  LookupPageId="Clases renta";
  fields
  {
    field(1;IdTabla;Integer)
    {
      Editable=false;
    }
    field(2;Codigo;Code[20])
    {
    }
    field(3;Idioma;Code[10])
    {
      TableRelation=Language;
    }
    field(4;Descripcion;Text[50])
    {
    }
    field(5;"Descripcion 2";Text[250])
    {
      Description='REQ-57';
    }
  }

  keys
  {
    key(Key1;IdTabla,Codigo,Idioma)
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
    fieldgroup(DropDown;Codigo,Descripcion,"Descripcion 2")
    {
    }
  }

  procedure IOFPonerFiltros(IOPIDTabla : Integer;"IOPCódigo" : Code[20]);
  begin
    FILTERGROUP(2);
    SETRANGE(IdTabla, IOPIDTabla);
    FILTERGROUP(0);
    SETRANGE(Codigo, IOPCódigo);
  end;

  procedure IOFIdClasesRentaIRPF() : Integer;
  begin
    //REQ-57.INI
    EXIT(7107999);
    //REQ-57.FIN
  end;

  procedure IOFIdModelosIRPF() : Integer;
  begin
    //REQ-57.INI
    EXIT(7107998);
    //REQ-57.FIN
  end;
}

