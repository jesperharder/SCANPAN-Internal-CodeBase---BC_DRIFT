codeunit 50041 "ClaimsAPIMgt"
{
    //Caption = 'Claims API Management';

    procedure ResolveItemLookup(Item: Record Item; RequestedLanguageCode: Code[10]; var DisplayDescription: Text[100]; var LanguageCodeUsed: Code[10])
    var
        ItemTranslation: Record "Item Translation";
    begin
        if not IsAllowedClaimsItem(Item) then begin
            Clear(DisplayDescription);
            Clear(LanguageCodeUsed);
            exit;
        end;

        DisplayDescription := Item.Description;
        LanguageCodeUsed := '';

        if (RequestedLanguageCode <> '') and TryGetItemTranslation(Item."No.", RequestedLanguageCode, ItemTranslation) then begin
            DisplayDescription := ItemTranslation.Description;
            LanguageCodeUsed := ItemTranslation."Language Code";
            exit;
        end;

        if TryGetItemTranslation(Item."No.", 'ENG', ItemTranslation) then begin
            DisplayDescription := ItemTranslation.Description;
            LanguageCodeUsed := ItemTranslation."Language Code";
            exit;
        end;

        if TryGetItemTranslation(Item."No.", 'ENU', ItemTranslation) then begin
            DisplayDescription := ItemTranslation.Description;
            LanguageCodeUsed := ItemTranslation."Language Code";
            exit;
        end;
    end;

    local procedure TryGetItemTranslation(ItemNo: Code[20]; LanguageCode: Code[10]; var ItemTranslation: Record "Item Translation"): Boolean
    begin
        ItemTranslation.Reset();
        ItemTranslation.SetRange("Item No.", ItemNo);
        ItemTranslation.SetRange("Language Code", LanguageCode);
        exit(ItemTranslation.FindFirst());
    end;

    procedure GetAllowedProductUsageFromItem(ItemNo: Code[20]; var ProductUsage: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        Clear(ProductUsage);

        if not Item.Get(ItemNo) then
            exit(false);

        if not IsAllowedClaimsItem(Item) then
            exit(false);

        ProductUsage := Item."Product Usage";
        exit(ProductUsage <> '');
    end;

    procedure IsAllowedReturnReason(ReturnReasonCode: Code[10]): Boolean
    var
        ReturnReason: Record "Return Reason";
    begin
        if not ReturnReason.Get(ReturnReasonCode) then
            exit(false);

        exit(IsNumericCode(ReturnReason.Code));
    end;

    procedure GetAllowedReasonsForItem(ItemNo: Code[20]; var ClaimProductUsageReason: Record ClaimProductUsageReason): Boolean
    var
        ProductUsage: Code[20];
    begin
        if not GetAllowedProductUsageFromItem(ItemNo, ProductUsage) then
            exit(false);

        ClaimProductUsageReason.Reset();
        ClaimProductUsageReason.SetRange(ProductUsage, ProductUsage);
        ClaimProductUsageReason.SetRange(Blocked, false);
        exit(not ClaimProductUsageReason.IsEmpty());
    end;

    local procedure IsAllowedClaimsItem(Item: Record Item): Boolean
    begin
        exit(
            (Item."Gen. Prod. Posting Group" = 'INTERN') or
            (Item."Gen. Prod. Posting Group" = 'EKSTERN') or
            (Item."Gen. Prod. Posting Group" = 'BRUND'));
    end;

    local procedure IsNumericCode(Value: Code[10]): Boolean
    var
        Index: Integer;
        CharValue: Text[1];
    begin
        if Value = '' then
            exit(false);

        for Index := 1 to StrLen(Value) do begin
            CharValue := CopyStr(Value, Index, 1);
            if (CharValue < '0') or (CharValue > '9') then
                exit(false);
        end;

        exit(true);
    end;
}
