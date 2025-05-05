//SHIPITREMOVE




/// <summary>
/// PageExtension TransportOrderLineSub (ID 50077) extends Record IDYS Transport Order Line Sub..
/// </summary>
/// 
/// <remarks>
/// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
/// 
/// </remarks>

/*
pageextension 50077 "TransportOrderLineSub" extends "IDYS Transport Order Line Sub."
{
    layout
    {
        addlast(Group)
        {
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = all;
                Visible = true;
                ToolTip = 'Displays the Tracking No. from Transport Header.';
            }
        }
    }


}
*/