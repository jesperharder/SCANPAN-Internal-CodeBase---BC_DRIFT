


/// <summary>
/// PageExtension "WhseShipmentLineExtSC" (ID 50029) extends Record Whse. Shipment Lines.
/// </summary>
/// 
/// <remarks>
/// 3.1.2023            Jesper Harder                      Extends page
/// </remarks>
pageextension 50029 WhseShipmentLineExtSC extends "Whse. Shipment Lines"
{
    layout
    {
        addafter("Item No.") { field("Completely Picked1"; "Completely Picked") { ApplicationArea = All; ToolTip = 'Specifies the value of the Completely Picked field.'; } }
    }
}
