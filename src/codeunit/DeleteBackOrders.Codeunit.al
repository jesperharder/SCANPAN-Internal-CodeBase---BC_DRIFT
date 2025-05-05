


codeunit 50011 "DeleteBackOrders"
{
    trigger OnRun()
    var
        NotoCustomization: codeunit "NOTOCustomization";
        SalesHeader: Record "Sales Header";
        dialog: Dialog;
        MessageLbl: Label 'Salesorder #1';
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Del. SO's With Rem. Qty. NOTO", true);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        SalesHeader.FindSet();
        dialog.Open(MessageLbl);
        repeat
            dialog.Update(1, SalesHeader."No.");
            NotoCustomization.DeleteSORemainingQty(SalesHeader);
        until SalesHeader.Next() = 0;
    end;
}