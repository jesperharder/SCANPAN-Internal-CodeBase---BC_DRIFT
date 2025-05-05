


/// <summary>
/// PageExtension PurchInvoiceSubform (ID 50102) extends Record Purch. Invoice Subform.
/// </summary>
pageextension 50102 "PurchInvoiceSubform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("VAT Bus. Posting Group68701"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
            }
            field("Gen. Bus. Posting Group42916"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
            }
            field("Gen. Prod. Posting Group09345"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            }
            field("Posting Group87451"; Rec."Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Group field.';
            }
        }
        addafter("Line Discount %")
        {
            field("VAT %95732"; Rec."VAT %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT % field.';
            }
            field("VAT Prod. Posting Group43851"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
            }
            field("VAT Calculation Type30350"; Rec."VAT Calculation Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Calculation Type field.';
            }
            field("Amount Including VAT66699"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount Including VAT field.';
            }
        }
    }
}
