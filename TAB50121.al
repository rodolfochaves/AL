table 50121 "Perceptores IRPF"
{
  // version AB10.01

  // REQ-02 - IRPF
  LookupPageId="Lista Perceptores IRPF";
  DrillDownPageId="Lista Perceptores IRPF";
  fields
  {
    field(1;Codigo;Code[20])
    {
      NotBlank=true;
    }
    field(2;Descripcion;Text[50])
    {
    }
  }

  keys
  {
    key(Key1;Codigo)
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
    fieldgroup(DropDown;Codigo,Descripcion)
    {
    }
  }
}

