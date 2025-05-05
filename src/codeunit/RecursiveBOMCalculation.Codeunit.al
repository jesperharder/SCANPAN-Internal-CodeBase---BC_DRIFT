codeunit 50031 "RecursiveBOMCalculation"
{ 
    /// <summary>
    /// 2024.10 Jesper Harder 093 Recursive BoM Listing of items. Inspiration from NAV5 sql
    /// </summary>

    var
        GLSetup: Record "General Ledger Setup";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        VersionMgt: Codeunit VersionManagement;
        UOMMgt: Codeunit "Unit of Measure Management";

        CalculateDate: Date;

        EntryNo: Integer;
        PreviousItemMaster: Code[20];

    procedure CalculateOneItemRecursiveBOM(RootBOMNo: Code[20]; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    begin
        // GlSetup
        GLSetup.Get();

        // WorkDate
        CalculateDate := WorkDate();

        // Start recursion from the top level
        ProcessBOMLevel(RootBOMNo, RootBOMNo, 1, RecursiveBOMtemp);
    end;



    procedure CalculateAllProductionBOMLines(ItemNo: text[100]; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        ProductionBomLine: Record "Production BOM Line";
        Dialog: Dialog;
        TotalCount, CurrentCount : Integer;
        DialogLbl: Label 'Processing Bill of Material... #1\ Lines #3\ Counting #2', Comment = '#1 BoM No. #2 Counting #3 Total records.';
    begin
        ProductionBomLine.Reset();
        ProductionBomLine.SetFilter("Production BOM No.", ItemNo);

        if not ProductionBomLine.IsEmpty then
            RecursiveBOMtemp.DeleteAll();

        TotalCount := ProductionBomLine.Count();
        Dialog.Open(DialogLbl);
        CurrentCount := 0;
        Dialog.Update(3, TotalCount);

        repeat
            CurrentCount += 1;
            Dialog.Update(1, ProductionBomLine."Production BOM No.");
            Dialog.Update(2, CurrentCount);

            CalculateOneItemRecursiveBOM(ProductionBomLine."Production BOM No.", RecursiveBOMtemp);
        until ProductionBomLine.Next() = 0;

        Dialog.Close();
    end;

    local procedure ProcessBOMLevel(ItemMaster: Code[20]; BOMNo: Code[20]; BoMLevel: Integer; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        ProductionBOMLine: Record "Production BOM Line";
    begin

        ProductionBOMLine.SetRange("Production BOM No.", BOMNo);
        if ProductionBOMLine.FindSet() then
            repeat
                InitializeRecursiveBOMtemp(ItemMaster, BOMNo, BoMLevel, ProductionBOMLine, RecursiveBOMtemp);
                CalculateCostsAndScrap(ProductionBOMLine, RecursiveBOMtemp);

                AssignItemBomDetails(ProductionBOMLine."No.", RecursiveBOMtemp);
                AssignItemMasterDetails(ItemMaster, RecursiveBOMtemp);

                // Insert and proceed to next level
                EntryNo += 1;
                RecursiveBOMtemp."Entry No." := EntryNo;
                if RecursiveBOMtemp.Insert() then;

                ProcessBOMLevel(ItemMaster, ProductionBOMLine."No.", BoMLevel + 1, RecursiveBOMtemp);
            until ProductionBOMLine.Next() = 0;
    end;


    procedure InitializeRecursiveBOMtemp(ItemMaster: Code[20]; BOMNo: Code[20]; BoMLevel: Integer; ProductionBOMLine: Record "Production BOM Line"; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        Item: Record Item;
        ScrapPct: Decimal;
        ProdBOMLine: Record "Production BOM Line";
    begin
        RecursiveBOMtemp.Init();
        RecursiveBOMtemp.ItemMaster := ItemMaster;
        if Item.Get(ItemMaster) then
            RecursiveBOMtemp.ItemMasterDescription := Item.Description;
        RecursiveBOMtemp.BomItem := BOMNo;
        RecursiveBOMtemp.BOMitem := ProductionBOMLine."No.";
        RecursiveBOMtemp.BOMitemDescription := ProductionBOMLine.Description;
        RecursiveBOMtemp.BOMlevel := BoMLevel;

        if Item.Get(ProductionBOMLine."No.") then
            RecursiveBOMtemp.BOMBaseUnitCode := Item."Base Unit of Measure";

        //exit(Qty * (1 + ScrapPct / 100));
        if Item.Get(ItemMaster) then // If masterItem has Scrap percentage
            ScrapPct := (1 + Item."Scrap %" / 100);

        RecursiveBOMtemp.ScrapPercentage := ScrapPct;


        RecursiveBOMtemp.FirstNewItemMaster := (PreviousItemMaster <> ItemMaster);
        PreviousItemMaster := ItemMaster;
    end;



    procedure CalculateCostsAndScrap(ProductionBOMLine: Record "Production BOM Line"; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        Item: Record Item;
        VersionCode: Code[20];

        BOMCompQtyBase: Decimal;
        CompItemQtyBase: Decimal;
        LotSize: Decimal;

        MaterialCost: Decimal;
        CapacityCost: Decimal;
        MfgItemQtyBase: Decimal;
        Quantity: Decimal;
        OverheadCost: Decimal;
        TotalCost: Decimal;

    begin
        // PreData
        if not Item.Get(ProductionBOMLine."No.") then
            exit;

        VersionCode := VersionMgt.GetBOMVersion(Item."Production BOM No.", CalculateDate, true);
        LotSize := GetLotSize(Item);

        MfgItemQtyBase := CalcMfgItemQtyBase(Item, VersionCode, LotSize);

        CompItemQtyBase :=
                CostCalcMgt.CalcCompItemQtyBase(
                ProductionBOMLine, CalculateDate, MfgItemQtyBase, Item."Routing No.",
                ProductionBOMLine.Type = ProductionBOMLine.Type::Item);

        CompItemQtyBase := CompItemQtyBase * RecursiveBOMtemp.ScrapPercentage;
        RecursiveBOMtemp.ScrapPercentage := CalculateCombinedPercentage((1 + ProductionBOMLine."Scrap %" / 100), RecursiveBOMtemp.ScrapPercentage);

        Quantity := CompItemQtyBase / LotSize;
        //BOMCompQtyBase := CompItemQtyBase / LotSize;

        MaterialCost :=
                Round(
                Quantity * Item."Rolled-up Material Cost",
                GLSetup."Unit-Amount Rounding Precision");

        CapacityCost :=
                Round(
                    Quantity * (Item."Rolled-up Capacity Cost" + Item."Rolled-up Subcontracted Cost"),
                    GLSetup."Unit-Amount Rounding Precision");

        OverheadCost :=
                    Round(
                        Quantity * (Item."Rolled-up Mfg. Ovhd Cost" + Item."Rolled-up Cap. Overhead Cost"),
                        GLSetup."Unit-Amount Rounding Precision");

        TotalCost := MaterialCost + CapacityCost + OverheadCost;



        // Add to Bom Record
        RecursiveBOMtemp.BOMQuantity := CompItemQtyBase;
        RecursiveBOMtemp.MaterialCostCalc := MaterialCost;
        RecursiveBOMtemp.CapacityCostCalc := CapacityCost;
        RecursiveBOMtemp.OverheadCostCalc := OverheadCost;
        RecursiveBOMtemp.TotalCostCalc := TotalCost;
    end;

    local procedure CalcMfgItemQtyBase(Item: Record Item; VersionCode: Code[20]; LotSize: Decimal): Decimal
    var

    begin
        exit(
          CostCalcMgt.CalcQtyAdjdForBOMScrap(LotSize, Item."Scrap %") /
          UOMMgt.GetQtyPerUnitOfMeasure(Item, VersionMgt.GetBOMUnitOfMeasure(Item."Production BOM No.", VersionCode)));
    end;

    local procedure GetLotSize(Item: Record Item): Decimal
    begin
        if Item."Lot Size" <> 0 then
            exit(Item."Lot Size");

        exit(1);
    end;

    procedure CalculateCombinedPercentage(BomPCT: Decimal; ItemPCT: Decimal): Decimal
    var
        CombinedPCT: Decimal;
    begin
        // Calculate combined percentage factor
        CombinedPCT := (BomPCT * ItemPCT - 1) * 100;
        // Return the result
        exit(CombinedPCT);
    end;


    // RollUpStandardCost Calculations
    var
        TempItem: Record Item temporary;
        StdCostWksh: Record "Standard Cost Worksheet";
        CalcStdCost: Codeunit "Calculate Standard Cost";
        CalculationDate: Date;
        ToStdCostWkshName: Code[10];
        RolledUp: Boolean;
        Text000: Label 'The standard costs have been rolled up successfully.';
        Text001: Label 'There is nothing to roll up.';
        Text002: Label 'You must enter a calculation date.';
        Text003: Label 'You must specify a worksheet name to roll up to.';
        NoMessage: Boolean;

    procedure RollUpStandardCost()
    var
        Item: Record Item;
    begin
        CalculateDate := WorkDate();

        Item.Get('28001200');

        StdCostWksh.LockTable();
        Clear(CalcStdCost);
        CalcStdCost.SetProperties(CalculationDate, true, false, false, ToStdCostWkshName, true);
        CalcStdCost.CalcItems(Item, TempItem);

        TempItem.SetFilter("Replenishment System", '%1|%2',
          TempItem."Replenishment System"::"Prod. Order",
          TempItem."Replenishment System"::Assembly);
        if TempItem.Find('-') then
            repeat
                // Updates the Journal 
                // UpdateStdCostWksh;
                RolledUp := true;
            until TempItem.Next() = 0;

    end;


    local procedure AssignItemBomDetails(ItemNo: Code[20]; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit;
        RecursiveBOMtemp.ProdBOM_Coating := Item.Coating;
        RecursiveBOMtemp.ProdBOM_ItemSize := Item."Item Size";
        RecursiveBOMtemp.ProdBOM_ItemBrand := Item."Item Brand";
        RecursiveBOMtemp.ProdBOM_ABCDcategory := Item."ABCD Category";
        RecursiveBOMtemp.ProdBOM_ItemBodyType := Item.ItemBodyType;
        RecursiveBOMtemp.ProdBOM_ProductUsage := Item."Product Usage";
        RecursiveBOMtemp.ProdBOM_ProductLineCode := Item."Product Line Code";
        RecursiveBOMtemp.ProdBOM_ItemCategoryCode := Item."Item Category Code";
        RecursiveBOMtemp.ProdBOM_ProductGroupCode := Item."Prod. Group Code";
        RecursiveBOMtemp.ProdBOM_ItemNoDescription := Item.Description;
        RecursiveBOMtemp.ProdBOM_CostingMethod := Item."Costing Method";
        RecursiveBOMtemp.ProdBOM_GenProdPostingGroup := Item."Gen. Prod. Posting Group";
        RecursiveBOMtemp.ProdBOM_InventoryPostingGroup := Item."Inventory Posting Group";
    end;

    local procedure AssignItemMasterDetails(ItemNo: Code[20]; var RecursiveBOMtemp: Record "RecursiveBOMtemp")
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit;
        RecursiveBOMtemp.Prod_Coating := Item.Coating;
        RecursiveBOMtemp.Prod_ItemSize := Item."Item Size";
        RecursiveBOMtemp.Prod_ItemBrand := Item."Item Brand";
        RecursiveBOMtemp.Prod_ABCDcategory := Item."ABCD Category";
        RecursiveBOMtemp.Prod_ItemBodyType := Item.ItemBodyType;
        RecursiveBOMtemp.Prod_ProductUsage := Item."Product Usage";
        RecursiveBOMtemp.Prod_ProductLineCode := Item."Product Line Code";
        RecursiveBOMtemp.Prod_ItemCategoryCode := Item."Item Category Code";
        RecursiveBOMtemp.Prod_ProductGroupCode := Item."Prod. Group Code";
        RecursiveBOMtemp.Prod_ItemNoDescription := Item.Description;
        RecursiveBOMtemp.Prod_CostingMethod := Item."Costing Method";
        RecursiveBOMtemp.Prod_GenProdPostingGroup := Item."Gen. Prod. Posting Group";
        RecursiveBOMtemp.Prod_InventoryPostingGroup := Item."Inventory Posting Group";
    end;

}

/*
report 5854 "Roll Up Standard Cost"
{
    Caption = 'Roll Up Standard Cost';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Costing Method";

            trigger OnPostDataItem()
            begin
                if not NoMessage then
                    if RolledUp then
                        Message(Text000)
                    else
                        Message(Text001);
            end;

            trigger OnPreDataItem()
            begin
                StdCostWksh.LockTable();
                Clear(CalcStdCost);
                CalcStdCost.SetProperties(CalculationDate, true, false, false, ToStdCostWkshName, true);
                CalcStdCost.CalcItems(Item, TempItem);

                TempItem.SetFilter("Replenishment System", '%1|%2',
                  TempItem."Replenishment System"::"Prod. Order",
                  TempItem."Replenishment System"::Assembly);
                if TempItem.Find('-') then
                    repeat
                        UpdateStdCostWksh;
                        RolledUp := true;
                    until TempItem.Next() = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CalculationDate; CalculationDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calculation Date';
                        ToolTip = 'Specifies the date you want the cost shares to be calculated.';

                        trigger OnValidate()
                        begin
                            if CalculationDate = 0D then
                                Error(Text002);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if CalculationDate = 0D then
                CalculationDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        StdCostWkshName: Record "Standard Cost Worksheet Name";
    begin
        RolledUp := false;

        if ToStdCostWkshName = '' then
            Error(Text003);
        StdCostWkshName.Get(ToStdCostWkshName);
    end;

    var
        TempItem: Record Item temporary;
        StdCostWksh: Record "Standard Cost Worksheet";
        CalcStdCost: Codeunit "Calculate Standard Cost";
        CalculationDate: Date;
        ToStdCostWkshName: Code[10];
        RolledUp: Boolean;
        Text000: Label 'The standard costs have been rolled up successfully.';
        Text001: Label 'There is nothing to roll up.';
        Text002: Label 'You must enter a calculation date.';
        Text003: Label 'You must specify a worksheet name to roll up to.';
        NoMessage: Boolean;

    local procedure UpdateStdCostWksh()
    var
        Found: Boolean;
    begin
        with StdCostWksh do begin
            Found := Get(ToStdCostWkshName, Type::Item, TempItem."No.");
            Validate("Standard Cost Worksheet Name", ToStdCostWkshName);
            Validate(Type, Type::Item);
            Validate("No.", TempItem."No.");
            "New Standard Cost" := TempItem."Standard Cost";

            "New Single-Lvl Material Cost" := TempItem."Single-Level Material Cost";
            "New Single-Lvl Cap. Cost" := TempItem."Single-Level Capacity Cost";
            "New Single-Lvl Subcontrd Cost" := TempItem."Single-Level Subcontrd. Cost";
            "New Single-Lvl Cap. Ovhd Cost" := TempItem."Single-Level Cap. Ovhd Cost";
            "New Single-Lvl Mfg. Ovhd Cost" := TempItem."Single-Level Mfg. Ovhd Cost";

            "New Rolled-up Material Cost" := TempItem."Rolled-up Material Cost";
            "New Rolled-up Cap. Cost" := TempItem."Rolled-up Capacity Cost";
            "New Rolled-up Subcontrd Cost" := TempItem."Rolled-up Subcontracted Cost";
            "New Rolled-up Cap. Ovhd Cost" := TempItem."Rolled-up Cap. Overhead Cost";
            "New Rolled-up Mfg. Ovhd Cost" := TempItem."Rolled-up Mfg. Ovhd Cost";
            OnUpdateStdCostWkshOnAfterFieldsPopulated(StdCostWksh, TempItem);

            if Found then
                Modify(true)
            else
                Insert(true);
        end;
    end;

    procedure SetStdCostWksh(NewStdCostWkshName: Code[10])
    begin
        ToStdCostWkshName := NewStdCostWkshName;
    end;

    procedure Initialize(StdCostWkshName2: Code[10]; NoMessage2: Boolean)
    begin
        ToStdCostWkshName := StdCostWkshName2;
        NoMessage := NoMessage2;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateStdCostWkshOnAfterFieldsPopulated(var StdCostWksh: Record "Standard Cost Worksheet"; TempItem: Record Item temporary)
    begin
    end;
}




*/
