
/// <summary>
/// PageExtension ItemJournalExtSC (ID 50021) extends Record Item Journal.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50021 "ItemJournalExtSC" extends "Item Journal"
{

    layout
    {
        addafter("Location Code")
        {
            field("Bin Code11297"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a bin code for the item.';
            }
        }

        addlast(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the number of the journal line.';
            }
        }
    }
}
