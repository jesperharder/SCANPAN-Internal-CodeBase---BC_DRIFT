codeunit 50037 "Prod. Dashboard Data Mgt."
{
    Permissions = tabledata "Capacity Ledger Entry" = R,
        tabledata "Capacity Unit of Measure" = R,
        tabledata Date = R,
        tabledata "Prod. Order Line" = R,
        tabledata "Prod. Order Routing Line" = R;

    procedure UpdateProductionChart(CapacityNo: Code[20];
                                    CapacityType: enum "Capacity Type";
                                    var BusinessChartBuffer: Record "Business Chart Buffer";
                                    OrderStatus: array[5] of Boolean;
                                    ProductionDateSelection: enum EnumProductionDateSelection;
                                    PeriodType: Enum "PeriodType";
                                    PeriodStart: Text[2048];
                                    PeriodLength: Integer;
                                    BusinessChartType: enum "Business Chart Type";
                                    ChartDataType: enum EnumChartDataType;
                                    CombinedChartActive: Boolean)
    var
        CalendarDate: Record Date;
        Qty: Decimal;
        PorderStatus: Enum "Production Order Status";
        ColumnNo: Integer;
        MeassureIndex: Integer;
        StatusLvl: Integer;
        SecondaryChartLbl: Label 'Planned Qty';
    begin
        BusinessChartBuffer.Initialize();
        MeassureIndex := 0;
        foreach StatusLvl in enum::"Production Order Status".Ordinals do
            if OrderStatus[StatusLvl + 1] then begin
                PorderStatus := enum::"Production Order Status".FromInteger(StatusLvl);
                BusinessChartBuffer.AddMeasure(Format(PorderStatus), MeassureIndex, BusinessChartBuffer."Data Type"::Decimal, BusinessChartType.AsInteger());
                MeassureIndex += 1;
            end;

        if CombinedChartActive then begin
            BusinessChartType := BusinessChartType::Line;
            BusinessChartBuffer.AddMeasure(SecondaryChartLbl, MeassureIndex, BusinessChartBuffer."Data Type"::Decimal, BusinessChartType.AsInteger());
        end;

        BusinessChartBuffer.SetXAxis(Format(PeriodType), BusinessChartBuffer."Data Type"::String);
        GetCalendarPeriodType(CalendarDate, PeriodType, PeriodLength, PeriodStart);

        ColumnNo := 0;
        if CalendarDate.FindSet() then
            repeat
                if PeriodType = PeriodType::Date then
                    BusinessChartBuffer.AddColumn(Format(CalendarDate."Period Start"))
                else
                    BusinessChartBuffer.AddColumn(Format(Date2DMY(CalendarDate."Period Start", 3)) + '-' + Format(CalendarDate."Period Name"));

                MeassureIndex := 0;
                for StatusLvl := 0 to 4 do
                    if OrderStatus[StatusLvl + 1] then begin
                        Qty := 0;
                        PorderStatus := enum::"Production Order Status".FromInteger(StatusLvl);

                        if (ChartDataType = ChartDataType::"Planned Quantity") or (ChartDataType = ChartDataType::"Planned Time") then begin
                            if StatusLvl = 4 then
                                Qty := GetProductionPostedCapacityLedgerQuantity(PorderStatus, ProductionDateSelection, CapacityNo, CapacityType, ChartDataType, CalendarDate);

                            if StatusLvl <> 4 then
                                Qty := GetProductionOrderRoutingLineQuantity(PorderStatus, ProductionDateSelection, CapacityNo, CapacityType, ChartDataType, CalendarDate);
                        end;

                        if (ChartDataType = ChartDataType::"Actual Quantity") or (ChartDataType = ChartDataType::"Actual Time") then
                            Qty := GetProductionPostedCapacityLedgerQuantity(PorderStatus, ProductionDateSelection, CapacityNo, CapacityType, ChartDataType, CalendarDate);

                        BusinessChartBuffer.SetValueByIndex(MeassureIndex, ColumnNo, Qty);
                        MeassureIndex += 1;
                    end;

                if CombinedChartActive then begin
                    Qty := GetProductionOrderRoutingLineQuantity(PorderStatus::Finished, ProductionDateSelection, CapacityNo, CapacityType, ChartDataType::"Planned Quantity", CalendarDate);
                    Qty += GetProductionOrderRoutingLineQuantity(PorderStatus::Released, ProductionDateSelection, CapacityNo, CapacityType, ChartDataType::"Planned Quantity", CalendarDate);
                    Qty += GetProductionOrderRoutingLineQuantity(PorderStatus::"Firm Planned", ProductionDateSelection, CapacityNo, CapacityType, ChartDataType::"Planned Quantity", CalendarDate);
                    BusinessChartBuffer.SetValueByIndex(MeassureIndex, ColumnNo, Qty);
                end;

                ColumnNo += 1;
            until CalendarDate.Next() = 0;
    end;

    procedure GetCalendarPeriodType(var CalendarDate: Record Date;
                                    PeriodType: enum PeriodType;
                                    PeriodLength: Integer;
                                    PeriodStart: Text[2048])
    var
        PeriodStartDate: Date;
        DateFormula: Text[50];
    begin
        CalendarDate.Reset();
        case PeriodType of
            PeriodType::Date:
                DateFormula := '<+' + Format(PeriodLength) + 'D>';
            PeriodType::Week:
                DateFormula := '<+' + Format(PeriodLength) + 'W>';
            PeriodType::Month:
                DateFormula := '<+' + Format(PeriodLength) + 'M>';
            PeriodType::Quarter:
                DateFormula := '<+' + Format(PeriodLength) + 'Q>';
            PeriodType::Year:
                DateFormula := '<+' + Format(PeriodLength) + 'Y>';
        end;

        if not Evaluate(PeriodStartDate, PeriodStart) then
            Error('The production dashboard period start value cannot be evaluated as a date. Value: %1.', PeriodStart);

        CalendarDate.SetRange("Period Type", PeriodType);
        CalendarDate.SetRange("Period Start", PeriodStartDate, CalcDate(DateFormula, PeriodStartDate));
    end;

    procedure GetProductionOrderRoutingLineQuantity(ProductionOrderStatus: enum "Production Order Status";
                                                    ProductionDateSelection: enum EnumProductionDateSelection;
                                                    CapacityNo: Code[20];
                                                    CapacityType: enum "Capacity Type";
                                                    ChartDataType: enum EnumChartDataType;
                                                    CalendarDate: Record Date): Decimal
    var
        CapacityUnitOfMeasure: Record "Capacity Unit of Measure";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        Qty: Decimal;
        RoutingTimeType: enum "Capacity Unit of Measure";
        TimeFactor: Integer;
    begin
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, ProductionOrderStatus);
        ProdOrderRoutingLine.SetFilter(Type, '%1', CapacityType);
        ProdOrderRoutingLine.SetFilter("No.", CapacityNo);

        if ProductionDateSelection = ProductionDateSelection::"Ending Date" then
            ProdOrderRoutingLine.SetRange("Ending Date", CalendarDate."Period Start", CalendarDate."Period End")
        else
            ProdOrderRoutingLine.SetRange("Starting Date", CalendarDate."Period Start", CalendarDate."Period End");

        if ProdOrderRoutingLine.FindSet() then
            repeat
                TimeFactor := 100;
                CapacityUnitOfMeasure.Get(ProdOrderRoutingLine."Run Time Unit of Meas. Code");
                if CapacityUnitOfMeasure.Type = RoutingTimeType::"100/Hour" then
                    TimeFactor := 100;
                if CapacityUnitOfMeasure.Type = RoutingTimeType::Hours then
                    TimeFactor := 1;

                ProdOrderLine.SetRange(Status, ProdOrderRoutingLine.Status);
                ProdOrderLine.SetFilter("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
                if ProdOrderLine.FindSet() then
                    repeat
                        if ChartDataType = ChartDataType::"Planned Quantity" then
                            Qty += ProdOrderLine.Quantity * ScanpanMiscellaneous.GetItemSetMultiplier(ProdOrderLine."Item No.");

                        if ChartDataType = ChartDataType::"Planned Time" then
                            Qty += Round((ProdOrderRoutingLine."Run Time" / TimeFactor) * ProdOrderLine.Quantity);
                    until ProdOrderLine.Next() = 0;
            until ProdOrderRoutingLine.Next() = 0;

        exit(Qty);
    end;

    procedure GetProductionPostedCapacityLedgerQuantity(ProductionOrderStatus: enum "Production Order Status";
                                                        ProductionDateSelection: enum EnumProductionDateSelection;
                                                        CapacityNo: Code[20];
                                                        CapacityType: enum "Capacity Type";
                                                        ChartDataType: enum EnumChartDataType;
                                                        CalendarDate: Record Date): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        CapacityUnitOfMeasure: Record "Capacity Unit of Measure";
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        Qty: Decimal;
        RoutingTimeType: enum "Capacity Unit of Measure";
        TimeFactor: Integer;
    begin
        CapacityLedgerEntry.SetRange(Status, ProductionOrderStatus);
        CapacityLedgerEntry.SetRange("Order Type", CapacityLedgerEntry."Order Type"::Production);
        CapacityLedgerEntry.SetRange("Posting Date", CalendarDate."Period Start", CalendarDate."Period End");
        CapacityLedgerEntry.SetFilter(Type, '%1', CapacityType);
        CapacityLedgerEntry.SetFilter("No.", CapacityNo);
        CapacityLedgerEntry.CalcFields(Status);

        if CapacityLedgerEntry.FindSet() then
            repeat
                TimeFactor := 100;
                CapacityUnitOfMeasure.Get(CapacityLedgerEntry."Cap. Unit of Measure Code");
                if CapacityUnitOfMeasure.Type = RoutingTimeType::"100/Hour" then
                    TimeFactor := 100;
                if CapacityUnitOfMeasure.Type = RoutingTimeType::Hours then
                    TimeFactor := 1;

                if (ChartDataType = ChartDataType::"Planned Quantity") or (ChartDataType = ChartDataType::"Actual Quantity") then
                    Qty += CapacityLedgerEntry."Output Quantity" * ScanpanMiscellaneous.GetItemSetMultiplier(CapacityLedgerEntry."Item No.");

                if (ChartDataType = ChartDataType::"Planned Time") or (ChartDataType = ChartDataType::"Actual Time") then
                    Qty += Round(CapacityLedgerEntry."Run Time" / TimeFactor);
            until CapacityLedgerEntry.Next() = 0;

        exit(Qty);
    end;
}
