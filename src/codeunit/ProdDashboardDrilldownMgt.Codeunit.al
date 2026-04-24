codeunit 50038 "Prod. Dashboard Drilldown Mgt."
{
    Permissions = tabledata "Capacity Ledger Entry" = R,
        tabledata Date = R,
        tabledata "Prod. Order Line" = R,
        tabledata "Prod. Order Routing Line" = R;

    procedure OpenProductionLines(CapacityNo: Code[20];
                                  CapacityType: enum "Capacity Type";
                                  ProductionDateSelection: enum EnumProductionDateSelection;
                                  PeriodType: enum PeriodType;
                                  ChartDataType: enum EnumChartDataType;
                                  OrderStatus: array[5] of Boolean;
                                  JsonObject: JsonObject)
    var
        FilteredLines: Record "Prod. Order Line";
        ChartDateFilter: Text;
        XValue: Text;
    begin
        XValue := GetRequiredJsonText(JsonObject, 'XValueString');
        ChartDateFilter := GetDateRange(PeriodType, XValue);

        GetFilteredProdOrderLines(FilteredLines,
                                  ChartDateFilter,
                                  OrderStatus,
                                  ProductionDateSelection,
                                  CapacityNo,
                                  CapacityType,
                                  ChartDataType);

        FilteredLines.MarkedOnly := true;
        if not FilteredLines.FindSet() then
            Error('No production order lines were found for chart drilldown. Capacity No.: %1, Capacity Type: %2, Statuses: %3, Date Filter: %4.',
                  CapacityNo,
                  CapacityType,
                  GetSelectedStatusText(OrderStatus),
                  ChartDateFilter);

        Page.RunModal(Page::ProdLines, FilteredLines);
    end;

    procedure GetDateRange(PeriodType: enum PeriodType; Input: Text): Text
    var
        CalendarDate: Record Date;
        EndDate: Date;
        StartDate: Date;
        DelimPos: Integer;
        QuarterNo: Integer;
        WeekNo: Integer;
        Year: Integer;
        Delimiter: Text;
        MonthName: Text;
    begin
        Delimiter := '-';
        DelimPos := StrPos(Input, Delimiter);

        case PeriodType of
            PeriodType::Date:
                begin
                    if not Evaluate(StartDate, Input) then
                        Error('Invalid chart date value: %1.', Input);
                    EndDate := StartDate;
                end;
            PeriodType::Week:
                begin
                    RequireDelimitedPeriodValue(Input, DelimPos, PeriodType);
                    if not Evaluate(Year, CopyStr(Input, 1, DelimPos - 1)) then
                        Error('Invalid chart week year value: %1.', Input);
                    if not Evaluate(WeekNo, CopyStr(Input, DelimPos + StrLen(Delimiter))) then
                        Error('Invalid chart week number value: %1.', Input);

                    CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Week);
                    CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
                    CalendarDate.SetRange("Period Name", Format(WeekNo));
                    if not CalendarDate.FindFirst() then
                        Error('No calendar week was found for chart value: %1.', Input);

                    StartDate := CalendarDate."Period Start";
                    EndDate := CalendarDate."Period End";
                end;
            PeriodType::Month:
                begin
                    RequireDelimitedPeriodValue(Input, DelimPos, PeriodType);
                    if not Evaluate(Year, CopyStr(Input, 1, DelimPos - 1)) then
                        Error('Invalid chart month year value: %1.', Input);
                    MonthName := CopyStr(Input, DelimPos + StrLen(Delimiter));

                    CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Month);
                    CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
                    CalendarDate.SetRange("Period Name", MonthName);
                    if not CalendarDate.FindFirst() then
                        Error('No calendar month was found for chart value: %1.', Input);

                    StartDate := CalendarDate."Period Start";
                    EndDate := CalendarDate."Period End";
                end;
            PeriodType::Quarter:
                begin
                    RequireDelimitedPeriodValue(Input, DelimPos, PeriodType);
                    if not Evaluate(Year, CopyStr(Input, 1, DelimPos - 1)) then
                        Error('Invalid chart quarter year value: %1.', Input);
                    if not Evaluate(QuarterNo, CopyStr(Input, DelimPos + StrLen(Delimiter))) then
                        Error('Invalid chart quarter number value: %1.', Input);
                    if (QuarterNo < 1) or (QuarterNo > 4) then
                        Error('Invalid chart quarter number. Value: %1.', QuarterNo);

                    CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Quarter);
                    CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
                    CalendarDate.SetRange("Period Name", Format(QuarterNo));
                    if not CalendarDate.FindFirst() then
                        Error('No calendar quarter was found for chart value: %1.', Input);

                    StartDate := CalendarDate."Period Start";
                    EndDate := CalendarDate."Period End";
                end;
            PeriodType::Year:
                begin
                    RequireDelimitedPeriodValue(Input, DelimPos, PeriodType);
                    if not Evaluate(Year, CopyStr(Input, 1, DelimPos - 1)) then
                        Error('Invalid chart year value: %1.', Input);

                    CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Year);
                    CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year));
                    CalendarDate.SetRange("Period Name", Format(Year));
                    if not CalendarDate.FindFirst() then
                        Error('No calendar year was found for chart value: %1.', Input);

                    StartDate := CalendarDate."Period Start";
                    EndDate := CalendarDate."Period End";
                end;
        end;

        exit(Format(StartDate, 0, '<Day,2><Month,2><Year4>') + '..' + Format(EndDate, 0, '<Day,2><Month,2><Year4>'));
    end;

    procedure GetFilteredProdOrderLines(var FilteredProdOrderLine: Record "Prod. Order Line";
                                        ChartDateFilter: Text;
                                        OrderStatus: array[5] of Boolean;
                                        ProductionDateSelection: enum EnumProductionDateSelection;
                                        CapacityNo: Code[20];
                                        ChartCapacityType: enum "Capacity Type";
                                        ChartDataType: enum EnumChartDataType)
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProductionOrderStatus: enum "Production Order Status";
        StatusLvl: Integer;
    begin
        ProdOrderLine.ClearMarks();
        ProdOrderLine.Reset();

        foreach StatusLvl in enum::"Production Order Status".Ordinals do
            if OrderStatus[StatusLvl + 1] then begin
                ProductionOrderStatus := enum::"Production Order Status".FromInteger(StatusLvl);
                if UsesCapacityLedger(ProductionOrderStatus, ChartDataType) then
                    MarkCapacityLedgerProdOrderLines(ProdOrderLine,
                                                     ChartDateFilter,
                                                     ProductionOrderStatus,
                                                     CapacityNo,
                                                     ChartCapacityType,
                                                     ChartDataType)
                else
                    MarkRoutingProdOrderLines(ProdOrderLine,
                                              ChartDateFilter,
                                              ProductionOrderStatus,
                                              ProductionDateSelection,
                                              CapacityNo,
                                              ChartCapacityType);
            end;

        ProdOrderLine.SetRange(Status);
        ProdOrderLine.SetRange("Prod. Order No.");
        FilteredProdOrderLine.Copy(ProdOrderLine);
    end;

    local procedure GetRequiredJsonText(JsonObject: JsonObject; PropertyName: Text): Text
    var
        JsonToken: JsonToken;
        Value: Text;
    begin
        if not JsonObject.Get(PropertyName, JsonToken) then
            Error('The chart drilldown payload is missing property %1.', PropertyName);

        JsonToken.WriteTo(Value);
        exit(RemoveUnwantedSubstrings(Value));
    end;

    local procedure UsesCapacityLedger(ProductionOrderStatus: enum "Production Order Status"; ChartDataType: enum EnumChartDataType): Boolean
    var
        FinishedStatus: enum "Production Order Status";
    begin
        if ProductionOrderStatus = FinishedStatus::Finished then
            exit(true);

        exit((ChartDataType = ChartDataType::"Actual Quantity") or (ChartDataType = ChartDataType::"Actual Time"));
    end;

    local procedure MarkCapacityLedgerProdOrderLines(var ProdOrderLine: Record "Prod. Order Line";
                                                     ChartDateFilter: Text;
                                                     ProductionOrderStatus: enum "Production Order Status";
                                                     CapacityNo: Code[20];
                                                     ChartCapacityType: enum "Capacity Type";
                                                     ChartDataType: enum EnumChartDataType)
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
    begin
        CapacityLedgerEntry.Reset();
        CapacityLedgerEntry.SetRange("Order Type", CapacityLedgerEntry."Order Type"::Production);
        CapacityLedgerEntry.SetRange(Status, ProductionOrderStatus);
        CapacityLedgerEntry.SetFilter("Posting Date", ChartDateFilter);
        CapacityLedgerEntry.SetRange(Type, ChartCapacityType);
        CapacityLedgerEntry.SetFilter("No.", CapacityNo);
        SetCapacityLedgerQuantityFilter(CapacityLedgerEntry, ChartDataType);

        if CapacityLedgerEntry.FindSet() then
            repeat
                CapacityLedgerEntry.CalcFields(Status);
                MarkProdOrderLinesByOrderNo(ProdOrderLine, CapacityLedgerEntry.Status, CapacityLedgerEntry."Order No.");
            until CapacityLedgerEntry.Next() = 0;
    end;

    local procedure MarkRoutingProdOrderLines(var ProdOrderLine: Record "Prod. Order Line";
                                              ChartDateFilter: Text;
                                              ProductionOrderStatus: enum "Production Order Status";
                                              ProductionDateSelection: enum EnumProductionDateSelection;
                                              CapacityNo: Code[20];
                                              ChartCapacityType: enum "Capacity Type")
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, ProductionOrderStatus);
        ProdOrderRoutingLine.SetRange(Type, ChartCapacityType);
        ProdOrderRoutingLine.SetFilter("No.", CapacityNo);

        if ProductionDateSelection = ProductionDateSelection::"Ending Date" then
            ProdOrderRoutingLine.SetFilter("Ending Date", ChartDateFilter)
        else
            ProdOrderRoutingLine.SetFilter("Starting Date", ChartDateFilter);

        if ProdOrderRoutingLine.FindSet() then
            repeat
                MarkProdOrderLinesByOrderNo(ProdOrderLine, ProdOrderRoutingLine.Status, ProdOrderRoutingLine."Prod. Order No.");
            until ProdOrderRoutingLine.Next() = 0;
    end;

    local procedure MarkProdOrderLinesByOrderNo(var ProdOrderLine: Record "Prod. Order Line"; ProductionOrderStatus: enum "Production Order Status"; ProdOrderNo: Code[20])
    begin
        ProdOrderLine.SetRange(Status, ProductionOrderStatus);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrderNo);
        if ProdOrderLine.FindSet() then
            repeat
                ProdOrderLine.Mark(true);
            until ProdOrderLine.Next() = 0;
    end;

    local procedure SetCapacityLedgerQuantityFilter(var CapacityLedgerEntry: Record "Capacity Ledger Entry"; ChartDataType: enum EnumChartDataType)
    begin
        if (ChartDataType = ChartDataType::"Planned Time") or (ChartDataType = ChartDataType::"Actual Time") then begin
            CapacityLedgerEntry.SetFilter("Run Time", '<>0');
            exit;
        end;

        CapacityLedgerEntry.SetFilter("Output Quantity", '<>0');
    end;

    local procedure GetSelectedStatusText(OrderStatus: array[5] of Boolean): Text
    var
        ProductionOrderStatus: enum "Production Order Status";
        SelectedStatusText: Text;
        StatusLvl: Integer;
    begin
        foreach StatusLvl in enum::"Production Order Status".Ordinals do
            if OrderStatus[StatusLvl + 1] then begin
                ProductionOrderStatus := enum::"Production Order Status".FromInteger(StatusLvl);
                if SelectedStatusText <> '' then
                    SelectedStatusText += ', ';
                SelectedStatusText += Format(ProductionOrderStatus);
            end;

        exit(SelectedStatusText);
    end;

    local procedure RemoveUnwantedSubstrings(InputString: Text): Text
    var
        CleanedString: Text;
    begin
        CleanedString := InputString;
        CleanedString := DelChr(CleanedString, '=', '[');
        CleanedString := DelChr(CleanedString, '=', ']');
        CleanedString := DelChr(CleanedString, '=', '"');
        exit(CleanedString);
    end;

    local procedure RequireDelimitedPeriodValue(Input: Text; DelimPos: Integer; PeriodType: enum PeriodType)
    begin
        if DelimPos = 0 then
            Error('The chart period value must contain a delimiter. Period Type: %1, Value: %2.', PeriodType, Input);
    end;
}
