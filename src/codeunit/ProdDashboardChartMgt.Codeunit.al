codeunit 50036 "Prod. Dashboard Chart Mgt."
{
    procedure UpdateProductionChart(ChartId: Enum "Prod. Dashboard Chart ID";
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
        DashboardDataMgt: Codeunit "Prod. Dashboard Data Mgt.";
    begin
        DashboardDataMgt.UpdateProductionChart(GetCapacityNo(ChartId),
                                               GetCapacityType(ChartId),
                                               BusinessChartBuffer,
                                               OrderStatus,
                                               ProductionDateSelection,
                                               PeriodType,
                                               PeriodStart,
                                               PeriodLength,
                                               BusinessChartType,
                                               ChartDataType,
                                               CombinedChartActive);
    end;

    procedure GetCapacityNo(ChartId: Enum "Prod. Dashboard Chart ID"): Code[20]
    begin
        case ChartId of
            ChartId::"All Presses":
                exit('P1..P8');
            ChartId::"Press 1":
                exit('P1');
            ChartId::"Press 2":
                exit('P2');
            ChartId::"Press 3":
                exit('P3');
            ChartId::"Press 4":
                exit('P4');
            ChartId::"Press 5":
                exit('P5');
            ChartId::"Press 6":
                exit('P6');
            ChartId::"Press 7":
                exit('P7');
            ChartId::"Press 8":
                exit('P8');
            ChartId::Coating1:
                exit('09');
            ChartId::Coating2:
                exit('16');
            ChartId::Lathe1:
                exit('10');
            ChartId::Lathe2:
                exit('15');
            ChartId::Lathe3:
                exit('18');
            ChartId::Polishing:
                exit('25');
            ChartId::Scrubbing:
                exit('27');
            ChartId::Packaging:
                exit('PA');
            ChartId::Riveting:
                exit('NI');
            ChartId::"Installing Handle":
                exit('SK');
        end;

        Error('Unsupported production dashboard chart ID: %1.', ChartId);
    end;

    procedure GetCapacityType(ChartId: Enum "Prod. Dashboard Chart ID"): Enum "Capacity Type"
    var
        CapacityType: Enum "Capacity Type";
    begin
        case ChartId of
            ChartId::Riveting:
                exit(CapacityType::"Work Center");
        end;

        exit(CapacityType::"Machine Center");
    end;
}
