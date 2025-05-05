


/// <summary>
/// PageExtension VendorCardExtSC (ID 50018) extends Record Vendor Card.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50018 "VendorCardExtSC" extends "Vendor Card"
{
    layout
    {
        addfirst(General) { field("Name 254161"; Rec."Name 2") { ApplicationArea = All; ToolTip = 'Specifies an additional part of the name.'; } }
        addafter("Old Vendor No.") { field("Shipping Agent Code20076"; Rec."Shipping Agent Code") { ApplicationArea = All; ToolTip = 'Specifies the value of the Shipping Agent Code field.'; } }
        addafter("Primary Contact No.") { field("Primary Contact No.06811"; Rec."Primary Contact No.") { ApplicationArea = All; ToolTip = 'Specifies the primary contact number for the vendor.'; } }

    }
}
