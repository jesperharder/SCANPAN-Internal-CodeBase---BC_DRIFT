




/// <summary>
/// PageExtension FinishedProduction Orders (ID 50098) extends Record Finished Production Orders.
/// </summary>
pageextension 50098 "FinishedProductionOrders" extends "Finished Production Orders"
{
    layout
    {
        addafter("Due Date")
        {
            field("Finished Date91039"; Rec."Finished Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the actual finishing date of a finished production order.';
            }
        }
        addafter("Ending Date-Time")
        {
            field("Prod. Group Code75969"; Rec."Prod. Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Group Code field.';
            }
        }
        addafter("Ending Date-Time")
        {
            field("Location Code50327"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
            }
        }

    }
}
