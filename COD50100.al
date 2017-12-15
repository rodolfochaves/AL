codeunit 50100 "Extensiones IRPF"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Ampliacion IRPF
  //DEMO ACTIVE

  trigger OnRun();
  begin
  end;
  var
  AmountTaxRetention :Decimal;
  AmountTaxRetentionLCY:Decimal;
  IRPFFactor:Integer;
  //[EventSubscriber(ObjectType::Codeunit, 12, 'OnPostIRPFCust', '', false, false)]
 [EventSubscriber(ObjectType::Table, 21,'OnAfterInsertEvent', '', false, false)]
  local procedure OnMoveGenJournalLine(VAR Rec : Record "Cust. Ledger Entry";RunTrigger : Boolean);
  var
    IncomeTaxEntry : Record "Income Tax Entry";
    GLEntry : Record 17;
    p_recCustLedgerEntry :Record 21;
  begin
    p_recCustLedgerEntry := Rec;
    IF p_recCustLedgerEntry."Income Tax Retention Code" <> '' THEN BEGIN
      IncomeTaxEntry.INIT ;
      IncomeTaxEntry."Entry No."    := p_recCustLedgerEntry."Entry No." ;
      IncomeTaxEntry."Posting Date" := p_recCustLedgerEntry."Posting Date" ;
      IF p_recCustLedgerEntry."Document Type" = p_recCustLedgerEntry."Document Type"::Invoice THEN
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::Invoice
      ELSE
        IncomeTaxEntry."Document Type"           := IncomeTaxEntry."Document Type"::"Credit Memo" ;
      IncomeTaxEntry."Document No."              := p_recCustLedgerEntry."Document No." ;
      IncomeTaxEntry."Income Tax Retention Code" := p_recCustLedgerEntry."Income Tax Retention Code" ;
      IncomeTaxEntry."Income Tax Retention Key"    := p_recCustLedgerEntry."Income Tax Retention Key";
      IncomeTaxEntry."Income Tax Retention SubKey" := p_recCustLedgerEntry."Income Tax Retention SubKey";
      IncomeTaxEntry."Income Tax Retention %" := p_recCustLedgerEntry."Income Tax Retention %" ;
      IncomeTaxEntry."Income Tax Base"        := p_recCustLedgerEntry."Income Tax Base" ;
      IncomeTaxEntry."Amount Tax Retention"   := p_recCustLedgerEntry."Amount Tax Retention" ;
      IncomeTaxEntry."Transaction No."        := p_recCustLedgerEntry."Transaction No." ;
      IncomeTaxEntry.Open                     := TRUE;
      IncomeTaxEntry."Customer No."           := p_recCustLedgerEntry."Customer No." ;
      IncomeTaxEntry.INSERT(TRUE) ;
    END ;
  end;
  /*
  local procedure PostIRPFCust(p_recCustLedgerEntry : Record 21;p_recGenJnlLine : Record 81;p_intNextEntryNo : Integer);
  var
    IncomeTaxEntry : Record "Income Tax Entry";
    GLEntry : Record 17;
  begin
    IF p_recCustLedgerEntry."Income Tax Retention Code" <> '' THEN BEGIN
      IncomeTaxEntry.INIT ;
      IncomeTaxEntry."Entry No."    := p_intNextEntryNo-1 ;
      IncomeTaxEntry."Posting Date" := p_recCustLedgerEntry."Posting Date" ;
      IF p_recCustLedgerEntry."Document Type" = p_recCustLedgerEntry."Document Type"::Invoice THEN
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::Invoice
      ELSE
        IncomeTaxEntry."Document Type"           := IncomeTaxEntry."Document Type"::"Credit Memo" ;
      IncomeTaxEntry."Document No."              := p_recCustLedgerEntry."Document No." ;
      IncomeTaxEntry."Income Tax Retention Code" := p_recCustLedgerEntry."Income Tax Retention Code" ;
      IncomeTaxEntry."Income Tax Retention Key"    := p_recCustLedgerEntry."Income Tax Retention Key";
      IncomeTaxEntry."Income Tax Retention SubKey" := p_recCustLedgerEntry."Income Tax Retention SubKey";
      IncomeTaxEntry."Income Tax Retention %" := p_recCustLedgerEntry."Income Tax Retention %" ;
      IncomeTaxEntry."Income Tax Base"        := p_recCustLedgerEntry."Income Tax Base" ;
      IncomeTaxEntry."Amount Tax Retention"   := p_recCustLedgerEntry."Amount Tax Retention" ;
      IncomeTaxEntry."Transaction No."        := p_recCustLedgerEntry."Transaction No." ;
      IncomeTaxEntry.Open                     := TRUE;
      IncomeTaxEntry."Customer No."           := p_recCustLedgerEntry."Customer No." ;
      IncomeTaxEntry.INSERT(TRUE) ;
    END ;
  end;
  */
  [EventSubscriber(ObjectType::Codeunit,90,'OnBeforePostVendorEntry','',false,false)]
  procedure CalcIRPFTaxesInfo(VAR GenJnlLine : Record "Gen. Journal Line";VAR PurchHeader : Record "Purchase Header";VAR TotalPurchLine : Record "Purchase Line";VAR TotalPurchLineLCY : Record "Purchase Line")
  var
    p_recPurchHeader:Record "Purchase Header";
    p_recGenJnlLine:Record "Gen. Journal Line";
    p_recTotalPurchLine2:Record "Purchase Line";
    p_recTotalPurchLineLCY2:Record "Purchase Line";
    GLSetup:Record "General Ledger Setup";
  begin
    p_recPurchHeader := PurchHeader;
    p_recGenJnlLine := GenJnlLine;
    p_recTotalPurchLine2 := TotalPurchLine;
    p_recTotalPurchLineLCY2 := TotalPurchLineLCY;
    GLSetup.Get();
    WITH p_recPurchHeader DO BEGIN
  IF "Income Tax Retention Code" = '' THEN BEGIN
    p_recGenJnlLine."Income Tax Retention Code"  := '' ;
    p_recGenJnlLine."Amount Tax Retention"       := 0 ;
    p_recGenJnlLine."Amount Tax Retention (LCY)" := 0 ;
    p_recGenJnlLine."Income Tax Base"            := 0 ;
    p_recGenJnlLine."Income Tax Base (LCY)"      := 0 ;
    p_recGenJnlLine."Income Tax Retention %"     := 0 ;
    AmountTaxRetention    := 0 ;
    AmountTaxRetentionLCY := 0 ;
    //REQ-57.INI
    p_recGenJnlLine."Income Tax Retention Key"    := '';
    p_recGenJnlLine."Income Tax Retention SubKey" := '';
    //REQ-57.FIN
  END ELSE BEGIN
    IF Invoice AND ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) THEN BEGIN
      IRPFFactor := -1 ;
    END ELSE BEGIN
      IF Invoice AND ("Document Type" IN ["Document Type"::"Credit Memo"]) THEN BEGIN
        IRPFFactor := 1 ;
      END ;
    END ;
    p_recGenJnlLine."Income Tax Retention Code"   := "Income Tax Retention Code" ;
    p_recGenJnlLine."Amount Tax Retention"        := IRPFFactor * ROUND(p_recTotalPurchLine2."Income Tax Base" *
                                                     "Income Tax Retention %" / 100, GLSetup."Amount Rounding Precision");
    p_recGenJnlLine."Amount Tax Retention (LCY)"  := IRPFFactor * ROUND(p_recTotalPurchLineLCY2."Income Tax Base" *
                                                     "Income Tax Retention %" / 100, GLSetup."Amount Rounding Precision");
    p_recGenJnlLine."Income Tax Base"             := p_recTotalPurchLine2."Income Tax Base";
    p_recGenJnlLine."Income Tax Base (LCY)"       := p_recTotalPurchLineLCY2."Income Tax Base";
    p_recGenJnlLine."Income Tax Retention %"      := "Income Tax Retention %";
    //REQ-57.INI
    p_recGenJnlLine."Income Tax Retention Key"    := p_recPurchHeader."Income Tax Retention Key";
    p_recGenJnlLine."Income Tax Retention SubKey" := p_recPurchHeader."Income Tax Retention SubKey";
    //REQ-57.FIN
  END ;
  p_recGenJnlLine.Amount                   := -(p_recTotalPurchLine2."Amount Including VAT"+p_recGenJnlLine."Amount Tax Retention");
  p_recGenJnlLine."Source Currency Code"   := "Currency Code";
  p_recGenJnlLine."Source Currency Amount" := -(p_recTotalPurchLine2."Amount Including VAT"+p_recGenJnlLine."Amount Tax Retention");
  p_recGenJnlLine."Amount (LCY)"           := -(p_recTotalPurchLineLCY2."Amount Including VAT"+p_recGenJnlLine."Amount Tax Retention (LCY)");
  AmountTaxRetention                       := ABS(p_recGenJnlLine."Amount Tax Retention") ;
  AmountTaxRetentionLCY                    := ABS(p_recGenJnlLine."Amount Tax Retention (LCY)") ;
