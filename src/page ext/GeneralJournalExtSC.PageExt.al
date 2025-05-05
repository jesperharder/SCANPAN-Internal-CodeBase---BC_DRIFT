

/// <summary>
/// PageExtension "GeneralJournalExtSC" (ID 50033) extends Record General Journal.
/// </summary>
pageextension 50033 GeneralJournalExtSC extends "General Journal"
{
    layout
    {
        moveafter(Amount; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; ShortcutDimCode3)
        moveafter(ShortcutDimCode3; ShortcutDimCode4)
        moveafter(ShortcutDimCode4; ShortcutDimCode6)
        moveafter(ShortcutDimCode6; ShortcutDimCode8)
        moveafter("Shortcut Dimension 2 Code"; "Gen. Prod. Posting Group")
        moveafter(ShortcutDimCode3; "Currency Code")
        moveafter(ShortcutDimCode3; "Gen. Bus. Posting Group")

        addafter(Amount)
        {
            field("VAT Posting82193"; Rec."VAT Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Posting field.';
            }
            field("VAT Amount73753"; Rec."VAT Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the amount of VAT that is included in the total amount.';
            }
        }
        addafter(Description)
        {
            field("Applies-to Doc. Type92013"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
            }
            field("Applies-to Doc. No.34516"; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
            }
        }


    }

}
