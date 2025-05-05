


pageextension 50047 PostedSalesShipments extends "Posted Sales Shipments"
{
    /// <summary>
    /// PageExtension ""PostedSalesShipments"ExtSC" (ID 50047) extends Record Posted Sales Shipments.
    /// </summary>
    /// 
    /// <remarks>
    /// 
    /// 2023.03.08          Jesper Harder       0193        Added description field
    /// 2023.05.01          Jesper Harder       027         Add Shipment tracking 
    /// 2024.07             Jesper Harder       072         Pallet Manifest v2 fetch from new tasklet tables and use PostedSalesShipment as base table
    /// 
    /// </remarks>
    /// 


    layout
    {
        addlast(Control1)
        {
            //072
            field(PostedWhseShipmentNo; PostedWhseShipmentNo)
            {
                ToolTip = 'Specifies the value of the Posted Whse. Shipment No.';
                ApplicationArea = Basic, Suite;
            }

            /* ShipIT remove
            field("Transport Order No."; Rec."Transport Order No.")
            {
                ToolTip = 'Specifies the value of the Transport Order No. field.';
                ApplicationArea = Basic, Suite;
            }
            */
        }
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ToolTip = 'Sales Order No.';
                ApplicationArea = Basic, Suite;
                Visible = true;
                Importance = Additional;
            }
        }
        addafter("No. Printed")
        {
            field("External Document No.1"; Rec."External Document No.")
            {
                ToolTip = 'External Document No. from Sales Order.';
                ApplicationArea = All;
                Visible = true;
            }
            field("Posting Date1"; Rec."Posting Date")
            {
                ToolTip = 'Posting Date.';
                ApplicationArea = All;
                Visible = true;
            }
        }
        addafter("External Document No.1")
        {
            field("Requested Delivery Date1"; Rec."Requested Delivery Date")
            {
                ApplicationArea = All;
            }
        }

    }


    

    //SHIPITREMOVE
    /*
    actions
    {
        addfirst("&Shipment")
        {
            action(LookupTransportOrderLines)
            {
                Image = Find;
                Caption = 'Lookup Transport Order';
                ToolTip = 'Displays all Transport Orders from this Sales Order.';
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = page "IDYS Transport Order Lines";
                RunPageLink = "Source Document No." = field("Order No.");

            }
        }
    }
    */

}
