
/// <summary>
/// 2024.07             Jesper Harder       073         Added Creation date and last date modified to Production BOM List and Routing List
/// </summary>
pageextension 50117 "ProductionBOMList" extends "Production BOM List"
{
    layout
    {
        addlast(Control1)
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Creation Date field.';
            }

            field("Last Date Modified1"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Date Modified field.';
            }
        }
    }
}
