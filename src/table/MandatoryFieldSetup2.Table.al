

/// <summary>
/// Table MandatoryFieldSetup (ID 50017).
/// </summary>
/// <remarks>
///
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
///
/// </remarks>


table 50018 "MandatoryFieldSetup2"
{
    Caption = 'Mandatory Field Setup';
    Permissions = 
        tabledata MandatoryFieldSetup2 = rimd;

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
            //LookupPageID = 50000;
            BlankZero = true;
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));

            trigger OnValidate()
            var
            begin
                CalcFields("Field Name");
            end;
        }
        field(4; "Field Name"; Text[250])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Conditional Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Conditional Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));

            trigger OnValidate()
            var
            begin
                CalcFields("Conditional Field Name");
            end;
        }
        field(6; "Conditional Field Name"; Text[250])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                        "No." = field("Conditional Field No.")));
            Caption = 'Conditional Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Condition"; Text[250])
        {
            Caption = 'Condition';
        }
        field(8; "Field Test"; Text[250])
        {
            Caption = 'Field Test';
        }
        field(9; "Logical Operator"; Enum EnumLogicalOperator)
        {
            Caption = 'Logical Operator';
        }

    }
    keys
    {
        key(PK; "Table Type", "Field No.", "Conditional Field No.")
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

    /// <summary>
    /// CheckCust.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    procedure CheckCust(Customer: Record Customer);
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Customer);
        MandatoryFieldSetup2.SetRange("Table Type", MandatoryFieldSetup2."Table Type"::Customer);
        CheckMandatoryFields(MandatoryFieldSetup2, RecordRef);
    end;

    /// <summary>
    /// CheckItem.
    /// </summary>
    /// <param name="Item">Record Item.</param>
    procedure CheckItem(Item: Record Item);
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Item);
        MandatoryFieldSetup2.SETRANGE("Table Type", MandatoryFieldSetup2."Table Type"::Item);
        CheckMandatoryFields(MandatoryFieldSetup2, RecordRef);
    end;

    /// <summary>
    /// CheckVend.
    /// </summary>
    /// <param name="Vendor">Record Vendor.</param>
    procedure CheckVend(Vendor: Record Vendor);
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Vendor);
        MandatoryFieldSetup2.SetRange("Table Type", MandatoryFieldSetup2."Table Type"::Vendor);
        CheckMandatoryFields(MandatoryFieldSetup2, RecordRef);
    end;
    /*
local procedure CheckMandatoryFields(var MandatoryFieldSetup2: Record MandatoryFieldSetup2; RecordRef: RecordRef);
    var
        FieldRef: FieldRef;
    begin
        if MandatoryFieldSetup2.FindSet() then
            if MandatoryFieldSetup2."Conditional Field No." = 0 then
                repeat
                    FieldRef := RecordRef.FIELD(MandatoryFieldSetup2."Field No.");
                    FieldRef.TestField();
                until MandatoryFieldSetup2.Next() = 0
            else
                repeat
                until MandatoryFieldSetup2.Next() = 0;
    end;
    
    */
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

    local procedure CheckMandatoryFields(var MandatoryFieldSetup2: Record MandatoryFieldSetup2; RecordRef: RecordRef);
    var
        FieldRef: FieldRef;
        ConditionalFieldRef: FieldRef;
        TestFieldRef: FieldRef;
        TestFieldValue: Text[250];
        ConditionalFieldValue: Text[250];
        ErrorMessageLbl: Label 'The Condition %1 = "%2" \Applying to field %3 With value "%4" \That must be %5 "%6"', Comment = '%1=Condition, %2=Condition Value, %3=Mandatory FieldName, %4=TestFieldValue, %5=Logical Operator, %6=Test Value';
        ErrorLbl: label 'Error found in Mandatory Field Test.';
        TestOperator: enum EnumLogicalOperator;
        TestResult: Boolean;
    begin
        if MandatoryFieldSetup2.FindSet() then
            repeat
                MandatoryFieldSetup2.CalcFields("Conditional Field Name", "Field Name");
                if MandatoryFieldSetup2."Conditional Field No." = 0 then begin
                    FieldRef := RecordRef.Field(MandatoryFieldSetup2."Field No.");
                    FieldRef.TestField();
                end else begin
                    ConditionalFieldRef := RecordRef.Field(MandatoryFieldSetup2."Conditional Field No.");
                    ConditionalFieldValue := Format(ConditionalFieldRef.Value);
                    TestFieldRef := RecordRef.Field(MandatoryFieldSetup2."Field No.");
                    TestFieldValue := Format(TestFieldRef.Value);
                    TestOperator := MandatoryFieldSetup2."Logical Operator";

                    TestResult := false;
                    if ConditionalFieldValue = MandatoryFieldSetup2.Condition then
                        case TestOperator of
                            TestOperator::"Equal":
                                if TestFieldValue <> MandatoryFieldSetup2."Field Test" then
                                    TestResult := true;
                            TestOperator::"Not":
                                if TestFieldValue = MandatoryFieldSetup2."Field Test" then
                                    TestResult := true;
                        end;
                    //
                    if TestResult = true then begin
                        Message(ErrorMessageLbl,
                            MandatoryFieldSetup2."Conditional Field Name",
                            MandatoryFieldSetup2.Condition,
                            MandatoryFieldSetup2."Field Name",
                            TestFieldValue,
                            TestOperator,
                            MandatoryFieldSetup2."Field Test"


                            );
                        Error(ErrorLbl);

                        //Betingelsen MandatoryFieldSetup2."Conditional Field Name": MandatoryFieldSetup2.Condition
                        //Passer ikke med: MandatoryFieldSetup2."Field Name", værdi TestFieldValue, der skal være Samme Som MandatoryFieldSetup2."Field Test"

                    end;
                end;
            until MandatoryFieldSetup2.Next() = 0;
    end;
}


