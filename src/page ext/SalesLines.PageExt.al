


/// <summary>
/// PageExtension Sales Lines (ID 50064) extends Record Sales Lines.
/// </summary>
pageextension 50064 "Sales Lines" extends "Sales Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Customer Price Group73588"; Rec."Customer Price Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Price Group field.';
            }
        }
    }
}
