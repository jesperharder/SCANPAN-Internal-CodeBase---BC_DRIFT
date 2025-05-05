

/// <summary>
/// Codeunit OneTimeSetQuantityUpdate (ID 50009).
/// </summary>
/// <remarks>
/// 057         Page Part - Graphs sorting parts
/// </remarks>
codeunit 50009 OneTimeSetQuantityUpdate
{
    trigger OnRun()
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderLine2: Record "Prod. Order Line";
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        WindowDialog: Dialog;
        c: Integer;
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.FindSet();
        WindowDialog.Open('ProdOrderLines Total #1, Counting #2');
        WindowDialog.Update(1, ProdOrderLine.Count);
        repeat
            c += 1;
            WindowDialog.Update(2, c);

            ProdOrderLine2.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
            ProdOrderLine2."Set Quantity" := ScanpanMiscellaneous.GetItemSetMultiplier(ProdOrderLine."Item No.");
            ProdOrderLine2."Remaining Set Quantity" := ProdOrderLine2."Set Quantity" * ProdOrderLine."Remaining Qty. (Base)";
            ProdOrderLine2."Finished Set Quantity" := ProdOrderLine2."Set Quantity" * ProdOrderLine."Finished Qty. (Base)";
            ProdOrderLine2."Quantity SetQuantity" := ProdOrderLine2."Set Quantity" * ProdOrderLine.Quantity;
            ProdOrderLine2.Modify(false);
        until ProdOrderLine.Next() = 0;
    end;

}