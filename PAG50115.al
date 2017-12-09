page 50115 "Income Tax Entries"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Incorporamos claves y subclaves del movimiento IRPF

  CaptionML=ENU='Income Tax Entries',
            ESP='Movimientos IRPF';
  Editable=false;
  PageType=List;
  SourceTable="Income Tax Entry";

  layout
  {
    area(content)
    {
      repeater("Movimientos")
      {
        field("Nº Mov";"Entry No.")
        {
        }
        field("Fecha registro";"Posting Date")
        {
        }
        field("Nº proveedor";"Vendor No.")
        {
        }
        field("Nº cliente";"Customer No.")
        {
        }
        field("Tipo documento";"Document Type")
        {
        }
        field("Nº documento";"Document No.")
        {
        }
        field("Código IPRF";"Income Tax Retention Code")
        {
        }
        field("% retención IRPF";"Income Tax Retention %")
        {
        }
        field("Base IRPF";"Income Tax Base")
        {
        }
        field("Importe Ret. IRPF";"Amount Tax Retention")
        {
        }
        field("Pendiente";Open)
        {
        }
        field("Cerrado a la fecha";"Closed at Date")
        {
        }
        field("Clave perceptor IRPF";"Income Tax Retention Key")
        {
          Description='REQ-57';
        }
        field("Subclave perceptor IRPF";"Income Tax Retention SubKey")
        {
          Description='REQ-57';
        }
      }
    }
    area(factboxes)
    {
      systempart("Prueba";Links)
      {
        Visible=false;
      }
      systempart("Notes";Notes)
      {
        Visible=false;
      }
    }
  }

  actions
  {
  }
}

