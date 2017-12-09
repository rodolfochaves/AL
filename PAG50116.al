page 50116 "Lista Perceptores IRPF"
{
  // version AB10.01

  // REQ-02 - IRPF

  PageType=List;
  PromotedActionCategoriesML=ENU='New,Tasks,Reports,Perceptors',
                             ESP='Nuevo,Tareas,Informes,Perceptores';
  SourceTable="Perceptores IRPF";

  layout
  {
    area(content)
    {
      repeater("repetir")
      {
        field(Código;Codigo)
        {
        }
        field(Descripción;Descripcion)
        {
        }
      }
    }
  }

  actions
  {
    area(navigation)
    {
      action(Subclaves)
      {
        CaptionML=ENU='Subkeys',
                  ESP='Subclaves';
        Image=EditLines;
        InFooterBar=true;
        Promoted=true;
        PromotedCategory=Category4;
        PromotedIsBig=true;
        RunObject=Page "Lista Subclaves IRPF";
        
        }
    }
  }
}

