





/// <summary>
/// PageExtension PostedWhseShipmentSubform (ID 50074) extends Record Posted Whse. Shipment Subform.
/// </summary>
/// <remarks>
/// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
/// </remarks>
pageextension 50074 "PostedWhseShipmentSubform" extends "Posted Whse. Shipment Subform"
{

    layout
    {
        modify("Source No.") { visible = true; }

        addafter("Source No.")
        {
            field("Transport Order No."; Rec."Transport Order No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Scanpan added Transport Order No.';
                Visible = true;
            }
        }
    }

}