


/// <summary>
/// PageExtension "ProductionJournalExtSC" (ID 50040) extends Record Production Journal.
/// </summary>
pageextension 50040 ProductionJournalExtSC extends "Production Journal"
{

    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Location Code69956"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
            }
            field("Bin Code09877"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a bin code for the item.';
            }
        }

        addlast(General)
        {
            field("Output Quantity1"; Rec."Output Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity of the produced item that can be posted as output on the journal line.';
            }
        }
    }





}
