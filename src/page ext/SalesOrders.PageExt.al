

/// <remarks>
/// 
/// Version list
/// 2024.01             Jesper Harder       064         Added the Sell-To CustomerName
/// 2024.09             Jesper Harder       079         Show Alternative Delivery Address on Sales Orders page, item,reference,sales orders
/// </remarks>

pageextension 50115 SalesOrders extends "Sales Orders"
{

    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Sell-To Customer Name"; rec."Sell-To Customer Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sell-To Customer Name field.';
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Code field.', Comment = '%';
            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Name field.', Comment = '%';
            }

        }
    }
}