





/// <summary>
/// PageExtension PurchaseOrderListExtSC (ID 50048) extends Record Purchase Order List.
/// </summary>
pageextension 50048 "PurchaseOrderListExtSC" extends "Purchase Order List"
{
    layout
    {
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "ITI IIC Created By")
        moveafter("Amount Including VAT"; "Vendor Authorization No.")

        addafter("Job Queue Status")
        {
            field("Container ID NOTO36816"; Rec."Container ID NOTO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Container ID field.';
            }
        }
        addafter("Buy-from Vendor No.")
        {
            field("Promised Receipt Date1"; Rec."Promised Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
            }
        }


    }
}
