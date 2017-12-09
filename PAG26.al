pageextension 50100 pageextension50100 extends "Vendor Card"
{
    // version NAVW110.00.00.18197,NAVES10.00.00.18197,AB

    layout
    {
        addafter(Receiving)
        {
            group(IRPF)
            {
                CaptionML = ENU = 'Income Tax',
                ESP = 'IRPF';
                field("Código IRPF"; "Income Tax Retention Code")
                {

                }
                /*field("% IRPF"; "Income Tax Retention %")
                {
                }*/

                field("Clave perceptor IRPF"; "Income Tax Retention Key")
                {
                }
                field("Subclave perceptor IRPF"; "Income Tax Retention SubKey")
                {
                }
                /*field("Retención IRPF"; "Tax Amount Retention")
                {
                }*/
            }
                       

        }
    }
}

