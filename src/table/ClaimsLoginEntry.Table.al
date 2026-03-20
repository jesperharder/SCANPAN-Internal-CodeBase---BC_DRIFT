table 50040 "ClaimsLoginEntry"
{
    Caption = 'Claims Login Entry';
    DataClassification = CustomerContent;

    fields
    { 
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(10; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
        field(20; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
        }
        field(30; Username; Text[100])
        {
            Caption = 'Username';
        }
        field(40; Password; Text[100])
        {
            Caption = 'Password';
        }
        field(50; Authenticated; Boolean)
        {
            Caption = 'Authenticated';
            Editable = false;
        }
        field(60; Ledger; Code[10])
        {
            Caption = 'Ledger';
            Editable = false;
        }
        field(70; "Company Id"; Guid)
        {
            Caption = 'Company Id';
            Editable = false;
        }
        field(80; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
        }
        field(90; Name; Text[100])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(100; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            Editable = false;
        }
        field(110; "Allow Qty On Claims"; Boolean)
        {
            Caption = 'Allow Qty On Claims';
            Editable = false;
        }
        field(120; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
