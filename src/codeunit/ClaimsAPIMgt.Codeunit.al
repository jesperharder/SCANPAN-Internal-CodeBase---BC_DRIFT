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

        if TryGetPreferredItemTranslation(Item."No.", RequestedLanguageCode, ItemTranslation) then begin
            DisplayDescription := ItemTranslation.Description;
            LanguageCodeUsed := ItemTranslation."Language Code";
            exit;
        end;

        if TryGetPreferredItemTranslation(Item."No.", 'ENG', ItemTranslation) then begin
            DisplayDescription := ItemTranslation.Description;
            LanguageCodeUsed := ItemTranslation."Language Code";
            exit;
        end;
    end;

    procedure ResolveReturnReasonDescription(ReturnReasonCode: Code[10]; RequestedLanguageCode: Code[10]; var DisplayDescription: Text[100]; var LanguageCodeUsed: Code[10])
    var
        ReturnReason: Record "Return Reason";
        ClaimReturnReasonTranslation: Record ClaimReturnReasonTranslation;
        NormalizedLanguageCode: Code[10];
    begin
        Clear(DisplayDescription);
        Clear(LanguageCodeUsed);

        if not ReturnReason.Get(ReturnReasonCode) then
            exit;

        DisplayDescription := ReturnReason.Description;
        NormalizedLanguageCode := NormalizeClaimsLanguageCode(RequestedLanguageCode);

        if (NormalizedLanguageCode <> '') and TryGetClaimReturnReasonTranslation(ReturnReasonCode, NormalizedLanguageCode, ClaimReturnReasonTranslation) then begin
            DisplayDescription := ClaimReturnReasonTranslation.Description;
            LanguageCodeUsed := ClaimReturnReasonTranslation.LanguageCode;
            exit;
        end;

        if TryGetClaimReturnReasonTranslation(ReturnReasonCode, 'ENG', ClaimReturnReasonTranslation) then begin
            DisplayDescription := ClaimReturnReasonTranslation.Description;
            LanguageCodeUsed := ClaimReturnReasonTranslation.LanguageCode;
            exit;
        end;
    end;

    procedure HasEnglishReturnReasonTranslation(ReturnReasonCode: Code[10]): Boolean
    var
        ClaimReturnReasonTranslation: Record ClaimReturnReasonTranslation;
    begin
        exit(TryGetClaimReturnReasonTranslation(ReturnReasonCode, 'ENG', ClaimReturnReasonTranslation));
    end;

    procedure GetEnglishReturnReasonTranslation(ReturnReasonCode: Code[10]; var TranslationText: Text[100]): Boolean
    var
        ClaimReturnReasonTranslation: Record ClaimReturnReasonTranslation;
    begin
        Clear(TranslationText);
        if not TryGetClaimReturnReasonTranslation(ReturnReasonCode, 'ENG', ClaimReturnReasonTranslation) then
            exit(false);

        TranslationText := ClaimReturnReasonTranslation.Description;
        exit(true);
    end;

    local procedure TryGetItemTranslation(ItemNo: Code[20]; LanguageCode: Code[10]; var ItemTranslation: Record "Item Translation"): Boolean
    begin
        ItemTranslation.Reset();
        ItemTranslation.SetRange("Item No.", ItemNo);
        ItemTranslation.SetRange("Language Code", LanguageCode);
        exit(ItemTranslation.FindFirst());
    end;

    local procedure TryGetPreferredItemTranslation(ItemNo: Code[20]; RequestedLanguageCode: Code[10]; var ItemTranslation: Record "Item Translation"): Boolean
    var
        NormalizedLanguageCode: Code[10];
    begin
        NormalizedLanguageCode := NormalizeClaimsLanguageCode(RequestedLanguageCode);
        if NormalizedLanguageCode = '' then
            exit(false);

        case NormalizedLanguageCode of
            'DAN':
                exit(
                    TryGetItemTranslation(ItemNo, 'DAN', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'DA', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'DK-I', ItemTranslation));
            'DEU':
                exit(
                    TryGetItemTranslation(ItemNo, 'DEU', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'DEA', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'DE', ItemTranslation));
            'FRA':
                exit(
                    TryGetItemTranslation(ItemNo, 'FRA', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'FR', ItemTranslation));
            'ENG':
                exit(
                    TryGetItemTranslation(ItemNo, 'ENG', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'ENU', ItemTranslation) or
                    TryGetItemTranslation(ItemNo, 'EN', ItemTranslation));
            else
                exit(TryGetItemTranslation(ItemNo, RequestedLanguageCode, ItemTranslation));
        end;
    end;

    local procedure TryGetClaimReturnReasonTranslation(ReturnReasonCodeValue: Code[10]; LanguageCodeValue: Code[10]; var ClaimReturnReasonTranslation: Record ClaimReturnReasonTranslation): Boolean
    begin
        ClaimReturnReasonTranslation.Reset();
        ClaimReturnReasonTranslation.SetRange(ReturnReasonCode, ReturnReasonCodeValue);
        ClaimReturnReasonTranslation.SetRange(LanguageCode, NormalizeClaimsLanguageCode(LanguageCodeValue));
        exit(ClaimReturnReasonTranslation.FindFirst());
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

    local procedure NormalizeClaimsLanguageCode(LanguageCode: Code[10]): Code[10]
    begin
        case UpperCase(LanguageCode) of
            'DAN', 'DA':
                exit('DAN');
            'DEU', 'DEA', 'DE':
                exit('DEU');
            'FRA', 'FR':
                exit('FRA');
            'ENG', 'ENU', 'EN':
                exit('ENG');
            else
                exit(UpperCase(LanguageCode));
        end;
    end;
}
