/// <summary>
/// Page FieldPage (ID 50004).
/// </summary>
/// <remarks>
///
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
///
/// </remarks>

page 50004 "FieldPage"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Fieldpage';
    PageType = List;
    Permissions =
        tabledata Field = RIMD;
    SourceTable = Field;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater("fields")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID number of the field in the table.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
            }
        }
    }
}