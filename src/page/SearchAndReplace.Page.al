



/// <summary>
/// Page SearchAndReplace (ID 50038).
/// </summary>
page 50038 "SearchAndReplace"
{
    AdditionalSearchTerms = 'SCANPAN';
    Caption = 'Search and Replace';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = all;

    SourceTable = "Field Selection Table";


    layout
    {
        area(Content)
        {
            repeater(Customers)
            {

                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Type the Table Number here.';
                    ApplicationArea = All;
                    TableRelation = field.TableNo;
                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                    begin
                        FieldRec.SetRange(TableNo, Rec."Table No.");
                        if FieldRec.FindFirst() then
                            Rec."Table Name" := FieldRec.TableName;
                    end;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Displays the Table Name from selected Table Number.';
                    ApplicationArea = All;

                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Type the Field Number.';
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        FieldSelect: Codeunit "Field Selection";
                    begin
                        FieldRec.SetRange(TableNo, rec."Table No.");
                        FieldRec.FindSet();
                        FieldSelect.Open(FieldRec);
                        Rec."Field No." := FieldRec."No.";
                        rec."Field Name" := FieldRec.FieldName;
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Displays the Fild Name from selected Field Number.';
                    ApplicationArea = All;

                }
            }
        }
    }

    var


    trigger OnInit()
    begin
        //Rec.SetFilter("Table No.",'37');
    end;


}