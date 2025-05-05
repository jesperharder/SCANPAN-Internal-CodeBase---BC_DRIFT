




/// <summary>
/// PageExtension PostedWhseShipment (ID 50072) extends Record Posted Whse. Shipment.
/// </summary>
/// <remarks>
/// 
/// 2023.7.19                   Jesper Harder           035 Post TransportOrderID posted to Posted Whse. ShipmentLines through 14.7.2023 Added Code
/// 
/// </remarks>      

pageextension 50072 "PostedWhseShipment" extends "Posted Whse. Shipment"
{

    layout
    {
        addafter("Whse. Shipment No.")
        {
            field("Transport Order No."; Rec."Transport Order No.")
            {
                ToolTip = 'Specifies the value of the Transport Order No. field.';
                ApplicationArea = Warehouse;
                Editable = false;
                Visible = true;
            }
        }
    }
}