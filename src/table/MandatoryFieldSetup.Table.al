/// <summary>
/// Table MandatoryFieldSetup (ID 50017).
/// </summary>
/// <remarks>
///
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
///
/// </remarks>



table 50017 "MandatoryFieldSetup"
{
    ObsoleteState = Removed;
    ObsoleteReason = 'Changes to PK keys';

    Caption = 'Mandatory Field Setup';

    fields
    {
        field(1; "Table Type"; enum EnumTableType)
        {
            Caption = 'Table Type';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
            //LookupPageID = 50000;
            BlankZero = true;

            trigger OnValidate()
            var
            begin
                CalcFields("Field Name");
            end;
        }
        field(4; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
        }
        field(5; "Conditional Field No."; Integer)
        {
            Caption = 'Conditional Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
            BlankZero = true;

            trigger OnValidate()
            var
            begin
                CalcFields("Conditional Field Name");
            end;
        }
        field(6; "Conditional Field Name"; Text[250])
        {
            Caption = 'Conditional Field Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                        "No." = field("Conditional Field No.")));
        }
        field(7; "Condition"; Text[250])
        {
            Caption = 'Condition';
        }
    }
    keys
    {
        key(PK; "Table Type", "Field No.")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    var
    begin
        if Rec."Conditional Field No." = 0 then
            Rec.Condition := '';
    end;

    local procedure CheckMandatoryFields(var MandatoryFieldSetup: Record MandatoryFieldSetup2; RecordRef: RecordRef);
    var
        FieldRef: FieldRef;
    begin
        if MandatoryFieldSetup.FindSet() then
            repeat
                FieldRef := RecordRef.FIELD(MandatoryFieldSetup."Field No.");
                FieldRef.TestField();
            until MandatoryFieldSetup.Next() = 0;
    end;

    /// <summary>
    /// NewRecord.
    /// </summary>
    procedure NewRecord();
    begin
        case "Table Type" of
            "Table Type"::Customer:
                "Table No." := DATABASE::Customer;
            "Table Type"::Vendor:
                "Table No." := DATABASE::Vendor;
            "Table Type"::Item:
                "Table No." := DATABASE::Item;
        end;
    end;

    /// <summary>
    /// CheckItem.
    /// </summary>
    /// <param name="Item">Record Item.</param>
    procedure CheckItem(Item: Record Item);
    var
        MandatoryFieldSetup: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Item);
        MandatoryFieldSetup.SETRANGE("Table Type", MandatoryFieldSetup."Table Type"::Item);
        CheckMandatoryFields(MandatoryFieldSetup, RecordRef);
    end;

    /// <summary>
    /// CheckCust.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    procedure CheckCust(Customer: Record Customer);
    var
        MandatoryFieldSetup: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Customer);
        MandatoryFieldSetup.SetRange("Table Type", MandatoryFieldSetup."Table Type"::Customer);
        CheckMandatoryFields(MandatoryFieldSetup, RecordRef);
    end;

    /// <summary>
    /// CheckVend.
    /// </summary>
    /// <param name="Vendor">Record Vendor.</param>
    procedure CheckVend(Vendor: Record Vendor);
    var
        MandatoryFieldSetup: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Vendor);
        MandatoryFieldSetup.SetRange("Table Type", MandatoryFieldSetup."Table Type"::Vendor);
        CheckMandatoryFields(MandatoryFieldSetup, RecordRef);
    end;
}
