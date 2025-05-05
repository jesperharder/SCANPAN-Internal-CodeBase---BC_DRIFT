/// <summary>
/// 50004 "WhseShipmentSubformExtSC" extends "Whse. Shipment Subform"
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2025.04             Jesper Harder       111.1       Added Shipment Status to Warehouse Shipement lines page
/// 
/// </remarks>

pageextension 50004 "WhseShipmentSubformExtSC" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Pick Qty.58694"; Rec."Pick Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity in pick instructions assigned to be picked for the warehouse shipment line.';
            }
            field("Qty. Picked10389"; Rec."Qty. Picked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many of the total shipment quantity have been registered as picked.';
            }
        }
        // 110.1
        addlast(Control1)
        {
            field("Status"; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the status of the warehouse shipment line.';
            }

        }

    }
}
