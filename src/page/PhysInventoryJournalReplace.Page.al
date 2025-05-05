



/// <summary>
/// Page PhysInventoryJournalReplace (ID 50046).
/// </summary>
/// 2024.01             Jesper Harder       062         Search and replace Inventory Journal<remarks>
/// </remarks>
page 50046 PhysInventoryJournalReplace
{

    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Search and Replace';
    PageType = StandardDialog;
    SourceTable = "Item Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            field(FindValue; FindValue)
            {
                Caption = 'Find Value';
                ToolTip = 'Specifies the value of the Find Value field.';
                Editable = true;
            }
            field(ReplaceValue; ReplaceValue)
            {
                Caption = 'Replace Value';
                ToolTip = 'Specifies the value of the Replace Value field.';
                Editable = true;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ReplaceValues)
            {
                Caption = 'Replace Document No.';
                ToolTip = 'Replaces values.';
                ApplicationArea = Basic, Suite;
                Image = ExecuteBatch;
                //Promoted = true;
                //PromotedCategory = Process;
                trigger OnAction()
                begin
                    ReplaceJournalValues();
                end;
            }
        }
    }
    var
        FindValue: Text;
        ReplaceValue: Text;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction = Action::OK then
            ReplaceJournalValues()
        else
            exit(true);
    end;

    local procedure ReplaceJournalValues()
    var
        ItemJournalLine: Record "Item Journal Line";
        NotFoundMsgLbl: Label 'We could not find Document Number #1################################### for replacement.', Comment = '#1################################### = FindValue variable.';
    begin
        ItemJournalLine.SetFilter("Journal Template Name", Rec."Journal Template Name");
        ItemJournalLine.SetFilter("Journal Batch Name", Rec."Journal Batch Name");
#pragma warning disable AA0210
        ItemJournalLine.SetFilter("Document No.", FindValue);
#pragma warning restore AA0210
        if not ItemJournalLine.FindSet() then
            Error(NotFoundMsgLbl, FindValue);
        ItemJournalLine.ModifyAll("Document No.", ReplaceValue);
    end;
}
