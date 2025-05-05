



/// <summary>
/// PageExtension Routing List (ID 50063) extends Record Routing List.
/// 2024.07             Jesper Harder       073         Added Creation date and last date modified to Production BOM List and Routing List
/// </summary>
pageextension 50063 "Routing List" extends "Routing List"
{
    layout
    {
        addafter(Description)
        {
            field(Status99786; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the status of this routing.';
            }
        }
        addlast(Control1)
        {
            field("Last Date Modified1"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Date Modified field.';
            }
        }

    }
}
