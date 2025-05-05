



page 50019 "WMSPickBinBalance"
{
    /// <summary>
    /// Page "SCANPANWMSPickBinBalance" (ID 50019).
    /// </summary>
    /// 
    /// <remarks>
    /// 
    /// 2023.03             Jesper Harder                       002     Added
    /// 
    /// </remarks>
    /// 

    AdditionalSearchTerms = 'Scanpan, Warehouse, Shipment';
    ApplicationArea = All;
    Caption = 'Warehouse Pick Bin Balance';
    PageType = List;
    Permissions =
        tabledata WMSPickBinBalanceTMP = RIMD;
    SourceTable = WMSPickBinBalanceTMP;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(FilterDate; FilterDate)
            {
                Caption = 'Date Filter';
                ToolTip = 'Specifies the value of the Date Filter field.';
                trigger OnValidate()
                var
                begin
                    ScanpanMiscellaneous.FillPickBalanceDataTable(Rec, FilterDate);
                end;
            }
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Item No"; Rec."Item No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bin Code field.';
                }
                field("Pick Quantity"; Rec."Pick Quantity")
                {
                    ApplicationArea = All;
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the value of the Pick Quantity field.';
                }
                field("Bin Quantity"; Rec."Bin Quantity")
                {
                    ApplicationArea = All;
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the value of the Bin Quantity field.';
                }
                field("Bin Quantity Balance"; Rec."Bin Quantity Balance")
                {
                    ApplicationArea = All;
                    BlankNumbers = BlankZero;
                    Style = Attention;
                    StyleExpr = ToggleBinBalanceColor;
                    ToolTip = 'Specifies the value of the Bin Quantity Balance field.';
                }
            }
        }
    }
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        ToggleBinBalanceColor: Boolean;
        FilterDate: Date;

    trigger OnAfterGetRecord()
    var
    begin
        ToggleBinBalanceColor := false;
        if Rec."Bin Quantity Balance" < 0 then ToggleBinBalanceColor := true;
    end;


}
