
/// <summary>
/// PageExtension CustomerLookupExtSC (ID 50009) extends Record Customer Lookup.
/// </summary>
/// 
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50009 "CustomerLookupExtSC" extends "Customer Lookup"
{
    layout
    {

        //modify(Name) { Visible = false; }
        //modify("Post Code") { Visible = false; }
        modify("Old Customer No.") { Visible = false; }
        modify("Phone No.") { Visible = false; }
        modify(Contact) { Visible = false; }

        addfirst("Group") { field("AlternativeDebitorNr"; Rec."Old Customer No.") { ApplicationArea = All; ToolTip = 'Specifies the value of the Alternative Customer No. field.'; } }


    }

}
