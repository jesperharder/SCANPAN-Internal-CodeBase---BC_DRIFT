




/// <summary>
/// PageExtension ReleasedProdOrderLines (ID 50066) extends Record Released Prod. Order Lines.
/// </summary>
/// <remarks>
/// 
/// 2023.04.27          Jesper Harder       026         Add Location Code from ProdOrdHeader to Lines 27.4.2023
/// 
/// </remarks>
pageextension 50066 "ReleasedProdOrderLines" extends "Released Prod. Order Lines"
{
    layout
    {
        modify("Location Code") { Visible = true; }
        modify("Bin Code") { Visible = true; }
        movelast(Control1; "Location Code")
        movelast(Control1; "Bin Code")

        addafter("Remaining Quantity")
        {
            field("Planning Flexibility07146"; Rec."Planning Flexibility")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.';
            }
        }

    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin

        Rec.TestField("Location Code");

    end;
}