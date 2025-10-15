codeunit 50034 "Ryom Availability Mgt"
{
    /// <summary>
    /// 2025.10             Jesper Harder       094.2   Added field for Inventory at RYOM, Qty. on Transfer to RYOM and Qty. on Prod. Order RYOM
    /// </summary>
    procedure GetRyomAvailability(Item: Record Item; var Inventory: Decimal; var TransferInbound: Decimal; var ProductionSupply: Decimal)
    var
        LocationCode: Code[10];
    begin
        Inventory := 0;
        TransferInbound := 0;
        ProductionSupply := 0;
        if Item."No." = '' then
            exit;
        LocationCode := GetTrackedLocationCode();
        Inventory := CalcInventory(Item, LocationCode);
        TransferInbound := CalcTransferInbound(Item, LocationCode);
        ProductionSupply := CalcProductionSupply(Item, LocationCode);
    end;

    local procedure GetTrackedLocationCode(): Code[10]
    begin
        exit('RYOM');
    end;

    local procedure CalcInventory(Item: Record Item; LocationCode: Code[10]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        DateFilter: Text;
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Location Code", "Variant Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        ApplyVariantFilterToILE(Item, ItemLedgerEntry);
        ApplyDimensionFiltersToILE(Item, ItemLedgerEntry);
        DateFilter := Item.GetFilter("Date Filter");
        if DateFilter <> '' then
            ItemLedgerEntry.SetFilter("Posting Date", DateFilter);
        ItemLedgerEntry.CalcSums("Remaining Quantity");
        exit(ItemLedgerEntry."Remaining Quantity");
    end;

    local procedure CalcTransferInbound(Item: Record Item; LocationCode: Code[10]): Decimal
    var
        TransferLine: Record "Transfer Line";
        TransferHeader: Record "Transfer Header";
        Qty: Decimal;
        DateFilter: Text;
        UnitOfMeasureFilter: Text;
    begin
        TransferLine.SetCurrentKey("Item No.", "Transfer-to Code", "Derived From Line No.");
        TransferLine.SetRange("Item No.", Item."No.");
        TransferLine.SetRange("Transfer-to Code", LocationCode);
        TransferLine.SetRange("Derived From Line No.", 0);
        TransferLine.SetFilter("Outstanding Qty. (Base)", '>%1', 0);
        ApplyVariantFilterToTransferLine(Item, TransferLine);
        ApplyDimensionFiltersToTransferLine(Item, TransferLine);
        DateFilter := Item.GetFilter("Date Filter");
        if DateFilter <> '' then
            TransferLine.SetFilter("Receipt Date", DateFilter);
        UnitOfMeasureFilter := Item.GetFilter("Unit of Measure Filter");
        if UnitOfMeasureFilter <> '' then
            TransferLine.SetFilter("Unit of Measure Code", UnitOfMeasureFilter);
        if TransferLine.FindSet() then
            repeat
                if TransferHeader.Get(TransferLine."Document No.") then
                    if (TransferHeader.Status = TransferHeader.Status::Released) or (TransferHeader.Status = TransferHeader.Status::Open) then
                        Qty += TransferLine."Outstanding Qty. (Base)";
            until TransferLine.Next() = 0;
        exit(Qty);
    end;

    local procedure CalcProductionSupply(Item: Record Item; LocationCode: Code[10]): Decimal
    var
        ProdOrderLine: Record "Prod. Order Line";
        DateFilter: Text;
        UnitOfMeasureFilter: Text;
    begin
        ProdOrderLine.SetCurrentKey(Status, "Item No.", "Location Code", "Variant Code");
        ProdOrderLine.SetRange("Item No.", Item."No.");
        ProdOrderLine.SetRange("Location Code", LocationCode);
        ProdOrderLine.SetFilter(Status, '%1|%2', ProdOrderLine.Status::Released, ProdOrderLine.Status::"Firm Planned");
        ApplyVariantFilterToProdLine(Item, ProdOrderLine);
        ApplyDimensionFiltersToProdLine(Item, ProdOrderLine);
        DateFilter := Item.GetFilter("Date Filter");
        if DateFilter <> '' then
            ProdOrderLine.SetFilter("Ending Date", DateFilter);
        UnitOfMeasureFilter := Item.GetFilter("Unit of Measure Filter");
        if UnitOfMeasureFilter <> '' then
            ProdOrderLine.SetFilter("Unit of Measure Code", UnitOfMeasureFilter);
        ProdOrderLine.CalcSums("Remaining Qty. (Base)");
        exit(ProdOrderLine."Remaining Qty. (Base)");
    end;

    local procedure ApplyVariantFilterToILE(Item: Record Item; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        VariantFilter: Text;
    begin
        VariantFilter := Item.GetFilter("Variant Filter");
        if VariantFilter <> '' then
            ItemLedgerEntry.SetFilter("Variant Code", VariantFilter);
    end;

    local procedure ApplyDimensionFiltersToILE(Item: Record Item; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
    begin
        GlobalDim1Filter := Item.GetFilter("Global Dimension 1 Filter");
        if GlobalDim1Filter <> '' then
            ItemLedgerEntry.SetFilter("Global Dimension 1 Code", GlobalDim1Filter);
        GlobalDim2Filter := Item.GetFilter("Global Dimension 2 Filter");
        if GlobalDim2Filter <> '' then
            ItemLedgerEntry.SetFilter("Global Dimension 2 Code", GlobalDim2Filter);
    end;

    local procedure ApplyVariantFilterToTransferLine(Item: Record Item; var TransferLine: Record "Transfer Line")
    var
        VariantFilter: Text;
    begin
        VariantFilter := Item.GetFilter("Variant Filter");
        if VariantFilter <> '' then
            TransferLine.SetFilter("Variant Code", VariantFilter);
    end;

    local procedure ApplyDimensionFiltersToTransferLine(Item: Record Item; var TransferLine: Record "Transfer Line")
    var
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
    begin
        GlobalDim1Filter := Item.GetFilter("Global Dimension 1 Filter");
        if GlobalDim1Filter <> '' then
            TransferLine.SetFilter("Shortcut Dimension 1 Code", GlobalDim1Filter);
        GlobalDim2Filter := Item.GetFilter("Global Dimension 2 Filter");
        if GlobalDim2Filter <> '' then
            TransferLine.SetFilter("Shortcut Dimension 2 Code", GlobalDim2Filter);
    end;

    local procedure ApplyVariantFilterToProdLine(Item: Record Item; var ProdOrderLine: Record "Prod. Order Line")
    var
        VariantFilter: Text;
    begin
        VariantFilter := Item.GetFilter("Variant Filter");
        if VariantFilter <> '' then
            ProdOrderLine.SetFilter("Variant Code", VariantFilter);
    end;

    local procedure ApplyDimensionFiltersToProdLine(Item: Record Item; var ProdOrderLine: Record "Prod. Order Line")
    var
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
    begin
        GlobalDim1Filter := Item.GetFilter("Global Dimension 1 Filter");
        if GlobalDim1Filter <> '' then
            ProdOrderLine.SetFilter("Shortcut Dimension 1 Code", GlobalDim1Filter);
        GlobalDim2Filter := Item.GetFilter("Global Dimension 2 Filter");
        if GlobalDim2Filter <> '' then
            ProdOrderLine.SetFilter("Shortcut Dimension 2 Code", GlobalDim2Filter);
    end;
}