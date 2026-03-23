page 50285 ClaimAllowedReasonLookupApi
{
    PageType = API;
    APIPublisher = 'scanpan';
    APIGroup = 'claims';
    APIVersion = 'v1.0';
    EntityName = 'claimAllowedReasonLookup';
    EntitySetName = 'claimAllowedReasonLookups';
    SourceTable = ClaimProductUsageReason;
    DelayedInsert = false;
    ODataKeyFields = ProductUsage, ReturnReasonCode;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;
    Caption = 'Claim Allowed Reason Lookup API';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(itemNumber; ItemNumber)
                {
                    Caption = 'Item Number';
                }
                field(productUsage; Rec.ProductUsage)
                {
                    Caption = 'Product Usage';
                }
                field(returnReasonCode; Rec.ReturnReasonCode)
                {
                    Caption = 'Return Reason Code';
                }
                field(returnReasonDescription; Rec.ReturnReasonDescription)
                {
                    Caption = 'Return Reason Description';
                }
                field(sorting; Rec.Sorting)
                {
                    Caption = 'Sorting';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
            }
        }
    }

    var
        ClaimsApiMgt: Codeunit ClaimsApiMgt;
        ItemNumber: Code[20];

    trigger OnOpenPage()
    begin
        if ItemNumber = '' then begin
            Rec.SetRange(ProductUsage, '');
            exit;
        end;

        if not ClaimsApiMgt.GetAllowedReasonsForItem(ItemNumber, Rec) then
            Rec.SetRange(ProductUsage, '');
    end;
}
