tableextension 50119 tableextension50119 extends "Sales/Purch. Book VAT Buffer"
{
  // version NAVES7.00,AB10.01

  fields
  {
    field(7107393;"Income Tax Amount";Decimal)
    {
      Description='REQ-02';
    }
    field(7107394;"IRPF %";Decimal)
    {
      Description='REQ-02';
    }
  }
  keys
  {
  }
}
