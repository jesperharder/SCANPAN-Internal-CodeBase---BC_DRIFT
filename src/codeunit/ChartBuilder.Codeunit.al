codeunit 50008 "ChartBuilder"
{
    /// <summary>
    /// Codeunit ChartBuilder
    /// </summary>
    /// <remarks>
    /// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts
    /// 2024.11             Jesper Harder       095         Look up production orders from Chart Dashboard
    /// </remarks>

    Permissions =
        tabledata "Business Chart Buffer" = R,
        tabledata Customer = R,
        tabledata Date = R,
        tabledata "Prod. Order Routing Line" = R,
        tabledata "Sorting Table" = RIM;

    var
        CombinedChartActive: Boolean;

    /// <summary>
    /// TriggerDemoActive.
    /// </summary>
    /// <param name="Active">Boolean.</param>
    procedure TriggerCombinedChart(Active: Boolean)
    begin
        CombinedChartActive := Active;
    end;


    #region ProductionChartBuilder

    /// <summary>
    /// UpdateProductionChart.
    /// </summary>
    procedure UpdateProductionChart(CapacityNo: Code[20];
                            CapacityType: enum "Capacity Type";
                            var BusinessChartBuffer: Record "Business Chart Buffer";
                            OrderStatus: array[5] of Boolean;
                            ProductionDateSelection: enum EnumProductionDateSelection;
                            PeriodType: Enum "PeriodType";
                            PeriodStart: Text[2048];
                            PeriodLength: Integer;
                            BusinessChartType: enum "Business Chart Type";
                            ChartDataType: enum EnumChartDataType
                        )
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
        //"Simulated","Planned","Firm Planned","Released","Finished"
        StatusLvl := 0;
        MeassureIndex := 0;
        foreach StatusLvl in enum::"Production Order Status".ordinals do
            if OrderStatus[StatusLvl + 1] = true then begin

                PorderStatus := enum::"Production Order Status".FromInteger(StatusLvl);
                BusinessChartBuffer.AddMeasure(Format(PorderStatus),
                                                MeassureIndex,
                                                BusinessChartBuffer."Data Type"::Decimal,
                                                BusinessChartType.AsInteger()
                                                );
                MeassureIndex += 1;
            end;

        //DEMO
        if CombinedChartActive then begin
            BusinessChartType := BusinessChartType::Line;
            BusinessChartBuffer.AddMeasure(SecondaryChartLbl,
                                            MeassureIndex,
                                            BusinessChartBuffer."Data Type"::Decimal,
                                            BusinessChartType.AsInteger()
                                            );
        end;
        //Y-Axis

        //X-Axis
        BusinessChartBuffer.SetXAxis(Format(PeriodType), BusinessChartBuffer."Data Type"::String);

        //GetDateSet
        GetCalendarPeriodType(CalendarDate,
                              PeriodType,
                              PeriodLength,
                              PeriodStart);
        //X-Axis Columns
        ColumnNo := 0;
        if CalendarDate.FindSet() then
            repeat
                if PeriodType = PeriodType::Date then
                    BusinessChartBuffer.AddColumn(format(CalendarDate."Period Start"))
                else
                    BusinessChartBuffer.AddColumn(format(Date2DMY(CalendarDate."Period Start", 3)) + '-' + format(CalendarDate."Period Name"));

                //"Simulated","Planned","Firm Planned","Released","Finished"
                MeassureIndex := 0;
                for StatusLvl := 0 to 4 do
                    if OrderStatus[StatusLvl + 1] = true then begin
                        Qty := 0;
                        if StatusLvl = 4 then PorderStatus := PorderStatus::Finished;
                        if StatusLvl = 3 then PorderStatus := PorderStatus::Released;
                        if StatusLvl = 2 then PorderStatus := PorderStatus::"Firm Planned";
                        if StatusLvl = 1 then PorderStatus := PorderStatus::Planned;
                        if StatusLvl = 0 then PorderStatus := PorderStatus::Simulated;

                        //Planned
                        if (ChartDataType = ChartDataType::"Planned Quantity") or (ChartDataType = ChartDataType::"Planned Time") then begin
                            //Finished
                            if StatusLvl = 4 then
                                Qty := GetProductionPostedCapacityLedgerQuantity(PorderStatus,
                                                                                ProductionDateSelection,
                                                                                CapacityNo,
                                                                                CapacityType,
                                                                                ChartDataType,
                                                                                CalendarDate);

                            //Not Status Finished
                            if StatusLvl <> 4 then
                                Qty := GetProductionOrderRoutingLineQuantity(PorderStatus,
                                                                            ProductionDateSelection,
                                                                            CapacityNo,
                                                                            CapacityType,
                                                                            ChartDataType,
                                                                            CalendarDate);
                        end;
                        //Actual
                        if (ChartDataType = ChartDataType::"Actual Quantity") or (ChartDataType = ChartDataType::"Actual Time") then
                            Qty := GetProductionPostedCapacityLedgerQuantity(PorderStatus,
                                                                            ProductionDateSelection,
                                                                            CapacityNo,
                                                                            CapacityType,
                                                                            ChartDataType,
                                                                            CalendarDate);


                        BusinessChartBuffer.SetValueByIndex(MeassureIndex, ColumnNo, Qty);
                        MeassureIndex += 1;
                    end;

                //DEMO
                if CombinedChartActive then begin
                    Qty := GetProductionOrderRoutingLineQuantity(PorderStatus::Finished,
                                                                ProductionDateSelection,
                                                                CapacityNo,
                                                                CapacityType,
                                                                ChartDataType::"Planned Quantity",
                                                                CalendarDate);

                    Qty += GetProductionOrderRoutingLineQuantity(PorderStatus::Released,
                                                                ProductionDateSelection,
                                                                CapacityNo,
                                                                CapacityType,
                                                                ChartDataType::"Planned Quantity",
                                                                CalendarDate);
                    Qty += GetProductionOrderRoutingLineQuantity(PorderStatus::"Firm Planned",
                                                                ProductionDateSelection,
                                                                CapacityNo,
                                                                CapacityType,
                                                                ChartDataType::"Planned Quantity",
                                                                CalendarDate);

                    BusinessChartBuffer.SetValueByIndex(MeassureIndex, ColumnNo, Qty);
                end;

                ColumnNo += 1;
            until CalendarDate.Next() = 0;
    end;

    #endregion

    #region GetTopX Customers SalesLCY
    /// <summary>
    /// GetTopXCustomers.
    /// </summary>
    /// <param name="TempCustomer">Temporary VAR Record Customer.</param>
    /// <param name="TopX">Integer.</param>
    procedure GetTopXCustomersSalesLCY(var
                                           TempCustomer: Record Customer temporary;
                                           TopX: Integer)
    var
        Customer: Record Customer;
        TempSortingTable: Record "Sorting Table" temporary;
        i: Integer;
    begin
        Customer.Reset();
        Customer.FindSet();
        repeat
            Customer.CalcFields("Sales (LCY)");
            i += 1;
            TempSortingTable.Init();
            TempSortingTable.Integer := i;
            TempSortingTable.Code := Customer."No.";
            TempSortingTable.Decimal := Customer."Sales (LCY)";
            TempSortingTable.Insert();
        until Customer.Next() = 0;

        TempSortingTable.SetCurrentKey(Decimal);
        TempSortingTable.Ascending(false);
        i := 0;
        Customer.Reset();
        TempCustomer.Init();
        if TempSortingTable.FindSet() then
            repeat
                i += 1;
                Customer.Get(TempSortingTable.Code);
                TempCustomer.TransferFields(Customer);
                TempCustomer.Insert();
            until (i = TopX + 1) or (TempSortingTable.Next() = 0);
    end;
    #endregion

    #region helper code

    /// <summary>
    /// GetYearWeekNoInt.
    /// </summary>
    /// <param name="DateToConvert">Date.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure ConvertDateToYearWeekInt(DateToConvert: Date): Integer
    var
        YearWeekInt: Integer;
        YearWeekNo: Text[6];
    begin
        YearWeekNo := '0' + Format(Date2DWY(DateToConvert, 2));
        if StrLen(YearWeekNo) = 3 then
            YearWeekNo := Format(Date2DWY(DateToConvert, 2));
        YearWeekNo := Format(Date2DWY(DateToConvert, 3)) + YearWeekNo;
        Evaluate(YearWeekInt, YearWeekNo);
        exit(YearWeekInt);
    end;

    /// <summary>
    /// FormatYearWeekIntToString.
    /// </summary>
    /// <param name="YearWeekNo">Integer.</param>
    /// <returns>Return value of type Text[6].</returns>
    procedure FormatYearWeekIntToStringPresentation(YearWeekNo: Integer): Text[6]
    var
        ConvText: Text[6];
    begin
        ConvText := Format(YearWeekNo, 6);
        exit(DelStr(ConvText, 1, 4));
        // + '-' + DelStr(Format(TempSortingTable.Integer), 5, 2);
    end;

    /// <summary>
    /// GetCalendar.
    /// </summary>
    /// <param name="CalendarDate">VAR Record Date.</param>
    /// <param name="PeriodType">enum PeriodType.</param>
    /// <param name="PeriodLength">Integer.</param>
    /// <param name="PeriodStart">Text[2048].</param>
    procedure GetCalendarPeriodType(var CalendarDate: Record Date;
                          PeriodType: enum PeriodType;
                                          PeriodLength: Integer;
                                          PeriodStart: Text[2048]
                          )
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

        CalendarDate.SetFilter("Period Type", '%1', PeriodType);
        Evaluate(PeriodStartDate, PeriodStart);
        CalendarDate.SetRange("Period Start", PeriodStartDate, CalcDate(DateFormula, PeriodStartDate));
    end;

    /// <summary>
    /// GetProductionOrderRoutingLineQuantity.
    /// </summary>
    /// <param name="ProductionOrderStatus">enum "Production Order Status".</param>
    /// <param name="CapacityNo">Code[20].</param>
    /// <param name="CapacityType">enum "Capacity Type".</param>
    /// <param name="ChartDataType">enum EnumChartDataType.</param>
    /// <param name="CalendarDate">Record Date.</param>
    /// <returns>Return value of type Decimal.</returns> 
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

        Qty := 0;
        if ProdOrderRoutingLine.FindSet() then
            repeat
                TimeFactor := 100;
                CapacityUnitOfMeasure.Get(ProdOrderRoutingLine."Run Time Unit of Meas. Code");
                if CapacityUnitOfMeasure.Type = RoutingTimeType::"100/Hour" then TimeFactor := 100;
                if CapacityUnitOfMeasure.Type = RoutingTimeType::Hours then TimeFactor := 1;

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

    /// <summary>
    /// GetProductionCapacityLedgerQuantity.
    /// </summary>
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
        Qty := 0;
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
                if CapacityUnitOfMeasure.Type = RoutingTimeType::"100/Hour" then TimeFactor := 100;
                if CapacityUnitOfMeasure.Type = RoutingTimeType::Hours then TimeFactor := 1;

                if (ChartDataType = ChartDataType::"Planned Quantity") or (ChartDataType = ChartDataType::"Actual Quantity") then
                    Qty += CapacityLedgerEntry."Output Quantity" * ScanpanMiscellaneous.GetItemSetMultiplier(CapacityLedgerEntry."Item No.");

                if (ChartDataType = ChartDataType::"Planned Time") or (ChartDataType = ChartDataType::"Actual Time") then
                    Qty += Round(CapacityLedgerEntry."Run Time" / TimeFactor);

            until CapacityLedgerEntry.Next() = 0;

        exit(Qty);
    end;

    #endregion

    #region
    /// 2024.11             Jesper Harder       095         Look up production orders from Chart Dashboard
    procedure GetDateRange(PeriodType: enum PeriodType; Input: Text): Text
    var
        CalendarDate: Record Date;
        EndDate: Date;
        StartDate: Date;
        DelimPos: Integer;
        QuarterNo: Integer;
        WeekNo: Integer;
        Year: Integer;
        SelectedDateFilter: Text;
        Delimiter: Text;
        MonthName: Text;
    begin
        // Initialize 
        CalendarDate.Reset();
        StartDate := 0D;
        EndDate := 0D;


        // Find the position of the delimiter
        Delimiter := '-';
        DelimPos := StrPos(Input, Delimiter);

        // Date
        if PeriodType = PeriodType::Date then begin
            Evaluate(StartDate, Input);
            Evaluate(EndDate, Input);
        end;

        // Week
        if PeriodType = PeriodType::Week then begin
            // Extract the year and week number
            Evaluate(Year, CopyStr(Input, 1, DelimPos - 1));
            Evaluate(WeekNo, CopyStr(Input, DelimPos + StrLen(Delimiter)));

            // Filter the CalendarDate table for the specified year and week
            CalendarDate.Reset();
            CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Week);
            CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
            CalendarDate.SetRange("Period Name", Format(WeekNo));

            if not CalendarDate.FindFirst() then
                exit;

            StartDate := CalendarDate."Period Start";
            EndDate := CalendarDate."Period End";
        end;

        // Month
        if PeriodType = PeriodType::Month then begin
            // Extract the year and month number
            Evaluate(Year, CopyStr(Input, 1, DelimPos - 1));
            MonthName := CopyStr(Input, DelimPos + StrLen(Delimiter));

            // Filter the CalendarDate table for the specified year and month
            CalendarDate.Reset();
            CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Month);
            CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
            CalendarDate.SetRange("Period Name", MonthName);

            if not CalendarDate.FindFirst() then
                exit;

            StartDate := CalendarDate."Period Start";
            EndDate := CalendarDate."Period End";
        end;

        // Quarter
        if PeriodType = PeriodType::Quarter then begin
            // Extract the year and quarter number
            Evaluate(Year, CopyStr(Input, 1, DelimPos - 1));
            Evaluate(QuarterNo, CopyStr(Input, DelimPos + StrLen(Delimiter)));

            // Validate quarter number
            if (QuarterNo < 1) or (QuarterNo > 4) then
                Error('Invalid quarter number. Must be between 1 and 4.');

            // Filter the CalendarDate table for the specified year and quarter
            CalendarDate.Reset();
            CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Quarter);
            CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year), DMY2Date(31, 12, Year));
            CalendarDate.SetRange("Period Name", Format(QuarterNo));

            if not CalendarDate.FindFirst() then
                exit;

            StartDate := CalendarDate."Period Start";
            EndDate := CalendarDate."Period End";
        end;

        // Year
        if PeriodType = PeriodType::Year then begin
            // Extract the start and end year from the input
            Evaluate(Year, CopyStr(Input, 1, DelimPos - 1));

            // Filter the CalendarDate table for the specified year range
            CalendarDate.Reset();
            CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Year);
            CalendarDate.SetRange("Period Start", DMY2Date(1, 1, Year));
            CalendarDate.SetRange("Period Name", Format(Year));
            if not CalendarDate.FindFirst() then
                exit;

            StartDate := CalendarDate."Period Start";
            EndDate := CalendarDate."Period End";
        end;


        // Format the StartDate and EndDate into a DateFilter string
        SelectedDateFilter := Format(StartDate, 0, '<Day,2><Month,2><Year4>') + '..' + Format(EndDate, 0, '<Day,2><Month,2><Year4>');

        // Return The DateFilter
        exit(SelectedDateFilter);

    end;


    procedure GetXValueString(RessourceName: Text; CapacityType: enum "Capacity Type"; ProductionDateSelection: enum EnumProductionDateSelection; PeriodType: enum PeriodType; JsonObject: JsonObject)
    var
        JsonToken: JsonToken;
        XValue: Text;
        YValue: Text;
        Measures: Text;

        MyPage: Page ProdLines;
        FilteredLines: Record "Prod. Order Line";
        ChartDateFilter: Text;
        MyProductionOrderStatus: Enum "Production Order Status";
    begin
        // Attempt to get the values for the JsonObject keys
        Measures := '';
        XValue := '';
        YValue := '';



        if JsonObject.Get('XValueString', JsonToken) then
            JsonToken.WriteTo(XValue);
        //XValue := format(JsonToken);

        if JsonObject.Get('YValues', JsonToken) then
            JsonToken.WriteTo(YValue);
        //YValue := format(JsonToken);

        if JsonObject.Get('Measures', JsonToken) then
            JsonToken.WriteTo(Measures);
        //Measures := format(JsonToken);

        XValue := RemoveUnwantedSubstrings(XValue);
        YValue := RemoveUnwantedSubstrings(YValue);
        Measures := RemoveUnwantedSubstrings(Measures);


        // Message('Measures %1  \XValue %2 \YValue %3 \PeriodType %4 \RessouceName %5', Measures, XValue, YValue, format(PeriodType), RessourceName);

        ChartDateFilter := GetDateRange(PeriodType, XValue);

        if Measures = 'Planlagt' then
            MyProductionOrderStatus := MyProductionOrderStatus::Planned;
        if Measures = 'Fastlagt' then
            MyProductionOrderStatus := MyProductionOrderStatus::"Firm Planned";
        if Measures = 'Frigivet' then
            MyProductionOrderStatus := MyProductionOrderStatus::Released;
        if Measures = 'Færdig' then
            MyProductionOrderStatus := MyProductionOrderStatus::Finished;


        // Get the filtered records
        GetFilteredProdOrderLines(FilteredLines,
                                  ChartDateFilter,
                                  MyProductionOrderStatus,
                                  ProductionDateSelection,
                                  RessourceName,
                                  CapacityType);

        // Debug: Ensure marked rows exist
        if not FilteredLines.FindSet() then
            Error('No marked production order lines found.');


        // Set to only the Marked records
        FilteredLines.MarkedOnly := true;

        // Open the page
        Page.RunModal(Page::ProdLines, FilteredLines)

    end;

    procedure RemoveUnwantedSubstrings(InputString: Text): Text
    var
        CleanedString: Text;
    begin
        CleanedString := InputString;

        // Remove each unwanted substring
        CleanedString := DelChr(CleanedString, '=', '['); // Remove [" 
        CleanedString := DelChr(CleanedString, '=', ']'); // Remove "] 
        CleanedString := DelChr(CleanedString, '=', '"'); // Remove "

        exit(CleanedString); // Return the cleaned string
    end;

    procedure GetFilteredProdOrderLines(var FilteredProdOrderLine: Record "Prod. Order Line";
                                        ChartDateFilter: Text;
                                        ProductionOrderStatus: enum "Production Order Status";
                                        ProductionDateSelection: enum EnumProductionDateSelection;
                                        RessourceNo: Text;
                                        ChartCapacityType: enum "Capacity Type"): Record "Prod. Order Line" temporary
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
    begin
        // Initialize and clear marks on ProdOrderLine to ensure a fresh state
        ProdOrderLine.ClearMarks();
        ProdOrderLine.Reset();

        // Handle the case where the Production Order status is "Finished"
        if ProductionOrderStatus = ProductionOrderStatus::Finished then begin
            // Filter CapacityLedgerEntry based on relevant criteria
            CapacityLedgerEntry.Reset();
            CapacityLedgerEntry.SetRange("Order Type", CapacityLedgerEntry."Order Type"::Production);
            CapacityLedgerEntry.SetFilter("Posting Date", ChartDateFilter);
            CapacityLedgerEntry.SetRange(Type, ChartCapacityType);
            CapacityLedgerEntry.SetRange("No.", RessourceNo);
            CapacityLedgerEntry.SetFilter("Output Quantity", '<>0');

            // Iterate through the filtered CapacityLedgerEntry records
            if CapacityLedgerEntry.FindSet() then
                repeat
                    // Mark related ProdOrderLine records
                    ProdOrderLine.SetRange("Prod. Order No.", CapacityLedgerEntry."Order No.");
                    if ProdOrderLine.FindFirst() then
                        ProdOrderLine.Mark(true);
                until CapacityLedgerEntry.Next() = 0;
        end;

        // Handle the case where the Production Order status is not "Finished"
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetFilter(Status, '<>%1', ProdOrderRoutingLine.Status::Finished);
        ProdOrderRoutingLine.SetRange(Type, ChartCapacityType);
        ProdOrderRoutingLine.SetRange("No.", RessourceNo);

        if ProductionDateSelection = ProductionDateSelection::"Ending Date" then
            ProdOrderRoutingLine.SetFilter("Ending Date", ChartDateFilter)
        else
            ProdOrderRoutingLine.SetFilter("Starting Date", ChartDateFilter);

        ProdOrderRoutingLine.SetFilter("Input Quantity", '<>0');

        // Iterate through the filtered ProdOrderRoutingLine records
        if ProdOrderRoutingLine.FindSet() then
            repeat
                // Mark related ProdOrderLine records
                ProdOrderLine.SetRange("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
                if ProdOrderLine.FindFirst() then
                    ProdOrderLine.Mark(true);
            until ProdOrderRoutingLine.Next() = 0;

        // Reset the "Prod. Order No." filter to include all marked records
        ProdOrderLine.SetRange("Prod. Order No.");

        // Copy the marked records to the output parameter
        FilteredProdOrderLine.Copy(ProdOrderLine);

        // Return the filtered ProdOrderLine records
        exit(FilteredProdOrderLine);
    end;


    #endregion

}
