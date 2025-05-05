



///
/// 2024.05             Jesper Harder       067         Add fields to facilitate Datawarehouse fields
/// 

pageextension 50108 CountryRegions extends "Countries/Regions"
{
    layout
    {
        addlast(Control1)
        {
            //067
            field("SalesMarket"; Rec."SalesMarket")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Market field.';
            }
            field("Market Type"; Rec."Market Types")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Market Type field.';
            }
            field("Channel Type"; Rec."Channel Types")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Channel Type field.';
            }
        }
    }
}