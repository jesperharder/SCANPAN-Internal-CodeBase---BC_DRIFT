



/// <summary>
/// PageExtension Transfer Orders (ID 50062) extends Record Transfer Orders.
/// </summary>
pageextension 50062 "Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addafter(Status)
        {
            field("Container ID NOTO16537"; Rec."Container ID NOTO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Container ID field.';
            }
        }
    }
}
