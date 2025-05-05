/// <summary>
/// Codeunit "SCANPAN_Subscriber_CU" (ID 50001).
/// </summary>
/// <remarks>
///
/// Version list
/// 2023.01             Jesper Harder       0193        CUBAGE Modification from NAV carried over to BC (Fixed in NOTORA code)
/// 2023.02             Jesper Harder       0193        SalesHeader, Requested Delivery Data calculated from Shipping Time formula
/// 2023.02             Jesper Harder       0193        Implement check for output quantity not greater then previous
/// 2023.02             Jesper Harder       0193        TRUECOMMERCE EDI
/// 2023.02             Jesper Harder       0193        Event CU GetShipmentLinjes to SalesInvoice - External document no.
/// 2023.03             Jesper Harder       0193        Event for Bank Account postings with Sales - Payment ID added
/// 2023.03             Jesper Harder       0193        Event for Calculate BOM Tree
/// 2023.03.29          Jesper Harder       018         Report "Notification Email"; //1320;
/// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
/// 2023.07.17          Jesper Harder       037         SalesOrder - Salesperson from Sell-To Customer
/// 2023.07.25          Jesper Harder       040         Warning salesline quantity Availability
/// 2023.06.12          Jesper Harder       034         Campaign statistics
/// 2023.08             Jesper Harder       045         Mandatory Fields setup
/// 2023.09             Jesper Harder       047         Restrict changes to user setup and General ledger posting dates
/// 2023.09             Jesper Harder       049         Restrict changes to Warehouse Source Filter (5771)
/// 2023.09             Jesper Harder       051         Set DropShip in Norway Company
/// 2023.09             Jesper Harder       052         Get external reference ID from Norway SalesOrder
/// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts, ItemMap Coating
/// 2023.11             Jesper Harder       059         PO Number City, break lookup for Web Customers
/// 2023.12             Jesper Harder       061         Customer Name must not exceed 35 chars in TrueCommerce transactions.
/// 2024.01             Jesper Harder       063         Warn if Gross weight, Net weight is same weight. LTS Customs system
/// 2024.04             Jesper Harder       064         Calculate Inventory Accept DateFilter
/// 2024.05             Jesper Harder       066         Test for Correct Chain Dimension value on Customer
/// 2024.07             Jesper Harder       071         Customers Blocked Status changed, message No. of Sales Orders
/// 2024.08             Jesper Harder       078         Transfer value from PurchaseLine to PurchaseInvoiceLine
/// 2024.09             Jesper Harder       080         Self-insured limit check with warning on sales order.
/// 
///                 Shift + Alt + E
///
/// </remarks>

