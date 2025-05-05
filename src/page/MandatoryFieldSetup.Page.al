/// <summary>
/// Page MandatoryFieldSetup (ID 50003).
/// </summary>
/// <remarks>
///
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
///
/// </remarks>
page 50003 MandatoryFieldSetup
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Mandatory Field Setup';
    PageType = List;
    Permissions =
        tabledata MandatoryFieldSetup2 = RIMD;
    SourceTable = MandatoryFieldSetup2;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Controls)
            {
                Caption = 'Controls';
                field(TableType2; EnumTableType)
                {
                    Caption = 'Business Area';
                    ToolTip = 'Selects the Business Area for Mandatory Fields.';

                    trigger OnValidate()
                    begin
                        SetTableTypeFilter();
                        CurrPage.Update();
                    end;
                }
            }
            group(RepeaterGroup)
            {
                Caption = 'Mandatory fields';
                repeater("Repeater")
                {
                    field("Field No."; Rec."Field No.")
                    {
                        ShowMandatory = true;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Field No. field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            FieldRec: Record Field;
                        begin

                            FieldRec.SetRange(TableNo, Rec."Table No.");
                            if Page.RunModal(Page::FieldPage, FieldRec) = Action::LookupOK then begin
                                Text := Format(FieldRec."No.");
                                exit(true);
                            end;
                        end;
                    }
                    field("Field Name"; Rec."Field Name")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Field Name field.';
                    }
                    field("Logical Operator"; Rec."Logical Operator")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Logical Operator field.';
                    }
                    field("Field Test"; Rec."Field Test")
                    {
                        Visible = ShowConditionalFields;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Field Test field.';
                    }
                    field("Conditional Field No."; Rec."Conditional Field No.")
                    {
                        Visible = ShowConditionalFields;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Conditional Field No. field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            FieldRec: Record Field;
                        begin

                            FieldRec.SetRange(TableNo, Rec."Table No.");
                            if Page.RunModal(Page::FieldPage, FieldRec) = Action::LookupOK then begin
                                Text := Format(FieldRec."No.");
                                exit(true);
                            end;
                        end;

                    }
                    field("Conditional Field Name"; Rec."Conditional Field Name")
                    {
                        Visible = ShowConditionalFields;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Conditional Field Name field.';
                    }
                    field(Condition; Rec.Condition)
                    {
                        Visible = ShowConditionalFields;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Condition field.';
                    }

                }
            }
        }
    }
    var
        EnumTableType: Enum EnumTableType;
        ShowConditionalFields: Boolean;

    trigger OnOpenPage()
    begin
        EnumTableType := EnumTableType::Item;
        //if UserId.ToLower() = 'jesperharder' then
        ShowConditionalFields := true;
        SetTableTypeFilter();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord();
    end;

    local procedure SetTableTypeFilter()
    begin
        Rec.FilterGroup := 2;
        Rec.SetRange("Table Type", EnumTableType);
        Rec.FilterGroup := 0;
    end;
}