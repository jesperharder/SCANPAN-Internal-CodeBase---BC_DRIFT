




/// <summary>
/// PageExtension CapacityLedgerEntries (ID 50090) extends Record Capacity Ledger Entries.
/// </summary>
pageextension 50090 CapacityLedgerEntries extends "Capacity Ledger Entries"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Stop Time1"; Rec."Stop Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the stop time of this entry.';
            }
            field("Stop Code1"; Rec."Stop Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the stop code.';
            }
        }
    }
}
