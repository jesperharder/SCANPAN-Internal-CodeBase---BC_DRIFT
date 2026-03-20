page 50306 ClaimYearCodeCard
{
    PageType = Card;
    SourceTable = ClaimYearCode;
    ApplicationArea = All;
    Caption = 'Claim Year Code';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(IntervalFrom; Rec.IntervalFrom)
                {
                    ApplicationArea = All;
                }
                field(IntervalTo; Rec.IntervalTo)
                {
                    ApplicationArea = All;
                }
                field(Sorting; Rec.Sorting)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
