


/// <summary>
/// PageExtension PuhCrMemoSubform (ID 50071) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 50071 "PuhCrMemoSubform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Item Reference No.")
        {
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("VAT Prod. Posting Group2"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
            }
        }
        addafter("Location Code")
        {
            field("Bin Code1"; Rec."Bin Code")
            {
                ApplicationArea = All;
            }
        }

    }
}
