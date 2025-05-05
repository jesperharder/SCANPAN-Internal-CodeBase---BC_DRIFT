



/// <summary>
/// PageExtension ValueEntries (ID 50103) extends Record Value Entries.
/// </summary>
pageextension 50103 "ValueEntries" extends "Value Entries"
{
    layout
    {
        addafter(Adjustment)
        {
            field("Salespers./Purch. Code80122"; Rec."Salespers./Purch. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which salesperson or purchaser is linked to the entry.';
            }
        }
    }
}
