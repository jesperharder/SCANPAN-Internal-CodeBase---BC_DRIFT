


/// <summary>
/// PageExtension "PostedSalesInvociesExtSC" (ID 50054) extends Record Posted Sales Invoices.
/// </summary>
///
/// <remarks>
/// 
/// 2023.03.22                     Jesper Harder                       011     Posted Sales Invoices Extends Add fields for better search
/// 
/// </remarks>      
pageextension 50054 PostedSalesInvoices extends "Posted Sales Invoices"
{

    layout
    {
        addlast(Control1)
        {
            //011
            field("Order No.1"; Rec."Order No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
                Visible = true;
            }
            field("External Document No.1"; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
                Visible = true;
            }
            field("Drop Shipment"; Rec."Drop Shipment")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Indicates if lines has Drop Shipment.';
                Visible = true;
            }
        }
    }
    views
    {
        addlast
        {
            view("TollSystemShip")
            {
                Caption = 'Ship to Toll System';
                Filters = where("Toll System Sent NOTO" = const(false));
                OrderBy = descending("No.");
                SharedLayout = true;
            }

        }
    }
}

