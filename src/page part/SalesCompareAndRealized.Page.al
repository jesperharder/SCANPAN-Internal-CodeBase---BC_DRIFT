page 50060 "SalesCompareAndRealized"
{
    // Page Caption for the page 'Sales Comparison & Realized Sales'
    Caption = 'Sales Comparison & Realized Sales';

    /// <summary>
    /// 2024.08             Jesper Harder       076         Sales Comparison and Realized Sales
    /// 
    /// This page provides an overview of sales data in Business Central.
    /// It allows switching between two views:
    /// 1. **Sales Comparison View**: Compares realized sales across multiple dimensions.
    /// 2. **Realized Sales View**: Displays detailed breakdown of realized sales.
    /// 
    /// Key Features:
    /// - **Charts and Cues**: Allows toggling between visual charts and cue groups for summary statistics.
    /// - **Drill-Down Capability**: Allows navigation to related pages like Sales Order List, Sales Budget Overview, etc.
    /// - **Custom Actions**: Switch between views, toggle group visibility, and refresh data.
    /// </summary>

    PageType = CardPart;

    layout
    {
        area(content)
        {
            // Group that shows the Sales comparison view using a chart (visible when ChartOption = 1)
            group(ComparisonViewGroup)
            {
                Caption = 'Sales Realized View';
                Visible = ChartOption = 1;

                // Chart control for visualizing sales data
                usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                {
                    ApplicationArea = All;

                    // Trigger to build the chart when the Add-in is ready
                    trigger AddInReady()
                    begin
                        BuildChart(); // Populate the chart with sales data
                    end;
                }
            }

            // Group that shows the Cue view for sales data (visible when ChartOption = 2)
            cuegroup(RealizedSalesViewGroup)
            {
                Caption = 'Realized Sales Cue View';
                CuegroupLayout = Wide;
                Visible = ChartOption = 2;

                // Total Sales Order Amount Cue (always visible)
                cuegroup(TotalSalesOrderGroup)
                {
                    Caption = 'Total Sales Orders';

                    cuegroup(TotalSalesOrdersSubCue)
                    {
                        ShowCaption = false;

                        // Field to display the total sales order amount
                        field(TotalSalesOrderAmountField; SalesCompData."Sales Order Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Orders (K)';
                            DecimalPlaces = 0;
                            DrillDownPageId = "Sales Order List"; // Links to Sales Order List
                            ToolTip = 'The total amount of all sales orders in thousands (K).';

                            /*
                                                        // Action to open the filtered page
                                                        trigger OnDrillDown()
                                                        begin
                                                            // Opening a filtered Sales Order List page
                                                            PAGE.Run(PAGE::"Sales Order List");
                                                        end;
                            */
                        }
                    }
                }

                // Group showing sales details (visible when ShowSalesGroup is true)
                cuegroup(SalesDetailsGroup)
                {
                    Caption = 'Sales Details';
                    Visible = ShowSalesGroup;

                    cuegroup(SalesDetailsGroupSubCue)
                    {
                        ShowCaption = false;

                        // Field displaying internal sales orders amount
                        field(SalesOrderAmountInternField; SalesCompData."Sales Amount INTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'INTERN Orders (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Sales order amount for items with the "INTERN" inventory posting group in thousands (K).';
                        }

                        // Field displaying external sales orders amount
                        field(SalesOrderAmountEksternField; SalesCompData."Sales Amount EKSTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'EKSTERN Orders (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Sales order amount for items with the "EKSTERN" inventory posting group in thousands (K).';
                        }
                    }
                }

                // Group showing realized sales metrics (visible when ShowRealizedSalesGroup is true)
                cuegroup(RealizedSalesGroup)
                {
                    Caption = 'Realized Sales';
                    ShowCaption = false;
                    Visible = ShowRealizedSalesGroup;

                    // Subgroup for Year-to-Date (YTD) realized sales metrics
                    cuegroup(RealisedSalesYTD)
                    {
                        Caption = 'Realised Sale YTD';

                        // Field displaying total YTD realized sales amount
                        field(TotalRealizedSalesYTDField; SalesCompData."Total YTD Sales Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'YTD Realized (K)';
                            DecimalPlaces = 0;
                            DrillDownPageId = "Posted Sales Invoices"; // Link to Posted Sales Invoices
                            ToolTip = 'The total realized sales amount year-to-date in thousands (K).';
                        }

                        // Field displaying internal YTD realized sales
                        field(RealizedSalesYTDInternField; SalesCompData."YTD Sales Amount INTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'INTERN YTD Realized (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Year-to-date realized sales amount for "INTERN" items in thousands (K).';
                        }

                        // Field displaying external YTD realized sales
                        field(RealizedSalesYTDEksternField; SalesCompData."YTD Sales Amount EKSTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'EKSTERN YTD Realized (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Year-to-date realized sales amount for "EKSTERN" items in thousands (K).';
                        }
                    }

                    // Subgroup for Last Year YTD realized sales metrics
                    cuegroup(RealisedSalesYTDLY)
                    {
                        Caption = 'Realised Sale Last YTD';

                        // Field displaying total Last Year YTD realized sales amount
                        field(TotalRealizedSalesLastYTDField; SalesCompData."Total Last Year YTD Sales Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Last YTD Realized (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'The total realized sales amount for the same period last year in thousands (K).';
                        }

                        // Field displaying internal Last Year YTD realized sales
                        field(RealizedSalesLastYTDInternField; SalesCompData."Last Year YTD Sales Amount INTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'INTERN Last YTD Realized (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Last years YTD realized sales for "INTERN" items in thousands (K).';
                        }

                        // Field displaying external Last Year YTD realized sales
                        field(RealizedSalesLastYTDEksternField; SalesCompData."Last Year YTD Sales Amount EKSTERN")
                        {
                            ApplicationArea = All;
                            Caption = 'EKSTERN Last YTD Realized (K)';
                            DecimalPlaces = 0;
                            ToolTip = 'Last years YTD realized sales for "EKSTERN" items in thousands (K).';
                        }
                    }
                }

                // Group showing budget details (visible when ShowBudgetGroup is true)
                cuegroup(BudgetGroup)
                {
                    Caption = 'Budget Details';
                    Visible = ShowBudgetGroup;

                    // Field displaying total YTD budgeted amount
                    field(TotalBudgetAmountField; SalesCompData."Total Budget Amount")
                    {
                        ApplicationArea = All;
                        Caption = 'YTD Budget Total (K)';
                        DecimalPlaces = 0;
                        DrillDownPageId = "Sales Budget Overview"; // Link to Sales Budget Overview
                        ToolTip = 'The total budgeted sales amount year-to-date in thousands (K).';
                    }

                    // Field displaying internal YTD budget amount
                    field(BudgetAmountInternField; SalesCompData."Budget Amount INTERN")
                    {
                        ApplicationArea = All;
                        Caption = 'INTERN YTD Budget (K)';
                        DecimalPlaces = 0;
                        ToolTip = 'Year-to-date budgeted amount for "INTERN" items in thousands (K).';
                    }

                    // Field displaying external YTD budget amount
                    field(BudgetAmountEksternField; SalesCompData."Budget Amount EKSTERN")
                    {
                        ApplicationArea = All;
                        Caption = 'EKSTERN YTD Budget (K)';
                        DecimalPlaces = 0;
                        ToolTip = 'Year-to-date budgeted amount for "EKSTERN" items in thousands (K).';
                    }
                }

                // Group displaying additional metrics (always visible)
                cuegroup(AdditionalMetricsGroup)
                {
                    Caption = 'Additional Metrics';

                    cuegroup(AdditionalMetrics)
                    {
                        ShowCaption = false;

                        // Field displaying the number of distinct campaigns
                        field(DistinctCampaignsField; SalesCompData."Distinct Campaigns")
                        {
                            ApplicationArea = All;
                            Caption = 'Distinct Campaigns';
                            DrillDownPageId = "Campaign List"; // Link to Campaign List
                            ToolTip = 'The number of distinct campaigns used across sales orders.';
                        }
                    }

                    // Subgroup for sales growth and sales vs budget comparison metrics
                    cuegroup(AdditionalMetricsGrowth)
                    {
                        ShowCaption = false;

                        // Field displaying sales growth percentage YTD
                        field(SalesIndexField; SalesCompData."Sales Index")
                        {
                            ApplicationArea = All;
                            Caption = 'Sales Growth (%) YTD YoY';
                            StyleExpr = SalesIndexStyle; // Style based on sales growth value
                            ToolTip = 'The percentage growth of year-to-date sales compared to the same period last year.';
                        }

                        // Field displaying sales vs budget percentage YTD
                        field(BudgetVsActualField; SalesCompData."Budget Vs Actual")
                        {
                            ApplicationArea = All;
                            Caption = 'Sales vs. Budget (%) YTD';
                            StyleExpr = BudgetVsActualStyle; // Style based on sales vs budget value
                            ToolTip = 'The percentage comparison of YTD actual sales against the YTD budgeted sales.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            // Action to switch between chart and cue views
            action(SwitchViewAction)
            {
                Caption = 'Switch View';
                Image = View;
                ToolTip = 'Switch between the available charts and cues.';

                // Toggles between ChartOption 1 (chart view) and 2 (cue view)
                trigger OnAction()
                begin
                    if ChartOption = 1 then
                        ChartOption := 2
                    else
                        ChartOption := 1;

                    CurrPage.Update(); // Update the page to reflect changes
                end;
            }

            group(ToggleGroups)
            {
                Caption = 'Toggle Groups';

                // Action to switch between available charts
                action(SwitchChartsAction)
                {
                    Caption = 'Chart Switch';
                    Image = BarChart;
                    ToolTip = 'Switch between the available charts.';

                    // Toggles between two chart options
                    trigger OnAction()
                    begin
                        if ChartSwitchOption = 1 then
                            ChartSwitchOption := 2
                        else
                            ChartSwitchOption := 1;
                        ChartOption := 1;
                        BuildChart(); // Rebuild the chart with the selected option
                        CurrPage.Update();
                    end;
                }

                // Group for toggling cue views
                group(CuesGroup)
                {
                    Caption = 'Cue View';

                    // Toggle sales details group visibility
                    action(ToggleSalesGroupAction)
                    {
                        Caption = 'Show/Hide Sales';
                        Image = ShowList;
                        ToolTip = 'Click to show or hide the sales details.';

                        // Toggle visibility of Sales Details group
                        trigger OnAction()
                        begin
                            ShowSalesGroup := not ShowSalesGroup;
                            CurrPage.Update(); // Update the page to reflect changes
                        end;
                    }

                    // Toggle realized sales group visibility
                    action(ToggleRealizedGroupAction)
                    {
                        Caption = 'Show/Hide Realized Sales';
                        Image = ShowList;
                        ToolTip = 'Click to show or hide the realized sales information.';

                        // Toggle visibility of Realized Sales group
                        trigger OnAction()
                        begin
                            ShowRealizedSalesGroup := not ShowRealizedSalesGroup;
                            CurrPage.Update(); // Update the page to reflect changes
                        end;
                    }

                    // Toggle budget details group visibility
                    action(ToggleBudgetGroupAction)
                    {
                        Caption = 'Show/Hide Budget';
                        Image = ShowList;
                        ToolTip = 'Click to show or hide the budget details.';

                        // Toggle visibility of Budget group
                        trigger OnAction()
                        begin
                            ShowBudgetGroup := not ShowBudgetGroup;
                            CurrPage.Update(); // Update the page to reflect changes
                        end;
                    }

                    // New action to reset the view to default settings
                    action(ResetViewAction)
                    {
                        Caption = 'Reset View';
                        Image = Undo;
                        ToolTip = 'Reset all view settings to their default values.';

                        trigger OnAction()
                        begin
                            // Reset variables to their default values
                            ChartOption := 2;               // Default to Cue view
                            ChartSwitchOption := 1;         // Default to first chart
                            ShowBudgetGroup := false;       // Default to hide Budget group
                            ShowRealizedSalesGroup := false; // Default to hide Realized Sales group
                            ShowSalesGroup := false;        // Default to hide Sales Details group
                            CurrPage.Update();            // Update the page to reflect changes
                        end;
                    }

                }

                // Action to refresh sales comparison data
                action(UpdateSalesComparisonDataAction)
                {
                    Caption = 'Update Data';
                    Image = Refresh;
                    ToolTip = 'Run the update to refresh sales comparison data.';

                    // Trigger to run the codeunit and update data
                    trigger OnAction()
                    begin
                        Codeunit.Run(50014); // Run codeunit to update sales comparison data
                        CurrPage.Update(); // Update the page with the new data
                    end;
                }
            }
        }
    }

    // Trigger to execute when the page is opened
    trigger OnOpenPage()
    begin
        ChartOption := 2; // Set default view to Cue view
        FetchData(); // Fetch initial data
        CurrPage.Update(); // Update the page to display fetched data
    end;

    var
        SalesCompData: Record "SalesComparisonData"; // Record to store sales comparison data
        ShowBudgetGroup: Boolean;                   // Boolean controlling visibility of budget group
        ShowRealizedSalesGroup: Boolean;            // Boolean controlling visibility of realized sales group
        ShowSalesGroup: Boolean;                    // Boolean controlling visibility of sales details group
        ChartSwitchOption: Decimal;                 // Option to toggle between chart types
        ChartOption: Integer;                       // Option to toggle between chart and cue views
        ChartLabelExternalSalesLbl: Label 'EKSTERN Sale';
        ChartLabelInternalSalesLbl: Label 'INTERN Sale';
        ChartLabelLastYTDRealizedLbl: Label 'Last YTD Sales';

        // Translation-ready variables for chart labels
        ChartLabelTotalOrdersLbl: Label 'Total Orders';
        ChartLabelTotalSalesLbl: Label 'Total Sale';
        ChartLabelYTDBudgetLbl: Label 'YTD Budget';
        ChartLabelYTDRealizedLbl: Label 'YTD Sales';
        BudgetVsActualStyle: Text[30];              // Style for the Sales vs Budget metric
        SalesIndexStyle: Text[30];                  // Style for the Sales Growth metric

    // Procedure to build the chart with the required data
    local procedure BuildChart()
    var
        TempBuffer: Record "Business Chart Buffer" temporary; // Temporary buffer to hold chart data
        i: Integer;
    begin
        TempBuffer.Initialize(); // Initialize the temporary buffer

        // Suppress warnings for using obsolete methods
#pragma warning disable AL0603
        TempBuffer.AddMeasure('Amount', 1, TempBuffer."Data Type"::Decimal, TempBuffer."Chart Type"::Column);
#pragma warning restore AL0603

        // Set the X-Axis to 'Metric'
        TempBuffer.SetXAxis('Metric', TempBuffer."Data Type"::String);

        i := 0;

        // Populate chart data based on ChartSwitchOption
        if SalesCompData.FindFirst() then
            if ChartSwitchOption = 1 then begin
                // First chart: Sales comparison metrics
                TempBuffer.AddColumn(ChartLabelTotalOrdersLbl); // Use label for 'Total Orders'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."Sales Order Amount");
                i += 1;

                TempBuffer.AddColumn(ChartLabelYTDRealizedLbl); // Use label for 'YTD Sales'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."Total YTD Sales Amount");
                i += 1;

                TempBuffer.AddColumn(ChartLabelLastYTDRealizedLbl); // Use label for 'Last YTD Sales'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."Total Last Year YTD Sales Amount");
                i += 1;

                TempBuffer.AddColumn(ChartLabelYTDBudgetLbl); // Use label for 'YTD Budget'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."Total Budget Amount");
                i += 1;
            end else begin
                // Second chart: Sales breakdown
                TempBuffer.AddColumn(ChartLabelTotalSalesLbl); // Use label for 'Total Sale'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."Total YTD Sales Amount");
                i += 1;

                TempBuffer.AddColumn(ChartLabelInternalSalesLbl); // Use label for 'INTERN Sale'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."YTD Sales Amount INTERN");
                i += 1;

                TempBuffer.AddColumn(ChartLabelExternalSalesLbl); // Use label for 'EKSTERN Sale'
                TempBuffer.SetValueByIndex(0, i, SalesCompData."YTD Sales Amount EKSTERN");
                i += 1;
            end;

        // Update the chart with the populated data
        TempBuffer.Update(CurrPage.Chart);
    end;

    // Procedure to fetch initial data and set styles for Sales Growth and Budget vs Actual comparison
    local procedure FetchData()
    begin
        if SalesCompData.FindFirst() then begin
            // Set style for Sales Growth (Sales Index) based on its value
            if SalesCompData."Sales Index" <= 100 then
                SalesIndexStyle := 'Unfavorable'
            else
                if (SalesCompData."Sales Index" > 100) and (SalesCompData."Sales Index" <= 104) then
                    SalesIndexStyle := 'Ambiguous'
                else
                    SalesIndexStyle := 'Favorable';

            // Set style for Budget vs Actual comparison based on its value
            if SalesCompData."Budget Vs Actual" <= 102 then
                BudgetVsActualStyle := 'Unfavorable'
            else
                BudgetVsActualStyle := 'Favorable';
        end;
    end;
}
