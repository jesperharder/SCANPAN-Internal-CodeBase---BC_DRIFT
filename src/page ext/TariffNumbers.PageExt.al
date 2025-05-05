


/// <summary>
/// PageExtension Tariff Numbers (ID 50086) extends Record Tariff Numbers.
/// </summary>
/// <remarks>
/// 2023.09            Jesper Harder        050         Duty Percentage to Tariff page 
/// </remarks>
pageextension 50086 "Tariff Numbers" extends "Tariff Numbers"
{
    layout
    {
        addlast(Control1)
        {
            field("Duty Percentage"; Rec."Duty Percentage")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Indicates Duty Percentage.';
            }
        }
    }
}
