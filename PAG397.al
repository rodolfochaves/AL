pageextension 50109 pageextension50109 extends "Sales Invoice Statistics" 
{
  // version NAVW110.00,NAVES10.00,AB10.01

  layout
  {
    
    addafter(TotalVolume)
    {
      
      field(IRPFAmount;-TotalIRPFAmount)
      {
        AutoFormatExpression="Currency Code";
        AutoFormatType=1;
        CaptionClass=FORMAT (IRPFAmountText);
        CaptionML=ENU='Income Tax Amount',
                  ESP='Importe IPRF';
        Editable=false;
        Visible=IRPFAmountVisible;
      }
      field(TotalIRPF;"Amount Including VAT"-TotalIRPFAmount)
      {
        AutoFormatExpression="Currency Code";
        AutoFormatType=1;
        CaptionML=ESP='Total factura';
        Editable=false;
        Visible=TotalIRPFVisible;
      }
    }
    addafter("TotalAdjCostLCY - CostLCY")
    {
      field("Código IPRF";"Income Tax Retention Code")
      {
        Visible="Income Tax BaseVisible";
      }
    }
  }
  
    trigger OnOpenPage();
    begin
        g_cdu.OnUpdateControls(Rec, TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible")
    end;
    trigger OnAfterGetRecord();
    begin
      g_cdu.OnUpdateControls(Rec, TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible")
    end;
  var IRPFAmountVisible:Boolean;
  var g_cdu:Codeunit "Extensiones IRPF";
  var TotalIRPFAmount:Decimal;
  var IRPFAmountText:Text;
  var TotalIRPFVisible:Boolean;
  var IRPFTextVisible:Boolean;
  var TotalIRPFTextVisible: Boolean;
  var "Income Tax BaseVisible":Boolean;
}

