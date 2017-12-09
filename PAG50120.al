page 50120 "Modelos IRPF"
{
  // version AB10.01

  // REQ-57 - Ampliación IRPF Configuración Modelos

  PageType=List;
  PopulateAllFields=true;
  SourceTable="Several Descriptions";
  SourceTableView=WHERE(IdTabla=CONST(7107999));

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

