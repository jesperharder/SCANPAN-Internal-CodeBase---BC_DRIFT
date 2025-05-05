/// <summary>
/// PageExtension "BankAccountLedgerEntriesExtSC" (ID 50042) extends Record Bank Account Ledger Entries.
/// </summary>
///
/// <remarks>
/// 2023.03.07                          Jesper Harder           003                     Field Added - External Document No.
/// </remarks>
pageextension 50049 BankAccountLedgerEntriesExtSC extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                Visible = true;
            }
        }
    }
}
