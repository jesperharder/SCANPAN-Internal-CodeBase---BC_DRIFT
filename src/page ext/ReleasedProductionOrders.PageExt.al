


/// <summary>
/// PageExtension ""ReleasedProductionOrders"ExtSC" (ID 50051) extends Record Released Production Orders.
/// </summary>
/// <remarks>
/// 
/// 2023.03.17                          Jesper Harder                               008     Released Production Added flowfield for Finished+Remaining Quantity
/// 2023.03.21                          Jesper Harder                               010     List Production Routing Lines 
/// 
/// 
/// </remarks>  

pageextension 50051 ReleasedProductionOrders extends "Released Production Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("Location Code1"; Rec."Location Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
            }
            field("Component Lines Count"; Rec."Component Lines Count")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Component Lines Count field.';
            }
        }

        //008
        addafter(Quantity) { field("Finished Quantity"; Rec."Finished Quantity") { ApplicationArea = all; ToolTip = 'Specifies the value of the Finished Quantity field.'; } }
        addafter("Finished Quantity") { field("Remaining Quantity"; Rec."Remaining Quantity") { ApplicationArea = all; ToolTip = 'Specifies the value of the Remaining Quantity field.'; } }
    }


    actions
    {
        addlast(processing)
        {
            group(scanpan)
            {
                Caption = 'SCANPAN';
                //010
                action(Action1)
                {
                    Caption = 'Production Controlling Routing List';
                    ToolTip = 'Controlling list containing Routing Lines with additional information.';
                    Image = ExplodeRouting;
                    RunObject = page "ProdControllingRoutingLine";
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
