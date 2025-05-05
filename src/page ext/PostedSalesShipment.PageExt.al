
/// <summary>
/// PageExtension PostedSalesShipmentextSC (ID 50015) extends Record Posted Sales Shipment.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12                     Jesper Harder                   0193        Added modifications
/// 2023.05.01                  Jesper Harder                   027         Add Shipment tracking 
/// 
/// </remarks>

/*
pageextension 50015 "PostedSalesShipment" extends "Posted Sales Shipment"
{
    layout
    {
        //SHIPITREMOVE
        addafter("IDYS Account No.")
        {
            field("IDYS Tracking No.77258"; Rec."IDYS Tracking No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ShipIT Tracking No. field.';
            }
            field("IDYS Tracking URL95913"; Rec."IDYS Tracking URL")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ShipIT Tracking URL field.';
            }
        }
    }
    //SHIPITREMOVE
    actions
    {
        addfirst("&Shipment")
        {
            action(LookupTransportOrderLines)
            {
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Category5;

                Caption = 'Lookup Transport Order';
                RunObject = page "IDYS Transport Order Lines";
                RunPageLink = "Source Document No." = field("Order No.");
                ToolTip = 'Executes the Lookup Transport Order action.';
            }
        }
    }

}
*/