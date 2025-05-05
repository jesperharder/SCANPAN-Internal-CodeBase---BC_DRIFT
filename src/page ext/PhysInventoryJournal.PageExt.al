




/// <summary>
/// PageExtension PhysInventoryJournalSC (ID 50059) extends Record Phys. Inventory Journal.
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.27          Jesper Harder       017         Inventory Journal StockStatus Add Code
/// 2024.01             Jesper Harder       062         Search and replace Inventory Journal
/// </remarks>

pageextension 50059 "PhysInventoryJournal" extends "Phys. Inventory Journal"
{

    actions
    {
        addlast(processing)
        {
            action(InventoryJournalSC)
            {
                Caption = 'Inventory Status';
                ToolTip = 'Invoentory Journal for Shelf status.';
                ApplicationArea = Basic, Suite;
                Image = InventoryJournal;
                RunObject = Page InventoryJournalStatusSC;
            }
            action(ChangeDocumentNo)
            {
                Caption = 'Change Document No.';
                ToolTip = 'Changes Document No.';
                ApplicationArea = Basic, Suite;
                Image = Change;
                trigger OnAction()
                var
                    PhysInventoryJournalReplace: Page PhysInventoryJournalReplace;
                begin
                    PhysInventoryJournalReplace.SetTableView(Rec);
                    PhysInventoryJournalReplace.RunModal();
                    CurrPage.Update(false);
                end;
            }

            action(ScanpanCalculateInventory)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate Inventory';
                Ellipsis = true;
                Image = CalculateInventory;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Start the process of counting inventory by filling the journal with known quantities.';

                trigger OnAction()
                begin
                    CalculateInventory.SetItemJnlLine(Rec);
                    CalculateInventory.RunModal;
                    Clear(CalculateInventory);
                end;
            }

        }
    }
    var
        CalculateInventory: Report "CalculateInventory";

    local procedure ChangeDocumentNo()
    var
    begin

    end;
}