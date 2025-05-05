page 50045 "SalesBackordersInterCompany"
{
    PageType = List;
    Caption = 'Sales Backorders InterCompany';
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTable = Integer;
    SourceTableView = where(Number = filter(1 .. 10000));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field(Number; Rec.Number)
                {
                    Caption = 'Line Number';
                    ToolTip = 'Specifies the Excel row number.';
                }
                field(SalesOrderNumberNO; GetSalesNO(Rec.Number, 1))
                {
                    Caption = 'Salesorder NO';
                    ToolTip = 'Specifies the value of the SalesOrderNumberNO field.';
                }
                field(SalesNOdeleteBackOrder; GetSalesNO(Rec.Number, 2))
                {
                    Caption = 'Delete BackOrder NO';
                    ToolTip = 'Specifies the value of the SalesNOdeleteBackOrder field.';
                }
                field(PurchaseOrderNumberNO; GetPurchaseNO(
                                                GetSalesNO(Rec.Number, 1)
                                                    , 1))
                {
                    Caption = 'Purchaseorder NO';
                    ToolTip = 'Specifies the value of the Purchaseorder NO field.';
                }
                field(SalesOrderNumberDK; GetSalesDK(
                                                    GetPurchaseNO(
                                                        GetSalesNO(Rec.Number, 1)
                                                        , 2)))
                {
                    Caption = 'Salesorder DK';
                    ToolTip = 'Specifies the value of the Salesorder DK field.';
                }
            }
        }
    }

    var




    local procedure GetSalesNO(c: Integer; ReturnType: Integer): Text
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        FirstSalesLine: Integer;
    begin
        SalesHeader.ChangeCompany('SCANPAN Norge');
        SalesLine.ChangeCompany('SCANPAN Norge');
        SalesLine.SetFilter("Document Type", '%1', SalesLine."Document Type"::Order);
        FirstSalesLine := 0;
        if SalesLine.FindSet() then
            repeat
                SalesHeader.SetFilter("Document Type", '%1', SalesLine."Document Type");
                SalesHeader.SetFilter("No.", SalesLine."Document No.");
                SalesHeader.SetFilter("Del. SO's With Rem. Qty. NOTO", '%1', true);
                if SalesHeader.FindFirst() then begin
                    FirstSalesLine += 1;
                    if FirstSalesLine = c then begin
                        if ReturnType = 1 then exit(SalesLine."Document No.");
                        if ReturnType = 2 then exit(Format(SalesHeader."Del. SO's With Rem. Qty. NOTO"));
                    end;
                end
            until SalesLine.Next() = 0;
    end;

    local procedure GetPurchaseNO(OrderNo: Text; ReturnType: Integer): Text
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        if OrderNo = '' then exit('');

        PurchaseHeader.ChangeCompany('SCANPAN Norge');
        PurchaseLine.ChangeCompany('SCANPAN Norge');
        PurchaseLine.SetFilter("Document Type", '%1', PurchaseLine."Document Type"::Order);
        PurchaseLine.SetFilter("Sales Order No.", OrderNo);
        if PurchaseLine.FindFirst() then begin
            PurchaseHeader.SetRange("Document Type", PurchaseLine."Document Type");
            PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
            PurchaseHeader.FindFirst();
            if ReturnType = 1 then
                exit(PurchaseLine."Document No.");
            if ReturnType = 2 then
                exit(PurchaseHeader."Vendor Order No.");

        end;


    end;

    local procedure GetSalesDK(OrderNo: Text): Text
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if OrderNo = '' then exit('');

        SalesHeader.ChangeCompany('SCANPAN Danmark');
        SalesLine.ChangeCompany('SCANPAN Danmark');
        SalesLine.SetFilter("Document Type", '%1', SalesLine."Document Type"::Order);
        SalesLine.SetFilter("Document No.", OrderNo);
        if SalesLine.FindFirst() then
            exit(SalesLine."Document No.");
    end;
}