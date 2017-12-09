codeunit 50101 "Extensiones Miscelanea"
{
  // version AB10.01

  // REQ-02 - IRPF
  // REQ-57 - Ampliación IRPF Configuración Modelos


  trigger OnRun();
  begin
  end;

  var
    Text007 : TextConst ENU='Archive %1 no.: %2?',ESP='¿Archivar %1 no.: %2?';
    Text001 : TextConst ENU='Document %1 has been archived.',ESP='Se ha archivado el Documento %1.';
    g_cduArchiveManagement : Codeunit 5063;
    ErrNoPermitidoBorrarRegistro : TextConst ESP='No se puede borrar el registro.';

  [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Bill-to Customer No.', false, false)]
  local procedure SalesHeader_BeforeValidateBillToCustomerNo(var Rec : Record 36;var xRec : Record 36;CurrFieldNo : Integer);
  var
    Cust : Record 18;
  begin
    WITH Rec DO BEGIN
      //Copiado desde la funcion GetCust de TAB36.
      IF NOT (("Document Type" = "Document Type"::Quote) AND ("Bill-to Customer No." = '')) THEN BEGIN
        IF "Bill-to Customer No." <> Cust."No." THEN
          Cust.GET("Bill-to Customer No.");
      END ELSE
        CLEAR(Cust);

      //REQ-57.INI
      IF (Cust."Income Tax Retention Key" <> '') OR
          (Cust."Income Tax Retention SubKey" <> '') THEN BEGIN
        VALIDATE("Income Tax Retention Key", Cust."Income Tax Retention Key");
        VALIDATE("Income Tax Retention SubKey", Cust."Income Tax Retention SubKey");
      END;
      //REQ-57.FIN

    END;
  end;

  [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
  local procedure PurchaseHeader_AfterValidateBuyFromVendorNo(var Rec : Record 38;var xRec : Record 38;CurrFieldNo : Integer);
  var
    Vend : Record 23;
  begin
    WITH Rec DO BEGIN
      Vend.GET("Buy-from Vendor No.");

      //REQ-02.INI
      VALIDATE("Income Tax Retention Code", Vend."Income Tax Retention Code") ;
      //REQ-02.FIN
    END;
  end;
}

