
/// <summary>
/// PageExtension CDOUnhandledPurchaseOrderExtSC (ID 50019) extends Record CDO Unhandled Purchase Order.
/// </summary>
/// s
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50019 "CDOUnhandledPurchaseOrderExtSC" extends "CDO Unhandled Purchase Order"
{
    layout
    {
        addafter("1000000013")
        {
            field("Container ID NOTO02765"; Rec."Container ID NOTO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Container ID field.';
            }
            field("Bill of Lading No. NOTO11584"; Rec."Bill of Lading No. NOTO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill of Lading No. field.';
            }
        }
    }
}
