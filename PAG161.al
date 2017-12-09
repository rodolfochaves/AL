pageextension 50106 pageextension50106 extends "Purchase Statistics" 
{
  // version NAVW110.00,NAVES10.00,AB10.01

  layout
  {
   
    addafter(TotalAmount2)
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
    addafter("TotalPurchLine.""Unit Volume""")
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
      g_cdu.OnShowPurchStatisticsControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible",TotalOrderAmount,TotalAmount1,TotalAmount2,TRUE);
    end;
    trigger OnAfterGetRecord();
    begin
      g_cdu.OnShowPurchStatisticsControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible",TotalOrderAmount,TotalAmount1,TotalAmount2,TRUE);

    end;

  var IRPFAmountVisible:Boolean;
  var g_cdu:Codeunit "Extensiones IRPF";
  var TotalIRPFAmount:Decimal;
  var IRPFAmountText:Text;
  var TotalIRPFVisible:Boolean;
  var IRPFTextVisible:Boolean;
  var TotalIRPFTextVisible: Boolean;
  var "Income Tax BaseVisible":Boolean;

var TotalOrderAmount:Decimal;
var TotalAmount1:Decimal;
var TotalAmount2: Decimal;

}

