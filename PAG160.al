pageextension 50105 pageextension50105 extends "Sales Statistics" 
{
  // version NAVW110.00,NAVES10.00,AB10.01

  layout
  {
    addafter("TotalSalesLineLCY.Amount")
    {
      field(IRPFAmount;-TotalIRPFAmount)
      {
        AutoFormatExpression="Currency Code";
        CaptionClass=FORMAT (IRPFAmountText);
        CaptionML=ENU='Income Tax Amount',
                  ESP='Importe IPRF';
        Editable=false;
        Visible=IRPFAmountVisible;
      }
      field(TotalIRPF;"Amount Including VAT"-TotalIRPFAmount)
      {
        AutoFormatExpression="Currency Code";
        CaptionML=ENU='Total Document Amount',
                  ESP='Total Documento';
        Visible=TotalIRPFVisible;
      }
      field(Total;TotalAmount1)
      {
        
      }
      field("Total IVA incl.";TotalAmount2)
      {
        
      }
      field("Total Documento";TotalOrderAmount)
      {
        
      }
    }
    addafter("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""")
    {
      field("Income Tax Base";"Income Tax Base")
      {
        CaptionClass='Base IRPF';
        CaptionML=ENU='Income Tax Base',
                  ESP='Base IRPF';
        Visible="Income Tax BaseVisible";
      }
    }
  }

trigger OnOpenPage();
    begin
        g_cdu.OnShowPageControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible",TotalOrderAmount,TotalAmount1,TotalAmount2,FALSE);
    end;
    trigger OnAfterGetRecord();
    begin
        g_cdu.OnShowPageControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible",TotalOrderAmount,TotalAmount1,TotalAmount2,FALSE);
    end;

  var IRPFAmountVisible:Boolean;
  var g_cdu:Codeunit "Extensiones IRPF";
  var TotalIRPFAmount:Decimal;
  var IRPFAmountText:Text;
  var TotalIRPFVisible:Boolean;
  var IRPFTextVisible:Boolean;
  var TotalIRPFTextVisible: Boolean;
  var "Income Tax BaseVisible":Boolean;
  var TotalOrderAmount:decimal;
  var TotalAmount1:decimal;
  var TotalAmount2:decimal;
}

