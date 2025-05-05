/// <summary>
/// Page SCANPANProdFoundry (ID 50021).
/// </summary>
///
/// <remarks>
///
/// 2023.03.21          Jesper Harder        010         List Production Orders in STØBERI
/// 2023.03.28          Jesper Harder        010         Added CapLedgEntries OutputQty by Operation
/// 2023.10             Jesper Harder        055         Priority and Description P.Order RoutingLines
/// 2023.10             Jesper Harder        056         Coating Description on Production Orders
/// </remarks>

page 50021 "ProdControllingRoutingLine"
{
    AdditionalSearchTerms = 'Scanpan, Controlling, Production';
    ApplicationArea = Basic, Suite;
    Caption = 'SCANPAN Production Controlling Routing List';
    PageType = List;
    Permissions =
        tabledata "Capacity Ledger Entry" = R,
        tabledata "Prod. Order Line" = R,
        tabledata "Prod. Order Routing Line" = RM,
        tabledata ProdContllingRoutingLinesTMP = RIMD;
    SourceTable = ProdContllingRoutingLinesTMP;
    UsageCategory = Lists;
    ShowFilter = true;

    layout
    {
        area(content)
        {
            group(group1)
            {
                ShowCaption = false;

                field(FilterWorkCenterGroupCode; FilterWorkCenterGroupCode)
                {
                    Caption = 'Work Center Group Code';
                    ToolTip = 'Defines filter on Work Center Group Code';
                    trigger OnValidate()
                    var
                    begin
                        FilterList();
                    end;
                }
                field(FilterStatus; FilterStatusEnum)
                {
                    Caption = 'Order status';
                    ToolTip = 'Filters the routinglines based on the order status.';
                    trigger OnValidate()
                    var
                    begin
                        FilterList();
                    end;
                }
            }

            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Modiified; Rec.Modiified)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Modified record field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Production Order Status.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    ToolTip = 'Indicates Order Priority.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Add Comments field.';
                }
                field("Production Order No."; Rec."Production Order No.")
                {
                    ToolTip = 'Specifies the value of the Production Order No. field.';
                    //LookupPageId = "Released Production Order";
                }
                field("Routing Type"; Rec.RoutingType)
                {
                    ToolTip = 'Specifies the value of the Ressource Type field.';
                }
                field("Ressource No."; Rec."Ressource No.")
                {
                    ToolTip = 'Specifies the value of the Ressource No. field.';
                }
                field("Routing Description"; Rec."Routing Description")
                {
                    ToolTip = 'Specifies the value of the Ressource Name field.';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ToolTip = 'Specifies the value of the Operation No. field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field(ItemNo; Rec.ItemNo)
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field(Coating; Rec.Coating)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of coating used in this Item.';
                }
                field("Coating Item"; Rec."Coating Item")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of coating item used in this Item.';
                }
                field("First BOM Body"; Rec."First BOM Body")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the First BOM Body field.';
                }
                field("Work Center Group Code"; Rec."Work Center Group Code")
                {
                    ToolTip = 'Specifies the value of the Departmnet No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Finished Quantity field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Finished Percentage"; Rec."Finished Percentage")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Finished Percentage field.';
                }
                field("Item Set Multiplier"; Rec."Item Set Multiplier")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    ToolTip = 'Shows how manny productionitems is contained in this Item.';
                }
                field("Quantity Set"; Rec."Quantity Set")
                {
                    DecimalPlaces = 0;
                    BlankZero = true;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity Set field.';
                }

                field("Remaining Set Quantity"; Rec."Remaining Set Quantity")
                {
                    Caption = 'Remaining Set Quantity';
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Set Quantity field.';
                }
                field("Finished Set Quantity"; Rec."Finished Set Quantity")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    DecimalPlaces = 0;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Finished Set Quantity field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(save)
            {
                Caption = 'Save changes';
                Image = Save;
                ToolTip = 'Saves changes into Productionorder routing lines.';

                trigger OnAction()
                var
                begin
                    SaveChanges();
                end;
            }
            action(clear)
            {
                Caption = 'Clear all priorities';
                Image = Delete;
                ToolTip = 'Executes the Clear all priorities action.';

                trigger OnAction()
                var
                begin
                    DeleteAllPriorities();
                end;
            }
            action(ItemMap)
            {
                Caption = 'Item Mapping';
                Image = ItemSubstitution;
                ToolTip = 'Executes the Item Mapping action.';

                trigger OnAction()
                var
                    ProdControllingItemMap: Page ProdControllingItemMap;
                begin
                    ProdControllingItemMap.RunModal();
                end;
            }
        }
        area(Reporting)
        {
            action(PriorityReport)
            {
                Caption = 'Print Route priority';
                Image = PrintReport;
                ToolTip = 'Prints the Priority report with comments.';

                trigger OnAction()
                var
                    PriorityReport: Report ProductionControllingPriority;
                begin
                    //CheckModified();
                    PriorityReport.SetTableView(Rec);
                    PriorityReport.Run();
                end;
            }
        }
    }

    var
        //FilterMachineCenter: Text;
        ProdContllingRoutingLinesTMPFilters: Record ProdContllingRoutingLinesTMP;
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        StyleExprFinishedQtyFavorable: Boolean;
        FilterStatusEnum: Enum EnumProductionOrderStatus;
        FilterWorkCenterGroupCode: text;

    trigger OnInit()
    var
    begin
        ScanpanMiscellaneous.ControllingFillProductionRouteLine(Rec);

        FilterStatusEnum := FilterStatusEnum::Released;
    end;

    trigger OnOpenPage()
    begin
        FilterList();
    end;

    trigger OnClosePage()
    var
    begin
        CheckModified();
    end;

    trigger OnAfterGetRecord()
    begin
        StyleExprFinishedQtyFavorable := false;
        if rec."Remaining Quantity" < 0 then StyleExprFinishedQtyFavorable := true;
    end;

    local procedure CheckModified()
    var
        NotSavedLbl: Label 'Changes has not been saved.';
        SaveChangesLbl: Label 'Do you want to save changes?';
    begin
        SaveRestoreFilters(0);
        Rec.SetFilter(Modiified, '%1', true);
        if not Rec.IsEmpty then begin
            if Dialog.Confirm(SaveChangesLbl) = true then
                SaveChanges()
            else
                error(NotSavedLbl);
            SaveRestoreFilters(1);
        end;
    end;

    local procedure DeleteAllPriorities()
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        ProdOrderRoutingLine.SetFilter(Status, '<>%1', ProdOrderRoutingLine.Status::Finished);
        ProdOrderRoutingLine.FindSet();
        ProdOrderRoutingLine.ModifyAll(Priority, 0, true);

        Rec.Reset();
        Rec.ModifyAll(Priority, 0, true);
        Rec.ModifyAll(Modiified, false);
    end;

    local procedure FilterList()
    var
    begin
        Rec.SetRange("Work Center Group Code");
        Rec.SetRange(Status);
        if FilterWorkCenterGroupCode <> '' then Rec.SetFilter("Work Center Group Code", '%1', FilterWorkCenterGroupCode);
        Rec.SetFilter(Status, '%1', FilterStatusEnum);

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure SaveChanges()
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        SaveRestoreFilters(0);
        Rec.Reset();
        Rec.SetFilter(Modiified, '%1', true);
        Rec.FindSet();
        repeat
            // key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")
            ProdOrderRoutingLine.SetFilter(Status, '%1', Rec.Status);
            ProdOrderRoutingLine.SetFilter("Prod. Order No.", Rec."Production Order No.");
            //ProdRoutingLine.SetFilter("Routing Reference No.",);
            ProdOrderRoutingLine.SetFilter("Operation No.", Rec."Operation No.");
            ProdOrderRoutingLine.FindSet();
            ProdOrderRoutingLine.Comment := Rec.Comment;
            ProdOrderRoutingLine.Priority := Rec.Priority;
            ProdOrderRoutingLine.ModifyAll(Comment, Rec.Comment, true);
            ProdOrderRoutingLine.ModifyAll(Priority, Rec.Priority, true);
        until Rec.Next() = 0;
        Rec.Reset();
        SaveRestoreFilters(1);
        Rec.FindFirst();
    end;

    local procedure SaveRestoreFilters(SaveRestore: Integer)
    var
    begin
        if SaveRestore = 1 then
            Rec.CopyFilters(ProdContllingRoutingLinesTMPFilters);
        if SaveRestore = 0 then
            ProdContllingRoutingLinesTMPFilters.CopyFilters(Rec);
    end;
}

/*

Type  Prod Ress
No.     P101943
CapLedgEntries: Record "Capacity Ledger Entry";

*/
