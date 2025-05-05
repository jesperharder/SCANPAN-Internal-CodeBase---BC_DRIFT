


codeunit 50004 "TEST_CU"
{

    Access = Public;
    Subtype = Normal;


    var





    #region Delete invoiced IIC Purchaseorders
    /// <summary>
    /// DeleteFullyInvoicedPurchaseOrders.
    /// </summary>
    procedure DeleteFullyInvoicedPurchaseOrders()
    var
        PurchaseHeader: Record "Purchase Header";
        TestMsg: Text;
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.FindSet();
        repeat
            if IsReadyForDeletion(PurchaseHeader."No.") then
                TestMsg += 'Yes -' + PurchaseHeader."No." + '\';
            TestMsg += 'No  -' + PurchaseHeader."No." + '\';
        until PurchaseHeader.Next() = 0;
        Message(TestMsg);
    end;


    local procedure IsReadyForDeletion(PurchaseOrderNo: code[20]): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        IsReadyDelete: Boolean;
        TestCompanyLbl: Label 'This must be executed from Scanpan Norway Company. ';
        CompanyNameDK: Text[100];
        CompanyNameNO: Text[100];
    begin
        IsReadyDelete := true;
        CompanyNameDK := 'SCANPAN Danmark';
        CompanyNameNO := 'SCANPAN Norge';
        if CompanyName <> CompanyNameNO then error(TestCompanyLbl + CompanyName);

        //Test if DropShip linked salesorder exists Norway
        PurchaseLine.Reset();
        PurchaseLine.SetFilter("Document Type", '%1', PurchaseLine."Document Type"::Order);
        PurchaseLine.SetFilter("Document No.", PurchaseOrderNo);
        PurchaseLine.SetFilter(Type, '%1', PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Drop Shipment", '%1', true);
        if PurchaseLine.FindFirst() then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetFilter("Document Type", PurchaseLine."Sales Order No.");


        end;

        //Test if IIC linked salesorder exists Denmark
        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseOrderNo);
        SalesHeader.ChangeCompany(CompanyNameDK);
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::Order);
        if SalesHeader.get(SalesHeader."Document Type"::Order, PurchaseHeader."Vendor Order No.") then
            IsReadyDelete := false;

        exit(IsReadyDelete);
    end;
    #endregion


}