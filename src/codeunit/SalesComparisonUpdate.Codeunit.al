codeunit 50014 "SalesComparisonUpdate"
{
    /// <summary>
    /// 2024.08             Jesper Harder       076         Sales Comparison Update
    ///
    /// This codeunit updates the sales comparison data by calculating various sales metrics.
    /// It processes sales orders, invoices, credit memos, and budget entries to compute amounts related to sales orders,
    /// realized sales, budgets, and comparisons to previous periods.
    /// The budget calculation now adjusts the current month's budget proportionally based on the days elapsed in the month.
    /// The results are stored in the SalesComparisonData table, categorized by Inventory Posting Group.
    /// </summary>



    trigger OnRun()
    begin
        UpdateSalesComparisonData();
        //CalculateAndStoreSalesComparison();
    end;

    var
        SalesComparisonData: Record "SalesComparisonData";
        CurrentDateTime: DateTime;

    procedure CalculateAndStoreSalesComparison()
    var
        BudgetVsActual: Decimal;
        LastYTDSalesEkstern: Decimal;
        LastYTDSalesIntern: Decimal;
        //RealizedSalesAmountEKSTERN: Decimal;
        //RealizedSalesAmountINTERN: Decimal;
        SalesIndex: Decimal;
        SalesOrderAmount: Decimal;
        SalesOrderAmountEKSTERN: Decimal;
        SalesOrderAmountINTERN: Decimal;
        TotalLastYearYTDRealizedSalesAmount: Decimal;
        //TotalRealizedSalesAmount: Decimal;
        TotalYTDRealizedSalesAmount: Decimal;
        YTDSalesEkstern: Decimal;
        YTDSalesIntern: Decimal;
        DistinctCampaigns: Integer;

    begin
        // Calculate sales order amounts for INTERN and EKSTERN inventory posting groups
        GetSalesOrdersAmount(SalesOrderAmountINTERN, SalesOrderAmountEKSTERN);
        SalesOrderAmount := SalesOrderAmountINTERN + SalesOrderAmountEKSTERN;

        // Calculate realized sales amounts from invoices and credit memos
        //GetRealizedSalesAmount(RealizedSalesAmountINTERN, RealizedSalesAmountEKSTERN);
        //TotalRealizedSalesAmount := RealizedSalesAmountINTERN + RealizedSalesAmountEKSTERN;

        // Calculate sales comparisons with previous year
        CalculateSalesComparison(SalesIndex, YTDSalesIntern, YTDSalesEkstern, LastYTDSalesIntern, LastYTDSalesEkstern);
        TotalYTDRealizedSalesAmount := YTDSalesIntern + YTDSalesEkstern;
        TotalLastYearYTDRealizedSalesAmount := LastYTDSalesIntern + LastYTDSalesEkstern;

        // Count the number of distinct campaigns used in sales lines
        DistinctCampaigns := CountDistinctUsedCampaignNo();

        // Calculate the budget vs actual percentage
        CalculateBudgetComparison(BudgetVsActual, YTDSalesIntern + YTDSalesEkstern); // Use total YTD sales

        // Update or insert the sales comparison data
        if SalesComparisonData.FindFirst() then begin
            SalesComparisonData."Sales Order Amount" := SalesOrderAmount;
            SalesComparisonData."Sales Amount INTERN" := SalesOrderAmountINTERN;
            SalesComparisonData."Sales Amount EKSTERN" := SalesOrderAmountEKSTERN;
            //SalesCompData."Realized Sales Amount INTERN" := RealizedSalesAmountINTERN;
            //SalesCompData."Realized Sales Amount EKSTERN" := RealizedSalesAmountEKSTERN;
            //SalesCompData."Total Realized Sales Amount" := TotalRealizedSalesAmount;
            SalesComparisonData."Distinct Campaigns" := DistinctCampaigns;
            SalesComparisonData."Sales Index" := SalesIndex;
            SalesComparisonData."Budget Vs Actual" := BudgetVsActual;
            SalesComparisonData."Last Update" := CurrentDateTime;
            // Save YTD and last year's YTD realized sales amounts
            SalesComparisonData."YTD Sales Amount INTERN" := YTDSalesIntern;
            SalesComparisonData."YTD Sales Amount EKSTERN" := YTDSalesEkstern;
            SalesComparisonData."Total YTD Sales Amount" := TotalYTDRealizedSalesAmount;
            SalesComparisonData."Last Year YTD Sales Amount INTERN" := LastYTDSalesIntern;
            SalesComparisonData."Last Year YTD Sales Amount EKSTERN" := LastYTDSalesEkstern;
            SalesComparisonData."Total Last Year YTD Sales Amount" := TotalLastYearYTDRealizedSalesAmount;

            SalesComparisonData.Modify();
        end else begin
            SalesComparisonData.Init();
            SalesComparisonData."Sales Order Amount" := SalesOrderAmount;
            SalesComparisonData."Sales Amount INTERN" := SalesOrderAmountINTERN;
            SalesComparisonData."Sales Amount EKSTERN" := SalesOrderAmountEKSTERN;
            //SalesCompData."Realized Sales Amount INTERN" := RealizedSalesAmountINTERN;
            //SalesCompData."Realized Sales Amount EKSTERN" := RealizedSalesAmountEKSTERN;
            //SalesCompData."Total Realized Sales Amount" := TotalRealizedSalesAmount;
            SalesComparisonData."Distinct Campaigns" := DistinctCampaigns;
            SalesComparisonData."Sales Index" := SalesIndex;
            SalesComparisonData."Budget Vs Actual" := BudgetVsActual;
            SalesComparisonData."Last Update" := CurrentDateTime;
            // Save YTD and last year's YTD realized sales amounts
            SalesComparisonData."YTD Sales Amount INTERN" := YTDSalesIntern;
            SalesComparisonData."YTD Sales Amount EKSTERN" := YTDSalesEkstern;
            SalesComparisonData."Total YTD Sales Amount" := TotalYTDRealizedSalesAmount;
            SalesComparisonData."Last Year YTD Sales Amount INTERN" := LastYTDSalesIntern;
            SalesComparisonData."Last Year YTD Sales Amount EKSTERN" := LastYTDSalesEkstern;
            SalesComparisonData."Total Last Year YTD Sales Amount" := TotalLastYearYTDRealizedSalesAmount;

            SalesComparisonData.Insert();
        end;
    end;

    procedure CalculateBudgetComparison(var BudgetVsActual: Decimal; YearToDateSales: Decimal)
    begin
        // Retrieve Total Budget Amount from SalesCompData
        if SalesComparisonData.FindFirst() then begin
            if SalesComparisonData."Total Budget Amount" <> 0 then
                BudgetVsActual := ROUND((YearToDateSales / SalesComparisonData."Total Budget Amount") * 100, 1)
            else
                BudgetVsActual := 0; // Avoid division by zero
        end else
            BudgetVsActual := 0;
    end;

    procedure CalculateSalesComparison(
                            var SalesIndex: Decimal;
                            var YearToDateSalesIntern: Decimal;
                            var YearToDateSalesEkstern: Decimal;
                            var LastYearToDateSalesIntern: Decimal;
                            var LastYearToDateSalesEkstern: Decimal
                            )
    var
        CurrentDate: Date;
        EndOfLastYear: Date;
        StartOfLastYear: Date;
        StartOfYear: Date;
        TotalLastYearYTDSales: Decimal;
        TotalYearToDateSales: Decimal;
    begin
        // Get the current date
        CurrentDate := TODAY;

        // Calculate the start of the current year and last year
        StartOfYear := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3));
        StartOfLastYear := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3) - 1);
        EndOfLastYear := DMY2DATE(DATE2DMY(CurrentDate, 1), DATE2DMY(CurrentDate, 2), DATE2DMY(CurrentDate, 3) - 1);

        // Initialize totals
        YearToDateSalesIntern := 0;
        YearToDateSalesEkstern := 0;
        LastYearToDateSalesIntern := 0;
        LastYearToDateSalesEkstern := 0;

        // Calculate YTD Sales for the current year
        ProcessSalesInvoices(StartOfYear, CurrentDate, YearToDateSalesIntern, YearToDateSalesEkstern);
        ProcessSalesCreditMemos(StartOfYear, CurrentDate, YearToDateSalesIntern, YearToDateSalesEkstern);
        TotalYearToDateSales := YearToDateSalesIntern + YearToDateSalesEkstern;

        // Calculate YTD Sales for last year
        ProcessSalesInvoices(StartOfLastYear, EndOfLastYear, LastYearToDateSalesIntern, LastYearToDateSalesEkstern);
        ProcessSalesCreditMemos(StartOfLastYear, EndOfLastYear, LastYearToDateSalesIntern, LastYearToDateSalesEkstern);
        TotalLastYearYTDSales := LastYearToDateSalesIntern + LastYearToDateSalesEkstern;

        // Calculate the sales index with last year's YTD sales as the base (100)
        if TotalLastYearYTDSales <> 0 then
            SalesIndex := ROUND((TotalYearToDateSales / TotalLastYearYTDSales) * 100, 1)
        else
            SalesIndex := 0; // Avoid division by zero
    end;

    procedure CheckAndUpdateSalesComparison()
    begin
        // Get the current date and time
        CurrentDateTime := CURRENTDATETIME;
        // Recalculate and store the sales comparison data
        CalculateAndStoreSalesComparison();
    end;

    procedure CountDistinctUsedCampaignNo(): Integer
    var
        SalesLine: Record "Sales Line";
        CampaignDict: Dictionary of [Code[20], Boolean];
        DistinctCount: Integer;
    begin
        DistinctCount := 0;

        // Filter Sales Lines where "Campaign No." is not blank
        SalesLine.SetFilter("Used Campaign NOTO", '<>%1', '');

        // Loop through Sales Lines
        if SalesLine.FindSet() then
            repeat
                if not CampaignDict.ContainsKey(SalesLine."Used Campaign NOTO") then begin
                    CampaignDict.Add(SalesLine."Used Campaign NOTO", true);
                    DistinctCount += 1;
                end;
            until SalesLine.Next() = 0;

        exit(DistinctCount);
    end;

    procedure GetRealizedSalesAmount(var RealizedSalesAmountINTERN: Decimal; var RealizedSalesAmountEKSTERN: Decimal)
    var
        CurrentDate: Date;
        StartOfYear: Date;
    begin
        RealizedSalesAmountINTERN := 0;
        RealizedSalesAmountEKSTERN := 0;

        // Get today's date
        CurrentDate := TODAY;
        // Calculate the start of the current year
        StartOfYear := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3));

        // Process Sales Invoices
        ProcessSalesInvoices(StartOfYear, CurrentDate, RealizedSalesAmountINTERN, RealizedSalesAmountEKSTERN);

        // Process Sales Credit Memos
        ProcessSalesCreditMemos(StartOfYear, CurrentDate, RealizedSalesAmountINTERN, RealizedSalesAmountEKSTERN);
    end;

    procedure GetSalesOrdersAmount(var SalesOrderAmountINTERN: Decimal; var SalesOrderAmountEKSTERN: Decimal)
    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesOrderAmountINTERN := 0;
        SalesOrderAmountEKSTERN := 0;

        // Set filter on Sales Header to include only Sales Orders
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);

        // Loop through the Sales Header records
        if SalesHeader.FindSet() then
            repeat
                // Set filter on Sales Line to match the Sales Header Document No.
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Outstanding Amount (LCY)", '<>%1', 0);

                // Loop through the sales lines related to the current Sales Header
                if SalesLine.FindSet() then
                    repeat
                        // Process only lines of type Item
                        if SalesLine.Type = SalesLine.Type::Item then
                            // Get the related Item record
                            if Item.Get(SalesLine."No.") then
                                // Accumulate amounts based on Inventory Posting Group
                                if Item."Inventory Posting Group" = 'INTERN' then
                                    SalesOrderAmountINTERN += SalesLine."Outstanding Amount (LCY)" / 1000
                                else
                                    SalesOrderAmountEKSTERN += SalesLine."Outstanding Amount (LCY)" / 1000;
                    until SalesLine.Next() = 0;
            until SalesHeader.Next() = 0;
    end;

    procedure ProcessSalesCreditMemos(FromDate: Date; ToDate: Date; var RealizedSalesAmountINTERN: Decimal; var RealizedSalesAmountEKSTERN: Decimal)
    var
        Item: Record Item;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Amount: Decimal;
        CurrencyFactor: Decimal;
    begin
        // Set filters for Sales Credit Memo Line
        SalesCrMemoLine.SetRange("Posting Date", FromDate, ToDate);
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);

        // Loop through Sales Credit Memo Lines
        if SalesCrMemoLine.FindSet() then
            repeat
                // Get the related Item record
                if Item.Get(SalesCrMemoLine."No.") then begin
                    // Get Currency Factor
                    SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.");
                    CurrencyFactor := SalesCrMemoHeader."Currency Factor";
                    if CurrencyFactor = 0 then
                        CurrencyFactor := 1;

                    // Calculate line amount with currency factor and reverse sign for Credit Memos
                    Amount := -(SalesCrMemoLine.Amount / CurrencyFactor) / 1000;

                    // Accumulate amounts based on Inventory Posting Group
                    if Item."Inventory Posting Group" = 'INTERN' then
                        RealizedSalesAmountINTERN += Amount
                    else
                        RealizedSalesAmountEKSTERN += Amount;
                end;
            until SalesCrMemoLine.Next() = 0;
    end;

    procedure ProcessSalesInvoices(FromDate: Date; ToDate: Date; var RealizedSalesAmountINTERN: Decimal; var RealizedSalesAmountEKSTERN: Decimal)
    var
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Amount: Decimal;
        CurrencyFactor: Decimal;
    begin
        // Set filters for Sales Invoice within the date range
        SalesInvoiceLine.SetRange("Posting Date", FromDate, ToDate);
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);

        // Loop through Sales Invoice Lines
        if SalesInvoiceLine.FindSet() then
            repeat
                // Get the related Item record
                if Item.Get(SalesInvoiceLine."No.") then begin
                    // CurrencyFactor
                    SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.");
                    CurrencyFactor := SalesInvoiceHeader."Currency Factor";
                    if CurrencyFactor = 0 then
                        CurrencyFactor := 1;

                    // Calculate line amount with currency factor
                    Amount := (SalesInvoiceLine.Amount / CurrencyFactor) / 1000;

                    // Accumulate amounts based on Inventory Posting Group
                    if Item."Inventory Posting Group" = 'INTERN' then
                        RealizedSalesAmountINTERN += Amount
                    else
                        RealizedSalesAmountEKSTERN += Amount;
                end;
            until SalesInvoiceLine.Next() = 0;
    end;

    procedure UpdateSalesComparisonData()
    begin
        // Update the budget amounts first
        UpdateSalesComparisonWithBudget();
        // Then update the sales comparison data
        CheckAndUpdateSalesComparison();
    end;



    /*
        procedure UpdateSalesComparisonWithBudget()
        var
            Item: Record Item;
            ItemBudgetEntry: Record "Item Budget Entry";
            ItemBudgetName: Record "Item Budget Name"; // Item Budget Name table (7132)
            CurrentDate: Date;
            StartOfYear: Date;
            BudgetAmountEKSTERN: Decimal;
            BudgetAmountINTERN: Decimal;
            TotalBudgetAmount: Decimal;
        begin
            // Get the current date and start of the current year
            CurrentDate := TODAY;
            StartOfYear := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3));

            // Initialize budget amounts
            BudgetAmountINTERN := 0;
            BudgetAmountEKSTERN := 0;

            // Set filters on Item Budget Name to include only unblocked budgets with analysis area Sales
            ItemBudgetName.SetRange(Blocked, false);
            ItemBudgetName.SetRange("Analysis Area", ItemBudgetName."Analysis Area"::Sales);

            // Loop through the valid Item Budget Names
            if ItemBudgetName.FindSet() then
                repeat
                    // Set filters on Item Budget Entry for current year and up to today's date, and valid budget names
                    ItemBudgetEntry.SetRange("Date", StartOfYear, CurrentDate);
                    ItemBudgetEntry.SetRange("Budget Name", ItemBudgetName."Name"); // Use the valid budget name
                    ItemBudgetEntry.SetRange("Analysis Area", ItemBudgetEntry."Analysis Area"::Sales);

                    // Loop through the Item Budget Entry records
                    if ItemBudgetEntry.FindSet() then
                        repeat
                            // Get the related Item record based on Item No.
                            if Item.Get(ItemBudgetEntry."Item No.") then
                                // Accumulate amounts based on Inventory Posting Group
                                if Item."Inventory Posting Group" = 'INTERN' then
                                    BudgetAmountINTERN += ItemBudgetEntry."Sales Amount" / 1000
                                else
                                    BudgetAmountEKSTERN += ItemBudgetEntry."Sales Amount" / 1000;
                        until ItemBudgetEntry.Next() = 0;
                until ItemBudgetName.Next() = 0;

            // Calculate the total budget amount
            TotalBudgetAmount := BudgetAmountINTERN + BudgetAmountEKSTERN;

            // Update or insert the SalesComparisonData record with budget amounts
            if SalesCompData.FindFirst() then begin
                SalesCompData."Budget Amount INTERN" := BudgetAmountINTERN;
                SalesCompData."Budget Amount EKSTERN" := BudgetAmountEKSTERN;
                SalesCompData."Total Budget Amount" := TotalBudgetAmount;
                SalesCompData.Modify();
            end else begin
                SalesCompData.Init();
                SalesCompData."Budget Amount INTERN" := BudgetAmountINTERN;
                SalesCompData."Budget Amount EKSTERN" := BudgetAmountEKSTERN;
                SalesCompData."Total Budget Amount" := TotalBudgetAmount;
                SalesCompData.Insert();
            end;
        end;
    */
    procedure UpdateSalesComparisonWithBudget()
    var
        Item: Record Item;
        ItemBudgetEntry: Record "Item Budget Entry";
        ItemBudgetName: Record "Item Budget Name"; // Item Budget Name table (7132)
        CurrentDate: Date;
        EndOfCurrentMonth: Date;
        StartOfYear: Date;
        BudgetAmountCurrentMonthEKSTERN: Decimal;
        BudgetAmountCurrentMonthINTERN: Decimal;
        BudgetAmountPrevMonthsEKSTERN: Decimal;
        BudgetAmountPrevMonthsINTERN: Decimal;
        TotalBudgetAmount: Decimal;
        TotalBudgetAmountEKSTERN: Decimal;
        TotalBudgetAmountINTERN: Decimal;
        DaysElapsedInCurrentMonth: Integer;
        DaysInCurrentMonth: Integer;
    begin
        // Get the current date, start of the current year, and end of the current month
        CurrentDate := TODAY;
        StartOfYear := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3));
        EndOfCurrentMonth := CALCDATE('<CM+1D>', CurrentDate) - 1;

        // Initialize budget amounts
        BudgetAmountPrevMonthsINTERN := 0;
        BudgetAmountPrevMonthsEKSTERN := 0;
        BudgetAmountCurrentMonthINTERN := 0;
        BudgetAmountCurrentMonthEKSTERN := 0;

        // Calculate days in current month and days elapsed
        DaysInCurrentMonth := DATE2DMY(EndOfCurrentMonth, 1);
        DaysElapsedInCurrentMonth := DATE2DMY(CurrentDate, 1);

        // Set filters on Item Budget Name to include only unblocked budgets with analysis area Sales
        ItemBudgetName.SetRange(Blocked, false);
        ItemBudgetName.SetRange("Analysis Area", ItemBudgetName."Analysis Area"::Sales);

        // Loop through the valid Item Budget Names
        if ItemBudgetName.FindSet() then
            repeat
                // Set filters on Item Budget Entry for current year up to end of current month
                ItemBudgetEntry.SetRange("Date", StartOfYear, EndOfCurrentMonth);
                ItemBudgetEntry.SetRange("Budget Name", ItemBudgetName."Name"); // Use the valid budget name
                ItemBudgetEntry.SetRange("Analysis Area", ItemBudgetEntry."Analysis Area"::Sales);

                // Loop through the Item Budget Entry records
                if ItemBudgetEntry.FindSet() then
                    repeat
                        // Get the related Item record based on Item No.
                        if Item.Get(ItemBudgetEntry."Item No.") then
                            // Determine if the entry date is in the current month
                            if (DATE2DMY(ItemBudgetEntry."Date", 2) = DATE2DMY(CurrentDate, 2)) and
                           (DATE2DMY(ItemBudgetEntry."Date", 3) = DATE2DMY(CurrentDate, 3)) then begin
                                // Entry is in the current month
                                // Accumulate amounts for current month
                                if Item."Inventory Posting Group" = 'INTERN' then
                                    BudgetAmountCurrentMonthINTERN += ItemBudgetEntry."Sales Amount"
                                else
                                    BudgetAmountCurrentMonthEKSTERN += ItemBudgetEntry."Sales Amount";
                            end else
                                // Entry is in a previous month
                                // Accumulate amounts for previous months
                                if Item."Inventory Posting Group" = 'INTERN' then
                                    BudgetAmountPrevMonthsINTERN += ItemBudgetEntry."Sales Amount"
                                else
                                    BudgetAmountPrevMonthsEKSTERN += ItemBudgetEntry."Sales Amount";
                    until ItemBudgetEntry.Next() = 0;
            until ItemBudgetName.Next() = 0;

        // Adjust current month's budget amounts proportionally
        BudgetAmountCurrentMonthINTERN := BudgetAmountCurrentMonthINTERN * DaysElapsedInCurrentMonth / DaysInCurrentMonth;
        BudgetAmountCurrentMonthEKSTERN := BudgetAmountCurrentMonthEKSTERN * DaysElapsedInCurrentMonth / DaysInCurrentMonth;

        // Calculate total budget amounts and convert to thousands
        TotalBudgetAmountINTERN := (BudgetAmountPrevMonthsINTERN + BudgetAmountCurrentMonthINTERN) / 1000;
        TotalBudgetAmountEKSTERN := (BudgetAmountPrevMonthsEKSTERN + BudgetAmountCurrentMonthEKSTERN) / 1000;

        // Calculate the total budget amount
        TotalBudgetAmount := TotalBudgetAmountINTERN + TotalBudgetAmountEKSTERN;

        // Update or insert the SalesComparisonData record with budget amounts
        if SalesComparisonData.FindFirst() then begin
            SalesComparisonData."Budget Amount INTERN" := TotalBudgetAmountINTERN;
            SalesComparisonData."Budget Amount EKSTERN" := TotalBudgetAmountEKSTERN;
            SalesComparisonData."Total Budget Amount" := TotalBudgetAmount;
            SalesComparisonData.Modify();
        end else begin
            SalesComparisonData.Init();
            SalesComparisonData."Budget Amount INTERN" := TotalBudgetAmountINTERN;
            SalesComparisonData."Budget Amount EKSTERN" := TotalBudgetAmountEKSTERN;
            SalesComparisonData."Total Budget Amount" := TotalBudgetAmount;
            SalesComparisonData.Insert();
        end;
    end;

}
