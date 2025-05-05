
/// <summary>
/// PageExtension ItemCrossReferenceEntriesExtSC (ID 50003) extends Record Item Reference Entries.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>



pageextension 50003 "ItemReferenceEntries" extends "Item Reference Entries"
{
    layout
    {
        addfirst(Control1) { field("Item No."; Rec."Item No.") { ApplicationArea = All; ToolTip = 'Specifies the number on the item card from which you opened the Item Reference Entries window.'; } }
    }
}
