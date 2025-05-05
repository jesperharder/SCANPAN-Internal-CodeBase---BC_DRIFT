



/// <summary>
/// Table Field Selection Table (ID 50016).
/// </summary>
table 50016 "Field Selection Table"
{
    Caption = 'Field Selection Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Table No."; integer)
        {
            Caption = 'Table No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Table Name"; text[50])
        {
            Caption = 'Table Namne';
            DataClassification = ToBeClassified;
        }
        field(3; "Field No."; integer)
        {
            Caption = 'Field No.';
            DataClassification = ToBeClassified;
        }

        field(4; "Field Name"; text[30])
        {
            Caption = 'Field Name';
            DataClassification = ToBeClassified;
        }

    }
}