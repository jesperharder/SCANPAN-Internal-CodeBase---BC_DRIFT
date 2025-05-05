
pageextension 50070 "PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform"
{
    /// <remarks>
    /// 2023.05.12          Jesper Harder       031         Added CountryRegion FlowField to Posted Invoices
    /// 2024.02             Jesper Harder                   Added Net+Gross weight fields
    /// 2025.01             Jesper Harder       031.02      Added Amount Including VAT
    /// </remarks>


    layout
    {
        addafter("Line Amount")
        {
            field("Country/Region Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Country/Region of Origin Code field.';
                Visible = true;
            }
        }
        // 031.2
        addafter("Line Amount")
        {
            field("Amount Including VAT1"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the net amount, including VAT, for this line.';
                Visible = true;
            }
        }
        addlast(Control1)
        {
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Net Weight field.';
                Visible = true;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Gross Weight field.';
                Visible = true;
            }

        }
    }

}
