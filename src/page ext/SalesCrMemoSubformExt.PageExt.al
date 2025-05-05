


/// <summary>
/// PageExtension SalesCrMemoSubformExt (ID 50027) extends Record Sales Cr. Memo Subform.
/// </summary>
/// 
/// <remarks>
/// Version list
/// 2022.12             Jesper Harder       0193        Collected from user designs
/// </remarks>

pageextension 50027 "SalesCrMemoSubformExt" extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Unit Price") { field("Return Reason Code95710"; Rec."Return Reason Code") { ApplicationArea = All; } }


        addafter("Location Code")
        {
            field("Bin Code2"; Rec."Bin Code") { ApplicationArea = All; }
        }
    }
}
