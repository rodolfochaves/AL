pageextension 50102 pageextension50102 extends "Purch. Invoice Subform" 
{
  // version NAVW110.00.00.17501,NAVES10.00.00.17501,AB

  layout
  {
    addafter("No.")
    {
      field("Código IRPF";"Income Tax Retention Code")
      {
      }

    }
    addafter("Total Amount Incl. VAT")
    {
      field(IRPFTotal;-1*(TotalPurchaseLine."Income Tax Base"*TotalPurchaseHeader."Income Tax Retention %"/100))
      {
        CaptionML=ESP='IRPF Total';
      }
      field(DocTotal;TotalPurchaseLine."Amount Including VAT"-TotalPurchaseLine."Income Tax Base"*TotalPurchaseHeader."Income Tax Retention %"/100)
      {
        CaptionML=ESP='Total';
      }
    }
  }
var
  TotalPurchaseLine:Record "purchase line";
  TotalPurchaseHeader:Record "Purchase Header";
}

