//SHIPITREMOVE

/// <summary>
/// PageExtension "IDYSTransportOrderLines" (ID 50067) extends Record IDYS Transport Order Lines.
/// </summary>
/// <remarks>
/// 2023.05.01                  Jesper Harder                   027         Add Shipment tracking
/// </remarks>
///

/*
pageextension 50067 "IDYSTransportOrderLines" extends "IDYS Transport Order Lines"
{

    layout
    {
        addafter("Line No.") { field("Document Date"; Rec."Document Date") { ApplicationArea = all; Visible = true; ToolTip = 'Specifies the value of the Transport Order Document Date field.'; } }
    }

}
*/