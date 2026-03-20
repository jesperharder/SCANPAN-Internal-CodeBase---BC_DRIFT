page 50292 ClaimProductUsageReasonList
{
    PageType = List;
    SourceTable = ClaimProductUsageReason;
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Claim Product Usage Reasons';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductUsage; Rec.ProductUsage)
                {
                    ApplicationArea = All;
                }
                field(ReturnReasonCode; Rec.ReturnReasonCode)
                {
                    ApplicationArea = All;
                }
                field(ReturnReasonDescription; Rec.ReturnReasonDescription)
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

