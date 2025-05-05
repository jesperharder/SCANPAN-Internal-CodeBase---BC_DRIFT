



/// <summary>
/// PageExtension ReleasedProductionOrder (ID 50065) extends Record Released Production Order.
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.04.27          Jesper Harder       026         Add Location Code from ProdOrdHeader to Lines 27.4.2023
/// 
/// </remarks>
pageextension 50065 "ReleasedProductionOrder" extends "Released Production Order"
{

    layout
    {

        addlast(General)
        {
            group(scanpan)
            {
                ShowCaption = false;
                field("Location Code1"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Visible = true;
                    ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
                }
                field("Bin Code1"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                    Visible = true;
                    ToolTip = 'Specifies a bin to which you want to post the finished items.';
                }
            }
        }

    }


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    //text000: Label 'Location Code is mandatory.';
    begin
        Rec.TestField("Location Code");
        //if Rec."Location Code" = '' then error('Husk lokationskode');
    end;
}