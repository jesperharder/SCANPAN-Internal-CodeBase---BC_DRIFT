using System.Integration;

page 50044 "ProdControllingDashboard"
{
    /// <summary>
    /// Page ProdControllingDashboard (ID 50044).
    /// </summary>
    /// <remarks>
    /// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts, Charts
    /// 2023.11             Jesper Harder       058         Save Page Settings
    /// 2024.11             Jesper Harder       095         Look up production orders from Chart Dashboard
    /// </remarks>

    AdditionalSearchTerms = 'Scanpan, Dashboard, Production, Controlling, Graph, Chart';
    ApplicationArea = All;
    Caption = 'Production Controlling Dashboard';
    PageType = Card;
    Permissions =
        tabledata "Prod. Dashboard User Pref." = RIMD;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(Foundry)
            {
                Caption = 'Foundry';
                Visible = VisibleFoundry;

                group(PressAll)
                {
                    Visible = VisiblePressAll;
                    Caption = 'All Presses';

                    usercontrol(AllPresses; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"All Presses");
                        end;
                    }

                }
                group(Press1)
                {
                    Caption = 'Casting1';
                    Visible = VisiblePress1;
                    usercontrol(ST1; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 1");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 1", point);
                        end;

                    }
                }
                group(Press2)
                {
                    Caption = 'Casting1';
                    Visible = VisiblePress2;
                    usercontrol(ST2; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 2");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 2", point);
                        end;
                    }
                }
                group(Press3)
                {
                    Caption = 'Casting3';
                    Visible = VisiblePress3;
                    usercontrol(ST3; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 3");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 3", point);
                        end;

                    }
                }
                group(Press4)
                {
                    Caption = 'Casting4';
                    Visible = VisiblePress4;
                    usercontrol(ST4; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 4");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 4", point);
                        end;

                    }
                }
                group(Press5)
                {
                    Caption = 'Casting5';
                    Visible = VisiblePress5;
                    usercontrol(ST5; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 5");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 5", point);
                        end;

                    }
                }
                group(Press6)
                {
                    Caption = 'Casting6';
                    Visible = VisiblePress6;
                    usercontrol(ST6; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 6");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 6", point);
                        end;

                    }
                }
                group(Press7)
                {
                    Caption = 'Casting7';
                    Visible = VisiblePress7;
                    usercontrol(ST7; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 7");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 7", point);
                        end;

                    }
                }
                group(Press8)
                {
                    Caption = 'Casting8';
                    Visible = VisiblePress8;
                    usercontrol(ST8; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Press 8");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Press 8", point);
                        end;

                    }
                }
            }
            group(Processing)
            {
                Caption = 'Processing';
                Visible = VisibleProcessing;

                group(Coating09)
                {
                    Caption = 'Coating1';
                    Visible = Visible09;
                    usercontrol(Machin09; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Coating1);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Coating1, point);
                        end;
                    }
                }

                group(Coating16)
                {
                    Caption = 'Coating2';
                    Visible = Visible16;
                    usercontrol(Machin16; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Coating2);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Coating2, point);
                        end;

                    }
                }


                group(Lathe1)
                {
                    Caption = 'Lathe1';
                    Visible = Visible10;
                    usercontrol(Machin10; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Lathe1);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Lathe1, point);
                        end;

                    }
                }
                group(Lathe2)
                {
                    Caption = 'Lathe2';
                    Visible = Visible15;
                    usercontrol(Machin15; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Lathe2);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Lathe2, point);
                        end;
                    }
                }

                group(Lathe3)
                {
                    Caption = 'Lathe3';
                    Visible = Visible18;
                    usercontrol(Machin18; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Lathe3);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Lathe3, point);
                        end;

                    }
                }


                group(Polishing1)
                {
                    Caption = 'Polishing';
                    Visible = Visible25;
                    usercontrol(Machin25; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Polishing);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Polishing, point);
                        end;

                    }
                }
                group(Scrubbing1)
                {
                    Caption = 'Scrubbing';
                    Visible = Visible27;
                    usercontrol(Machin27; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Scrubbing);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Scrubbing, point);
                        end;

                    }
                }
            }

            group(Packaging)
            {
                Caption = 'Packaging';
                Visible = VisiblePackaging;

                group(RoutePA)
                {
                    Caption = 'Arb.Center f. pakkeri';
                    Visible = VisiblePA;

                    usercontrol(MachinPA; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Packaging);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Packaging, point);
                        end;

                    }
                }
                group(RouteNI)
                {
                    Caption = 'Arb.Center f. nittemaskine';
                    Visible = VisibleNI;
                    usercontrol(WorkNI; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::Riveting);
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::Riveting, point);
                        end;

                    }
                }
                group(RouteSK)
                {
                    Caption = 'Skafte';
                    Visible = VisibleSK;
                    usercontrol(MachinSK; BusinessChart)
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshChart(DashboardChartId::"Installing Handle");
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            OpenChartDrilldown(DashboardChartId::"Installing Handle", point);
                        end;

                    }
                }
            }

            group(Settings)
            {
                Caption = 'Settings';
                group(POrderStatus)
                {
                    Caption = 'Order Status';
                    //"Simulated","Planned","Firm Planned","Released","Finished";
                    field(OrderStatus0; OrderStatus[1])
                    {
                        Caption = 'Simulated';
                        ToolTip = 'Specifies the value of the Simulated field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(OrderStatus1; OrderStatus[2])
                    {
                        Caption = 'Planned';
                        ToolTip = 'Specifies the value of the Planned field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(OrderStatus2; OrderStatus[3])
                    {
                        Caption = 'Firm Planned';
                        ToolTip = 'Specifies the value of the Firm Planned field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(OrderStatus3; OrderStatus[4])
                    {
                        Caption = 'Released';
                        ToolTip = 'Specifies the value of the Released field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(OrderStatus4; OrderStatus[5])
                    {
                        Caption = 'Finished';
                        ToolTip = 'Specifies the value of the Finished field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(ProductionDateSelection; ProductionDateSelection)
                    {
                        Caption = 'Date Selection';
                        ToolTip = 'Specifies if Begining date or Ending date is uses to display data.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }

                }
                group(Types)
                {
                    Caption = 'Chart settings';

                    field(BusinessChartType; BusinessChartType)
                    {
                        Caption = 'Chart Type';
                        ToolTip = 'Specifies the value of the Chart Type field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(ChartDataType; ChartDataType)
                    {
                        Caption = 'Data Type';
                        ToolTip = 'Specifies the value of the Data Type field.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                }
                field(CombinedChart; CombinedChart)
                {
                    Caption = 'Toggle Combined Line Chart';
                    ToolTip = 'Toggles the combined Line Chart View.';
                    trigger OnValidate()
                    begin
                        HandleDashboardSettingChanged();
                    end;
                }

                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the value of the Date Filter field.';
                    trigger OnValidate()
                    var
                        FilterTxt: Text;
                    begin
                        FilterTxt := DateFilter;
                        FilterTokens.MakeDateFilter(FilterTxt);
                        DateFilter := Format(FilterTxt, 2048);
                        UseCurrentDate := false;
                        HandleDashboardSettingChanged();
                    end;
                }
                field(UseCurrentDate; UseCurrentDate)
                {
                    Caption = 'Use Current Date';
                    ToolTip = 'Specifies the value of the Use Current Date field.';
                    trigger OnValidate()
                    begin
                        if UseCurrentDate then
                            DateFilter := Format(Today);
                        HandleDashboardSettingChanged();
                    end;
                }
                field(PeriodFormat; PeriodFormat)
                {
                    Caption = 'Period Format';
                    ToolTip = 'Specifies the value of the PeriodFormat field.';
                    trigger OnValidate()
                    begin
                        HandleDashboardSettingChanged();
                    end;
                }
                field(PeriodLength; PeriodLength)
                {
                    Caption = 'Period Length';
                    ToolTip = 'Specifies the value of the Period Length field.';
                    trigger OnValidate()
                    begin
                        HandleDashboardSettingChanged();
                    end;
                }
            }

            group(FoundryChartSettings)
            {
                Caption = 'FoundryChart Settings';
                group(FoundryChartVisibility)
                {
                    Caption = 'Foundry Chart visibility';

                    field(VisibleFoundry; VisibleFoundry)
                    {
                        Caption = 'Toggle Foundry';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(VisiblePressAll; VisiblePressAll)
                    {
                        Caption = 'All Presses';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"All Presses");
                        end;
                    }
                    field(VisiblePress1; VisiblePress1)
                    {
                        Caption = 'Press 1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 1");
                        end;
                    }
                    field(VisiblePress2; VisiblePress2)
                    {
                        Caption = 'Press 2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 2");
                        end;
                    }
                    field(VisiblePress3; VisiblePress3)
                    {
                        Caption = 'Press 3';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 3");
                        end;
                    }
                    field(VisiblePress4; VisiblePress4)
                    {
                        Caption = 'Press 4';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 4");
                        end;
                    }
                    field(VisiblePress5; VisiblePress5)
                    {
                        Caption = 'Press 5';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 5");
                        end;
                    }
                    field(VisiblePress6; VisiblePress6)
                    {
                        Caption = 'Press 6';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 6");
                        end;
                    }
                    field(VisiblePress7; VisiblePress7)
                    {
                        Caption = 'Press 7';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 7");
                        end;
                    }
                    field(VisiblePress8; VisiblePress8)
                    {
                        Caption = 'Press 8';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Press 8");
                        end;
                    }
                }
                group(ProcessingChartVisibility)
                {
                    Caption = 'Processing Chart visibility';
                    //120
                    field(VisibleProcessing; VisibleProcessing)
                    {
                        Caption = 'Toggle Processing';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }
                    field(Visible09; Visible09)
                    {
                        Caption = 'Coating1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Coating1);
                        end;
                    }

                    field(Visible16; Visible16)
                    {
                        Caption = 'Coating2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Coating2);
                        end;
                    }
                    field(Visible10; Visible10)
                    {
                        Caption = 'Lathe1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Lathe1);
                        end;
                    }
                    field(Visible15; Visible15)
                    {
                        Caption = 'Lathe2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Lathe2);
                        end;
                    }
                    field(Visible18; Visible18)
                    {
                        Caption = 'Lathe3';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Lathe3);
                        end;
                    }
                    field(Visible25; Visible25)
                    {
                        Caption = 'Polishing';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Polishing);
                        end;
                    }
                    field(Visible27; Visible27)
                    {
                        Caption = 'Scrubbing';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Scrubbing);
                        end;
                    }

                }
                group(PackagingChartVisibility)
                {
                    Caption = 'Packaging Chart visibility';
                    field(VisiblePackaging; VisiblePackaging)
                    {
                        Caption = 'Toggle Packaging';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleDashboardSettingChanged();
                        end;
                    }

                    field(VisiblePA; VisiblePA)
                    {
                        Caption = 'Packaging';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Packaging);
                        end;
                    }
                    field(VisibleNI; VisibleNI)
                    {
                        Caption = 'Riviting';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::Riveting);
                        end;
                    }
                    field(VisibleSK; VisibleSK)
                    {
                        Caption = 'Installing Handle';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            HandleChartVisibilityChanged(DashboardChartId::"Installing Handle");
                        end;
                    }

                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            ToolTip = 'Navigate related production areas.';

            group(BuildInAreas)
            {
                Caption = 'Native Tools';
                ToolTip = 'Navigate the Business Central native production tools.';

                action("Firm Planned Prod. Orders")
                {
                    Image = PlannedOrder;
                    Caption = 'Firm Planned Prod. Orders';
                    ToolTip = 'Executes the Firm Planned Prod. Orders action.';
                    RunObject = page "Firm Planned Prod. Orders";
                }
                action("Released Production Orders")
                {
                    Image = PlannedOrder;
                    Caption = 'Released Production Orders';
                    ToolTip = 'Executes the Released Production Orders action.';
                    RunObject = page "Released Production Orders";
                }
                action("Finished Production Orders")
                {
                    Image = Archive;
                    Caption = 'Finished Production Orders';
                    ToolTip = 'Executes the Finished Production Orders action.';
                    RunObject = page "Finished Production Orders";
                }

            }
            group("Controlling")
            {
                Caption = 'Controlling';
                ToolTip = 'Navigate the specialized Controlling tools.';
                action("ProductionControlling ")
                {
                    Image = LinesFromJob;
                    Caption = 'Production Lines';
                    ToolTip = 'Insepct Firmed, Released and Transfer lines.';
                    RunObject = Page ProductionControlling;
                }
                action("ProdControllingRoutingLine")
                {
                    Image = Production;
                    Caption = 'Production Prioritize Routing Line';
                    ToolTip = 'prioritize, comments, and print the list.';
                    RunObject = Page ProdControllingRoutingLine;
                }
                action("ProdControlListRoutingLine")
                {
                    Image = Route;
                    Caption = 'Production List Routing Line';
                    ToolTip = 'View all production routinglines.';
                    RunObject = page ProdControlListRoutingLine;
                }
                group("ControllingSetup")
                {
                    Caption = 'Controlling Setup';
                    ToolTip = 'Establish the prerequisites for Controlling.';
                    action("ProdControllingItemMap")
                    {
                        Image = ProductionSetup;
                        Caption = 'Setup Production Item Map';
                        ToolTip = 'Setup list for listing BoM items with common nametypes.';
                        RunObject = page ProdControllingItemMap;
                    }

                }
            }
        }
        area(Processing)
        {
            action(ResetDashboardSettings)
            {
                Caption = 'Reset Dashboard Settings';
                Image = Restore;
                ToolTip = 'Resets the production dashboard settings for the current user and company.';

                trigger OnAction()
                begin
                    ResetDashboardPreference();
                end;
            }
        }
        area(Reporting)
        {
            action("ProductionControllingPriority")
            {
                Image = PrintChecklistReport;
                Caption = 'Print Production Priority Report';
                ToolTip = 'Prints production priority report, used at each production ressource.';
                RunObject = report ProductionControllingPriority;
            }

        }
        area(Creation)
        { }
    }

    var
        DashboardChartMgt: Codeunit "Prod. Dashboard Chart Mgt.";
        DashboardDrilldownMgt: Codeunit "Prod. Dashboard Drilldown Mgt.";
        DashboardPreferenceMgt: Codeunit "Prod. Dashboard Pref. Mgt.";
        FilterTokens: Codeunit "Filter Tokens";
        DashboardPreference: Record "Prod. Dashboard User Pref.";

        OrderStatus: array[5] of Boolean;

        UseCurrentDate: Boolean;

        BusinessChartType: enum "Business Chart Type";
        ChartDataType: Enum EnumChartDataType;
        DashboardChartId: Enum "Prod. Dashboard Chart ID";
        PeriodFormat: Enum "PeriodType";
        ProductionDateSelection: Enum EnumProductionDateSelection;
        PeriodLength: Integer;

        DateFilter: Text[2048];

        CombinedChart: Boolean;
        c: Integer;

        //110
        VisibleFoundry: Boolean;
        VisiblePressAll: Boolean;
        VisiblePress1: Boolean;
        VisiblePress2: Boolean;
        VisiblePress3: Boolean;
        VisiblePress4: Boolean;
        VisiblePress5: Boolean;
        VisiblePress6: Boolean;
        VisiblePress7: Boolean;
        VisiblePress8: Boolean;

        //120
        VisibleProcessing: Boolean;
        Visible09: Boolean;
        Visible15: Boolean;
        Visible10: Boolean;
        Visible16: Boolean;
        Visible18: Boolean;
        Visible25: Boolean;
        Visible27: Boolean;
        //130
        VisiblePackaging: Boolean;
        VisiblePA: Boolean;
        VisibleSK: Boolean;
        VisibleNI: Boolean;



    trigger OnOpenPage()
    begin
        DashboardPreferenceMgt.GetOrCreatePreference(DashboardPreference);
        ApplyPreferenceToPage();
        UpdatePage()
    end;

    trigger OnClosePage()
    begin
        SaveDashboardPreference();
    end;

    local procedure RefreshVisibleCharts()
    var
        Dialog: Dialog;
        MessageLbl: Label 'Refreshing Charts #1', Comment = '#1 Counter.';
    begin
        c := 0;
        if GuiAllowed then
            Dialog.Open(MessageLbl);

        RefreshChartWithProgress(DashboardChartId::"All Presses", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 1", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 2", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 3", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 4", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 5", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 6", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 7", Dialog);
        RefreshChartWithProgress(DashboardChartId::"Press 8", Dialog);
        RefreshChartWithProgress(DashboardChartId::Coating1, Dialog);
        RefreshChartWithProgress(DashboardChartId::Coating2, Dialog);
        RefreshChartWithProgress(DashboardChartId::Lathe1, Dialog);
        RefreshChartWithProgress(DashboardChartId::Lathe2, Dialog);
        RefreshChartWithProgress(DashboardChartId::Lathe3, Dialog);
        RefreshChartWithProgress(DashboardChartId::Polishing, Dialog);
        RefreshChartWithProgress(DashboardChartId::Scrubbing, Dialog);
        RefreshChartWithProgress(DashboardChartId::Packaging, Dialog);
        RefreshChartWithProgress(DashboardChartId::Riveting, Dialog);
        RefreshChartWithProgress(DashboardChartId::"Installing Handle", Dialog);

        if GuiAllowed then
            Dialog.Close();
        UpdatePage();
    end;

    local procedure RefreshChart(ChartId: Enum "Prod. Dashboard Chart ID")
    var
        TempBusinessChartBuffer: Record "Business Chart Buffer" temporary;
    begin
        if not IsChartVisible(ChartId) then
            exit;

        BuildChart(ChartId, TempBusinessChartBuffer);
        UpdateChartControl(ChartId, TempBusinessChartBuffer);
    end;

    local procedure RefreshChartWithProgress(ChartId: Enum "Prod. Dashboard Chart ID"; var Dialog: Dialog)
    var
        TempBusinessChartBuffer: Record "Business Chart Buffer" temporary;
    begin
        c += 1;
        if not IsChartVisible(ChartId) then
            exit;

        if GuiAllowed then
            Dialog.Update(1, c);
        BuildChart(ChartId, TempBusinessChartBuffer);
        UpdateChartControl(ChartId, TempBusinessChartBuffer);
    end;

    local procedure BuildChart(ChartId: Enum "Prod. Dashboard Chart ID"; var TempBusinessChartBuffer: Record "Business Chart Buffer" temporary)
    begin
        TempBusinessChartBuffer.DeleteAll();
        DashboardChartMgt.UpdateProductionChart(ChartId,
                                                TempBusinessChartBuffer,
                                                OrderStatus,
                                                ProductionDateSelection,
                                                PeriodFormat,
                                                DateFilter,
                                                PeriodLength,
                                                BusinessChartType,
                                                ChartDataType,
                                                CombinedChart);
    end;

    local procedure UpdateChartControl(ChartId: Enum "Prod. Dashboard Chart ID"; var TempBusinessChartBuffer: Record "Business Chart Buffer" temporary)
    begin
        case ChartId of
            ChartId::"All Presses":
                TempBusinessChartBuffer.UpdateChart(CurrPage.AllPresses);
            ChartId::"Press 1":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST1);
            ChartId::"Press 2":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST2);
            ChartId::"Press 3":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST3);
            ChartId::"Press 4":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST4);
            ChartId::"Press 5":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST5);
            ChartId::"Press 6":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST6);
            ChartId::"Press 7":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST7);
            ChartId::"Press 8":
                TempBusinessChartBuffer.UpdateChart(CurrPage.ST8);
            ChartId::Coating1:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin09);
            ChartId::Coating2:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin16);
            ChartId::Lathe1:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin10);
            ChartId::Lathe2:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin15);
            ChartId::Lathe3:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin18);
            ChartId::Polishing:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin25);
            ChartId::Scrubbing:
                TempBusinessChartBuffer.UpdateChart(CurrPage.Machin27);
            ChartId::Packaging:
                TempBusinessChartBuffer.UpdateChart(CurrPage.MachinPA);
            ChartId::Riveting:
                TempBusinessChartBuffer.UpdateChart(CurrPage.WorkNI);
            ChartId::"Installing Handle":
                TempBusinessChartBuffer.UpdateChart(CurrPage.MachinSK);
            else
                Error('Unsupported production dashboard chart ID: %1.', ChartId);
        end;
    end;

    local procedure IsChartVisible(ChartId: Enum "Prod. Dashboard Chart ID"): Boolean
    begin
        case ChartId of
            ChartId::"All Presses":
                exit(VisibleFoundry and VisiblePressAll);
            ChartId::"Press 1":
                exit(VisibleFoundry and VisiblePress1);
            ChartId::"Press 2":
                exit(VisibleFoundry and VisiblePress2);
            ChartId::"Press 3":
                exit(VisibleFoundry and VisiblePress3);
            ChartId::"Press 4":
                exit(VisibleFoundry and VisiblePress4);
            ChartId::"Press 5":
                exit(VisibleFoundry and VisiblePress5);
            ChartId::"Press 6":
                exit(VisibleFoundry and VisiblePress6);
            ChartId::"Press 7":
                exit(VisibleFoundry and VisiblePress7);
            ChartId::"Press 8":
                exit(VisibleFoundry and VisiblePress8);
            ChartId::Coating1:
                exit(VisibleProcessing and Visible09);
            ChartId::Coating2:
                exit(VisibleProcessing and Visible16);
            ChartId::Lathe1:
                exit(VisibleProcessing and Visible10);
            ChartId::Lathe2:
                exit(VisibleProcessing and Visible15);
            ChartId::Lathe3:
                exit(VisibleProcessing and Visible18);
            ChartId::Polishing:
                exit(VisibleProcessing and Visible25);
            ChartId::Scrubbing:
                exit(VisibleProcessing and Visible27);
            ChartId::Packaging:
                exit(VisiblePackaging and VisiblePA);
            ChartId::Riveting:
                exit(VisiblePackaging and VisibleNI);
            ChartId::"Installing Handle":
                exit(VisiblePackaging and VisibleSK);
        end;

        exit(false);
    end;

    //
    // 058     Save Page Settings
    //
    #region 058 Save Page Settings
    local procedure ApplyPreferenceToPage()
    begin
        PeriodFormat := DashboardPreference."Period Type";
        PeriodLength := DashboardPreference."Period Length";
        DateFilter := DashboardPreference."Date Filter";
        UseCurrentDate := DashboardPreference."Use Current Date";

        if UseCurrentDate then
            DateFilter := Format(Today);

        OrderStatus[1] := DashboardPreference.Simulated;
        OrderStatus[2] := DashboardPreference.Planned;
        OrderStatus[3] := DashboardPreference."Firm Planned";
        OrderStatus[4] := DashboardPreference.Released;
        OrderStatus[5] := DashboardPreference.Finished;
        ProductionDateSelection := DashboardPreference."Production Date Selection";

        BusinessChartType := DashboardPreference."Chart Type";
        ChartDataType := DashboardPreference."Chart Data Type";
        CombinedChart := DashboardPreference."Combined Chart";

        VisibleFoundry := DashboardPreference."Visible Foundry";
        VisiblePressAll := DashboardPreference."Visible All Presses";
        VisiblePress1 := DashboardPreference."Visible Press 1";
        VisiblePress2 := DashboardPreference."Visible Press 2";
        VisiblePress3 := DashboardPreference."Visible Press 3";
        VisiblePress4 := DashboardPreference."Visible Press 4";
        VisiblePress5 := DashboardPreference."Visible Press 5";
        VisiblePress6 := DashboardPreference."Visible Press 6";
        VisiblePress7 := DashboardPreference."Visible Press 7";
        VisiblePress8 := DashboardPreference."Visible Press 8";

        VisibleProcessing := DashboardPreference."Visible Processing";
        Visible09 := DashboardPreference."Visible Coating 1";
        Visible16 := DashboardPreference."Visible Coating 2";
        Visible10 := DashboardPreference."Visible Lathe 1";
        Visible15 := DashboardPreference."Visible Lathe 2";
        Visible18 := DashboardPreference."Visible Lathe 3";
        Visible25 := DashboardPreference."Visible Polishing";
        Visible27 := DashboardPreference."Visible Scrubbing";

        VisiblePackaging := DashboardPreference."Visible Packaging";
        VisiblePA := DashboardPreference."Visible Packaging Chart";
        VisibleSK := DashboardPreference."Visible Installing Handle";
        VisibleNI := DashboardPreference."Visible Riveting";
    end;

    local procedure ApplyPageToPreference()
    begin
        DashboardPreference."Period Type" := PeriodFormat;
        DashboardPreference."Period Length" := PeriodLength;
        DashboardPreference."Use Current Date" := UseCurrentDate;

        if UseCurrentDate then
            DateFilter := Format(Today);
        DashboardPreference."Date Filter" := DateFilter;

        DashboardPreference.Simulated := OrderStatus[1];
        DashboardPreference.Planned := OrderStatus[2];
        DashboardPreference."Firm Planned" := OrderStatus[3];
        DashboardPreference.Released := OrderStatus[4];
        DashboardPreference.Finished := OrderStatus[5];
        DashboardPreference."Production Date Selection" := ProductionDateSelection;

        DashboardPreference."Chart Type" := BusinessChartType;
        DashboardPreference."Chart Data Type" := ChartDataType;
        DashboardPreference."Combined Chart" := CombinedChart;

        DashboardPreference."Visible Foundry" := VisibleFoundry;
        DashboardPreference."Visible All Presses" := VisiblePressAll;
        DashboardPreference."Visible Press 1" := VisiblePress1;
        DashboardPreference."Visible Press 2" := VisiblePress2;
        DashboardPreference."Visible Press 3" := VisiblePress3;
        DashboardPreference."Visible Press 4" := VisiblePress4;
        DashboardPreference."Visible Press 5" := VisiblePress5;
        DashboardPreference."Visible Press 6" := VisiblePress6;
        DashboardPreference."Visible Press 7" := VisiblePress7;
        DashboardPreference."Visible Press 8" := VisiblePress8;

        DashboardPreference."Visible Processing" := VisibleProcessing;
        DashboardPreference."Visible Coating 1" := Visible09;
        DashboardPreference."Visible Coating 2" := Visible16;
        DashboardPreference."Visible Lathe 1" := Visible10;
        DashboardPreference."Visible Lathe 2" := Visible15;
        DashboardPreference."Visible Lathe 3" := Visible18;
        DashboardPreference."Visible Polishing" := Visible25;
        DashboardPreference."Visible Scrubbing" := Visible27;

        DashboardPreference."Visible Packaging" := VisiblePackaging;
        DashboardPreference."Visible Packaging Chart" := VisiblePA;
        DashboardPreference."Visible Installing Handle" := VisibleSK;
        DashboardPreference."Visible Riveting" := VisibleNI;
    end;

    local procedure SaveDashboardPreference()
    begin
        ApplyPageToPreference();
        DashboardPreferenceMgt.SavePreference(DashboardPreference);
    end;

    local procedure ResetDashboardPreference()
    begin
        DashboardPreferenceMgt.ResetPreference(DashboardPreference);
        ApplyPreferenceToPage();
        RefreshVisibleCharts();
    end;

    local procedure HandleDashboardSettingChanged()
    begin
        SaveDashboardPreference();
        RefreshVisibleCharts();
    end;

    local procedure HandleChartVisibilityChanged(ChartId: Enum "Prod. Dashboard Chart ID")
    begin
        SaveDashboardPreference();
        UpdatePage();
        if IsChartVisible(ChartId) then
            RefreshChart(ChartId);
    end;
    #endregion

    //
    // 095 Look up production orders from Chart Dashboard
    //
    local procedure OpenChartDrilldown(ChartId: Enum "Prod. Dashboard Chart ID"; JsonObject: JsonObject)
    begin
        DashboardDrilldownMgt.OpenProductionLines(DashboardChartMgt.GetCapacityNo(ChartId),
                                                  DashboardChartMgt.GetCapacityType(ChartId),
                                                  ProductionDateSelection,
                                                  PeriodFormat,
                                                  ChartDataType,
                                                  OrderStatus,
                                                  JsonObject);
    end;

    procedure UpdatePage()
    begin
        c := 0;
        CurrPage.Update();
    end;
}
