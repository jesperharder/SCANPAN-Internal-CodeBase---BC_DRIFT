



/// <summary>
/// PageExtension Firm Planned Prod. Orders (ID 50087) extends Record Firm Planned Prod. Orders.
/// </summary>
pageextension 50088 "Firm Planned Prod. Orders" extends "Firm Planned Prod. Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("Component Lines Count"; Rec."Component Lines Count")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Component Lines Count field.';
            }
        }

    }
}