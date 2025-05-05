




pageextension 50094 "FirmPlannedProdOrderLines" extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Location Code99517"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the location code, if the produced items should be stored in a specific location.';
            }
            field("Bin Code81857"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bin that the produced item is posted to as output, and from where it can be taken to storage or cross-docked.';
            }
        }
    }
}
