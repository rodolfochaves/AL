page 50118 "Income Tax Retention Setup"
{
  // version AB10.01

  // REQ-02 - IRPF
  
  CaptionML=ENU='Income Tax Retention Setup',
            ESP='Configuración IRPF';
  PageType=List;
  SourceTable="Income Tax Retention Setup";
  InsertAllowed=true;
  DeleteAllowed=true;
  ModifyAllowed=true;
  
  layout
  {
    
    area(content)
    {
      repeater("repetir")
      {
        field("Códio";Code)
        {
        }
        field("Descripción";Description)
        {
        }
        field("% Retención IRPF";"Income Tax Retention %")
        {
        }
        field("Cta. retención IRPF";"Income Tax Retention Acc.")
        {
        }
      }
    }
    area(factboxes)
    {
      systempart(Links;Links)
      {
        Visible=false;
      }
      systempart(Notes;Notes)
      {
        Visible=false;
      }
    }
  }

  actions
  {
  }
}

