
/// <summary>
/// PageExtension ItemReclassJournalExtSC (ID 50023) extends Record Item Reclass. Journal.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50023 "ItemReclassJournalExtSC" extends "Item Reclass. Journal"
{

    layout
    {
        addafter("Location Code") { field("Bin Code1"; Rec."Bin Code") { ApplicationArea = All; ToolTip = 'Specifies a bin code for the item.'; } }
        addafter("New Location Code") { field("New Bin Code1"; Rec."New Bin Code") { ApplicationArea = All; ToolTip = 'Specifies the new bin code to link to the items on this journal line.'; } }
    }
}
