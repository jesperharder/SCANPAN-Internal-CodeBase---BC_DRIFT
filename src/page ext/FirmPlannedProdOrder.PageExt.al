




/// <summary>
/// PageExtension FirmPlannedProdOrder (ID 50093) extends Record Firm Planned Prod. Order.
/// </summary>
pageextension 50093 "FirmPlannedProdOrder" extends "Firm Planned Prod. Order"
{
    layout
    {
        addafter("Item Feature")
        {
            field("Location Code27160"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
            field("Bin Code66758"; Rec."Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
