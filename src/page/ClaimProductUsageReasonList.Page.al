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
                    ToolTip = 'Specifies the product usage that controls which claim reasons are allowed.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NotoItemCategory: Record "NOTO Item Categories";
                    begin
                        NotoItemCategory.Reset();
                        NotoItemCategory.SetRange("Category Code", NotoItemCategory."Category Code"::ProductUsage);

                        if Page.RunModal(Page::ClaimProductUsageLookup, NotoItemCategory) = Action::LookupOK then begin
                            Rec.Validate(ProductUsage, NotoItemCategory.Code);
                            exit(true);
                        end;

                        exit(false);
                    end;
                }
                field(ProductUsageDescription; Rec.ProductUsageDescription)
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
