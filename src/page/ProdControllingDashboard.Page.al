


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
        tabledata UserSettingsPage = RIM;
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

                    usercontrol(AllPresses; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('PressAll');
                        end;
                    }

                }
                group(Press1)
                {
                    Caption = 'Casting1';
                    Visible = VisiblePress1;
                    usercontrol(ST1; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P1');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P1', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press2)
                {
                    Caption = 'Casting1';
                    Visible = VisiblePress2;
                    usercontrol(ST2; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P2');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P2', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;
                    }
                }
                group(Press3)
                {
                    Caption = 'Casting3';
                    Visible = VisiblePress3;
                    usercontrol(ST3; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P3');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P3', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press4)
                {
                    Caption = 'Casting4';
                    Visible = VisiblePress4;
                    usercontrol(ST4; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P4');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P4', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press5)
                {
                    Caption = 'Casting5';
                    Visible = VisiblePress5;
                    usercontrol(ST5; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P5');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P5', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press6)
                {
                    Caption = 'Casting6';
                    Visible = VisiblePress6;
                    usercontrol(ST6; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P6');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P6', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press7)
                {
                    Caption = 'Casting7';
                    Visible = VisiblePress7;
                    usercontrol(ST7; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P7');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P7', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Press8)
                {
                    Caption = 'Casting8';
                    Visible = VisiblePress8;
                    usercontrol(ST8; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            RefreshPage('P8');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('P8', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
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
                    usercontrol(Machin09; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('09');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('09', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;
                    }
                }

                group(Coating16)
                {
                    Caption = 'Coating2';
                    Visible = Visible16;
                    usercontrol(Machin16; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('16');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('16', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }


                group(Lathe1)
                {
                    Caption = 'Lathe1';
                    Visible = Visible10;
                    usercontrol(Machin10; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('10');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('10', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Lathe2)
                {
                    Caption = 'Lathe2';
                    Visible = Visible15;
                    usercontrol(Machin15; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('15');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('15', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;
                    }
                }

                group(Lathe3)
                {
                    Caption = 'Lathe3';
                    Visible = Visible18;
                    usercontrol(Machin18; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('18');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('18', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }


                group(Polishing1)
                {
                    Caption = 'Polishing';
                    Visible = Visible25;
                    usercontrol(Machin25; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('25');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('25', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(Scrubbing1)
                {
                    Caption = 'Scrubbing';
                    Visible = Visible27;
                    usercontrol(Machin27; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('27');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('27', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
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

                    usercontrol(MachinPA; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('PA');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('PA', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(RouteNI)
                {
                    Caption = 'Arb.Center f. nittemaskine';
                    Visible = VisibleNI;
                    usercontrol(WorkNI; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('NI');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('NI', CapacityType::"Work Center", ProductionDateSelection, PeriodFormat, point);
                        end;

                    }
                }
                group(RouteSK)
                {
                    Caption = 'Skafte';
                    Visible = VisibleSK;
                    usercontrol(MachinSK; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                    {
                        ApplicationArea = all;
                        trigger AddInReady()
                        begin
                            //PageIsFirstRun := 2;
                            RefreshPage('SK');
                        end;

                        trigger DataPointClicked(point: JsonObject)
                        begin
                            GetXValueString('SK', CapacityType::"Machine Center", ProductionDateSelection, PeriodFormat, point);
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
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(OrderStatus1; OrderStatus[2])
                    {
                        Caption = 'Planned';
                        ToolTip = 'Specifies the value of the Planned field.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(OrderStatus2; OrderStatus[3])
                    {
                        Caption = 'Firm Planned';
                        ToolTip = 'Specifies the value of the Firm Planned field.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(OrderStatus3; OrderStatus[4])
                    {
                        Caption = 'Released';
                        ToolTip = 'Specifies the value of the Released field.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(OrderStatus4; OrderStatus[5])
                    {
                        Caption = 'Finished';
                        ToolTip = 'Specifies the value of the Finished field.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(ProductionDateSelection; ProductionDateSelection)
                    {
                        Caption = 'Date Selection';
                        ToolTip = 'Specifies if Begining date or Ending date is uses to display data.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
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
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(ChartDataType; ChartDataType)
                    {
                        Caption = 'Data Type';
                        ToolTip = 'Specifies the value of the Data Type field.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                }
                field(CombinedChart; CombinedChart)
                {
                    Caption = 'Toggle Combined Line Chart';
                    ToolTip = 'Toggles the combined Line Chart View.';
                    trigger OnValidate()
                    begin
                        ChartBuilder.TriggerCombinedChart(CombinedChart);
                        PageIsFirstRun := 2;
                        RefreshPage('');
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
                        PageIsFirstRun := 2;
                        RefreshPage('');
                    end;
                }
                field(UseCurrentDate; UseCurrentDate)
                {
                    Caption = 'Use Current Date';
                    ToolTip = 'Specifies the value of the Use Current Date field.';
                    trigger OnValidate()
                    begin
                        DateFilter := Format(Today);
                        PageIsFirstRun := 2;
                        RefreshPage('');
                    end;
                }
                field(PeriodFormat; PeriodFormat)
                {
                    Caption = 'Period Format';
                    ToolTip = 'Specifies the value of the PeriodFormat field.';
                    trigger OnValidate()
                    begin
                        PageIsFirstRun := 2;
                        RefreshPage('');
                    end;
                }
                field(PeriodLength; PeriodLength)
                {
                    Caption = 'Period Length';
                    ToolTip = 'Specifies the value of the Period Length field.';
                    trigger OnValidate()
                    begin
                        PageIsFirstRun := 2;
                        RefreshPage('');
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
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(VisiblePressAll; VisiblePressAll)
                    {
                        Caption = 'All Presses';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('PressAll');
                        end;
                    }
                    field(VisiblePress1; VisiblePress1)
                    {
                        Caption = 'Press 1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P1');
                        end;
                    }
                    field(VisiblePress2; VisiblePress2)
                    {
                        Caption = 'Press 2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P2');
                        end;
                    }
                    field(VisiblePress3; VisiblePress3)
                    {
                        Caption = 'Press 3';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P3');
                        end;
                    }
                    field(VisiblePress4; VisiblePress4)
                    {
                        Caption = 'Press 4';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P4');
                        end;
                    }
                    field(VisiblePress5; VisiblePress5)
                    {
                        Caption = 'Press 5';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P5');
                        end;
                    }
                    field(VisiblePress6; VisiblePress6)
                    {
                        Caption = 'Press 6';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P6');
                        end;
                    }
                    field(VisiblePress7; VisiblePress7)
                    {
                        Caption = 'Press 7';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P7');
                        end;
                    }
                    field(VisiblePress8; VisiblePress8)
                    {
                        Caption = 'Press 8';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('P8');
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
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }
                    field(Visible09; Visible09)
                    {
                        Caption = 'Coating1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('09');
                        end;
                    }

                    field(Visible16; Visible16)
                    {
                        Caption = 'Coating2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('16');
                        end;
                    }
                    field(Visible10; Visible10)
                    {
                        Caption = 'Lathe1';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('10');
                        end;
                    }
                    field(Visible15; Visible15)
                    {
                        Caption = 'Lathe2';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('15');
                        end;
                    }
                    field(Visible18; Visible18)
                    {
                        Caption = 'Lathe3';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('18');
                        end;
                    }
                    field(Visible25; Visible25)
                    {
                        Caption = 'Polishing';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('25');
                        end;
                    }
                    field(Visible27; Visible27)
                    {
                        Caption = 'Scrubbing';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('27');
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
                            PageIsFirstRun := 2;
                            RefreshPage('');
                        end;
                    }

                    field(VisiblePA; VisiblePA)
                    {
                        Caption = 'Packaging';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('PA');
                        end;
                    }
                    field(VisibleNI; VisibleNI)
                    {
                        Caption = 'Riviting';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('NI');
                        end;
                    }
                    field(VisibleSK; VisibleSK)
                    {
                        Caption = 'Installing Handle';
                        ToolTip = 'Triggers visibility.';
                        trigger OnValidate()
                        begin
                            PageIsFirstRun := 2;
                            RefreshPage('SK');
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
        { }
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
        ChartBuilder: Codeunit "ChartBuilder";
        FilterTokens: Codeunit "Filter Tokens";

        OrderStatus: array[5] of Boolean;

        UseCurrentDate: Boolean;

        BusinessChartType: enum "Business Chart Type";
        CapacityType: Enum "Capacity Type";
        ChartDataType: Enum EnumChartDataType;
        PeriodFormat: Enum "PeriodType";
        ProductionDateSelection: Enum EnumProductionDateSelection;
        PeriodLength: Integer;

        OrderStatusOption: Option "Simulated","Planned","Firm Planned","Released","Finished";

        DateFilter: Text[2048];

        PageIsFirstRun: Integer;
        PageMaxElements: Integer;

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
        PageIsFirstRun := 1;
        UserSettings(0);
        UpdatePage()
    end;

    trigger OnClosePage()
    begin
        UserSettings(1);
    end;

    local procedure RefreshPage(Refresh: Text)
    var
        TempBusinessChartBuffer: Record "Business Chart Buffer" temporary;
        Dialog: Dialog;
        MessageLbl: label 'Refreshing Charts #1', Comment = '#1 Counter.';
    begin
        if GuiAllowed then Dialog.Open(MessageLbl);
        //if (PageIsFirstRun = 1) and (PageMaxElements <> 0) then exit;
        //PageIsFirstRun := 2;


        //
        // 110
        //
        c += 1;
        if VisiblePressAll then
            if (Refresh = 'PressAll') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P1..P8',
                                         CapacityType::"Machine Center",
                                         TempBusinessChartBuffer,
                                         OrderStatus,
                                         ProductionDateSelection,
                                         PeriodFormat,
                                         DateFilter,
                                         PeriodLength,
                                         BusinessChartType,
                                         ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.AllPresses);
            end;

        c += 1;
        if VisiblePress1 then
            if (Refresh = 'P1') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P1',
                                         CapacityType::"Machine Center",
                                         TempBusinessChartBuffer,
                                         OrderStatus,
                                         ProductionDateSelection,
                                         PeriodFormat,
                                         DateFilter,
                                         PeriodLength,
                                         BusinessChartType,
                                         ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST1);
            end;

        c += 1;
        if VisiblePress2 then
            if (Refresh = 'P2') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P2', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST2);
            end;

        c += 1;
        if VisiblePress3 then
            if (Refresh = 'P3') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P3', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST3);
            end;

        c += 1;
        if VisiblePress4 then
            if (Refresh = 'P4') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P4', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST4);
            end;

        c += 1;
        if VisiblePress5 then
            if (Refresh = 'P5') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P5', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST5);
            end;

        c += 1;
        if VisiblePress6 then
            if (Refresh = 'P6') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P6', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST6);
            end;

        c += 1;
        if VisiblePress7 then
            if (Refresh = 'P7') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P7', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST7);
            end;

        c += 1;
        if VisiblePress8 then
            if (Refresh = 'P8') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('P8', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.ST8);
            end;

        //
        // 120
        //
        c += 1;
        if Visible09 then
            if (Refresh = '09') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('09', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin09);
            end;

        c += 1;
        if Visible15 then
            if (Refresh = '15') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);
                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('15', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin15);
            end;

        c += 1;
        if Visible10 then
            if (Refresh = '10') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('10', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin10);
            end;

        c += 1;
        if Visible16 then
            if (Refresh = '16') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('16', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin16);
            end;

        c += 1;
        if Visible18 then
            if (Refresh = '18') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('18', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin18);
            end;

        c += 1;
        if Visible25 then
            if (Refresh = '25') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('25', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin25);
            end;

        c += 1;
        if Visible27 then
            if (Refresh = '27') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('27', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.Machin27);
            end;

        //
        // 130
        //
        c += 1;
        if VisiblePA then
            if (Refresh = 'PA') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('PA', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.MachinPA);
            end;

        c += 1;
        if VisibleSK then
            if (Refresh = 'SK') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('SK', CapacityType::"Machine Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.MachinSK);
            end;

        c += 1;
        if VisibleNI then
            if (Refresh = 'NI') or (Refresh = '') then begin
                if GuiAllowed then Dialog.Update(1, c);

                TempBusinessChartBuffer.DeleteAll();
                ChartBuilder.UpdateProductionChart('NI', CapacityType::"Work Center", TempBusinessChartBuffer, OrderStatus, ProductionDateSelection, PeriodFormat, DateFilter, PeriodLength, BusinessChartType, ChartDataType);
                TempBusinessChartBuffer.Update(CurrPage.WorkNI);
            end;
        //

        UserSettings(1);

        UpdatePage();
        if GuiAllowed then Dialog.Close();

        PageMaxElements := c;
        PageIsFirstRun := 1;
    end;

    //
    // 058     Save Page Settings
    //
    #region 058 Save Page Settings
    local procedure UserSettings(GetSave: Option Get,Save)
    var
        UserSettingsPage: Record "UserSettingsPage";
        CurrUserID: Text;
    begin
        CurrUserID := Database.UserId;

        if not GetOrCreateUserSettings(UserSettingsPage, CurrUserID, '50044') then
            InitializeUserSettings(UserSettingsPage);

        case GetSave of
            GetSave::Get:
                LoadUserSettings(UserSettingsPage);
            GetSave::Save:
                SaveUserSettings(UserSettingsPage);
        end;
    end;

    local procedure GetOrCreateUserSettings(var UserSettingsPage: Record "UserSettingsPage"; UserID: Text; PageID: Text): Boolean
    begin
        UserSettingsPage.Reset();
        UserSettingsPage.SetRange("UserID", UserID);
        UserSettingsPage.SetRange("PageID", PageID);

        if not UserSettingsPage.FindFirst() then begin
            UserSettingsPage.Init();
            UserSettingsPage."UserID" := UserID;
            UserSettingsPage."PageID" := PageID;
            exit(false);
        end;

        exit(true);
    end;

    local procedure InitializeUserSettings(var UserSettingsPage: Record "UserSettingsPage")
    begin
        UserSettingsPage.Integer_2 := OrderStatusOption;
        UserSettingsPage."EnumPeriodFormat" := UserSettingsPage."EnumPeriodFormat"::Week;
        UserSettingsPage."Integer_1" := 12;
        UserSettingsPage."Text50_2" := Format(Today);
        UserSettingsPage."Boolean_1" := true;

        UserSettingsPage.Simulated := OrderStatus[1];
        UserSettingsPage.Planned := OrderStatus[2];
        UserSettingsPage."Firm Planned" := OrderStatus[3];
        UserSettingsPage.Released := OrderStatus[4];
        UserSettingsPage.Finished := OrderStatus[5];
        UserSettingsPage.ProductionDateSelection := ProductionDateSelection;

        UserSettingsPage.EnumBusinessChartType := BusinessChartType;
        UserSettingsPage.EnumChartDataType := ChartDataType;

        UserSettingsPage.VisibleFoundry := true;

        InitializeVisibility(UserSettingsPage);

        UserSettingsPage.Insert();
    end;

    local procedure InitializeVisibility(var UserSettingsPage: Record "UserSettingsPage")
    begin
        UserSettingsPage.ChartVisibilityAll := true;
        UserSettingsPage.ChartVisibility1 := true;
        UserSettingsPage.ChartVisibility2 := true;
        UserSettingsPage.ChartVisibility3 := true;
        UserSettingsPage.ChartVisibility4 := true;
        UserSettingsPage.ChartVisibility5 := true;
        UserSettingsPage.ChartVisibility6 := true;
        UserSettingsPage.ChartVisibility7 := true;
        UserSettingsPage.ChartVisibility8 := true;

        UserSettingsPage.VisibleProcessing := true;
        UserSettingsPage.Visible09 := true;
        UserSettingsPage.Visible15 := true;
        UserSettingsPage.Visible10 := true;
        UserSettingsPage.Visible16 := true;
        UserSettingsPage.Visible18 := true;
        UserSettingsPage.Visible25 := true;
        UserSettingsPage.Visible27 := true;

        UserSettingsPage.VisiblePackaging := true;
        UserSettingsPage.VisiblePA := true;
        UserSettingsPage.VisibleSK := true;
        UserSettingsPage.VisibleNI := true;
    end;

    local procedure LoadUserSettings(var UserSettingsPage: Record "UserSettingsPage")
    begin
        OrderStatusOption := UserSettingsPage.Integer_2;
        PeriodFormat := UserSettingsPage."EnumPeriodFormat";
        PeriodLength := UserSettingsPage."Integer_1";
        DateFilter := UserSettingsPage."Text50_2";
        UseCurrentDate := UserSettingsPage."Boolean_1";

        if UseCurrentDate then
            DateFilter := Format(Today);

        OrderStatus[1] := UserSettingsPage.Simulated;
        OrderStatus[2] := UserSettingsPage.Planned;
        OrderStatus[3] := UserSettingsPage."Firm Planned";
        OrderStatus[4] := UserSettingsPage.Released;
        OrderStatus[5] := UserSettingsPage.Finished;
        ProductionDateSelection := UserSettingsPage.ProductionDateSelection;

        BusinessChartType := UserSettingsPage.EnumBusinessChartType;
        ChartDataType := UserSettingsPage.EnumChartDataType;

        LoadVisibility(UserSettingsPage);
    end;

    local procedure SaveUserSettings(var UserSettingsPage: Record "UserSettingsPage")
    begin
        UserSettingsPage.Integer_2 := OrderStatusOption;
        UserSettingsPage."EnumPeriodFormat" := PeriodFormat;
        UserSettingsPage."Integer_1" := PeriodLength;
        UserSettingsPage."Text50_2" := DateFilter;
        UserSettingsPage."Boolean_1" := UseCurrentDate;

        UserSettingsPage.Simulated := OrderStatus[1];
        UserSettingsPage.Planned := OrderStatus[2];
        UserSettingsPage."Firm Planned" := OrderStatus[3];
        UserSettingsPage.Released := OrderStatus[4];
        UserSettingsPage.Finished := OrderStatus[5];
        UserSettingsPage.ProductionDateSelection := ProductionDateSelection;

        UserSettingsPage.EnumBusinessChartType := BusinessChartType;
        UserSettingsPage.EnumChartDataType := ChartDataType;

        SaveVisibility(UserSettingsPage);

        UserSettingsPage.Modify();
    end;

    local procedure LoadVisibility(var UserSettingsPage: Record "UserSettingsPage")
    begin
        VisibleFoundry := UserSettingsPage.VisibleFoundry;
        VisiblePressAll := UserSettingsPage.ChartVisibilityAll;
        VisiblePress1 := UserSettingsPage.ChartVisibility1;
        VisiblePress2 := UserSettingsPage.ChartVisibility2;
        VisiblePress3 := UserSettingsPage.ChartVisibility3;
        VisiblePress4 := UserSettingsPage.ChartVisibility4;
        VisiblePress5 := UserSettingsPage.ChartVisibility5;
        VisiblePress6 := UserSettingsPage.ChartVisibility6;
        VisiblePress7 := UserSettingsPage.ChartVisibility7;
        VisiblePress8 := UserSettingsPage.ChartVisibility8;

        VisibleProcessing := UserSettingsPage.VisibleProcessing;
        Visible09 := UserSettingsPage.Visible09;
        Visible15 := UserSettingsPage.Visible15;
        Visible10 := UserSettingsPage.Visible10;
        Visible16 := UserSettingsPage.Visible16;
        Visible18 := UserSettingsPage.Visible18;
        Visible25 := UserSettingsPage.Visible25;
        Visible27 := UserSettingsPage.Visible27;

        VisiblePackaging := UserSettingsPage.VisiblePackaging;
        VisiblePA := UserSettingsPage.VisiblePA;
        VisibleSK := UserSettingsPage.VisibleSK;
        VisibleNI := UserSettingsPage.VisibleNI;
    end;

    local procedure SaveVisibility(var UserSettingsPage: Record "UserSettingsPage")
    begin
        UserSettingsPage.VisibleFoundry := VisibleFoundry;
        UserSettingsPage.ChartVisibilityAll := VisiblePressAll;
        UserSettingsPage.ChartVisibility1 := VisiblePress1;
        UserSettingsPage.ChartVisibility2 := VisiblePress2;
        UserSettingsPage.ChartVisibility3 := VisiblePress3;
        UserSettingsPage.ChartVisibility4 := VisiblePress4;
        UserSettingsPage.ChartVisibility5 := VisiblePress5;
        UserSettingsPage.ChartVisibility6 := VisiblePress6;
        UserSettingsPage.ChartVisibility7 := VisiblePress7;
        UserSettingsPage.ChartVisibility8 := VisiblePress8;

        UserSettingsPage.VisibleProcessing := VisibleProcessing;
        UserSettingsPage.Visible09 := Visible09;
        UserSettingsPage.Visible15 := Visible15;
        UserSettingsPage.Visible10 := Visible10;
        UserSettingsPage.Visible16 := Visible16;
        UserSettingsPage.Visible18 := Visible18;
        UserSettingsPage.Visible25 := Visible25;
        UserSettingsPage.Visible27 := Visible27;

        UserSettingsPage.VisiblePackaging := VisiblePackaging;
        UserSettingsPage.VisiblePA := VisiblePA;
        UserSettingsPage.VisibleSK := VisibleSK;
        UserSettingsPage.VisibleNI := VisibleNI;
    end;
    #endregion

    //
    // 095 Look up production orders from Chart Dashboard
    //
    procedure GetXValueString(RessourceName: Text; CapacityType: enum "Capacity Type"; ProductionDateSelection: enum EnumProductionDateSelection; PeriodType: enum PeriodType; JsonObject: JsonObject)
    begin
        ChartBuilder.GetXValueString(
                        RessourceName,
                        CapacityType,
                        ProductionDateSelection,
                        PeriodType,
                        JsonObject)
    end;

    procedure UpdatePage()
    begin
        c := 0;
        CurrPage.Update();
    end;
}