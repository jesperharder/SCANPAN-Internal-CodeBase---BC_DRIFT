



/// <summary>
/// PageExtension ItemPlanningFactBox (ID 50101) extends Record Item Planning FactBox.
/// </summary>
pageextension 50097 ItemPlanningFactBox extends "Item Planning FactBox"
{
    layout
    {
        addafter("No.")
        {
            field("ABCD Category31662"; Rec."ABCD Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ABCD Category field.';
            }
        }
    }
}
