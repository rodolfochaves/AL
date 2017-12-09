pageextension 50112 pageextension50112 extends "Purch. Credit Memo Statistics" 
{
  // version NAVW110.00,NAVES10.00,AB10.01

  layout
  {

    addafter(AmountInclVAT)
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
        CaptionML=ESP='Total abono';
        Editable=false;
        Visible=TotalIRPFVisible;
      }

    }
    addafter(TotalVolume)
    {
      field("Código IRPF";"Income Tax Base")
      {
        Visible="Income Tax BaseVisible";
      }
    }
  }

     trigger OnOpenPage();
    begin
        g_cdu.OnUpdateControlsPurchCrMemo(Rec, TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible")
    end;
    trigger OnAfterGetRecord();
    begin
      g_cdu.OnUpdateControlsPurchCrMemo(Rec, TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible")
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

