




/// <summary>
/// PageExtension User Setup (ID 50084) extends Record User Setup.
/// </summary>
/// 
/// <remarks>
/// 2023.09             Jesper Harder       047         Restrict changes to user setup and General ledger posting dates
/// </remarks>
/// 
pageextension 50085 "User Setup" extends "User Setup"
{

    layout
    {
        addlast(Control1)
        {
            field("Allow Edit Posting Dates"; Rec."Allow Edit Posting Dates")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Checking this field enables the user permission to edit the allowed posting dates in User Setup and in General ledger setup.';
            }
        }
    }
}