
page 50298 ClaimYearCodeListPart
{
    PageType = ListPart;
    SourceTable = ClaimYearCode;
    ApplicationArea = All;
    Caption = 'Claim Year Codes';

    layout
    {
        area(content)
        {
            repeater(General)
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


