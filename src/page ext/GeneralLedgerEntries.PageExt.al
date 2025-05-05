


pageextension 50111 GeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        addafter("External Document No.")
        {
            field("User ID90897";Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}
