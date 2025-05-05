

/// <summary>
/// PageExtension PostedPurchaseInvoicesExtSC (ID 50052) extends Record Posted Purchase Invoices.
/// </summary>
pageextension 50052 "PostedPurchaseInvoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice No.32929"; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s own invoice number.';
            }
            field("Applies-to Doc. No.25479"; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
            }
        }
        addafter(Closed)
        {
            field("Drop Shipment"; Rec."Drop Shipment")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Indicates if lines has Drop Shipment.';
                Visible = true;
            }

        }
    }
}