END;
//REQ-02.FIN

  end;
  [EventSubscriber(ObjectType::Table, 25, 'OnAfterInsertEvent', '', false, false)]
  procedure PostIRPFVend(VAR Rec : Record "Vendor Ledger Entry";RunTrigger : Boolean);
  var
    IncomeTaxEntry : Record "Income Tax Entry";
    IncomeTaxSetup : Record "Income Tax Retention Setup";
    GLEntry : Record 17;
    p_recVendorLedgerEntry:Record "Vendor Ledger Entry";
  begin
    p_recVendorLedgerEntry := Rec;
    IF p_recVendorLedgerEntry."Income Tax Retention Code" <> '' THEN BEGIN
      IncomeTaxEntry.INIT ;
      IncomeTaxEntry."Entry No."    := p_recVendorLedgerEntry."Entry No." ;
      IncomeTaxEntry."Posting Date" := p_recVendorLedgerEntry."Posting Date" ;
      IF p_recVendorLedgerEntry."Document Type" = p_recVendorLedgerEntry."Document Type"::Invoice THEN
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::Invoice
      ELSE
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::"Credit Memo" ;
      IncomeTaxEntry."Document No."              := p_recVendorLedgerEntry."Document No." ;
      IncomeTaxEntry."Income Tax Retention Code" := p_recVendorLedgerEntry."Income Tax Retention Code" ;
      IncomeTaxEntry."Income Tax Retention Key"    := p_recVendorLedgerEntry."Income Tax Retention Key";
      IncomeTaxEntry."Income Tax Retention SubKey" := p_recVendorLedgerEntry."Income Tax Retention SubKey";
      IncomeTaxEntry."Income Tax Retention %" := p_recVendorLedgerEntry."Income Tax Retention %" ;
      IncomeTaxEntry."Income Tax Base"        := p_recVendorLedgerEntry."Income Tax Base" ;
      IncomeTaxEntry."Amount Tax Retention"   := p_recVendorLedgerEntry."Amount Tax Retention" ;
      IncomeTaxEntry."Transaction No."        := p_recVendorLedgerEntry."Transaction No." ;
      IncomeTaxEntry.Open                     := TRUE ;
      IncomeTaxEntry."Vendor No."             := p_recVendorLedgerEntry."Vendor No." ;
      IncomeTaxEntry.INSERT(TRUE) ;
    END ;
  end;

  /*
  [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostIRPFVend', '', false, false)]
  procedure PostIRPFVend(p_recVendorLedgerEntry : Record 25;p_recGenJnlLine : Record 81;p_intNextEntryNo : Integer);
  var
    IncomeTaxEntry : Record "Income Tax Entry";
    IncomeTaxSetup : Record "Income Tax Retention Setup";
    GLEntry : Record 17;
  begin
    IF p_recVendorLedgerEntry."Income Tax Retention Code" <> '' THEN BEGIN
      IncomeTaxEntry.INIT ;
      IncomeTaxEntry."Entry No."    := p_intNextEntryNo-1 ;
      IncomeTaxEntry."Posting Date" := p_recVendorLedgerEntry."Posting Date" ;
      IF p_recVendorLedgerEntry."Document Type" = p_recVendorLedgerEntry."Document Type"::Invoice THEN
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::Invoice
      ELSE
        IncomeTaxEntry."Document Type" := IncomeTaxEntry."Document Type"::"Credit Memo" ;
      IncomeTaxEntry."Document No."              := p_recVendorLedgerEntry."Document No." ;
      IncomeTaxEntry."Income Tax Retention Code" := p_recVendorLedgerEntry."Income Tax Retention Code" ;
      IncomeTaxEntry."Income Tax Retention Key"    := p_recVendorLedgerEntry."Income Tax Retention Key";
      IncomeTaxEntry."Income Tax Retention SubKey" := p_recVendorLedgerEntry."Income Tax Retention SubKey";
      IncomeTaxEntry."Income Tax Retention %" := p_recVendorLedgerEntry."Income Tax Retention %" ;
      IncomeTaxEntry."Income Tax Base"        := p_recVendorLedgerEntry."Income Tax Base" ;
      IncomeTaxEntry."Amount Tax Retention"   := p_recVendorLedgerEntry."Amount Tax Retention" ;
      IncomeTaxEntry."Transaction No."        := p_recVendorLedgerEntry."Transaction No." ;
      IncomeTaxEntry.Open                     := TRUE ;
      IncomeTaxEntry."Vendor No."             := p_recVendorLedgerEntry."Vendor No." ;
      IncomeTaxEntry.INSERT(TRUE) ;
    END ;
  end;
*/
  [EventSubscriber(ObjectType::Table, 50124, 'OnAfterInsertEvent', '', false, false)]
  procedure SaveIncomeTaxEntry(var Rec : Record 50124;RunTrigger : Boolean);
  var
    Started : Boolean;
    TempIncomeTaxEntry : Record "Income Tax Entry";
  begin
    IF Started THEN BEGIN
      TempIncomeTaxEntry := Rec;
      TempIncomeTaxEntry."Document No." := '***';
      IF TempIncomeTaxEntry.INSERT THEN;
    END;
  end;

  /*
  ACTRCG INI
  [EventSubscriber(ObjectType::Page, 26, 'OnAfterActionEvent', 'Action1103358006', false, false)]
  local procedure MovimientosIRPF(var Rec : Record 23);
  var
    l_recIncomeTaxEntry : Record "Income Tax Entry";
    l_pgIncomeTaxEntries : Page "Income Tax Entries";
  begin
    l_recIncomeTaxEntry.RESET;
    l_recIncomeTaxEntry.SETCURRENTKEY("Vendor No.");
    l_recIncomeTaxEntry.SETRANGE("Vendor No.", Rec."No.");
    IF l_recIncomeTaxEntry.FINDSET THEN;

    l_pgIncomeTaxEntries.SETTABLEVIEW(l_recIncomeTaxEntry);
    l_pgIncomeTaxEntries.RUN;
  end;

 
  [EventSubscriber(ObjectType::Page, 116, 'OnAfterActionEvent', 'Page G/L - Item Ledger Relation', false, false)]
  local procedure ItemLedgerRelation(var Rec : Record 45);
  var
    IncomeTaxEntry : Record "Income Tax Entry";
  begin
    IncomeTaxEntry.SETCURRENTKEY("Transaction No.");
    IncomeTaxEntry.SETRANGE("Transaction No.", Rec."Period Trans. No.");
    PAGE.RUN(7107436,IncomeTaxEntry);
  end;
  ACTRCG FIN
*/
  [IntegrationEvent(false, false)]
  procedure OnShowPageControls(Rec : Record 36;var IRPFAmountText : Text;var TotalIRPFAmount : Decimal;var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var IncomeTaxbaseVisible : Boolean;var TotalOrderAmount : Decimal;var TotalAmount1 : Decimal;var TotalAmount2 : Decimal;Calc : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnShowPageControls', '', false, false)]
  local procedure ShowPageControls(Rec : Record 36;var IRPFAmountText : Text;var TotalIRPFAmount : Decimal;var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var IncomeTaxbaseVisible : Boolean;var TotalOrderAmount : Decimal;var TotalAmount1 : Decimal;var TotalAmount2 : Decimal;Calc : Boolean);
  var
    Text56300 : TextConst ENU='Income Tax Retention %',ESP='% IRPF';
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention %" <> 0 THEN BEGIN
        IRPFAmountText := FORMAT("Income Tax Retention %") + Text56300 ;
        TotalIRPFAmount := "Income Tax Base" * "Income Tax Retention %" / 100 ;
        IRPFTextVisible := TRUE ;
        IRPFAmountVisible := TRUE ;
        TotalIRPFVisible := TRUE ;
        TotalIRPFTextVisible := TRUE ;
        IncomeTaxbaseVisible := TRUE;
      END ELSE BEGIN
        IRPFAmountText := Text56300 ;
        TotalIRPFAmount := 0 ;
        IRPFTextVisible := FALSE ;
        IRPFAmountVisible := FALSE ;
        TotalIRPFVisible := FALSE ;
        TotalIRPFTextVisible := FALSE ;
        IncomeTaxbaseVisible := FALSE;
      END ;
    END;

    IF Calc THEN BEGIN
      IF NOT Rec."Prices Including VAT" THEN
        TotalOrderAmount := TotalAmount2-TotalIRPFAmount
      ELSE
        TotalOrderAmount := TotalAmount1-TotalIRPFAmount ;
    END ;
  end;

  [IntegrationEvent(false, false)]
  procedure OnShowPurchStatisticsControls(Rec : Record 38;var IRPFAmountText : Text;var TotalIRPFAmount : Decimal;var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var IncomeTaxBaseVisible : Boolean;var TotalOrderAmount : Decimal;var TotalAmount1 : Decimal;var TotalAmount2 : Decimal;Calc : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnShowPurchStatisticsControls', '', false, false)]
  local procedure ShowPurchStatisticsControls(Rec : Record 38;var IRPFAmountText : Text;var TotalIRPFAmount : Decimal;var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var IncomeTaxBaseVisible : Boolean;var TotalOrderAmount : Decimal;var TotalAmount1 : Decimal;var TotalAmount2 : Decimal;Calc : Boolean);
  var
    Text56300 : TextConst ENU='Income Tax Retention %',ESP='% IRPF';
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention %" <> 0 THEN BEGIN
        IRPFAmountText := FORMAT("Income Tax Retention %") + Text56300 ;
        TotalIRPFAmount := "Income Tax Base" * "Income Tax Retention %" / 100 ;
        IRPFTextVisible := TRUE ;
        IRPFAmountVisible := TRUE ;
        TotalIRPFVisible := TRUE ;
        TotalIRPFTextVisible := TRUE ;
        IncomeTaxBaseVisible := TRUE;
      END ELSE BEGIN
        IRPFAmountText := Text56300 ;
        TotalIRPFAmount := 0 ;
        IRPFTextVisible := FALSE ;
        IRPFAmountVisible := FALSE ;
        TotalIRPFVisible := FALSE ;
        TotalIRPFTextVisible := FALSE ;
        IncomeTaxBaseVisible := FALSE;
      END ;
    END;

    IF Calc THEN BEGIN
      IF NOT Rec."Prices Including VAT" THEN
        TotalOrderAmount := TotalAmount2-TotalIRPFAmount
      ELSE
        TotalOrderAmount := TotalAmount1-TotalIRPFAmount ;
    END ;
  end;

  [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateFindRecords', '', false, false)]
  local procedure NavigateFindIncomeTaxEntries(var DocumentEntry : Record 265;DocNoFilter : Text;PostingDateFilter : Text);
  var
    IncomeTaxEntry : Record 50124;
  begin
    IF IncomeTaxEntry.READPERMISSION THEN BEGIN
      IncomeTaxEntry.RESET;
      IncomeTaxEntry.SETCURRENTKEY("Document No.");
      IncomeTaxEntry.SETFILTER("Document No.",DocNoFilter);
      IncomeTaxEntry.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Income Tax Entry",0,IncomeTaxEntry.TABLECAPTION,IncomeTaxEntry.COUNT,DocumentEntry);
    END ;
  end;

  local procedure InsertIntoDocEntry(DocTableID : Integer;DocType : Option;DocTableName : Text[1024];DocNoOfRecords : Integer;var p_recDocumentEntry : Record 265);
  begin
    WITH p_recDocumentEntry DO BEGIN
      IF DocNoOfRecords = 0 THEN
        EXIT;
      INIT;
      "Entry No." := "Entry No." + 1;
      "Table ID" := DocTableID;
      "Document Type" := DocType;
      "Table Name" := COPYSTR(DocTableName,1,MAXSTRLEN("Table Name"));
      "No. of Records" := DocNoOfRecords;
      INSERT;
    END;
  end;

  [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateShowRecords', '', false, false)]
  local procedure ShowRecordsIncome(TableID : Integer;DocNoFilter : Text;PostingDateFilter : Text;ItemTrackingSearch : Boolean);
  var
    IncomeTaxEntry : Record 50124;
  begin
    CASE TableID OF
      DATABASE::"Income Tax Entry": BEGIN
        IncomeTaxEntry.RESET;
        IncomeTaxEntry.SETCURRENTKEY("Document No.");
        IncomeTaxEntry.SETFILTER("Document No.",DocNoFilter);
        IncomeTaxEntry.SETFILTER("Posting Date",PostingDateFilter);

        PAGE.RUN(0,IncomeTaxEntry);
      END ;
    END ;
  end;

  [IntegrationEvent(false, false)]
  procedure OnUpdateControls(SalesInvoiceHeader : Record 112;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnUpdateControls', '', false, false)]
  local procedure UpdateControlsSalesInvoice(SalesInvoiceHeader : Record 112;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  var
    Text56300 : TextConst ENU='% Income Tax Retention',ESP='% IRPF';
  begin
    WITH SalesInvoiceHeader DO BEGIN
      GET("No.");
      CALCFIELDS("Income Tax Base") ;
      UpdateControls("Income Tax Retention %", "Income Tax Base", TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible");
    END;
  end;

  [IntegrationEvent(false, false)]
  procedure OnUpdateControlsCrMemo(SalesCrMemoHeader : Record 114;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnUpdateControlsCrMemo', '', false, false)]
  local procedure UpdateControlsSalesCrMemo(SalesCrMemoHeader : Record 114;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
    WITH SalesCrMemoHeader DO BEGIN
      GET("No.");
      CALCFIELDS("Income Tax Base") ;
      UpdateControls("Income Tax Retention %", "Income Tax Base", TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible");
    END;
  end;

  [IntegrationEvent(false, false)]
  procedure OnUpdateControlsPurchInvoice(PurchInvHeader : Record 122;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnUpdateControlsPurchInvoice', '', false, false)]
  local procedure UpdateControlsPurchInvoice(PurchInvHeader : Record 122;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
    WITH PurchInvHeader DO BEGIN
      GET("No.");
      CALCFIELDS("Income Tax Base") ;
      UpdateControls("Income Tax Retention %", "Income Tax Base", TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible");
    END;
  end;

  [IntegrationEvent(false, false)]
  procedure OnUpdateControlsPurchCrMemo(PurchCrMemoHdr : Record 124;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
  end;

  [EventSubscriber(ObjectType::Codeunit, 50100, 'OnUpdateControlsPurchCrMemo', '', false, false)]
  local procedure UpdateControlsPurchCrMemo(PurchCrMemoHdr : Record 124;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  begin
    WITH PurchCrMemoHdr DO BEGIN
      GET("No.");
      CALCFIELDS("Income Tax Base") ;
      UpdateControls("Income Tax Retention %", "Income Tax Base", TotalIRPFAmount, IRPFAmountText, IRPFTextVisible, IRPFAmountVisible, TotalIRPFVisible, TotalIRPFTextVisible, "Income Tax BaseVisible");
    END;
  end;

  procedure CorregirIVA(var VATBuffer : Record 10704;VATEntry : Record 254);
  var
    Moviva2 : Record 254;
    RecMovIRPF : Record 50124;
  begin
    Moviva2.RESET;
    Moviva2.COPY(VATEntry);
    Moviva2.SETRANGE("Document No.",VATEntry."Document No.");
    Moviva2.SETRANGE("Posting Date",VATEntry."Posting Date");
    Moviva2.SETFILTER("Entry No.",'>%1',VATEntry."Entry No.");
    IF NOT Moviva2.FINDFIRST THEN BEGIN
      RecMovIRPF.RESET;
      RecMovIRPF.SETCURRENTKEY("Document No.");
      RecMovIRPF.SETFILTER("Document No.",VATEntry."Document No.");
      RecMovIRPF.SETRANGE("Posting Date",VATEntry."Posting Date");
      RecMovIRPF.SETRANGE("Transaction No.",VATEntry."Transaction No.");
      IF RecMovIRPF.FINDFIRST THEN BEGIN
        VATBuffer."IRPF %" := RecMovIRPF."Income Tax Retention %";
        VATBuffer."Income Tax Amount" := RecMovIRPF."Amount Tax Retention";
      END ELSE BEGIN
        VATBuffer."IRPF %" := 0;
        VATBuffer."Income Tax Amount" := 0;
      END;
    END ELSE BEGIN
      VATBuffer."IRPF %" := 0;
      VATBuffer."Income Tax Amount" := 0;
    END;
  end;

  procedure cargarInfoIRPFEnBuffer(var VATBuffer : Record 10704 temporary;VATEntry : Record 254;var OldDocNo : Code[20]);
  var
    RecMovIRPF : Record 50124;
  begin
    IF OldDocNo <> VATEntry."Document No." THEN BEGIN
      RecMovIRPF.RESET;
      RecMovIRPF.SETCURRENTKEY("Document No.");
      RecMovIRPF.SETFILTER("Document No.",VATEntry."Document No.");
      IF RecMovIRPF.FIND('-') THEN
        BEGIN
          VATBuffer."IRPF %"  := RecMovIRPF."Income Tax Retention %";
          VATBuffer."Income Tax Amount" := RecMovIRPF."Amount Tax Retention";
        END;
      OldDocNo := VATEntry."Document No.";
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 15, 'OnAfterValidateEvent', 'Income Tax Retention Key', false, false)]
  local procedure GlAcc_AferrValidateIncomeTaxRetentionKey(var Rec : Record 15;var xRec : Record 15;CurrFieldNo : Integer);
  begin
    //REQ-57.INI
    Rec."Income Tax Retention SubKey" := '00' ;
    //REQ-57.FIN
  end;

  [EventSubscriber(ObjectType::Table, 15, 'OnAfterValidateEvent', 'Income Tax Retention SubKey', false, false)]
  local procedure GlAcc_AfterValidateIncomeTaxRetentionSubkey(var Rec : Record 15;var xRec : Record 15;CurrFieldNo : Integer);
  var
    Text51000 : TextConst ESP='La clave percerpción IRPF %1 no permite subclave.';
  begin
    WITH Rec DO BEGIN
      CASE NOT TRUE OF
        "Income Tax Retention Key" = 'B',"Income Tax Retention Key" = 'F',"Income Tax Retention Key" = 'G',"Income Tax Retention Key" = 'H',
        "Income Tax Retention Key" = 'I',"Income Tax Retention Key" = 'K',"Income Tax Retention Key" = 'L':
        BEGIN
        END;
        ELSE
          ERROR(Text51000,"Income Tax Retention Key") ;
      END;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure Cust_AfterValidateIncomeTaxRetentionCode(var Rec : Record 18;var xRec : Record 18;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention Code" <> xRec."Income Tax Retention Code" THEN BEGIN
        IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
          "Income Tax Retention %" := recIncomeTaxRetention."Income Tax Retention %"
        ELSE
          "Income Tax Retention %" := 0 ;
      END ;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure Cust_AfterValidateIncomeTaxRetentionKey(var Rec : Record 18;var xRec : Record 18;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    Rec."Income Tax Retention SubKey" := '00' ;
  end;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Income Tax Retention SubKey', false, false)]
  local procedure Cust_AfterValidateIncomeTaxRetentionSubkey(var Rec : Record 18;var xRec : Record 18;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
    Text51000 : TextConst ESP='La clave percerpción IRPF %1 no permite subclave.';
  begin
    WITH Rec DO BEGIN
      CASE NOT TRUE OF
        "Income Tax Retention Key" = 'B',"Income Tax Retention Key" = 'F',"Income Tax Retention Key" = 'G',"Income Tax Retention Key" = 'H',
        "Income Tax Retention Key" = 'I',"Income Tax Retention Key" = 'K',"Income Tax Retention Key" = 'L':
        BEGIN
        END;
        ELSE
          ERROR(Text51000,"Income Tax Retention Key") ;
      END;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure Vend_AfterValidateIncomeTaxRetentionCode(var Rec : Record 23;var xRec : Record 23;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention Code" <> xRec."Income Tax Retention Code" THEN BEGIN
        IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
          "Income Tax Retention %" := recIncomeTaxRetention."Income Tax Retention %"
        ELSE
          "Income Tax Retention %" := 0 ;
      END ;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Income Tax Retention Key', false, false)]
  local procedure Vend_AfterValidateIncomeTaxRetentionKey(var Rec : Record 23;var xRec : Record 23;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    Rec."Income Tax Retention SubKey" := '00' ;
  end;

  [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Income Tax Retention SubKey', false, false)]
  local procedure Vend_AfterValidateIncomeTaxRetentionSubkey(var Rec : Record 23;var xRec : Record 23;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
    Text51000 : TextConst ESP='La clave percerpción IRPF %1 no permite subclave.';
  begin
    WITH Rec DO BEGIN
      CASE NOT TRUE OF
        "Income Tax Retention Key" = 'B',"Income Tax Retention Key" = 'F',"Income Tax Retention Key" = 'G',"Income Tax Retention Key" = 'H',
        "Income Tax Retention Key" = 'I',"Income Tax Retention Key" = 'K',"Income Tax Retention Key" = 'L':
        BEGIN
        END;
        ELSE
          ERROR(Text51000,"Income Tax Retention Key") ;
      END;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 21, 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
  local procedure CopyFromGenJnlLine(var CustLedgerEntry : Record 21;GenJournalLine : Record 81);
  begin
    WITH CustLedgerEntry DO BEGIN
      //"Cod. banco"         := GenJournalLine."Cod. banco" ;   //ACTDGB - Corresponde a REQ07 Tesoreria
      //"Cod. banco inicial" := GenJournalLine."Cod. banco" ;   //ACTDGB - Corresponde a REQ07 Tesoreria

      "Income Tax Retention Code" := GenJournalLine."Income Tax Retention Code";
      "Income Tax Retention %"    := GenJournalLine."Income Tax Retention %";
      "Income Tax Base"           := GenJournalLine."Income Tax Base (LCY)";
      "Amount Tax Retention"      := GenJournalLine."Amount Tax Retention (LCY)";

      "Income Tax Retention Key"    := GenJournalLine."Income Tax Retention Key";
      "Income Tax Retention SubKey" := GenJournalLine."Income Tax Retention SubKey";
    END;
  end;

  [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
  local procedure CopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry : Record 25; GenJournalLine : Record 81);
  begin
    WITH VendorLedgerEntry DO BEGIN
      //"Cod. banco"         := GenJournalLine."Cod. banco" ;   //ACTDGB - Corresponde al REQ07 Tesoreria
      //"Cod. banco inicial" := GenJournalLine."Cod. banco" ;   //ACTDGB - Corresponde al REQ07 Tesoreria

      "Income Tax Retention Code" := GenJournalLine."Income Tax Retention Code";
      "Income Tax Retention %"    := GenJournalLine."Income Tax Retention %";
      "Income Tax Base"           := GenJournalLine."Income Tax Base (LCY)";
      "Amount Tax Retention"      := GenJournalLine."Amount Tax Retention (LCY)";

      "Income Tax Retention Key"    := GenJournalLine."Income Tax Retention Key";
      "Income Tax Retention SubKey" := GenJournalLine."Income Tax Retention SubKey";
    END;
  end;

  [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Bill-to Customer No.', false, false)]
  local procedure SalesHeader_BeforeValidateBillToCustomerNo(var Rec : Record 36;var xRec : Record 36;CurrFieldNo : Integer);
  var
    Cust : Record 18;
  begin
    WITH Rec DO BEGIN
      IF NOT (("Document Type" = "Document Type"::Quote) AND ("Bill-to Customer No." = '')) THEN BEGIN
        IF "Bill-to Customer No." <> Cust."No." THEN
          Cust.GET("Bill-to Customer No.");
      END ELSE
        CLEAR(Cust);

      VALIDATE("Income Tax Retention Code", Cust."Income Tax Retention Code") ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure SalesHeader_AfterValidateIncomeTaxRetentionCode(var Rec : Record 36;var xRec : Record 36;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention Code" <> xRec."Income Tax Retention Code" THEN BEGIN
        IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
          "Income Tax Retention %" := recIncomeTaxRetention."Income Tax Retention %"
        ELSE
          "Income Tax Retention %" := 0 ;
      END ;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
  local procedure SalesLine_AfterValidateNo(var Rec : Record 37;var xRec : Record 37;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    SalesHeader : Record 36;
    Currency : Record 4;
    GLAcc : Record 15;
  begin
    WITH Rec DO BEGIN
      GetSalesHeader(Rec,SalesHeader,Currency) ;
      IF Type <> Type::" " THEN BEGIN
        GenProdPostingGrp.GET("Gen. Prod. Posting Group") ;
        IF NOT GenProdPostingGrp."Allow Income Tax Retention" THEN
          VALIDATE("Income Tax Retention Code",'')
        ELSE
          VALIDATE("Income Tax Retention Code",SalesHeader."Income Tax Retention Code") ;
      END ;
      IF Type = Type::"G/L Account" THEN BEGIN
        GLAcc.GET("No.") ;
        IF (SalesHeader."Income Tax Retention Key" = '') AND
            (SalesHeader."Income Tax Retention SubKey" = '') THEN BEGIN
            IF (GLAcc."Income Tax Retention Key" <> '') OR
              (GLAcc."Income Tax Retention SubKey" <> '') THEN BEGIN
              SalesHeader.VALIDATE("Income Tax Retention Key", GLAcc."Income Tax Retention Key");
              SalesHeader.VALIDATE("Income Tax Retention SubKey", GLAcc."Income Tax Retention SubKey");
          END;
        END ELSE BEGIN
          IF (GLAcc."Income Tax Retention Key" <> '') OR
              (GLAcc."Income Tax Retention SubKey" <> '') THEN BEGIN
            SalesHeader.TESTFIELD("Income Tax Retention Key", GLAcc."Income Tax Retention Key");
            SalesHeader.TESTFIELD("Income Tax Retention Key", GLAcc."Income Tax Retention SubKey");
          END;
        END;
      END ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Gen. Prod. Posting Group', false, false)]
  local procedure SalesLine_AfterValidateGenProdPostingGroup(var Rec : Record 37;var xRec : Record 37;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    SalesHeader : Record 36;
    Currency : Record 4;
  begin
    WITH Rec DO BEGIN
      GetSalesHeader(Rec,SalesHeader,Currency) ;
      GenProdPostingGrp.GET("Gen. Prod. Posting Group") ;
      IF NOT GenProdPostingGrp."Allow Income Tax Retention" THEN
        VALIDATE("Income Tax Retention Code",'')
      ELSE
        VALIDATE("Income Tax Retention Code",SalesHeader."Income Tax Retention Code") ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure SalesLine_AfterValidateIncomeTaxRetentionCode(var Rec : Record 37;var xRec : Record 37;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    SalesHeader : Record 36;
    Currency : Record 4;
    Text56300 : TextConst ESP='No puede elegir una configuración IRPF diferente a la cabecera.';
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      GetSalesHeader(Rec,SalesHeader,Currency) ;
      IF ("Income Tax Retention Code" <> SalesHeader."Income Tax Retention Code") AND ("Income Tax Retention Code" <> '') THEN
        ERROR(Text56300) ;
      IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
        "Income Tax Retencion %" := recIncomeTaxRetention."Income Tax Retention %"
      ELSE
        "Income Tax Retencion %" := 0 ;
      InitOutstandingAmount() ;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
  local procedure PurchaseHeader_AfterValidateBuyFromVendorNo(var Rec : Record 38;var xRec : Record 38;CurrFieldNo : Integer);
  var
    Vend : Record 23;
  begin
    WITH Rec DO BEGIN
      Vend.GET("Buy-from Vendor No.");

      VALIDATE("Income Tax Retention Code", Vend."Income Tax Retention Code") ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Pay-to Vendor No.', false, false)]
  local procedure PurchaseHeader_AfterValidatePaytoVendorNo(var Rec : Record 38;var xRec : Record 38;CurrFieldNo : Integer);
  var
    Vend : Record 23;
  begin
    WITH Rec DO BEGIN
      Vend.GET("Pay-to Vendor No.");

      IF (Vend."Income Tax Retention Key" <> '') OR
         (Vend."Income Tax Retention SubKey" <> '') THEN BEGIN
        VALIDATE("Income Tax Retention Key", Vend."Income Tax Retention Key");
        VALIDATE("Income Tax Retention SubKey", Vend."Income Tax Retention SubKey");
      END;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure PurchaseHeader_AfterValidateIncomeTaxRetentionCode(var Rec : Record 38;var xRec : Record 38;CurrFieldNo : Integer);
  var
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      IF "Income Tax Retention Code" <> xRec."Income Tax Retention Code" THEN BEGIN
        IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
          "Income Tax Retention %" := recIncomeTaxRetention."Income Tax Retention %"
        ELSE
          "Income Tax Retention %" := 0 ;
      END ;
    END ;
  end;

  [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', false, false)]
  local procedure PurchaseLine_AfterValidateNo(var Rec : Record 39;var xRec : Record 39;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    PurchHeader : Record 38;
    GLAcc : Record 15;
  begin
    WITH Rec DO BEGIN
      IF Type <> Type::" " THEN BEGIN
        GenProdPostingGrp.GET("Gen. Prod. Posting Group") ;
        GetPurchaseHeader(Rec, PurchHeader);
        IF NOT GenProdPostingGrp."Allow Income Tax Retention" THEN
          VALIDATE("Income Tax Retention Code",'')
        ELSE
          VALIDATE("Income Tax Retention Code",PurchHeader."Income Tax Retention Code") ;
      END ;

      IF Type = Type::"G/L Account" THEN BEGIN
        GLAcc.GET("No.") ;
        IF (PurchHeader."Income Tax Retention Key" = '') AND
            (PurchHeader."Income Tax Retention SubKey" = '') THEN BEGIN
            IF (GLAcc."Income Tax Retention Key" <> '') OR
              (GLAcc."Income Tax Retention SubKey" <> '') THEN BEGIN
              PurchHeader.VALIDATE("Income Tax Retention Key", GLAcc."Income Tax Retention Key");
              PurchHeader.VALIDATE("Income Tax Retention SubKey", GLAcc."Income Tax Retention SubKey");
          END;
        END ELSE BEGIN
          IF (GLAcc."Income Tax Retention Key" <> '') OR
              (GLAcc."Income Tax Retention SubKey" <> '') THEN BEGIN
            PurchHeader.TESTFIELD("Income Tax Retention Key", GLAcc."Income Tax Retention Key");
            PurchHeader.TESTFIELD("Income Tax Retention Key", GLAcc."Income Tax Retention SubKey");
          END;
        END;
      END ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Gen. Prod. Posting Group', false, false)]
  local procedure PurchaseLine_AfterValidateGenProdPostingGroup(var Rec : Record 39;var xRec : Record 39;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    PurchHeader : Record 38;
  begin
    WITH Rec DO BEGIN
      GenProdPostingGrp.GET("Gen. Prod. Posting Group") ;
      GetPurchaseHeader(Rec, PurchHeader);
      IF NOT GenProdPostingGrp."Allow Income Tax Retention" THEN
        VALIDATE("Income Tax Retention Code",'')
      ELSE
        VALIDATE("Income Tax Retention Code",PurchHeader."Income Tax Retention Code") ;
    END;
  end;

  [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Income Tax Retention Code', false, false)]
  local procedure PurchaseLine_AfterValidateIncomeTaxRetentionCode(var Rec : Record 39;var xRec : Record 39;CurrFieldNo : Integer);
  var
    GenProdPostingGrp : Record 251;
    PurchHeader : Record 38;
    Currency : Record 4;
    Text56300 : TextConst ESP='No puede elegir una configuración IRPF diferente a la cabecera.';
    recIncomeTaxRetention : Record 50123;
  begin
    WITH Rec DO BEGIN
      GetPurchaseHeader(Rec,PurchHeader) ;
      IF ("Income Tax Retention Code" <> PurchHeader."Income Tax Retention Code") AND ("Income Tax Retention Code" <> '') THEN
        ERROR(Text56300) ;
      IF recIncomeTaxRetention.GET("Income Tax Retention Code") THEN
        "Income Tax Retention %" := recIncomeTaxRetention."Income Tax Retention %"
      ELSE
        "Income Tax Retention %" := 0 ;
      InitOutstandingAmount() ;
    END ;
  end;

  procedure GetPurchaseHeader(p_recPurchaseLine : Record 39;var p_recPurchaseHeader : Record 38);
  var
    Currency : Record 4;
  begin
    WITH p_recPurchaseLine DO BEGIN
      TESTFIELD("Document No.");
      IF ("Document Type" <> p_recPurchaseHeader."Document Type") OR ("Document No." <> p_recPurchaseHeader."No.") THEN BEGIN
        p_recPurchaseHeader.GET("Document Type","Document No.");
        IF p_recPurchaseHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          p_recPurchaseHeader.TESTFIELD("Currency Factor");
          Currency.GET(p_recPurchaseHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
      END;
    END;
  end;

  local procedure GetSalesHeader(SalesLine : Record 37;var SalesHeader : Record 36;var Currency : Record 4);
  begin
    WITH SalesLine DO BEGIN
      TESTFIELD("Document No.");
      IF ("Document Type" <> SalesHeader."Document Type") OR ("Document No." <> SalesHeader."No.") THEN BEGIN
        SalesHeader.GET("Document Type","Document No.");
        IF SalesHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          SalesHeader.TESTFIELD("Currency Factor");
          Currency.GET(SalesHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
      END;
    END ;
  end;

  local procedure UpdateControls(var IncomeTaxRetention : Decimal;var IncomeTaxBase : Decimal;var TotalIRPFAmount : Decimal;var IRPFAmountText : Text[30];var IRPFTextVisible : Boolean;var IRPFAmountVisible : Boolean;var TotalIRPFVisible : Boolean;var TotalIRPFTextVisible : Boolean;var "Income Tax BaseVisible" : Boolean);
  var
    Text56300 : TextConst ENU='% Income Tax Retention',ESP='% IRPF';
  begin
    IF IncomeTaxRetention <> 0 THEN BEGIN
        IRPFAmountText           := FORMAT(IncomeTaxRetention) + Text56300 ;
        TotalIRPFAmount          := IncomeTaxBase * IncomeTaxRetention / 100 ;
        IRPFTextVisible          := TRUE ;
        IRPFAmountVisible        := TRUE ;
        TotalIRPFVisible         := TRUE ;
        TotalIRPFTextVisible     := TRUE ;
        "Income Tax BaseVisible" := TRUE ;
      END ELSE BEGIN
        IRPFAmountText           := Text56300 ;
        TotalIRPFAmount          := 0 ;
        IRPFTextVisible          := FALSE ;
        IRPFAmountVisible        := FALSE ;
        TotalIRPFVisible         := FALSE ;
        TotalIRPFTextVisible     := FALSE ;
        "Income Tax BaseVisible" := FALSE ;
    END ;
  end;

  [EventSubscriber(ObjectType::Page, 146, 'OnAfterGetCurrRecordEvent', '', false, false)]
  local procedure OnAfterGetCurrentRecorPurchaseInvoice(var Rec : Record 122);
  var
    IOGTotalIRPFAmount : Decimal;
  begin
    WITH Rec DO BEGIN
      CALCFIELDS("Income Tax Base");
      IOGTotalIRPFAmount := ROUND("Income Tax Base" * "Income Tax Retention %" / 100, 0.01);
      "Amount Including VAT" -= IOGTotalIRPFAmount;
    END ;
  end;
}

