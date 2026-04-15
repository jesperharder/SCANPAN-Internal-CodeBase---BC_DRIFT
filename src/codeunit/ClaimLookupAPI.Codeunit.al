codeunit 50045 "Claim Lookup API"
{
    procedure GetItemLookup(ItemNo: Code[20]; RequestedLanguageCode: Code[10]): Text
    var
        Item: Record Item;
        ClaimsApiMgt: Codeunit ClaimsAPIMgt;
        Payload: JsonObject;
        DisplayDescription: Text[100];
        LanguageCodeUsed: Code[10];
    begin
        if ItemNo = '' then
            Error('ItemNo is required.');

        if not Item.Get(ItemNo) then
            exit('');

        ClaimsApiMgt.ResolveItemLookup(Item, RequestedLanguageCode, DisplayDescription, LanguageCodeUsed);
        if DisplayDescription = '' then
            exit('');

        Payload.Add('number', Item."No.");
        Payload.Add('description', DisplayDescription);
        Payload.Add('baseDescription', Item.Description);
        Payload.Add('productUsage', Item."Product Usage");
        Payload.Add('languageCodeUsed', LanguageCodeUsed);
        Payload.Add('blocked', Item.Blocked);
        Payload.Add('salesBlocked', Item."Sales Blocked");

        exit(FormatJsonObject(Payload));
    end;

    procedure GetAllowedReasons(ItemNo: Code[20]; RequestedLanguageCode: Code[10]): Text
    var
        ClaimProductUsageReason: Record ClaimProductUsageReason;
        ClaimsApiMgt: Codeunit ClaimsAPIMgt;
        Payload: JsonArray;
        ReasonObject: JsonObject;
        DisplayDescription: Text[100];
        LanguageCodeUsed: Code[10];
    begin
        if ItemNo = '' then
            Error('ItemNo is required.');

        if not ClaimsApiMgt.GetAllowedReasonsForItem(ItemNo, ClaimProductUsageReason) then
            exit('[]');

        ClaimProductUsageReason.SetCurrentKey(ProductUsage, Sorting, ReturnReasonCode);
        if ClaimProductUsageReason.FindSet() then
            repeat
                ClaimsApiMgt.ResolveReturnReasonDescription(
                    ClaimProductUsageReason.ReturnReasonCode,
                    RequestedLanguageCode,
                    DisplayDescription,
                    LanguageCodeUsed);

                Clear(ReasonObject);
                ReasonObject.Add('code', ClaimProductUsageReason.ReturnReasonCode);
                ReasonObject.Add('description', DisplayDescription);
                ReasonObject.Add('languageCodeUsed', LanguageCodeUsed);
                ReasonObject.Add('sorting', ClaimProductUsageReason.Sorting);
                Payload.Add(ReasonObject);
            until ClaimProductUsageReason.Next() = 0;

        exit(FormatJsonArray(Payload));
    end;

    local procedure FormatJsonObject(Obj: JsonObject): Text
    var
        Result: Text;
    begin
        Obj.WriteTo(Result);
        exit(Result);
    end;

    local procedure FormatJsonArray(Arr: JsonArray): Text
    var
        Result: Text;
    begin
        Arr.WriteTo(Result);
        exit(Result);
    end;
}
