/// <summary>
/// Page ProdControlListRoutingLine (ID 50036).
/// </summary>
/// <remarks>
/// 2023.05.11                      Jesper Harder                           030     List All Routing Lines
/// </remarks>
page 50036 "ProdControlListRoutingLine"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Production Controlling List Routing Lines';
    PageType = List;
    SourceTable = "ProdControllingRoutes";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Editable = isEditable;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    Editable = isEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = isEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = isEditable;
                }
                field(LastDateModified; Rec.LastDateModified)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                    Editable = isEditable;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Has Comment field.';
                    Editable = isEditable;
                }
                field(OperationNo; Rec.OperationNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Operation No. field.';
                    Editable = isEditable;
                }
                field("Routing Priority"; Rec."Routing Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Routing Priority field.';
                    Editable = true;
                    Visible = false;
                }
                field(Line_Type; Rec.Line_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                    Editable = isEditable;
                }
                field(Line_No; Rec.Line_No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ressource No. field.';
                    Editable = isEditable;
                }
                field(Line_Description; Rec.Line_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ressouce Description field.';
                    Editable = isEditable;
                }
                field(RoutingLinkCode; Rec.RoutingLinkCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Routing Link Code field.';
                    Editable = isEditable;
                }
                field(SetupTime; Rec.SetupTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Setup Time field.';
                    Editable = isEditable;
                }
                field(RunTime; Rec.RunTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Run Time field.';
                    Editable = isEditable;
                }
                field(RunTimeUnitofMeasCode; Rec.RunTimeUnitofMeasCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Run Time Unit of Measure Code field.';
                    Editable = isEditable;
                }
                field(WaitTime; Rec.WaitTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Wait Time field.';
                    Editable = isEditable;
                }
                field(MoveTime; Rec.MoveTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Move Time field.';
                    Editable = isEditable;
                }
                field(FixedScrapQuantity; Rec.FixedScrapQuantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fixed Scrap Quantity field.';
                    Editable = isEditable;
                }
                field(ScrapFactor; Rec.ScrapFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scrap Factor field.';
                    Editable = isEditable;
                }
                field(ConcurrentCapacities; Rec.ConcurrentCapacities)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Concurrent Capacities field.';
                    Editable = isEditable;
                }
                field(SendAheadQuantity; Rec.SendAheadQuantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Ahead Quantity field.';
                    Editable = isEditable;
                }
                field(UnitCostper; Rec.UnitCostper)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Cost per field.';
                    Editable = isEditable;
                }
            }
        }
    }

    var
        isEditable: Boolean;

    trigger OnOpenPage()
    var
        QueryProdRoutingLinesList: Query "ProdRoutingLinesList";
        LineNo: Integer;
    begin
        isEditable := false;
        QueryProdRoutingLinesList.Open();
        while QueryProdRoutingLinesList.Read() do begin
            Rec.Init();
            LineNo += 1;
            Rec."Line No." := LineNo;
            Rec."No." := QueryProdRoutingLinesList.No;
            Rec.Description := QueryProdRoutingLinesList.Description;
            Rec.Status := QueryProdRoutingLinesList.Status;
            Rec.LastDateModified := QueryProdRoutingLinesList.LastDateModified;
            Rec.OperationNo := QueryProdRoutingLinesList.OperationNo;
            //Rec."Routing Priority" := QueryProdRoutingLinesList.RoutingPriority;
            Rec.Line_Type := QueryProdRoutingLinesList.Line_Type;
            Rec.Line_No := QueryProdRoutingLinesList.Line_No;
            Rec.Line_Description := QueryProdRoutingLinesList.Line_Description;
            Rec.RoutingLinkCode := QueryProdRoutingLinesList.RoutingLinkCode;
            Rec.SetupTime := QueryProdRoutingLinesList.SetupTime;
            Rec.RunTime := QueryProdRoutingLinesList.RunTime;
            Rec.RunTimeUnitofMeasCode := QueryProdRoutingLinesList.RunTimeUnitofMeasCode;
            Rec.WaitTime := QueryProdRoutingLinesList.WaitTime;
            Rec.MoveTime := QueryProdRoutingLinesList.MoveTime;
            Rec.FixedScrapQuantity := QueryProdRoutingLinesList.FixedScrapQuantity;
            Rec.ScrapFactor := QueryProdRoutingLinesList.ScrapFactor;
            Rec.ConcurrentCapacities := QueryProdRoutingLinesList.ConcurrentCapacities;
            Rec.SendAheadQuantity := QueryProdRoutingLinesList.SendAheadQuantity;
            Rec.UnitCostper := QueryProdRoutingLinesList.UnitCostper;
            Rec.Insert();
        end;
        Rec.FindFirst();
    end;
}
