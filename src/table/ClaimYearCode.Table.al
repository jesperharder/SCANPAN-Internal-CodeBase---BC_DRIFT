table 50038 ClaimYearCode
{
    Caption = 'Claim Year Code';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; IntervalFrom; Date)
        {
            Caption = 'Interval From';
            DataClassification = CustomerContent;
        }
        field(30; IntervalTo; Date)
        {
            Caption = 'Interval To';
            DataClassification = CustomerContent;
        }
        field(40; Sorting; Integer)
        {
            Caption = 'Sorting';
            DataClassification = CustomerContent;
        }
        field(50; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(SortingKey; Sorting, Code)
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateInterval();
    end;

    trigger OnModify()
    begin
        ValidateInterval();
    end;

    local procedure ValidateInterval()
    begin
        if (IntervalFrom <> 0D) and (IntervalTo <> 0D) and (IntervalFrom > IntervalTo) then
            Error('Interval From must be on or before Interval To.');
    end;
}

