



pageextension 50109 ProductionBOMLines extends "Production BOM Lines"
{
    layout
    {
        addafter("Routing Link Code")
        {
            field("Starting Date1"; Rec."Starting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Starting Date field.';
            }
            field("Ending Date1"; Rec."Ending Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ending Date field.';
            }
        }
    }
}
