codeunit 50044 "Claim Basket Intake API"
{
    procedure ReceiveBasket(BasketJson: Text): Text
    var
        Basket: JsonObject;
        LinesToken: JsonToken;
        Lines: JsonArray;
        LineToken: JsonToken;
        LineObject: JsonObject;
        Receipt: JsonObject;
        ClaimRowIds: JsonArray;
        SharedCreatedDateTime: DateTime;
        SharedBuyDateTime: DateTime;
        InsertedCount: Integer;
        ClaimId: Integer;
    begin
        if DelChr(BasketJson, '<>', ' ') = '' then
            Error('BasketJson is required.');

        if not Basket.ReadFrom(BasketJson) then
            Error('BasketJson is not valid JSON.');

        if not Basket.Get('lines', LinesToken) then
            Error('Basket lines are required.');

        if not LinesToken.IsArray() then
            Error('lines must be a JSON array.');

        Lines := LinesToken.AsArray();
        if Lines.Count() = 0 then
            Error('Basket must contain at least one line.');

        SharedCreatedDateTime := GetOptionalDateTime(Basket, 'createdDate', CurrentDateTime());
        SharedBuyDateTime := GetOptionalDateTime(Basket, 'buyDate', SharedCreatedDateTime);

        foreach LineToken in Lines do begin
            if not LineToken.IsObject() then
                Error('Each basket line must be a JSON object.');

            LineObject := LineToken.AsObject();
            ClaimId := InsertClaimLine(Basket, LineObject, SharedCreatedDateTime, SharedBuyDateTime);
            ClaimRowIds.Add(ClaimId);
            InsertedCount += 1;
        end;

        Receipt.Add('accepted', true);
        Receipt.Add('createdDate', Format(SharedCreatedDateTime, 0, 9));
        Receipt.Add('insertedCount', InsertedCount);
        Receipt.Add('claimRowIds', ClaimRowIds);

        exit(FormatJson(Receipt));
    end;

    local procedure InsertClaimLine(Basket: JsonObject; BasketLine: JsonObject; SharedCreatedDateTime: DateTime; SharedBuyDateTime: DateTime): Integer
    var
        NotoClaim: Record "NOTO Claims";
        ClaimId: Integer;
    begin
        ValidateHeader(Basket);
        ValidateLine(BasketLine);

        ClaimId := GetNextClaimId();

        NotoClaim.Init();
        NotoClaim.ID := ClaimId;
        NotoClaim.ShopID := CopyStr(GetRequiredText(Basket, 'shopId'), 1, MaxStrLen(NotoClaim.ShopID));
        NotoClaim.ContactName := CopyStr(GetOptionalText(Basket, 'contactName'), 1, MaxStrLen(NotoClaim.ContactName));
        NotoClaim.ContactPhone := CopyStr(GetOptionalText(Basket, 'contactPhone'), 1, MaxStrLen(NotoClaim.ContactPhone));
        NotoClaim.ItemID := CopyStr(GetRequiredText(BasketLine, 'itemId'), 1, MaxStrLen(NotoClaim.ItemID));
        NotoClaim.BuyDate := SharedBuyDateTime;
        NotoClaim.ErrorTypeID := GetRequiredInteger(BasketLine, 'errorTypeId');
        NotoClaim."ErrorType Text" := CopyStr(GetOptionalText(BasketLine, 'errorTypeText'), 1, MaxStrLen(NotoClaim."ErrorType Text"));
        NotoClaim.CreatedDate := SharedCreatedDateTime;
        NotoClaim."YearCode Text" := CopyStr(GetOptionalText(BasketLine, 'yearCodeText'), 1, MaxStrLen(NotoClaim."YearCode Text"));
        NotoClaim."YearCode Interval From" := GetOptionalDate(BasketLine, 'yearCodeIntervalFrom');
        NotoClaim."YearCode Interval To" := GetOptionalDate(BasketLine, 'yearCodeIntervalTo');
        NotoClaim.SecondHand := GetOptionalInteger(BasketLine, 'secondHand', 0);
        NotoClaim.WhatToDo := GetRequiredInteger(BasketLine, 'whatToDo');
        NotoClaim.YearCodeID := GetOptionalInteger(BasketLine, 'yearCodeId', 0);
        NotoClaim.Reference := CopyStr(GetOptionalText(BasketLine, 'reference'), 1, MaxStrLen(NotoClaim.Reference));
        NotoClaim.Quantity := GetRequiredInteger(BasketLine, 'quantity');
        NotoClaim.Ledger := CopyStr(GetRequiredText(Basket, 'ledger'), 1, MaxStrLen(NotoClaim.Ledger));
        NotoClaim."Line text" := CopyStr(GetOptionalText(BasketLine, 'lineText'), 1, MaxStrLen(NotoClaim."Line text"));
        NotoClaim.Exclude := false;

        NotoClaim.Insert(true);
        exit(ClaimId);
    end;

    local procedure ValidateHeader(Basket: JsonObject)
    begin
        if GetRequiredText(Basket, 'shopId') = '' then;
        if GetRequiredText(Basket, 'ledger') = '' then;
    end;

    local procedure ValidateLine(BasketLine: JsonObject)
    var
        WhatToDo: Integer;
    begin
        if GetRequiredText(BasketLine, 'itemId') = '' then;
        if GetRequiredInteger(BasketLine, 'errorTypeId') <= 0 then
            Error('errorTypeId must be greater than 0.');

        WhatToDo := GetRequiredInteger(BasketLine, 'whatToDo');
        if (WhatToDo <> 0) and (WhatToDo <> 1) then
            Error('whatToDo must be 0 or 1.');

        if GetRequiredInteger(BasketLine, 'quantity') <= 0 then
            Error('quantity must be greater than 0.');

        ValidateYearCodeTriplet(BasketLine);
    end;

    local procedure ValidateYearCodeTriplet(BasketLine: JsonObject)
    var
        HasYearCodeText: Boolean;
        HasIntervalFrom: Boolean;
        HasIntervalTo: Boolean;
    begin
        HasYearCodeText := HasNonEmptyText(BasketLine, 'yearCodeText');
        HasIntervalFrom := HasValue(BasketLine, 'yearCodeIntervalFrom');
        HasIntervalTo := HasValue(BasketLine, 'yearCodeIntervalTo');

        if HasYearCodeText <> HasIntervalFrom then
            Error('yearCodeText and yearCodeIntervalFrom must travel together.');

        if HasYearCodeText <> HasIntervalTo then
            Error('yearCodeText and yearCodeIntervalTo must travel together.');
    end;

    local procedure GetNextClaimId(): Integer
    var
        NotoClaim: Record "NOTO Claims";
    begin
        NotoClaim.Reset();
        if NotoClaim.FindLast() then
            exit(NotoClaim.ID + 1);

        exit(1);
    end;

    local procedure GetRequiredText(Obj: JsonObject; PropertyName: Text): Text
    var
        Value: Text;
    begin
        Value := GetOptionalText(Obj, PropertyName);
        if Value = '' then
            Error('%1 is required.', PropertyName);

        exit(Value);
    end;

    local procedure GetOptionalText(Obj: JsonObject; PropertyName: Text): Text
    var
        Token: JsonToken;
        Value: JsonValue;
    begin
        if not Obj.Get(PropertyName, Token) then
            exit('');

        if IsJsonNull(Token) then
            exit('');

        if not Token.IsValue() then
            Error('%1 must be a scalar value.', PropertyName);

        Value := Token.AsValue();
        exit(Value.AsText());
    end;

    local procedure GetRequiredInteger(Obj: JsonObject; PropertyName: Text): Integer
    var
        Token: JsonToken;
        Value: JsonValue;
        ParsedValue: Integer;
    begin
        if not Obj.Get(PropertyName, Token) then
            Error('%1 is required.', PropertyName);

        if not Token.IsValue() then
            Error('%1 must be a scalar value.', PropertyName);

        Value := Token.AsValue();
        if not Evaluate(ParsedValue, Value.AsText()) then
            Error('%1 must be an integer value.', PropertyName);

        exit(ParsedValue);
    end;

    local procedure GetOptionalInteger(Obj: JsonObject; PropertyName: Text; DefaultValue: Integer): Integer
    var
        Token: JsonToken;
        Value: JsonValue;
        ParsedValue: Integer;
    begin
        if not Obj.Get(PropertyName, Token) then
            exit(DefaultValue);

        if IsJsonNull(Token) then
            exit(DefaultValue);

        if not Token.IsValue() then
            Error('%1 must be a scalar value.', PropertyName);

        Value := Token.AsValue();
        if not Evaluate(ParsedValue, Value.AsText()) then
            Error('%1 must be an integer value.', PropertyName);

        exit(ParsedValue);
    end;

    local procedure GetOptionalDateTime(Obj: JsonObject; PropertyName: Text; DefaultValue: DateTime): DateTime
    var
        ValueText: Text;
    begin
        ValueText := GetOptionalText(Obj, PropertyName);
        if ValueText = '' then
            exit(DefaultValue);

        exit(ParseFlexibleDateTime(ValueText));
    end;

    local procedure GetOptionalDate(Obj: JsonObject; PropertyName: Text): Date
    var
        ValueText: Text;
    begin
        ValueText := GetOptionalText(Obj, PropertyName);
        if ValueText = '' then
            exit(0D);

        exit(ParseFlexibleDate(ValueText));
    end;

    local procedure HasNonEmptyText(Obj: JsonObject; PropertyName: Text): Boolean
    begin
        exit(GetOptionalText(Obj, PropertyName) <> '');
    end;

    local procedure HasValue(Obj: JsonObject; PropertyName: Text): Boolean
    var
        Token: JsonToken;
    begin
        if not Obj.Get(PropertyName, Token) then
            exit(false);

        exit(not IsJsonNull(Token));
    end;

    local procedure IsJsonNull(Token: JsonToken): Boolean
    var
        TokenText: Text;
    begin
        Token.WriteTo(TokenText);
        TokenText := DelChr(LowerCase(TokenText), '<>', ' ');
        exit(TokenText = 'null');
    end;

    local procedure FormatJson(Obj: JsonObject): Text
    var
        JsonText: Text;
    begin
        Obj.WriteTo(JsonText);
        exit(JsonText);
    end;

    local procedure ParseFlexibleDateTime(ValueText: Text): DateTime
    var
        ParsedDateTime: DateTime;
        DatePart: Text;
        TimePart: Text;
        ParsedDate: Date;
        ParsedTime: Time;
    begin
        if Evaluate(ParsedDateTime, ValueText) then
            exit(ParsedDateTime);

        DatePart := CopyStr(ValueText, 1, 10);
        TimePart := CopyStr(ValueText, 12, 8);

        if DatePart = '' then
            Error('The date is not valid.');

        ParsedDate := ParseFlexibleDate(DatePart);

        if (TimePart = '') or (TimePart = '00:00:00') then
            exit(CreateDateTime(ParsedDate, 0T));

        if not Evaluate(ParsedTime, TimePart) then
            Error('The date is not valid.');

        exit(CreateDateTime(ParsedDate, ParsedTime));
    end;

    local procedure ParseFlexibleDate(ValueText: Text): Date
    var
        ParsedDate: Date;
        YearNumber: Integer;
        MonthNumber: Integer;
        DayNumber: Integer;
    begin
        if Evaluate(ParsedDate, ValueText) then
            exit(ParsedDate);

        if StrLen(ValueText) >= 10 then begin
            if (CopyStr(ValueText, 5, 1) = '-') and (CopyStr(ValueText, 8, 1) = '-') then begin
                if Evaluate(YearNumber, CopyStr(ValueText, 1, 4)) and
                   Evaluate(MonthNumber, CopyStr(ValueText, 6, 2)) and
                   Evaluate(DayNumber, CopyStr(ValueText, 9, 2))
                then
                    exit(DMY2Date(DayNumber, MonthNumber, YearNumber));
            end;
        end;

        Error('The date is not valid.');
    end;
}
