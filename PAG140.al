pageextension 50104 pageextension50104 extends "Posted Purchase Credit Memo" 
{
  // version NAVW110.00.00.17972,NAVES10.00.00.17972,AB.10

  layout
  {
    addafter("Pay-to Contact")
    {
      field("Clave perceptor IRPF";"Income Tax Retention Key")
      {
        Description='REQ-57';
        Editable=false;
      }
      field("Subclave perceptor IRPF";"Income Tax Retention SubKey")
      {
        Description='REQ-57';
        Editable=false;
      }
      field("Código IRPF";"Income Tax Retention Code")
      {
      }
      field("% retención IRPF";"Income Tax Retention %")
      {
      }
      field("Base IRPF";"Income Tax Base")
      {
      }
    }
  }
  var "Income Tax Retention Key":Boolean;
  var "Income Tax Retention SubKey":Boolean;
  var "Income Tax Retention Code":Boolean;
}

