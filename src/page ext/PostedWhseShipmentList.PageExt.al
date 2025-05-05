



/// <summary>
/// PageExtension PostedWhseShipmentList (ID 50079) extends Record Posted Whse. Shipment List.
/// </summary>
/// <remarks>
/// 
/// 2023.7.19                   Jesper Harder           035 Post TransportOrderID posted to Posted Whse. ShipmentLines through 14.7.2023 Added Code
/// 
/// </remarks>      
pageextension 50079 "PostedWhseShipmentList" extends "Posted Whse. Shipment List"
{

    layout
    {
        addafter("Whse. Shipment No.")
        {
            field("Transport Order No."; Rec."Transport Order No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Transport Order No. field.';
            }
        }
        addafter("Whse. Shipment No.")
        {
            field("Assignment Date1"; Rec."Assignment Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Assignment Date field.';
            }
        }

    }
}