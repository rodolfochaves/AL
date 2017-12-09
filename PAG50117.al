page 50117 "Lista Subclaves IRPF"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Incorporación de las clases de renta así como los distintos modelos aceptados para cada clave/subclave

  PageType=List;
  SourceTable="Subclaves IRPF";

  layout
  {
    area(content)
    {
      repeater(Group)
      {
        field("Codigo perceptor IRPF";"Codigo perceptor IRPF")
        {
        }
        field(Codigo;Codigo)
        {
        }
        field(Descripcion;Descripcion)
        {
        }
        field("Clase renta";"Clase renta")
        {
          Description='REQ-57';
          LookupPageID="Clases renta";

          trigger OnValidate();
          begin
            CurrPage.UPDATE;
          end;
        }
        field("Decripcion clase renta";"Descripcion clase renta")
        {
          Description='REQ-57';
        }
        field("Modelo 1";"Modelo 1")
        {
          Description='REQ-57';
          LookupPageID="Modelos IRPF";
        }
        field("Modelo 2";"Modelo 2")
        {
          Description='REQ-57';
          LookupPageID="Modelos IRPF";
        }
        field("Modelo 3";"Modelo 3")
        {
          Description='REQ-57';
          LookupPageID="Modelos IRPF";
        }
      }
    }
  }

  actions
  {
  }
}

