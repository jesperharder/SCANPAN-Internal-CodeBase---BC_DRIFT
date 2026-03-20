table 50037 ClaimsSetup
{
    Caption = 'Claims Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; ClaimsEnabled; Boolean)
        {
            Caption = 'Claims Enabled';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(20; ItemPostingGroupFilter; Text[100])
        {
            Caption = 'Item Posting Group Filter';
            DataClassification = CustomerContent;
            InitValue = 'INTERN|EKSTERN|BRUND';
        }
        field(30; DefaultLanguageFallback1; Code[10])
        {
            Caption = 'Language Fallback 1';
            DataClassification = CustomerContent;
            InitValue = 'ENG';
        }
        field(40; DefaultLanguageFallback2; Code[10])
        {
            Caption = 'Language Fallback 2';
            DataClassification = CustomerContent;
            InitValue = 'ENU';
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if PrimaryKey = '' then
            PrimaryKey := 'SETUP';
    end;
}


