pageextension 50113 pageextension50113 extends "Sales Order Statistics"
{
  // version NAVW110.00.00.18609,NAVES10.00.00.18609,AB10.01

  layout
  {
    addafter("TotalAmount2[1]")
    {
      field(IRPFAmount;-TotalIRPFAmount)
      {
        CaptionClass=FORMAT (IRPFAmountText);
        CaptionML=ESP='Importe Irpf';
        Editable=false;
        Visible=IRPFAmountVisible;
      }
      field(TotalDocument;TotalOrderAmount)
      {
        CaptionML=ENU='Document Total',
                  ESP='Total documento';
        Editable=false;
        Visible=TotalIRPFVisible;
      }
    }
    addafter("NoOfVATLines_General")
    {
      field("<Control1103358002>";"Income Tax Base")
      {
        Visible="Income Tax BaseVisible";
      }
      field(TotalAmount1;TotalAmount1[1])
      {

      }
      field(TotalAmount2;TotalAmount2[2])
      {

      }
   }
  }

     trigger OnOpenPage();
    begin
        g_cdu.OnShowPageControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible", TotalOrderAmount,TotalAmount1[1],TotalAmount2[2],FALSE)
    end;
    trigger OnAfterGetRecord();
    begin
      g_cdu.OnShowPageControls(Rec, IRPFAmountText, TotalIRPFAmount, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible",TotalOrderAmount,TotalAmount1[1],TotalAmount2[2],FALSE);
    end;

   var IRPFAmountVisible:Boolean;
  var g_cdu:Codeunit "Extensiones IRPF";
  var TotalIRPFAmount:Decimal;

  var TotalOrderAmount:Decimal;
  var IRPFAmountText:Text;
  var TotalIRPFVisible:Boolean;
  var IRPFTextVisible:Boolean;
  var TotalIRPFTextVisible: Boolean;
  var "Income Tax BaseVisible":Boolean;

var TotalAmount1:array[3] of decimal;
var TotalAmount2:array[3] of Decimal;

}

