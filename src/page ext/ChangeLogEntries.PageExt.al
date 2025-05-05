



/// <summary>
/// PageExtension ChangeLogEntries (ID 50095) extends Record Change Log Entries.
/// </summary>
pageextension 50095 "ChangeLogEntries" extends "Change Log Entries"
{
    layout
    {
        addafter("Table Caption")
        {
            field("Table No.44238"; Rec."Table No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the table containing the changed field.';
            }
            field("Primary Key16202"; Rec."Primary Key")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the primary key or keys of the changed field.';
            }
        }
    }
}
