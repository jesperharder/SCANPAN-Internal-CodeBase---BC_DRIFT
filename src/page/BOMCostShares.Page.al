page 50069 "BOMCostShares"
{
    ///<summary>
    /// 2024.10 Jesper Harder 093 Recursive BoM Listing of items. Inspiration from NAV5 sql
    /// 2025.09 Tilføjet Top Item kolonne (page-variabel), Gen. Posting Group, Net/Gross Weight
    /// </summary>

    Caption = 'Recursive BOM Cost Shares';
    ApplicationArea = all;
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BOM Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            grid(Option)
            {
                Caption = 'Option';
                field(ItemFilter; ItemFilter)
                {
                    ApplicationArea = Assembly;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies the value of the Item Filter field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        ItemList.SetTableView(Item);
                        ItemList.LookupMode := true;
                        if ItemList.RunModal() = ACTION::LookupOK then begin
                            ItemList.GetRecord(Item);
                            Text := Item."No.";
                            exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        RefreshPage();
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Lines';
                IndentationColumn = Indentation;
                ShowAsTree = true;

                // Nyttige felter
                field(Type; Type)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the value of the Type field.';
                }

                // --- Top Item ---
                field(TopItemNo; TopItemNo)
                {
                    ApplicationArea = Assembly;
                    Caption = 'Top Item';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Top Item field.';
                }

                field("No."; "No.")
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Indentation; Indentation)
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Indentation field.';
                }
                field("Qty. per Parent"; "Qty. per Parent")
                {
                    ApplicationArea = Assembly;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the value of the Qty. per Parent field.';
                }
                field("Qty. per Top Item"; "Qty. per Top Item")
                {
                    ApplicationArea = Assembly;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. per Top Item field.';
                }
                field("Qty. per BOM Line"; "Qty. per BOM Line")
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. per BOM Line field.';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("BOM Unit of Measure Code"; "BOM Unit of Measure Code")
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    ToolTip = 'Specifies the value of the BOM Unit of Measure Code field.';
                }
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = Assembly;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Replenishment System field.';
                }

                // Kostfelter
                field("Rolled-up Material Cost"; "Rolled-up Material Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the value of the Rolled-up Material Cost field.';
                }
                field("Rolled-up Capacity Cost"; "Rolled-up Capacity Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the value of the Rolled-up Capacity Cost field.';
                }
                field("Rolled-up Subcontracted Cost"; "Rolled-up Subcontracted Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the value of the Rolled-up Subcontracted Cost field.';
                }
                field("Rolled-up Mfg. Ovhd Cost"; "Rolled-up Mfg. Ovhd Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the value of the Rolled-up Mfg. Ovhd Cost field.';
                }
                field("Rolled-up Capacity Ovhd. Cost"; "Rolled-up Capacity Ovhd. Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the value of the Rolled-up Capacity Ovhd. Cost field.';
                }
                field("Rolled-up Scrap Cost"; "Rolled-up Scrap Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the value of the Rolled-up Scrap Cost field.';
                }
                field("Total Cost"; "Total Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }

                // --- Nye felter fra Item ---
                field(GeneralPostingGroup; GeneralPostingGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Gen. Posting Group';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gen. Posting Group field.';
                }
                field(NetWeight; NetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Net Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Weight field.';
                }
                field(GrossWeight; GrossWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Gross Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gross Weight field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("UpdatePage")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Page';
                Image = ErrorLog;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Update Page action.';
                trigger OnAction()
                begin
                    RefreshPage();
                end;
            }
            action("Show Warnings")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Warnings';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Warnings action.';
                trigger OnAction()
                begin
                    ShowWarningsForAllLines();
                end;
            }
        }
        area(reporting)
        {
            action("BOM Cost Share Distribution")
            {
                ApplicationArea = Assembly;
                Caption = 'BOM Cost Share Distribution';
                Image = "Report";
                Promoted = true;
                promotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the BOM Cost Share Distribution action.';
                trigger OnAction()
                begin
                    ShowBOMCostShareDistribution();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DummyBOMWarningLog: Record "BOM Warning Log";
        ScanBuffer: Record "BOM Buffer";
    begin
        IsParentExpr := not "Is Leaf";
        HasWarning := not IsLineOk(false, DummyBOMWarningLog);

        // --- Top Item logik ---
        if Indentation = 0 then
            LastTopItemNo := "No."
        else
            if LastTopItemNo = '' then begin
                ScanBuffer := Rec;
                while ScanBuffer.Next(-1) <> 0 do
                    if ScanBuffer.Indentation = 0 then begin
                        LastTopItemNo := ScanBuffer."No.";
                        break;
                    end;
                if LastTopItemNo = '' then
                    LastTopItemNo := "No.";
            end;
        TopItemNo := LastTopItemNo;

        // Slå Item op for ekstra felter
        if Type = Type::Item then begin
            if Item.Get("No.") then begin
                GeneralPostingGroup := Item."Gen. Prod. Posting Group";
                NetWeight := Item."Net Weight";
                GrossWeight := Item."Gross Weight";
            end else begin
                Clear(GeneralPostingGroup);
                Clear(NetWeight);
                Clear(GrossWeight);
            end;
        end else begin
            Clear(GeneralPostingGroup);
            Clear(NetWeight);
            Clear(GrossWeight);
        end;
    end;

    trigger OnOpenPage()
    var
        Items: record Item;
    begin
        Clear(LastTopItemNo);
        Clear(TopItemNo);
        Items.Get('28001200');
        InitItem(Items);
    end;

    var
        Item: Record Item;
        AssemblyHeader: Record "Assembly Header";
        ProdOrderLine: Record "Prod. Order Line";
        IsParentExpr: Boolean;
        ItemFilter: Code[250];
        ShowBy: Option Item,Assembly,Production;
        Text001Msg: Label 'There are no warnings.';
        HasWarning: Boolean;

        TopItemNo: Code[20];
        LastTopItemNo: Code[20];
        GeneralPostingGroup: Code[20];
        NetWeight: Decimal;
        GrossWeight: Decimal;

    // ====== eksisterende procedurer ======

    procedure InitItem(var NewItem: Record Item)
    var
        ConstantTxt: Label '''%1''', Locked = true;
    begin
        Item.Copy(NewItem);
        ItemFilter := '';
        if Item."No." <> '' then
            ItemFilter := StrSubstNo(ConstantTxt, Item."No.");
        ShowBy := ShowBy::Item;
    end;

    procedure InitAsmOrder(NewAssemblyHeader: Record "Assembly Header")
    begin
        AssemblyHeader := NewAssemblyHeader;
        ShowBy := ShowBy::Assembly;
    end;

    procedure InitProdOrder(NewProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderLine := NewProdOrderLine;
        ShowBy := ShowBy::Production;
    end;

    local procedure RefreshPage()
    var
        CalculateBOMTree: Codeunit "Calculate BOM Tree";
        HasBOM: Boolean;
        IsHandled: Boolean;
    begin
        Clear(Rec);
        Clear(LastTopItemNo);
        Clear(TopItemNo);

        IsHandled := false;
        OnBeforeRefreshPage(Rec, Item, AssemblyHeader, ProdOrderLine, ShowBy, ItemFilter, IsHandled);
        if IsHandled then
            exit;

        Item.SetFilter("No.", ItemFilter);
        Item.SetRange("Date Filter", 0D, WorkDate());
        CalculateBOMTree.SetItemFilter(Item);

        case ShowBy of
            ShowBy::Item:
                begin
                    if Item.FindSet() then begin
                        repeat
                            HasBOM := Item.HasBOM() or (Item."Routing No." <> '');
                        until HasBOM or (Item.Next() = 0);
                        if HasBOM then
                            CalculateBOMTree.GenerateTreeForItems(Item, Rec, 2);
                    end;
                end;
            ShowBy::Production:
                CalculateBOMTree.GenerateTreeForProdLine(ProdOrderLine, Rec, 2);
            ShowBy::Assembly:
                CalculateBOMTree.GenerateTreeForAsm(AssemblyHeader, Rec, 2);
        end;

        CurrPage.Update(false);
    end;

    local procedure ShowBOMCostShareDistribution()
    var
        Items: Record Item;
    begin
        TestField(Type, Type::Item);
        Items.Get("No.");
        Items.SetRange("No.", "No.");
        Items.SetFilter("Variant Filter", "Variant Code");
        if ShowBy <> ShowBy::Item then
            Items.SetFilter("Location Filter", "Location Code");
        REPORT.Run(REPORT::"BOM Cost Share Distribution", true, true, Items);
    end;

    local procedure ShowWarnings()
    var
        TempBOMWarningLog: Record "BOM Warning Log" temporary;
    begin
        if IsLineOk(true, TempBOMWarningLog) then
            Message(Text001Msg)
        else
            PAGE.RunModal(PAGE::"BOM Warning Log", TempBOMWarningLog);
    end;

    local procedure ShowWarningsForAllLines()
    var
        TempBOMWarningLog: Record "BOM Warning Log" temporary;
    begin
        if AreAllLinesOk(TempBOMWarningLog) then
            Message(Text001Msg)
        else
            PAGE.RunModal(PAGE::"BOM Warning Log", TempBOMWarningLog);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRefreshPage(var BOMBuffer: Record "BOM Buffer"; var Item: Record Item; var AssemblyHeader: Record "Assembly Header"; var ProdOrderLine: Record "Prod. Order Line"; ShowBy: Option; ItemFilter: Code[250]; var IsHandled: Boolean)
    begin
    end;
}
