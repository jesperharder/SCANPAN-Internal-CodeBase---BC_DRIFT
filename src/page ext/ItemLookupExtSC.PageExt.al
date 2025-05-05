

/// <summary>
/// pageextension 50006 "ItemLookupExtSC" extends "Item Lookup"
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50006 "ItemLookupExtSC" extends "Item Lookup"
{

    layout
    {
        modify("Unit Price") { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        modify("Vendor No.") { Visible = false; }
        modify("Vendor Item No.") { Visible = false; }
        modify("Routing No.") { Visible = false; }

        addafter("Unit Cost") { field(Inventory1; Rec.Inventory) { ApplicationArea = All; ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.'; } }
        addafter(Inventory1) { field("Calculated Available NOTO1"; "Calculated Available NOTO") { ApplicationArea = all; ToolTip = 'Specifies the value of the Calculated Available field.'; } }

    }

}


