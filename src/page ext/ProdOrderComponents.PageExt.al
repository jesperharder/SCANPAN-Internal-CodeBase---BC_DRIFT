





/// <summary>
/// PageExtension ProdOrderComponentsExt (ID 50058) extends Record Prod. Order Components.
/// </summary>
pageextension 50058 "ProdOrderComponents" extends "Prod. Order Components"
{
    layout
    {
        addafter("Remaining Quantity")
        {
            field("Routing Link Code28792"; Rec."Routing Link Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the routing link code when you calculate the production order.';
            }
        }
        addafter("Item No.")
        {
            field("Prod. Order No.1"; Rec."Prod. Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related production order.';
            }
        }
        addafter("Bin Code")
        {
            field("Location Code21264"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the location where the component is stored. It is copied from the corresponding field on the production order line.';
            }
        }


    }
}
