





/// <summary>
/// PageExtension PostedSalesShptSubform (ID 50075) extends Record Posted Sales Shpt. Subform.
/// </summary>
/// <remarks>
/// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
/// </remarks>
pageextension 50075 "PostedSalesShptSubform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addbefore("No.")
        {
            /*    
                field("Transport Order Id"; Rec."Transport Order No2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transport Order No.';
                    ToolTip = 'Scanpan Transport Order No.';
                    Visible = true;
                }
            */
        }
    }
}