codeunit 50001 "SubscriberCU"
{
    EventSubscriberInstance = StaticAutomatic;
    Permissions =
        tabledata Campaign = R,
        tabledata "Capacity Ledger Entry" = R,
        tabledata "Company Information" = R,
        tabledata Customer = R,
        tabledata "General Ledger Setup" = R,

        tabledata Item = R,
        tabledata "Item Journal Line" = R,
        tabledata MandatoryFieldSetup2 = R,
        tabledata "Notification Entry" = R,
        tabledata "Posted Whse. Shipment Header" = RM,
        tabledata "Posted Whse. Shipment Line" = RM,
        tabledata "Prod. Order Routing Line" = R,
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = R,
        tabledata "Sales Header" = RM,
        tabledata "Sales Line" = R,
        tabledata "User Setup" = R,
        tabledata Vendor = R,
        tabledata "Warehouse Employee" = R,
        tabledata "Warehouse Shipment Header" = RM,
        tabledata "Warehouse Source Filter" = R;

    /*
        #region 078         Transfer value from PurchaseLine to PurchaseInvoiceLine
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvLineInsert', '', true, true)]
        local procedure OnBeforePurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchaseLine: Record "Purchase Line")
        begin
            PurchInvLine."Custom Field" := PurchLine."Custom Field";
        end;
        #endregion
    */

    #region #066 Test for Correct Chain Dimension value on Customer
    // Event subscribers for table 352 "Default Dimension"

    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertDefaultDimension(Rec: Record "Default Dimension")
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        // Logic for handling new records
        ScanpanMiscellaneous.testChainDimension(Rec."Table ID", Rec."Dimension Code", Rec."Dimension Value Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyDefaultDimension(Rec: Record "Default Dimension")
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        // Logic for handling modified records
        ScanpanMiscellaneous.testChainDimension(Rec."Table ID", Rec."Dimension Code", Rec."Dimension Value Code");
    end;

    #endregion

    #region 064 - Calculate Inventory accept DateFilter
    [EventSubscriber(ObjectType::Report, Report::"CalculateInventory", 'OnItemLedgerEntryOnAfterPreDataItem', '', true, true)]
    local procedure CalculateInventoryOnItemLedgerEntryOnAfterPreDataItem(var ItemLedgerEntry: Record "Item Ledger Entry"; var Item: Record Item)
    var
    begin
        //Copied from old NAV soloution
        if Item.GetRangeMax("Date Filter") <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, Item.GetRangeMax("Date Filter"));
        // << BS01.00
    end;


    #endregion

    #region 063 Warn if Gross weight, Net weight is same weight. LTS Customs system
    /*
    [EventSubscriber(ObjectType::Table, database::Item, 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyEventItem(var Rec: Record Item)
    var
        WarningLbl: Label 'Warning Gross Weight and Net Weight must not be the same in the Customs System LTS.';

    begin
        if GuiAllowed then
            if not Rec.IsTemporary then
                case Rec."Prod. Group Code" of
                    '1':
                        ;
                    '6':
                        ;
                    '2':
                        ;
                    '3':
                        ;
                    else
                        if (Rec."Gross Weight" = 0) or (Rec."Net Weight" = 0) then
                            Message(WarningLbl);
                end;
    end;
    */
    #endregion

    #region 061 - Customer Name must not exceed 35 chars in TrueCommerce transactions.
    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterValidateEvent', 'Name', true, true)]
    local procedure OnafterValidateEventCustomer(var Rec: Record Customer)
    var
        WarningLbl: Label 'Warning - In TrueCommerce EDI Customer Name must not exceed 35 chars.';
    begin
        if not Rec.IsTemporary then
            if GuiAllowed then
                if StrLen(Rec.Name) > 35 then
                    Message(WarningLbl);
    end;
    #endregion

    #region 2023.11 059 - PO Number City, break lookup for Web Customers
    /*
        [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeModifyEvent', '', true, true)]
        local procedure OnBeforeModifyEventPostnumerCity(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
        var
            Customer: Record Customer;

        begin
            if not Rec.IsTemporary then begin
                Customer.Get(Rec."Sell-to Customer No.");
                if Customer.SkipPostNumCityCheckOnActivate = true then begin
                    if xRec."Sell-to City" <> Rec."Sell-to City" then Rec."Sell-to City" := xRec."Sell-to City";
                    if xRec."Sell-to Post Code" <> Rec."Sell-to Post Code" then Rec."Sell-to Post Code" := xRec."Sell-to Post Code";
                end;
            end;
        end;
    */
    #endregion

    #region 57 - Production Order UpdateSetQuantiy, ItemMap Coating
    [EventSubscriber(ObjectType::Table, database::"Prod. Order Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventProdOrderLine(var Rec: Record "Prod. Order Line")
    begin
        SetSetQuantityProdOrdLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Prod. Order Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventProdOrderLine(var Rec: Record "Prod. Order Line")
    begin
        SetSetQuantityProdOrdLine(Rec);
    end;

    //57
    local procedure SetSetQuantityProdOrdLine(var ProdOrderLine: Record "Prod. Order Line")
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        ProdOrderLine."Set Quantity" := ScanpanMiscellaneous.GetItemSetMultiplier(ProdOrderLine."Item No.");
        ProdOrderLine."Remaining Set Quantity" := ProdOrderLine."Set Quantity" * ProdOrderLine."Remaining Qty. (Base)";
        ProdOrderLine."Finished Set Quantity" := ProdOrderLine."Set Quantity" * ProdOrderLine."Finished Qty. (Base)";
        ProdOrderLine."Quantity SetQuantity" := ProdOrderLine."Set Quantity" * ProdOrderLine.Quantity;
    end;
    #endregion

    #region Event CU GetShipmentLinjes to SalesInvoice - External document no.
    //OnBeforeCodeInsertInvLineFromShptLine
    //Sales Shipment Line
    [EventSubscriber(ObjectType::Table, database::"Sales Shipment Line", 'OnAfterDescriptionSalesLineInsert', '', true, true)]
    local procedure GetShipmentText(var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line")
    var
        //SalesOrderHeader: Record "Sales Header";
        //SalesShipmentHeader: Record "Sales Shipment Header";
        ScanpanMisc: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMisc.UpdateShipmentGetTextOnInvoiceLine(SalesLine, SalesShipmentLine);
    end;
    #endregion

    #region Event ItemjounalLineOnAfterValidateOutputQuantityBase
    //Item Jounal Line
    //Validate output quantity not greater then previous operation, current + posted
    //Output Quantity Item Jounal Linje
    //Original code from NAV installation 15.2.2023
    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterValidateEvent', 'Output Quantity', true, true)]
    local procedure ItemjounalLineOnAfterValidateOutputQuantityBase(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line"; CurrFieldNo: Integer)
    var
        ScanpanMisc: Codeunit ScanpanMiscellaneous;
    begin
        SCANPANmisc.CheckItemJournalLinePreviousOutputQuantiy(Rec);
    end;
    #endregion

    #region Event for updating RequestedOrderDate OnAfterSelltoCustomerNoOnAfterValidate
    //Sales Header
    //[EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Order Date', true, true)]
    //037 SalesOrder - Salesperson from Sell-To Customer
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterSelltoCustomerNoOnAfterValidate', '', true, true)]
    local procedure SalesHeaderOnAfterSelltoCustomerNoOnAfterValidate(var SalesHeader: Record "Sales Header")
    var
        ScanpanMisc: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMisc.UpdateRequestedOrderDate(SalesHeader);
        //037
        ScanpanMisc.UpdateSalespersonFromSelltoCustomer(SalesHeader);
    end;
    #endregion

    #region Event for updating RequestedOrderDate OnAfterValidateEvent Order Date
    //Sales Header x 2 events
    //Set Requested Delivery data to next shipment day, next working day
    //037 SalesOrder - Salesperson from Sell-To Customer
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Order Date', true, true)]
    local procedure SalesHeaderOnAfterValidateOrderDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        ScanpanMisc: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMisc.UpdateRequestedOrderDate(Rec);
        //037
        ScanpanMisc.UpdateSalespersonFromSelltoCustomer(Rec);
    end;
    #endregion

    #region Event for field updates for TrueCommerce EDI
    //
    //TRUECOMMERCE EDI
    //Email adr
    //
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'TRCUDF6', true, true)]
    local procedure SalesHeaderOnAfterValidateTRCUDF6(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
    begin
        Rec."Sell-to E-Mail" := Rec.TRCUDF6;
        if Rec.Modify(true) then;
    end;
    //
    //TRUECOMMERCE EDI
    //PHONE NO
    //
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'TRCUDF7', true, true)]
    local procedure SalesHeaderOnAfterValidateTRCUDF7(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
    begin
        Rec."Sell-to Phone No." := CopyStr(Rec.TRCUDF7, 1, 30);
        if Rec.Modify(true) then;
    end;
    #endregion

    #region 018 Report "Notification Email"; //1320;
    //Updates the DocumentURL in Workflow mails to be the live tier
    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholdersOnAfterGetDocumentURL', '', true, true)]
    local procedure OnSetReportFieldPlaceholdersOnAfterGetDocumentURL(var DocumentURL: Text; var NotificationEntry: Record "Notification Entry")
    var
        Len: Integer;
        Text000Lbl: Label '&page=654#EventSubscriber Scanpan Link';
    begin
        DocumentURL := DocumentURL.Replace('_UP', '');
        Len := StrPos(DocumentURL, '&page=');
        NotificationEntry."Custom Link" := DelStr(DocumentURL, Len) + Text000Lbl;
    end;
    #endregion

    #region 037 New SalesOrder - Salesperson from Sell-To Customer
    //2024.04 Changed to OnBeforeSetDefaultSalesperson, from OnAfterInsert
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSetDefaultSalesperson', '', true, true)]
    local procedure OnBeforeSetDefaultSalespersonSalesHeader(var SalesHeader: Record "Sales Header");
    var
        ScanpanMisc: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMisc.UpdateSalespersonFromSelltoCustomer(SalesHeader);
    end;

    #endregion

    /*
    //SHIPITREMOVE
    #region 035 Post TransportOrderID posted to Posted Whse. ShipmentLines through 14.7.2023 Added Code
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"IDYS Publisher", 'OnAfterCreateTransportOrder', '', false, false)]
    //[EventSubscriber(ObjectType::Table, Database::"IDYS Transport Order Header", 'OnAfterInsertEvent', '', true, true)]
    //    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IDYS Publisher", 'OnAfterCreateTransportOrder', '', true, true)]
    [EventSubscriber(ObjectType::Table, Database::"Posted Whse. Shipment Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPostedWhseShipmentHeader(var Rec: Record "Posted Whse. Shipment Header")
    var
        IDYSTransportOrderHeader: Record "IDYS Transport Order Header";
    begin
        IDYSTransportOrderHeader.SetFilter(Description, 'Lagerleverancehoved ' + Rec."Whse. Shipment No.");
        if IDYSTransportOrderHeader.FindLast() then begin
            Rec."Transport Order No." := IDYSTransportOrderHeader."No.";
            Rec.Modify();
        end;
    end;
    //SHIPITREMOVE

    [EventSubscriber(ObjectType::Table, Database::"Posted Whse. Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPostedWhseShipmentLine(var Rec: Record "Posted Whse. Shipment Line")
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
    begin
        PostedWhseShipmentHeader.Get(Rec."No.");
        Rec."Transport Order No." := PostedWhseShipmentHeader."Transport Order No.";
        Rec.Modify();
    end;

    #endregion
    */


    #region 034 Campaign statistics
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Campaign Target Group Mgt", 'OnBeforeActivateCampaign', '', false, false)]
    local procedure OnBeforeActivateCampaign(var Campaign: Record Campaign; var IsHandled: Boolean);
    var
        CampaignNotification: Notification;
        NotificationLbl: Label 'Please select Campaign Purpose.';
    begin
        if Campaign."Campaign Purpose NOTO" = '' then begin
            CampaignNotification.Message(NotificationLbl);
            CampaignNotification.Send();
        end;
        Campaign.TestField("Campaign Purpose NOTO")
    end;
    #endregion

    #region 040 Warning salesline quantity Availability
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Quantity', true, true)]
    local procedure SalesLineOnBeforeValidateEvent(var Rec: Record "Sales Line")
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMiscellaneous.AvailableQuantityWarning(Rec);
    end;
    #endregion


    #region 045 Mandatory Fields setup

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Blocked', true, true)]
    local procedure OnBeforeValidateEventCustomerBlocked(var Rec: Record Customer)
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;

        //071
        SalesHeader: Record "Sales Header";
        SalesOrderReleasedCountLbl: Label 'Please note there are %1 Sales Orders Released.', Comment = '%1, Count of released sales orders.';
        SalesOrderOpenCountLbl: Label 'Please note there are %1 Open Sales Orders.', Comment = '%1, Count of open sales orders.';
    begin
        if GuiAllowed then begin
            if Rec.Blocked = Rec.Blocked::" " then begin
                //045 Mandatory Fields setup
                MandatoryFieldSetup2.CheckCust(Rec);

                ///071 Customers Blocked, message of salesorders
                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetFilter("Sell-to Customer No.", Rec."No.");
                SalesHeader.SetFilter(Status, '<>%1', SalesHeader.Status::Released);
                if SalesHeader.Count > 0 then Message(SalesOrderOpenCountLbl, SalesHeader.Count);

            end;
            ///071 Customers Blocked, message of salesorders
            if Rec.Blocked <> Rec.Blocked::" " then begin
                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetFilter("Sell-to Customer No.", Rec."No.");
                SalesHeader.SetRange(Status, SalesHeader.Status::Released);
                if SalesHeader.Count > 0 then Message(SalesOrderReleasedCountLbl, SalesHeader.Count);
            end;
        end;
    end;


    //Mandatory fields check
    [EventSubscriber(ObjectType::Table, Database::"Item", 'OnBeforeValidateEvent', 'Blocked', true, true)]
    local procedure OnBeforeValidateEventItemBlocked(var Rec: Record Item)
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;
    begin
        if not Rec.Blocked then
            MandatoryFieldSetup2.CheckItem(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeValidateEvent', 'Blocked', true, true)]
    local procedure OnBeforeValidateEventVendorBlocked(var Rec: Record Vendor)
    var
        MandatoryFieldSetup2: Record MandatoryFieldSetup2;
    begin
        if Rec.Blocked = Rec.Blocked::" " then
            MandatoryFieldSetup2.CheckVend(Rec);
    end;

    #endregion

    #region 047 Restrict changes to user setup and General ledger posting dates

    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", 'OnBeforeModifyEvent', '', true, true)]
    local procedure OnBeforeModifyEventGeneralLedgerSetup(var Rec: Record "General Ledger Setup"; var xRec: Record "General Ledger Setup")
    var
        UserSetup: Record "User Setup";
        ErrorLbl: Label 'You do not have permissions to change posting setup dates.\Consult your Administrator.';
    begin
        UserSetup.SetFilter("User ID", UserId());
        if (xRec."Allow Posting From" <> Rec."Allow Posting From") or (xRec."Allow Posting To" <> Rec."Allow Posting To") then
            if UserSetup.FindFirst() then
                if UserSetup."Allow Edit Posting Dates" = false then Error(ErrorLbl);
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Setup", 'OnBeforeModifyEvent', '', true, true)]
    local procedure OnBeforeModifyEventUserSetup(var Rec: Record "User Setup"; var xRec: Record "User Setup")
    var
        UserSetup: Record "User Setup";
        ErrorLbl: Label 'You do not have permissions to change posting setup dates.\Consult your Administrator.';
    begin
        UserSetup.SetFilter("User ID", UserId());
        if (xRec."Allow Posting From" <> Rec."Allow Posting From") or (xRec."Allow Posting To" <> Rec."Allow Posting To") then
            if UserSetup.FindFirst() then
                if UserSetup."Allow Edit Posting Dates" = false then Error(ErrorLbl);
    end;
    #endregion

    #region 049 Restrict changes to Warehouse Source Filter (5771)
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Source Filter", 'OnBeforeModifyEvent', '', true, true)]
    local procedure OnBeforeModifyEventWarehouseSourceFilter(var Rec: Record "Warehouse Source Filter"; var xRec: Record "Warehouse Source Filter")
    var
        WarehouseEmployee: Record "Warehouse Employee";
        ErrorLbl: Label 'You do not have permissions to change Warehouse Filters.\Consult your Administrator.';
    begin
        WarehouseEmployee.SetFilter("User ID", UserId());
        if WarehouseEmployee.FindFirst() then
            if (WarehouseEmployee."Permit Change Warehouse Filter" = false) and (xRec."Allow Edit" = false) then Error(ErrorLbl);
    end;
    #endregion

    #region 051 Set DropShip in Norway Company
    /*
    local procedure SalesHeaderNorwayIIC(var SalesHeader: Record "Sales Header")
    var
    begin
        if CompanyName = 'SCANPAN Norge' then
            if not SalesHeader.IsTemporary then
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                    SalesHeader."ITI IIC Drop Ship. Vendor No." := '5008';
    end

    //
    //[EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]
    //local procedure OnAfterInsertEventSalesHeader(var Rec: Record "Sales Header");
    //begin
    //    if CompanyName = 'SCANPAN Norge' then
    //        if not Rec.IsTemporary then
    //            if Rec."Document Type" = SalesHeader."Document Type"::Order then
    //            Rec."ITI IIC Drop Ship. Vendor No." := '5008';
    //end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertEventSalesLine(var Rec: Record "Sales Line");
    begin
        if CompanyName = 'SCANPAN Norge' then
            if not Rec.IsTemporary then
                if Rec."Document Type" = Rec."Document Type"::Order then
                    if Rec.Type = Rec.Type::Item then
                        Rec.Validate("Purchasing Code", 'DROPSHIP');
    end;
    */
    #endregion

    #region 052 Get external reference ID from Norway SalesOrder
    /*
    //[EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, true)]
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'External Document No.', true, true)]
    local procedure OnafterValidateEventExternalDocNoSalesHeader(var Rec: Record "Sales Header")
    var
        LookupPurchaseHeader: Record "Purchase Header";
        LookupPurchaseLine: Record "Purchase Line";
        LookupSalesHeader: Record "Sales Header";
        PurchaseReference: code[50];
        LookupCompanyName: Text;
    begin
        if (CompanyName = 'SCANPAN Danmark') and (Rec."Sell-to Customer No." = '1010') then
            if not Rec.IsTemporary then begin
                LookupCompanyName := 'SCANPAN Norge';
                PurchaseReference := Rec."ITI IIC Document ID";
                LookupPurchaseHeader.ChangeCompany(LookupCompanyName);
                LookupPurchaseLine.ChangeCompany(LookupCompanyName);
                LookupSalesHeader.ChangeCompany(LookupCompanyName);
                LookupPurchaseHeader.SetFilter("ITI IIC Document ID", PurchaseReference);
                if LookupPurchaseHeader.FindFirst() then begin
                    LookupPurchaseLine.SetRange("Document Type", LookupPurchaseHeader."Document Type");
                    LookupPurchaseLine.SetFilter("Document No.", LookupPurchaseHeader."No.");
                    if LookupPurchaseLine.FindFirst() then
                        if LookupSalesHeader.Get(LookupSalesHeader."Document Type"::Order, LookupPurchaseLine."Sales Order No.") then
                            Rec."External Document No." := CopyStr(LookupPurchaseHeader."No." + '-' + LookupSalesHeader."External Document No.", 1, 35);
                end;
            end;
    end;
    */
    #endregion

    #region

    #endregion
    #region 080         Self-insured limit check with warning on sales order.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterManualReleaseSalesDoc', '', false, false)]
    local procedure OnAfterSalesOrderRelease(SalesHeader: Record "Sales Header")
    var
        CustomerRec: Record Customer;
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        // Retrieve the customer from the Sales Header's "Sell-to Customer No."
        if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
            // Call the procedure to check the "Self-Insured" limit
            ScanpanMiscellaneous.CheckCustomerCreditLimit(CustomerRec, SalesHeader);
    end;
    #endregion

    




}
