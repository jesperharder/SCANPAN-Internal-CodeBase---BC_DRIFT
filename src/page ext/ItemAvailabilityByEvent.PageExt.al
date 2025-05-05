



pageextension 50130 ItemAvailabilityByEvent extends "Item Availability by Event"
{
    /// <summary>
    /// 2025.03             Jesper Harder       109.1       Add Item No. to Document No. in Item Availability by Event (5530, Worksheet)
    /// </summary>


    // 109.1
    trigger OnAfterGetRecord()

    var
        ProductionOrder: Record "Production Order";
        RecordRef: RecordRef;
    begin

        // ✅ Exit if Level is 0
        if Rec.Level = 0 then
            exit;

        // ✅ Attempt to retrieve the record reference from "Source Document ID"
        if Format(Rec."Source Document ID") = '' then
            exit;

        RecordRef := Rec."Source Document ID".GetRecord();
        case Rec."Source Document ID".TableNo of
            DATABASE::"Production Order":
                begin
                    // ✅ Convert RecordRef to a ProductionOrder record
                    RecordRef.SetTable(ProductionOrder);

                    // ✅ Get the Production Order record
                    if ProductionOrder.Get(ProductionOrder.Status, ProductionOrder."No.") then
                        Rec."Document No." := CopyStr(Rec."Document No." + ', ' + ProductionOrder."Source No.", 1, 20);
                end;
        end;
    end;

}
