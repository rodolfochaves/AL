page 50119 "Clases renta"
{
  // version AB10.01

  // REQ-57 - Ampliación IRPF Configuración Modelos

  PageType=List;
  PopulateAllFields=true;
  SourceTable="Several Descriptions";
  SourceTableView=WHERE(IdTabla=CONST(7107998));

  layout
  {
    area(content)
    {
      repeater(Group)
      {
        field(Codigo;Codigo)
        {
        }
        field(Descripcion;Descripcion)
        {
        }
        field("Descripcion 2";"Descripcion 2")
        {
          Description='REQ-57';
        }
      }
    }
  }

  actions
  {
  }
}

