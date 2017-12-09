pageextension 50101 pageextension50101 extends "Purchase Invoice"

{
    // version NAVW110.00.00.18197,NAVES10.00.00.18197,AB

    layout
    {
        addafter(PayToOptions)
        {
                field("Clave perceptor IRPF"; "Income Tax Retention Key")
                {
                    Description = 'REQ-57';
                    Visible = false;
                }
                field("Subclave perceptor IRPF"; "Income Tax Retention SubKey")
                {
                    Visible = false;
                }
                field("Codigo IRPF"; "Income Tax Retention Code")
                {
                }
                field("% retención IRPF"; "Income Tax Retention %")
                {
                }
                field("Base IRPF"; "Income Tax Base")
                {
                }
        }
    }
}

