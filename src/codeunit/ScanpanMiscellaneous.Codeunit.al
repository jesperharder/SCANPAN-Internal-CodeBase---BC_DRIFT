

codeunit 50002 "ScanpanMiscellaneous"
{
    /// <summary>
    /// Codeunit "ScanpanMiscellaneous" (ID 50002).
    /// 
    /// This codeunit provides a collection of utility procedures for the Scanpan implementation in Business Central.
    /// 
    /// Main functionalities include:
    /// - Updating the Requested Delivery Date on Sales Orders based on working days.
    /// - Ensuring manufacturing output quantities do not exceed previous operation quantities.
    /// - Updating GTIN on Item Cards from Item References.
    /// - Verifying if the user is in the specified company.
    /// - Generating barcodes (EAN and UCC codes) for items.
    /// - Toggling action messages on Requisition Lines in Purchase and Planning Worksheets.
    /// - Calculating warehouse pick bin balances.
    /// - Filling temporary tables for Sales Lines and Production Controlling Routing Lines.
    /// - Providing warnings for specific sales scenarios (e.g., Imerco DropShip).
    /// - Calculating sales prices based on purchase price markup.
    /// - Validating chain dimension values on customers.
    /// - Sending emails via AL code.
    /// 
    /// Version list
    /// 2023.02             Jesper Harder       0193        UpdateRequestedOrderDate, used from Subscriber CU
    /// 2023.02             Jesper Harder       0193        CheckItemJournalLinePreviousOutputQuantiy, used to ensure output qty not over previous
    /// 2023.02             Jesper Harder       0193        Update GTIN on Item Card
    /// 2023.02             Jesper Harder       0193        CheckIsUserInCompany MASTER
    /// 2023.03             Jesper Harder                   Updates Purchase and Planning Worksheet
    /// 2023.03             Jesper Harder       002         Warehouse Pick Balance
    /// 2023.03             Jesper Harder       005         Sales Lines Page
    /// 2023.03.27          Jesper Harder       015         Flowfield Tariff - SalesLine
    /// 2023.03.27          Jesper Harder       017         Inventory Journal StockStatus Add Code
    /// 2023.06             Jesper Harder       032         Warning Imerco DropShip 
    /// 2023.07.25          Jesper Harder       040         Warning salesline quantity Availability
    /// 2023.07.23          Jesper Harder       042         Salesprice based on PurchasePrice Markup
    /// 2023.10             Jesper Harder       056         Coating Description on Production Orders
    /// 2024.04             Jesper Harder       065         Filter and output of ItemUnitQuantity added
    /// 2024.05             Jesper Harder       066         Test for Correct Chain Dimension value on Customer
    /// 
    /// 2024.09             Jesper Harder                   //Error thrown in certain situations. Start Revised Code 18.9.2024JH
    /// 2024.09             Jesper Harder       080         Self-insured limit check with warning on sales order.
    /// 2024.10             Jesper Harder       083         Delete BackOrders Norway
    /// 2024.11             Jesper Harder       096         JobQueue hardening to make sure it executes as expected
    /// </summary>

    Permissions =
        tabledata BarCodesTmpSC = RIMD,
        tabledata Bin = R,
        tabledata "Bin Content" = R,
        tabledata Campaign = R,
        tabledata CampaignStatistics = RI,
        tabledata "Capacity Ledger Entry" = R,
        tabledata "Company Information" = R,
        tabledata Currency = R,
        tabledata Customer = R,
        tabledata "Dimension Value" = R,
        tabledata InventoryJournalStatus = RID,
        tabledata InventoryMapShelfSC = R,
        tabledata "Inventory Setup" = RM,
        tabledata Item = RM,
        tabledata "Item Reference" = RI,
        tabledata "Item Journal Line" = RM,
        tabledata "Item Unit of Measure" = R,
        tabledata "Price List Line" = R,
        tabledata "Prod. Order Routing Line" = R,
        tabledata "Production Forecast Entry" = R,
        tabledata "Requisition Line" = RM,
        tabledata "Sales Header" = RM,
        tabledata "Sales Invoice Header" = R,
        tabledata "Sales Invoice Line" = R,
        tabledata "Sales Line" = RM,
        tabledata SalesLineTMP = RID,
        tabledata "Sales Shipment Line" = R,
        tabledata User = R,
        tabledata "Warehouse Shipment Line" = R,
        tabledata WMSPickBinBalanceTMP = RIMD;

    #region #066 Test for Correct Chain Dimension value on Customer
    /// <summary>
    /// Validates that the Chain Dimension value on a Customer is of type STANDARD.
    /// If the Dimension Value is not of type STANDARD, displays a message to the user.
    /// </summary>
    /// <param name="TableID">The ID of the table; should be 18 for Customer table.</param>
    /// <param name="DimensionCode">The dimension code; expected to be 'KÆDE' (Chain).</param>
    /// <param name="DimensionValueCode">The dimension value code to validate.</param>
    procedure testChainDimension(TableID: Integer; DimensionCode: Code[20]; DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
        MessageLbl: Label 'Only use Chain Dimension of type STANDARD. The selected type is %1.', Comment = '%1 = Dimension Value Type';
    begin
        if (TableID = 18) and (DimensionCode = 'KÆDE') then begin
            DimensionValue.Reset();
            DimensionValue.SetFilter("Dimension Code", 'KÆDE');
            DimensionValue.SetRange("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
            DimensionValue.SetFilter(Code, DimensionValueCode);
            if DimensionValue.IsEmpty then begin
                DimensionValue.SetRange("Dimension Value Type");
                DimensionValue.FindFirst();
                Message(MessageLbl, DimensionValue."Dimension Value Type");
            end;
        end;
    end;
    #endregion

    #region Update RequestedDeliveryDate on Sales Order Header
    /// <summary>
    /// Updates the Requested Delivery Date on the Sales Order Header based on the company's working calendar.
    /// </summary>
    /// <param name="SalesHeader">The Sales Header record to update.</param>
    procedure UpdateRequestedOrderDate(var SalesHeader: Record "Sales Header")
    var
        CompanyInformation: Record "Company Information";
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        DummyDate: Date;
    begin
        CompanyInformation.Get();
        CalendarManagement.SetSource(CompanyInformation, CustomizedCalendarChange);
        DummyDate := CalcDate(SalesHeader."Shipping Time", SalesHeader."Order Date");
        while CalendarManagement.IsNonworkingDay(DummyDate, CustomizedCalendarChange) do
            DummyDate += 1;
        SalesHeader."Requested Delivery Date" := DummyDate;
        if SalesHeader.Modify(true) then;
    end;
    #endregion

    #region 037 Get Salesperson from Sell-To Customer
    /// <summary>
    /// Updates the Salesperson Code on the Sales Header from the Sell-To Customer's Salesperson Code.
    /// </summary>
    /// <param name="SalesHeader">The Sales Header record to update.</param>
    procedure UpdateSalespersonFromSelltoCustomer(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if not SalesHeader.IsTemporary then
            if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                SalesHeader."Salesperson Code" := Customer."Salesperson Code";
                if SalesHeader.Modify(true) then;
            end;
    end;
    #endregion

    #region Message if Manufacturing order Output Quantity is bigger than previous operation
    /// <summary>
    /// Checks the Output Quantity in an Item Journal Line to ensure it does not exceed the Output Quantity of the previous operation.
    /// If it does, displays a warning message to the user.
    /// </summary>
    /// <param name="ItemJournalLine">The Item Journal Line record to validate.</param>
    procedure CheckItemJournalLinePreviousOutputQuantiy(var ItemJournalLine: Record "Item Journal Line")
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        CapacityLedgerEntry2: Record "Capacity Ledger Entry";
        PrevOutputLine_ItemJournalLine: Record "Item Journal Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        QtyInJnl: Decimal;
        Text001Lbl: Label '%7 \Afgangsantal %1 \+ tilbagemeldt antal %2 \på operation %3 er større end\afgangsantal %4 \+ tilbagemeldt antal %5 \på foregående operation %6.',
        Comment = '%1 = Output Quantity, %2 = Previously Reported Quantity, %3 = Operation No., %4 = Output Quantity, %5 = Reported Quantity, %6 = Previous Operation No., %7 = Item Description';
    begin
        if ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Output then
            exit;

        // Error thrown in certain cases, updated code on 18.9.2024 JH
        if ItemJournalLine."Journal Template Name" = '' then
            exit; // Continue if validation fails
        if ItemJournalLine."Journal Batch Name" = '' then
            exit;

        // Get the production order routing line
        if ProdOrderRoutingLine.Get(ProdOrderRoutingLine.Status::Released,
                ItemJournalLine."Document No.",                   // "Prod. Order No."
                ItemJournalLine."Routing Reference No.",
                ItemJournalLine."Routing No.",
                ItemJournalLine."Operation No.") then begin

            if ProdOrderRoutingLine."Previous Operation No." = '' then
                exit;

            // Get posted output on previous routing line
            CapacityLedgerEntry.SetCurrentKey("Document No.", "Order Line No.", "Routing No.", "Routing Reference No.", "Operation No.", "Last Output Line");
            CapacityLedgerEntry.SetRange("Document No.", ItemJournalLine."Document No.");
            CapacityLedgerEntry.SetRange("Order Line No.", ItemJournalLine."Order Line No.");
            CapacityLedgerEntry.SetRange("Routing No.", ItemJournalLine."Routing No.");
            CapacityLedgerEntry.SetRange("Routing Reference No.", ItemJournalLine."Routing Reference No.");
            CapacityLedgerEntry.SetRange("Operation No.", ProdOrderRoutingLine."Previous Operation No.");
            CapacityLedgerEntry.CalcSums("Output Quantity");

            // Get posted output on current routing line
            CapacityLedgerEntry2.SetCurrentKey("Document No.", "Order Line No.", "Routing No.", "Routing Reference No.", "Operation No.", "Last Output Line");
            CapacityLedgerEntry2.SetRange("Document No.", ItemJournalLine."Document No.");
            CapacityLedgerEntry2.SetRange("Order Line No.", ItemJournalLine."Order Line No.");
            CapacityLedgerEntry2.SetRange("Routing No.", ItemJournalLine."Routing No.");
            CapacityLedgerEntry2.SetRange("Routing Reference No.", ItemJournalLine."Routing Reference No.");
            CapacityLedgerEntry2.SetRange("Operation No.", ProdOrderRoutingLine."Operation No.");
            CapacityLedgerEntry2.CalcSums("Output Quantity");

            // Get output registered in journal for previous routing line
            PrevOutputLine_ItemJournalLine.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
            PrevOutputLine_ItemJournalLine.SetRange("Journal Batch Name", ItemJournalLine."Journal Batch Name");
            PrevOutputLine_ItemJournalLine.SetRange("Document No.", ItemJournalLine."Document No.");
            PrevOutputLine_ItemJournalLine.SetRange("Order Line No.", ItemJournalLine."Order Line No.");
            PrevOutputLine_ItemJournalLine.SetRange("Routing Reference No.", ItemJournalLine."Routing Reference No.");
            PrevOutputLine_ItemJournalLine.SetRange("Operation No.", ProdOrderRoutingLine."Previous Operation No.");
            PrevOutputLine_ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type");
            if PrevOutputLine_ItemJournalLine.FindSet(false) then
                repeat
                    QtyInJnl += PrevOutputLine_ItemJournalLine."Output Quantity";
                until PrevOutputLine_ItemJournalLine.Next() = 0;

            if ItemJournalLine."Output Quantity" + CapacityLedgerEntry2."Output Quantity" >
              QtyInJnl + CapacityLedgerEntry."Output Quantity" then
                MESSAGE(Text001Lbl,
                            ItemJournalLine."Output Quantity",
                            CapacityLedgerEntry2."Output Quantity",
                            ProdOrderRoutingLine."Operation No.",
                            QtyInJnl,
                            CapacityLedgerEntry."Output Quantity",
                            ProdOrderRoutingLine."Previous Operation No.",
                            ItemJournalLine.Description
                            );
        end;
    end;
    #endregion

    #region Update InvoiceLine Description from ShipmentLinesGet
    // 92         Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 

    procedure UpdateShipmentGetTextOnInvoiceLine(var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesHeader: Record "Sales Header";
        XTECSCShipmentLog: Record "XTECSC Shipment Log";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", SalesShipmentLine."Order No.");

        if not SalesHeader.FindFirst() then
            exit;

        SalesLine.Description += ' ' + SalesHeader."No." + ' ' + SalesHeader."External Document No.";

        // 092 Lookup TrackAndTrace
        XTECSCShipmentLog.Reset();
        XTECSCShipmentLog.SetRange("Shipment Type", XTECSCShipmentLog."Shipment Type"::"Sales Order");
        XTECSCShipmentLog.SetRange("Order No.", SalesHeader."No.");
        if XTECSCShipmentLog.FindFirst() then
            SalesLine.Description += ' ' + XTECSCShipmentLog."Track & Trace Number";

        if SalesLine.Modify(true) then;

    end;
    #endregion

    #region Update GTIN on Item Card
    /// <summary>
    /// Updates the GTIN on all Item Cards from their associated Item References.
    /// </summary>
    procedure UpdateAllItemsWithGTIN()
    var
        Items: Record Item;
        Answer: Boolean;
        WindowDialog: Dialog;
        ItemsCount: Integer;
        LoopCount: Integer;
        Pct: Integer;
        Text001Lbl: Label 'Updating GTIN on all Items \Progress pct. #1', Comment = '#1 = Progress percentage.';
        Text002Lbl: Label 'Update all Items GTIN from Item Reference?';
        Text003Lbl: Label 'Are you sure?\Update all Items GTIN from Item Reference?';
    begin
        Answer := Dialog.Confirm(Text002Lbl, true);
        if Answer then Answer := Dialog.Confirm(Text003Lbl, true);
        if not Answer then
            exit;
        WindowDialog.Open(Text001Lbl);
        Items.Reset();
        Items.FindFirst();
        ItemsCount := Items.Count;
        repeat
            LoopCount += 1;
            Pct := Round((100 / ItemsCount) * LoopCount, 1);
            WindowDialog.Update(1, Format(Pct));
            UpdateGTINItemCard(Items."No.");
        until Items.Next() = 0;
        WindowDialog.Close();
    end;

    /// <summary>
    /// Updates the GTIN on a single Item Card from its associated Item Reference.
    /// </summary>
    /// <param name="ItemsNo">The Item No. to update.</param>
    procedure UpdateGTINItemCard(ItemsNo: Code[20])
    var
        Items: Record Item;
        ItemReference: Record "Item Reference";
        User: Record User;
    begin
        Items.Get(ItemsNo);
        User.Get(UserSecurityId());
        if not CheckIsUserInCompany(User.CurrentCompany, '_MASTER') then
            exit;
        ItemReference.SetFilter("Item No.", ItemsNo);
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetFilter("Unit of Measure", Items."Base Unit of Measure");
        if ItemReference.FindFirst() then begin
            Items.GTIN := CopyStr(ItemReference."Reference No.", 1, 14);
            if Items.Modify(true) then;
        end;
    end;
    #endregion

    #region Check if user is in Company name
    /// <summary>
    /// Checks if the current user is operating within a specified company.
    /// </summary>
    /// <param name="CurrentCompany">The current company name.</param>
    /// <param name="CompanyName">The company name to check against.</param>
    /// <returns>True if the user is in the specified company; otherwise, an error is raised.</returns>
    procedure CheckIsUserInCompany(CurrentCompany: Text; CompanyName: Text): Boolean
    var
        Text001Lbl: Label 'Company #1#############################. You must be in the #2############################## company to perform this task!',
        Comment = '#1 = Current Company, #2 = Required Company';
    begin
        if CurrentCompany.ToUpper() <> CompanyName.ToUpper() then
            Error(Text001Lbl, CurrentCompany, CompanyName);
        exit(true);
    end;
    #endregion

    #region Barcode Generator
    /// <summary>
    /// Calculates a new unique EAN-13 code.
    /// </summary>
    /// <returns>A new unique EAN-13 code as Code[13].</returns>
    procedure CalcEANCode(): Code[13]
    var
        InventorySetup: Record "Inventory Setup";
        NewEANCodeFound: Boolean;
        LastEANCode: Code[10];
        Weight: Code[12];
        NewEANCode: Code[13];
        Text004Lbl: Label 'There are no available EAN-codes.';
    begin
        InventorySetup.LockTable();
        InventorySetup.Get();
        InventorySetup.TestField("EAN Country Code");
        InventorySetup.TestField("EAN Company No.");

        Weight := '131313131313';
        LastEANCode := InventorySetup."Last EAN Code Used";

        while not NewEANCodeFound do begin
            if LastEANCode = '' then
                LastEANCode := '00000';
            LastEANCode := IncStr(LastEANCode);
            if LastEANCode > '99999' then
                ERROR(Text004Lbl);

            NewEANCode := CopyStr(InventorySetup."EAN Country Code" + InventorySetup."EAN Company No." + LastEANCode, 1, 13);
            NewEANCode := NewEANCode + Format(StrCheckSum(NewEANCode, Weight));
            NewEANCodeFound := IsEANCodeUnique(NewEANCode);
        end;

        InventorySetup."Last EAN Code Used" := CopyStr(LastEANCode, 1, 5);
        InventorySetup.Modify();
        exit(NewEANCode);
    end;

    /// <summary>
    /// Calculates a new unique UCC-12 code.
    /// </summary>
    /// <returns>A new unique UCC-12 code as Code[12].</returns>
    procedure CalcUCCCode(): Code[12]
    var
        InventorySetup: Record "Inventory Setup";
        NewUCCCodeFound: Boolean;
        LastUCCCode: Code[10];
        Weight: Code[11];
        NewUCCCode: Code[12];
        Text010Lbl: Label 'There are no available UCC-codes.';
    begin
        InventorySetup.LockTable();
        InventorySetup.Get();
        InventorySetup.TestField("UPC Prefix");
        InventorySetup.TestField("UPC Company No.");
        Weight := '31313131313';
        LastUCCCode := InventorySetup."Last UPC Code Used";
        while not NewUCCCodeFound do begin
            if LastUCCCode = '' then
                LastUCCCode := '00000';
            LastUCCCode := IncStr(LastUCCCode);
            if LastUCCCode > '99999' then
                ERROR(Text010Lbl);
            NewUCCCode := CopyStr(InventorySetup."UPC Prefix" + InventorySetup."UPC Company No." + LastUCCCode, 1, 12);
            NewUCCCode := CopyStr(NewUCCCode + Format(StrCheckSum(NewUCCCode, Weight)), 1, 12);
            NewUCCCodeFound := IsUCCCodeUnique(NewUCCCode);
        end;
        InventorySetup."Last UPC Code Used" := CopyStr(LastUCCCode, 1, 5);
        InventorySetup.Modify();
        exit(NewUCCCode);
    end;

    /// <summary>
    /// Validates the structure of an EAN-13 code.
    /// </summary>
    /// <param name="EANCode">The EAN code to validate.</param>
    /// <returns>True if the EAN code is valid; otherwise, false.</returns>
    procedure CheckEANCode(EANCode: Code[20]): Boolean
    var
        Weight: Code[11];
        String: Code[12];
        Checksum: Integer;
        Text003Lbl: Label 'The EAN-Code must consist of 13 digits.';
    begin
        if StrLen(EANCode) <> 13 then
            ERROR(Text003Lbl);

        Weight := CopyStr('131313131313', 1, 11);
        String := CopyStr(CopyStr(EANCode, 1, StrLen(EANCode) - 1), 1, 11);

        Checksum := StrCheckSum(String, Weight);
        exit(String + Format(Checksum) = EANCode);
    end;

    /// <summary>
    /// Creates a barcode for an item based on the Inventory Setup configuration.
    /// </summary>
    /// <param name="Item">The Item record for which to create a barcode.</param>
    procedure CreateBarCode(Item: Record Item)
    var
        InventorySetup: Record "Inventory Setup";
        ItemReference: Record "Item Reference";
    begin
        InventorySetup.Get();
        ItemReference.Validate("Item No.", Item."No.");
        ItemReference.Validate("Reference Type", ItemReference."Reference Type"::"Bar Code");
        case InventorySetup."Use Bar Code Type" of
            InventorySetup."Use Bar Code Type"::"UCC-12":
                ItemReference.Validate("Reference No.", CalcUCCCode());
            InventorySetup."Use Bar Code Type"::"EAN-13":
                ItemReference.Validate("Reference No.", CalcEANCode());
        end;
    end;

    /// <summary>
    /// Creates a barcode for a specific unit of measure of an item.
    /// </summary>
    /// <param name="ItemNo">The Item No.</param>
    /// <param name="UOMCode">The Unit of Measure Code.</param>
    /// <param name="EAN">True to use EAN code; false to use UCC code.</param>
    procedure CreateUOMBarcode(ItemNo: Code[20]; UOMCode: Code[10]; EAN: Boolean)
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.Validate("Item No.", ItemNo);
        ItemReference.Validate("Unit of Measure", UOMCode);
        ItemReference.Validate("Reference Type", ItemReference."Reference Type"::"Bar Code");
        if EAN then
            ItemReference.Validate("Reference No.", CalcEANCode())
        else
            ItemReference.Validate("Reference No.", CalcUCCCode());
        ItemReference.Insert();
    end;

    /// <summary>
    /// Fills a temporary table with barcode information for a specific item.
    /// </summary>
    /// <param name="RecBarCodesTmpSC">The temporary barcode record to fill.</param>
    /// <param name="ItemNo">The Item No. to process.</param>
    procedure fillBarcodeTable(var RecBarCodesTmpSC: Record BarCodesTmpSC; ItemNo: Code[20])
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ItemReference: Record "Item Reference";
        User: Record User;
    begin
        User.Get(UserSecurityId());
        if not CheckIsUserInCompany(User.CurrentCompany, '_MASTER') then
            exit;

        RecBarCodesTmpSC.DeleteAll();
        ItemUnitOfMeasure.SetRange("Item No.", ItemNo);
        if ItemUnitOfMeasure.FindSet() then begin
            repeat
                RecBarCodesTmpSC.Init();
                RecBarCodesTmpSC."Item No" := ItemUnitOfMeasure."Item No.";
                RecBarCodesTmpSC."Unit of Measure Code" := ItemUnitOfMeasure.Code;
                RecBarCodesTmpSC."Num Barcodes" := 0;
                RecBarCodesTmpSC.Insert();
            until ItemUnitOfMeasure.Next() = 0;

            ItemReference.SetRange("Item No.", ItemNo);
            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
            if ItemReference.FindSet() then
                repeat
                    RecBarCodesTmpSC.Reset();
                    RecBarCodesTmpSC.SetRange("Item No", ItemNo);
                    RecBarCodesTmpSC.SetRange("Unit of Measure Code", ItemReference."Unit of Measure");
                    if RecBarCodesTmpSC.FindFirst() then begin
                        RecBarCodesTmpSC."Num Barcodes" += 1;
                        RecBarCodesTmpSC.Modify();
                    end;
                until ItemReference.Next() = 0;
            RecBarCodesTmpSC.Reset();
        end;
    end;

    /// <summary>
    /// Checks if an EAN code is unique across item references.
    /// </summary>
    /// <param name="EANCode">The EAN code to check.</param>
    /// <returns>True if the EAN code is unique; otherwise, false.</returns>
    procedure IsEANCodeUnique(EANCode: Code[20]): Boolean
    var
        ItemReference: Record "Item Reference";
        Text003Lbl: Label 'The EAN-Code must consist of 13 digits.';
    begin
        if StrLen(EANCode) <> 13 then
            ERROR(Text003Lbl);
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetRange("Reference No.", EANCode);
        exit(ItemReference.IsEmpty);
    end;

    /// <summary>
    /// Checks if a UCC code is unique and valid.
    /// </summary>
    /// <param name="UCCCode">The UCC code to check.</param>
    /// <returns>True if the UCC code is unique and valid; otherwise, false.</returns>
    procedure IsUCCCodeUnique(UCCCode: Code[20]): Boolean
    var
        Weight: Code[11];
        String: Code[12];
        Checksum: Integer;
        Text007Lbl: Label 'The UCC-Code must consist of 12 digits.';
    begin
        if StrLen(UCCCode) <> 12 then
            ERROR(Text007Lbl);
        Weight := '31313131313';
        String := CopyStr(CopyStr(UCCCode, 1, StrLen(UCCCode) - 1), 1, 12);
        Checksum := StrCheckSum(String, Weight);
        exit(String + Format(Checksum) = UCCCode);
    end;
    #endregion

    #region Updates Purchase and Planning Worksheet Action Messages 
    /// <summary>
    /// Toggles the 'Accept Action Message' flag on all Requisition Lines in a set.
    /// </summary>
    /// <param name="RecRequisitionLine">The Requisition Line records to update.</param>
    /// <param name="State">True to accept action messages; false to reject.</param>
    procedure ToggleActionMessage(var RecRequisitionLine: Record "Requisition Line"; State: Boolean)
    begin
        RecRequisitionLine.FindFirst();
        repeat
            RecRequisitionLine."Accept Action Message" := State;
            if RecRequisitionLine.Modify(true) then;
        until RecRequisitionLine.Next() = 0;
        RecRequisitionLine.FindFirst();
    end;
    #endregion

    #region 002 Warehouse Pick Bin Balance
    /// <summary>
    /// Fills a temporary table with pick balance data up to a specified date.
    /// </summary>
    /// <param name="RecWMSPickBinBalanceTMP">The temporary pick balance record to fill.</param>
    /// <param name="FilterDate">The date up to which to calculate balances.</param>
    procedure FillPickBalanceDataTable(var RecWMSPickBinBalanceTMP: Record WMSPickBinBalanceTMP; FilterDate: Date)
    var
        Bin: Record Bin;
        BinContent: Record "Bin Content";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        LineNo: Integer;
    begin
        RecWMSPickBinBalanceTMP.Reset();
        RecWMSPickBinBalanceTMP.DeleteAll();
        RecWMSPickBinBalanceTMP.Init();
        WarehouseShipmentLine.SetFilter("Shipment Date", '..%1', FilterDate);
        WarehouseShipmentLine.SetFilter("Qty. to Ship", '<>0');
        if WarehouseShipmentLine.FindSet() then
            repeat
                LineNo += 1;
                RecWMSPickBinBalanceTMP.SetFilter("Item No", WarehouseShipmentLine."Item No.");
                if RecWMSPickBinBalanceTMP.FindFirst() then begin
                    RecWMSPickBinBalanceTMP."Pick Quantity" += WarehouseShipmentLine."Qty. Outstanding";
                    if RecWMSPickBinBalanceTMP.Modify() then;
                end else begin
                    RecWMSPickBinBalanceTMP."Line No." := LineNo;
                    RecWMSPickBinBalanceTMP."Item No" := WarehouseShipmentLine."Item No.";
                    RecWMSPickBinBalanceTMP."Item Description" := WarehouseShipmentLine.Description;
                    RecWMSPickBinBalanceTMP."Pick Quantity" := WarehouseShipmentLine."Qty. Outstanding";
                    if RecWMSPickBinBalanceTMP.Insert() then;
                end;
            until WarehouseShipmentLine.Next() = 0;

        RecWMSPickBinBalanceTMP.Reset();
        if RecWMSPickBinBalanceTMP.FindSet() then
            repeat
                BinContent.SetRange(Default, true);
                BinContent.SetFilter("Item No.", RecWMSPickBinBalanceTMP."Item No");

                if BinContent.FindFirst() then begin
                    if Bin.Get('AUNING', BinContent."Bin Code") then;
                    BinContent.CalcFields(Quantity);
                    RecWMSPickBinBalanceTMP."Bin Quantity" := BinContent.Quantity;
                    RecWMSPickBinBalanceTMP."Bin Code" := CopyStr(Bin.Description, 1, 20);
                    if RecWMSPickBinBalanceTMP.Modify() then;
                end;
            until RecWMSPickBinBalanceTMP.Next() = 0;

        RecWMSPickBinBalanceTMP.Reset();
        if RecWMSPickBinBalanceTMP.FindSet() then
            repeat
                RecWMSPickBinBalanceTMP."Bin Quantity Balance" := RecWMSPickBinBalanceTMP."Bin Quantity" - RecWMSPickBinBalanceTMP."Pick Quantity";
                if RecWMSPickBinBalanceTMP.Modify() then;
            until RecWMSPickBinBalanceTMP.Next() = 0;
        RecWMSPickBinBalanceTMP.Reset();
        RecWMSPickBinBalanceTMP.FindFirst();
    end;
    #endregion

    #region 005 Sales Lines Page
    /// <summary>
    /// Fills a temporary table with Sales Line data based on various filters.
    /// </summary>
    /// <param name="RecSalesLineTMP">The temporary Sales Line record to fill.</param>
    /// <param name="ShowShippedNotInvd">True to include lines that are shipped but not invoiced.</param>
    /// <param name="SalespersonFilter">Filter for Salesperson Code.</param>
    /// <param name="CountryFilter">Filter for Country/Region Code.</param>
    /// <param name="CustomerFilter">Filter for Customer No.</param>
    /// <param name="OutstandingQuantityFilter">True to include lines with outstanding quantity.</param>
    /// <param name="ToggleHeadlines">True to include headlines for new documents.</param>
    /// <param name="ItemUnitsFilter">Filter for Item Unit of Measure Codes.</param>
    procedure FillSalesLineListPage(var RecSalesLineTMP: Record SalesLineTMP;
                                    ShowShippedNotInvd: Boolean;
                                    SalespersonFilter: Text[50];
                                    CountryFilter: Text[50];
                                    CustomerFilter: Text[50];
                                    OutstandingQuantityFilter: Boolean;
                                    ToggleHeadlines: Boolean;
                                    ItemUnitsFilter: Text[50])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ItemReference: Record "Item Reference";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        LineNo: Integer;
        NewDocNo: Code[20];
    begin
        NewDocNo := '';
        RecSalesLineTMP.Reset();
        RecSalesLineTMP.DeleteAll();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::Order);
        SalesLine.SetFilter("Document Type", '%1', SalesLine."Document Type"::Order);
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");

        if SalespersonFilter <> '' then
            SalesHeader.SetFilter("Salesperson Code", SalespersonFilter);
        if CountryFilter <> '' then
            SalesHeader.SetFilter("Sell-to Country/Region Code", CountryFilter);
        if CustomerFilter <> '' then
            SalesHeader.SetFilter("Sell-to Customer No.", '%1', CustomerFilter);

        if OutstandingQuantityFilter then
            SalesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
        if ShowShippedNotInvd then
            SalesLine.SetFilter("Qty. Shipped Not Invoiced", '<>%1', 0);

        if SalesLine.FindSet() then
            repeat
                SalesHeader.SetFilter("No.", SalesLine."Document No.");
                if SalesHeader.FindFirst() then begin
                    RecSalesLineTMP.Init();
                    ItemReference.SetFilter("Item No.", SalesLine."No.");
                    ItemReference.SetFilter("Unit of Measure", SalesLine."Unit of Measure Code");
                    ItemReference.SetFilter("Reference Type", '%1', ItemReference."Reference Type"::"Bar Code");

                    if ToggleHeadlines = true then
                        if NewDocNo <> SalesLine."Document No." then begin
                            NewDocNo := SalesLine."Document No.";
                            LineNo += 1;
                            RecSalesLineTMP."Line No." := LineNo;
                            RecSalesLineTMP."Sell-To Customer Name" := SalesHeader."Sell-to Customer Name";
                            if RecSalesLineTMP.Insert() then;
                        end;

                    LineNo += 1;
                    RecSalesLineTMP."Line No." := LineNo;
                    RecSalesLineTMP."Document Status" := SalesHeader.Status;
                    RecSalesLineTMP."Document No." := SalesLine."Document No.";
                    RecSalesLineTMP."Sell-To Customer No." := SalesHeader."Sell-to Customer No.";
                    RecSalesLineTMP."Sell-To Customer Name" := SalesLine."Sell-To Customer Name";
                    RecSalesLineTMP."Ship-To Name" := SalesHeader."Ship-to Name";
                    RecSalesLineTMP."Location Code" := SalesHeader."Location Code";
                    RecSalesLineTMP.Type := Format(SalesLine.Type);
                    RecSalesLineTMP."No." := SalesLine."No.";

                    if ItemReference.FindFirst() then
                        RecSalesLineTMP."Item Cross-Reference No." := ItemReference."Reference No.";

                    //015 Flowfield Tariff - SalesLine
                    if Item.Get(SalesLine."No.") then
                        RecSalesLineTMP."Tariff No." := Item."Tariff No.";

                    RecSalesLineTMP.Description := SalesLine.Description;
                    RecSalesLineTMP."Unit Price" := SalesLine."Unit Price";
                    RecSalesLineTMP."Quantity" := SalesLine.Quantity;
                    RecSalesLineTMP."Outstanding Quantity" := SalesLine."Outstanding Quantity";
                    RecSalesLineTMP."Qty. Shipped Not Invoiced" := SalesLine."Qty. Shipped Not Invoiced";
                    RecSalesLineTMP."Line Amount" := SalesLine."Line Amount";
                    RecSalesLineTMP."Outstanding Amount" := SalesLine."Outstanding Amount";
                    RecSalesLineTMP."Currency Code" := SalesLine."Currency Code";
                    RecSalesLineTMP."Planned Shipment Date" := SalesLine."Planned Shipment Date";

                    RecSalesLineTMP."Sell-To Customer Name" := SalesHeader."Sell-to Customer Name";
                    RecSalesLineTMP."External Document No." := SalesHeader."External Document No.";
                    RecSalesLineTMP."Salesperson Code" := SalesHeader."Salesperson Code";
                    RecSalesLineTMP."Country Code" := SalesHeader."Sell-to Country/Region Code";

                    // Add ItemUnitFilter (e.g., Pallets)
                    if ItemUnitsFilter <> '' then begin
                        RecSalesLineTMP.ItemUnitCode := 'N/A';

                        if SalesLine.Type = SalesLine.Type::Item then begin
                            ItemUnitOfMeasure.Reset();
                            ItemUnitOfMeasure.SetFilter("Item No.", SalesLine."No.");
                            ItemUnitOfMeasure.SetFilter(Code, ItemUnitsFilter);
                            if ItemUnitOfMeasure.FindFirst() then begin
                                RecSalesLineTMP.ItemUnitCode := ItemUnitOfMeasure.Code;
                                RecSalesLineTMP.ItemUnitQuantity := ItemUnitOfMeasure."Qty. per Unit of Measure";
                            end;
                        end;
                    end;

                    if RecSalesLineTMP.Insert() then;
                end;
            until SalesLine.Next() = 0;
        if RecSalesLineTMP.FindFirst() then;
    end;
    #endregion

    #region 017 Inventory Journal StockStatus Add Code
    /// <summary>
    /// Fills the Inventory Journal Status table based on Item Journal Lines.
    /// </summary>
    /// <param name="RecInventoryJournalStatus">The Inventory Journal Status record to fill.</param>
    /// <param name="JournalBatchName">The name of the journal batch.</param>
    procedure InventoryJournalFillITable(var RecInventoryJournalStatus: Record InventoryJournalStatus; JournalBatchName: Text[50])
    var
        InventoryMapShelfSC: Record InventoryMapShelfSC;
        Item: Record Item;
        ItemJournalLine: Record "Item Journal Line";
        LineNo: Integer;
        Text000Lbl: Label 'Not found';
        ShelfNo: Text[30];
    begin
        if not RecInventoryJournalStatus.IsEmpty() then
            RecInventoryJournalStatus.DeleteAll();
        ItemJournalLine.SetFilter("Journal Batch Name", JournalBatchName);
        ItemJournalLine.FindSet();
        repeat

            if Item.Get(ItemJournalLine."Item No.") then begin
                ShelfNo := '';
                ShelfNo := Item."Shelf No.";
                ShelfNo := ShelfNo.Replace('''', ''); // removes illigal single hyphen


                InventoryMapShelfSC.SetFilter("Shelf No.", ShelfNo);
                if (InventoryMapShelfSC.FindSet()) and (ShelfNo <> '') then
                    repeat
                        RecInventoryJournalStatus.Init();
                        LineNo += 1;
                        RecInventoryJournalStatus."Line No." := LineNo;
                        RecInventoryJournalStatus."Ressource ID" := InventoryMapShelfSC."Ressource Name";
                        RecInventoryJournalStatus."Item No." := ItemJournalLine."Item No.";
                        RecInventoryJournalStatus."Item Description" := ItemJournalLine.Description;
                        RecInventoryJournalStatus."Shelf No." := ShelfNo;
                        RecInventoryJournalStatus."Inventory Journal ID" := CopyStr(JournalBatchName, 1, 30);
                        RecInventoryJournalStatus."Reported Quatity" := 0;
                        RecInventoryJournalStatus."Base Quantity" := ItemJournalLine."Qty. (Calculated)";
                        RecInventoryJournalStatus."Difference Quatity" := -ItemJournalLine."Qty. (Calculated)";
                        if RecInventoryJournalStatus.Insert() then;
                    until InventoryMapShelfSC.Next() = 0
                else begin
                    // Shelf No. or Resource ID was not found.
                    RecInventoryJournalStatus.Init();
                    LineNo += 1;
                    RecInventoryJournalStatus."Line No." := LineNo;
                    RecInventoryJournalStatus."Ressource ID" := Text000Lbl;
                    RecInventoryJournalStatus."Item No." := ItemJournalLine."Item No.";
                    RecInventoryJournalStatus."Item Description" := ItemJournalLine.Description;
                    RecInventoryJournalStatus."Shelf No." := '';
                    RecInventoryJournalStatus."Inventory Journal ID" := CopyStr(JournalBatchName, 1, 30);
                    RecInventoryJournalStatus."Reported Quatity" := 0;
                    RecInventoryJournalStatus."Base Quantity" := ItemJournalLine."Qty. (Calculated)";
                    RecInventoryJournalStatus."Difference Quatity" := -ItemJournalLine."Qty. (Calculated)";
                    if RecInventoryJournalStatus.Insert() then;
                end;
            end;
        until ItemJournalLine.Next() = 0;
        if RecInventoryJournalStatus.FindFirst() then;
    end;

    /// <summary>
    /// Writes back reported quantities from the Inventory Journal Status to the Item Journal Lines.
    /// </summary>
    /// <param name="InventoryJournalStatus">The Inventory Journal Status records containing reported quantities.</param>
    /// <param name="JournalName">The name of the journal batch to update.</param>
    procedure InventoryJournalWriteBack(InventoryJournalStatus: Record InventoryJournalStatus;
        JournalName: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        StatusQty: Decimal;
        TransferedLines: Integer;
        Text000Lbl: Label 'Writeback to Item Journal is complete.\#1 lines transferred', Comment = '#1 = Number of lines transferred.';
    begin
        ItemJournalLine.Reset();
        ItemJournalLine.SetFilter("Journal Template Name", 'LAGEROPGØR');
        ItemJournalLine.SetFilter("Bin Code", 'PRODUKTION');
        ItemJournalLine.SetFilter("Journal Batch Name", JournalName);
        ItemJournalLine.FindSet();
        InventoryJournalStatus.Reset();
        repeat
            InventoryJournalStatus.SetFilter("Item No.", ItemJournalLine."Item No.");
            InventoryJournalStatus.SetFilter("Reported Quatity", '<>%1', 0);
            if InventoryJournalStatus.FindSet() then begin
                StatusQty := 0;
                repeat
                    StatusQty += InventoryJournalStatus."Reported Quatity";
                    TransferedLines += 1;
                until InventoryJournalStatus.Next() = 0;
                ItemJournalLine.Validate("Qty. (Phys. Inventory)", StatusQty);
                ItemJournalLine.Modify();
            end;
        until ItemJournalLine.Next() = 0;
        Message(Text000Lbl, Format(TransferedLines));
    end;
    #endregion

    #region 032 Warning Imerco DropShip
    /// <summary>
    /// Provides warnings for Imerco DropShip orders to ensure correct customer and order types.
    /// </summary>
    /// <param name="RecSalesHeader">The Sales Header record to check.</param>
    procedure WarningCheckImercoDropShip(var RecSalesHeader: Record "Sales Header")
    var
        Text001Lbl: Label 'This order should be changed to Customer 1916 Websupply ordertype';
        Text002Lbl: Label 'Note this is an Imerco Drop-IN ordertype.\Change customer to 2112.';
    begin
        if (RecSalesHeader."Sell-to Customer No." = '2112') and not (CopyStr(RecSalesHeader."External Document No.", 1, 1) = 'D') then
            Message(Text001Lbl);
        if (RecSalesHeader."Sell-to Customer No." = '1916') and (CopyStr(RecSalesHeader."External Document No.", 1, 1) = 'D') then
            Message(Text002Lbl);
    end;
    #endregion

    #region 034 Campaign Sales Statistics
    /// <summary>
    /// Retrieves Sales Orders related to campaigns and fills the Campaign Statistics table.
    /// </summary>
    /// <param name="RecCampaignStatistics">The Campaign Statistics record to fill.</param>
    /// <param name="DateRangeTxt">The date range filter as text.</param>
    /// <param name="LineNo">The line number counter (passed by reference).</param>
    procedure CampaignSalesGetSalesOrders(var RecCampaignStatistics: Record CampaignStatistics; DateRangeTxt: Text; var LineNo: Integer)
    var
        Campaign: Record Campaign;
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CampaignFound: Boolean;
        CampaignCodeNotFoundLbl: Label 'Campaign Code not found';
        CurrencyDescription: Text[100];
        ChainDimName: Text[100];
        ChainGroupDimName: Text[100];
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetFilter("Planned Delivery Date", DateRangeTxt);
        SalesLine.SetFilter("Used Campaign NOTO", '<>%1', '');
        RecCampaignStatistics.Init();
        if SalesLine.FindSet() then
            repeat
                CampaignFound := false;
                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                CurrencyDescription := 'Danske kroner';
                if Currency.Get(SalesHeader."Currency Code") then
                    CurrencyDescription := Currency.Description;
                if Campaign.Get(SalesLine."Used Campaign NOTO") then
                    CampaignFound := true;

                LineNo += 1;
                RecCampaignStatistics."Line No." := LineNo;
                RecCampaignStatistics."Date" := SalesLine."Planned Delivery Date";

                CampaignSalesGetChain(SalesLine."Bill-to Customer No.", ChainDimName, ChainGroupDimName);
                RecCampaignStatistics.Chain := ChainDimName;
                RecCampaignStatistics."Chain Group" := ChainGroupDimName;

                RecCampaignStatistics."Customer No." := SalesLine."Sell-to Customer No.";
                RecCampaignStatistics."Customer Name" := SalesHeader."Sell-to Customer Name";
                RecCampaignStatistics."SalesPerson Code" := SalesHeader."Salesperson Code";
                RecCampaignStatistics."Country Code" := SalesHeader."Sell-to Country/Region Code";

                RecCampaignStatistics."Campaign Code" := SalesLine."Used Campaign NOTO";
                RecCampaignStatistics."Campaign Name" := CampaignCodeNotFoundLbl;
                if CampaignFound then begin
                    RecCampaignStatistics."Campaign Name" := Campaign.Description;
                    RecCampaignStatistics."Campaign Type" := Campaign."Campaign Type NOTO";
                    RecCampaignStatistics."Campaign Purpose" := Campaign."Campaign Purpose NOTO";
                end;

                RecCampaignStatistics."Document Type" := RecCampaignStatistics."Document Type"::"Sales Order";
                RecCampaignStatistics."Document No." := SalesLine."Document No.";
                RecCampaignStatistics."Currency Code" := SalesHeader."Currency Code";
                if RecCampaignStatistics."Currency Code" = '' then
                    RecCampaignStatistics."Currency Code" := 'DKR';
                RecCampaignStatistics."Currency Description" := CurrencyDescription;

                RecCampaignStatistics."Item No." := SalesLine."No.";
                RecCampaignStatistics."Item Description" := SalesLine.Description;

                RecCampaignStatistics.Quantity := SalesLine."Quantity (Base)";
                RecCampaignStatistics.Amount := SalesLine.Amount;
                if SalesHeader."Currency Factor" = 0 then
                    SalesHeader."Currency Factor" := 1;
                RecCampaignStatistics."Amount(RV)" := SalesLine.Amount / (SalesHeader."Currency Factor" + 0.0001);

                if RecCampaignStatistics.Insert() then;
            until SalesLine.Next() = 0;
    end;

    /// <summary>
    /// Retrieves Posted Sales Invoices related to campaigns and fills the Campaign Statistics table.
    /// </summary>
    /// <param name="RecCampaignStatistics">The Campaign Statistics record to fill.</param>
    /// <param name="DateRangeTxt">The date range filter as text.</param>
    /// <param name="LineNo">The line number counter (passed by reference).</param>
    procedure CampaignSalesGetPostedSalesInvoice(var RecCampaignStatistics: Record CampaignStatistics; DateRangeTxt: Text; var LineNo: Integer)
    var
        Campaign: Record Campaign;
        Currency: Record Currency;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CampaignFound: Boolean;
        CampaignCodeNotFoundLbl: Label 'Campaign Code not found';
        CurrencyDescription: Text[100];
        ChainDimName: Text[100];
        ChainGroupDimName: Text[100];
    begin
        SalesInvoiceLine.SetFilter("Posting Date", DateRangeTxt);
        SalesInvoiceLine.SetFilter("Used Campaign NOTO", '<>%1', '');
        RecCampaignStatistics.Init();
        if SalesInvoiceLine.FindSet() then
            repeat
                CampaignFound := false;
                SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.");
                CurrencyDescription := 'Danske kroner';
                if Currency.Get(SalesInvoiceHeader."Currency Code") then
                    CurrencyDescription := Currency.Description;
                if Campaign.Get(SalesInvoiceLine."Used Campaign NOTO") then
                    CampaignFound := true;
                LineNo += 1;
                RecCampaignStatistics."Line No." := LineNo;
                RecCampaignStatistics."Date" := SalesInvoiceLine."Posting Date";

                CampaignSalesGetChain(SalesInvoiceLine."Sell-to Customer No.", ChainDimName, ChainGroupDimName);
                RecCampaignStatistics.Chain := ChainDimName;
                RecCampaignStatistics."Chain Group" := ChainGroupDimName;

                RecCampaignStatistics."Customer No." := SalesInvoiceLine."Sell-to Customer No.";
                RecCampaignStatistics."Customer Name" := SalesInvoiceHeader."Sell-to Customer Name";
                RecCampaignStatistics."SalesPerson Code" := SalesInvoiceHeader."Salesperson Code";
                RecCampaignStatistics."Country Code" := SalesInvoiceHeader."Sell-to Country/Region Code";

                RecCampaignStatistics."Campaign Code" := SalesInvoiceLine."Used Campaign NOTO";
                RecCampaignStatistics."Campaign Name" := CampaignCodeNotFoundLbl;
                if CampaignFound then begin
                    RecCampaignStatistics."Campaign Name" := Campaign.Description;
                    RecCampaignStatistics."Campaign Type" := Campaign."Campaign Type NOTO";
                    RecCampaignStatistics."Campaign Purpose" := Campaign."Campaign Purpose NOTO";
                end;

                RecCampaignStatistics."Document Type" := RecCampaignStatistics."Document Type"::Invoice;
                RecCampaignStatistics."Document No." := SalesInvoiceLine."Document No.";
                RecCampaignStatistics."Currency Code" := SalesInvoiceHeader."Currency Code";
                if RecCampaignStatistics."Currency Code" = '' then
                    RecCampaignStatistics."Currency Code" := 'DKR';
                RecCampaignStatistics."Currency Description" := CurrencyDescription;

                RecCampaignStatistics."Item No." := SalesInvoiceLine."No.";
                RecCampaignStatistics."Item Description" := SalesInvoiceLine.Description;

                RecCampaignStatistics.Quantity := SalesInvoiceLine."Quantity (Base)";
                RecCampaignStatistics.Amount := SalesInvoiceLine.Amount;
                if SalesInvoiceHeader."Currency Factor" = 0 then
                    SalesInvoiceHeader."Currency Factor" := 1;
                RecCampaignStatistics."Amount(RV)" := SalesInvoiceLine.Amount / SalesInvoiceHeader."Currency Factor";

                if RecCampaignStatistics.Insert() then;
            until SalesInvoiceLine.Next() = 0;
    end;

    /// <summary>
    /// Retrieves Sales Forecasts related to campaigns and fills the Campaign Statistics table.
    /// </summary>
    /// <param name="RecCampaignStatistics">The Campaign Statistics record to fill.</param>
    /// <param name="DateRangeTxt">The date range filter as text.</param>
    /// <param name="LineNo">The line number counter (passed by reference).</param>
    procedure CampaignSalesGetSalesForecasts(var RecCampaignStatistics: Record CampaignStatistics; DateRangeTxt: Text; LineNo: Integer)
    var
        Campaign: Record Campaign;
        Item: Record Item;
        ProductionForecastEntry: Record "Production Forecast Entry";
        CampaignFound: Boolean;
        CampaignCodeNotFoundLbl: Label 'Campaign Code not found';
    begin
        ProductionForecastEntry.SetFilter("Forecast Date", DateRangeTxt);
        ProductionForecastEntry.SetFilter("Campaign No. NOTO", '<>%1', '');
        RecCampaignStatistics.Init();
        if ProductionForecastEntry.FindSet() then
            repeat
                CampaignFound := false;
                Item.Get(ProductionForecastEntry."Item No.");
                if Campaign.Get(ProductionForecastEntry."Campaign No. NOTO") then
                    CampaignFound := true;
                LineNo += 1;
                RecCampaignStatistics."Line No." := LineNo;
                RecCampaignStatistics."Date" := ProductionForecastEntry."Forecast Date";
                RecCampaignStatistics."Customer No." := 'Forecast';
                RecCampaignStatistics."Customer Name" := ProductionForecastEntry."Production Forecast Name";

                RecCampaignStatistics."Campaign Code" := ProductionForecastEntry."Campaign No. NOTO";
                RecCampaignStatistics."Campaign Name" := CampaignCodeNotFoundLbl;
                if CampaignFound then begin
                    RecCampaignStatistics."Campaign Name" := Campaign.Description;
                    RecCampaignStatistics."Campaign Type" := Campaign."Campaign Type NOTO";
                    RecCampaignStatistics."Campaign Purpose" := Campaign."Campaign Purpose NOTO";
                end;
                RecCampaignStatistics."Document Type" := RecCampaignStatistics."Document Type"::Forecast;
                RecCampaignStatistics."Document No." := Format(ProductionForecastEntry."Entry No.");
                RecCampaignStatistics."Currency Code" := '';
                RecCampaignStatistics."Currency Description" := '';

                RecCampaignStatistics."Item No." := ProductionForecastEntry."Item No.";
                RecCampaignStatistics."Item Description" := Item.Description;

                RecCampaignStatistics.Quantity := ProductionForecastEntry."Forecast Quantity (Base)";
                RecCampaignStatistics.Amount := 0;
                RecCampaignStatistics."Amount(RV)" := 0;

                if RecCampaignStatistics.Insert() then;
            until ProductionForecastEntry.Next() = 0;
    end;

    /// <summary>
    /// Retrieves the Chain and Chain Group dimension names for a given customer.
    /// </summary>
    /// <param name="CustomerNo">The Customer No. to process.</param>
    /// <param name="ChainDimName">The Chain dimension name (output parameter).</param>
    /// <param name="ChainGroupDimName">The Chain Group dimension name (output parameter).</param>
    local procedure CampaignSalesGetChain(CustomerNo: Code[20]; var ChainDimName: Text[100]; var ChainGroupDimName: Text[100])
    var
        Customer: Record Customer;
        DimensionValue: Record "Dimension Value";
    begin
        ChainDimName := '';
        ChainGroupDimName := '';

        if Customer.Get(CustomerNo) then begin
            Customer.CalcFields(Chain);
            if DimensionValue.Get('KÆDE', Customer.Chain) then
                ChainDimName := DimensionValue.Name;
            if DimensionValue.Get('KÆDE', Customer.ChainGroup) then
                ChainGroupDimName := DimensionValue.Name;
        end
    end;
    #endregion

    #region 042 Sales price based on Purchase Price Markup
    /// <summary>
    /// Calculates the landed purchase price of an item based on vendor prices and indirect cost percentage.
    /// </summary>
    /// <param name="Item">The Item record to calculate for.</param>
    /// <returns>The calculated vendor price as Decimal.</returns>
    procedure ItemCalculatePurchaseLandedPrice(var Item: Record Item): Decimal
    var
        InventorySetup: Record "Inventory Setup";
        PriceListLine: Record "Price List Line";
        CalculatedVendorPrice: Decimal;
    begin
        InventorySetup.Get();
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Vendor);
        PriceListLine.SetFilter("Source No.", Item."Vendor No.");
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetFilter("Asset No.", Item."No.");
        PriceListLine.SetFilter("Ending Date", '');
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);
        CalculatedVendorPrice := 0;
        if PriceListLine.FindSet() then
            repeat
                if PriceListLine."Direct Unit Cost" > CalculatedVendorPrice then
                    CalculatedVendorPrice := PriceListLine."Direct Unit Cost";
            until PriceListLine.Next() = 0;

        if (CalculatedVendorPrice <> 0) and (Item."Indirect Cost %" <> 0) then
            CalculatedVendorPrice := CalculatedVendorPrice * (Item."Indirect Cost %" / 100 + 1);

        exit(CalculatedVendorPrice);
    end;
    #endregion

    #region 040 Warning sales line quantity Availability
    /// <summary>
    /// Provides a warning if the sales line quantity exceeds available inventory.
    /// </summary>
    /// <param name="SalesLine">The Sales Line record to check.</param>
    procedure AvailableQuantityWarning(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        SalesLine2: Record "Sales Line";
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";
        CalculatedAvailableDate: Date;
        AvailableFuture: Decimal;
        AvailableNow: Decimal;
        CalculatedAvailable: Decimal;
        WarningLbl: Label 'Warning - out of stock\ Item %1\ Quantity %2\\Available Now %3\Available Future %4\Calculated Available %5, on date %6',
                Comment = '%1 = Item No., %2 = Quantity, %3 = Available Now, %4 = Available Future, %5 = Calculated Available, %6 = Calculated Available on date.';
    begin
        if CompanyName = 'SCANPAN Norge' then
            exit;

        if (CompanyName = 'SCANPAN Danmark') and (SalesLine."Sell-to Customer No." = '1010') then
            exit;

        if not SalesLine2.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then
            exit;

        // 040 2024.12 validate on
        if SalesLine."Drop Shipment" then
            exit;

        if GuiAllowed then begin
            if SalesLine2."Planned Shipment Date" <> 0D then
                SalesLine2."Planned Shipment Date" := CalcDate('<+5Y>', SalesLine2."Shipment Date");
            if SalesLine2."Shipment Date" <> 0D then
                SalesLine2."Shipment Date" := CalcDate('<+5Y>', SalesLine2."Shipment Date");
            if SalesLine2."Planned Delivery Date" <> 0D then
                SalesLine2."Planned Delivery Date" := CalcDate('<+5Y>', SalesLine2."Planned Delivery Date");

            AvailableNow := SalesInfoPaneManagement.CalcAvailability(SalesLine);
            AvailableFuture := SalesInfoPaneManagement.CalcAvailability(SalesLine2);

            CalculatedAvailable := 0;
            CalculatedAvailableDate := 0D;
            if (Item.Get(SalesLine."No.")) and (SalesLine.Type = SalesLine.Type::Item) then begin
                CalculatedAvailable := Item."Calculated Available NOTO";
                CalculatedAvailableDate := Item."Calculated Available Date NOTO";
            end;

            if (AvailableNow < 0)
                or (AvailableFuture < 0)
                or (CalculatedAvailable < 0) then
                Message(WarningLbl,
                        SalesLine."No." + ' - ' + SalesLine.Description,
                        SalesLine.Quantity,
                        AvailableNow,
                        AvailableFuture,
                        CalculatedAvailable,
                        CalculatedAvailableDate);
        end;
    end;
    #endregion

    #region 056 Production Controlling
    /// <summary>
    /// Fills a temporary table with production routing lines for controlling purposes.
    /// </summary>
    /// <param name="ProdContllingRoutingLinesTMP">The temporary production controlling routing lines record to fill.</param>
    procedure ControllingFillProductionRouteLine(var ProdContllingRoutingLinesTMP: Record ProdContllingRoutingLinesTMP)
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        EnumGetCoatingDescription: enum EnumGetCoatingDescription;
        LineNo: Integer;
    begin
        ProdOrderRoutingLine.SetFilter(Status, '%1|%2', ProdOrderRoutingLine.Status::"Firm Planned", ProdOrderRoutingLine.Status::Released);
        ProdOrderRoutingLine.SetCurrentKey(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");

        ProdOrderRoutingLine.FindSet();
        repeat
            ProdOrderLine.Get(ProdOrderRoutingLine.Status,
                                    ProdOrderRoutingLine."Prod. Order No.",
                                    ProdOrderRoutingLine."Routing Reference No.");
            ProdContllingRoutingLinesTMP.Init();
            LineNo += 1;
            ProdContllingRoutingLinesTMP."Line No." := LineNo;
            ProdContllingRoutingLinesTMP.RoutingType := Format(ProdOrderRoutingLine."Type");
            ProdContllingRoutingLinesTMP.Status := ProdOrderRoutingLine.Status;
            ProdContllingRoutingLinesTMP."Production Order No." := ProdOrderRoutingLine."Prod. Order No.";
            ProdContllingRoutingLinesTMP."Ressource No." := ProdOrderRoutingLine."No.";
            ProdContllingRoutingLinesTMP."Routing Description" := ProdOrderRoutingLine.Description;
            ProdContllingRoutingLinesTMP."Operation No." := ProdOrderRoutingLine."Operation No.";
            ProdContllingRoutingLinesTMP.Priority := ProdOrderRoutingLine.Priority;
            ProdContllingRoutingLinesTMP.Comment := ProdOrderRoutingLine.Comment;

            ProdContllingRoutingLinesTMP.ItemNo := ProdOrderLine."Item No.";
            ProdContllingRoutingLinesTMP."Item Description" := ProdOrderLine.Description;

            ProdContllingRoutingLinesTMP.Coating := GetCoatingDescription(ProdOrderLine, EnumGetCoatingDescription::"Coating Description Map");
            ProdContllingRoutingLinesTMP."Coating Item" := GetCoatingDescription(ProdOrderLine, EnumGetCoatingDescription::"Item No. Map");

            ProdContllingRoutingLinesTMP."First BOM Body" := GetIFirstProductionBody(ProdOrderLine."Item No.");

            ProdContllingRoutingLinesTMP."Work Center Group Code" := ProdOrderRoutingLine."Work Center Group Code";

            ProdContllingRoutingLinesTMP.Quantity := ProdOrderLine."Quantity (Base)";
            ProdContllingRoutingLinesTMP."Finished Quantity" := ControllingProdControllingOperationOutputQty(ProdContllingRoutingLinesTMP."Production Order No.", ProdContllingRoutingLinesTMP."Ressource No.");
            ProdContllingRoutingLinesTMP."Remaining Quantity" := ProdContllingRoutingLinesTMP.Quantity - ProdContllingRoutingLinesTMP."Finished Quantity";
            ProdContllingRoutingLinesTMP."Finished Percentage" := (ProdContllingRoutingLinesTMP."Finished Quantity" / ProdContllingRoutingLinesTMP.Quantity) * 100;

            ProdContllingRoutingLinesTMP."Item Set Multiplier" := ProdOrderLine."Set Quantity";

            ProdContllingRoutingLinesTMP."Quantity Set" := ProdContllingRoutingLinesTMP.Quantity * ProdOrderLine."Set Quantity";
            ProdContllingRoutingLinesTMP."Remaining Set Quantity" := ProdContllingRoutingLinesTMP."Remaining Quantity" * ProdContllingRoutingLinesTMP."Item Set Multiplier";
            ProdContllingRoutingLinesTMP."Finished Set Quantity" := ProdContllingRoutingLinesTMP."Finished Quantity" * ProdContllingRoutingLinesTMP."Item Set Multiplier";

            ProdContllingRoutingLinesTMP."Starting Date" := ProdOrderLine."Starting Date";
            ProdContllingRoutingLinesTMP."Ending Date" := ProdOrderLine."Ending Date";

            if ProdContllingRoutingLinesTMP.Insert() then;
        until ProdOrderRoutingLine.Next() = 0;
    end;

    /// <summary>
    /// Calculates the total output quantity for a specific operation in a production order.
    /// </summary>
    /// <param name="ProductionOrderNo">The Production Order No.</param>
    /// <param name="OperationNo">The Operation No.</param>
    /// <returns>The total output quantity as Decimal.</returns>
    procedure ControllingProdControllingOperationOutputQty(ProductionOrderNo: Code[20]; OperationNo: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        OutputQuantity: Decimal;
    begin
        CapacityLedgerEntry.SetFilter("Order Type", '%1', CapacityLedgerEntry."Order Type"::Production);
        CapacityLedgerEntry.SetFilter("Order No.", ProductionOrderNo);
        CapacityLedgerEntry.SetFilter("No.", OperationNo);
        if CapacityLedgerEntry.FindSet() then
            repeat
                OutputQuantity += CapacityLedgerEntry."Output Quantity";
            until CapacityLedgerEntry.Next() = 0;
        exit(OutputQuantity);
    end;

    /// <summary>
    /// Retrieves the coating description or item number for a production order line.
    /// </summary>
    /// <param name="ProdOrderLine">The Production Order Line record.</param>
    /// <param name="EnumGetCoatingDescription">An enum indicating which value to retrieve.</param>
    /// <returns>The coating description or item number as Text[50].</returns>
    procedure GetCoatingDescription(ProdOrderLine: Record "Prod. Order Line"; EnumGetCoatingDescription: enum EnumGetCoatingDescription): Text[50]
    var
        ProdOrderComponent: Record "Prod. Order Component";
        ProdControllingItemMap: Record ProdControllingItemMap;
    begin
        ProdOrderComponent.Reset();
        ProdOrderComponent.SetFilter(Status, '%1', ProdOrderLine.Status);
        ProdOrderComponent.SetFilter("Prod. Order No.", '%1', ProdOrderLine."Prod. Order No.");
        ProdOrderComponent.SetFilter("Prod. Order Line No.", '%1', ProdOrderLine."Line No.");

        ProdControllingItemMap.Reset();
        ProdControllingItemMap.FindSet();
        repeat
            ProdOrderComponent.SetFilter("Item No.", ProdControllingItemMap."Item No.");
            if not ProdOrderComponent.IsEmpty then
                case EnumGetCoatingDescription of
                    EnumGetCoatingDescription::"Coating Description Map":
                        exit(ProdControllingItemMap.Coating);
                    EnumGetCoatingDescription::"Item No. Map":
                        exit(ProdControllingItemMap."Item No.");
                end;
        until ProdControllingItemMap.Next() = 0;
    end;
    #endregion

    #region 060 Find Item Set Multiplier for Sales to Production calculations
    /// <summary>
    /// Calculates the Item Set Multiplier for an item, used in sales to production calculations.
    /// </summary>
    /// <param name="ItemNo">The Item No. to process.</param>
    /// <returns>The Item Set Multiplier as Integer.</returns>
    procedure GetItemSetMultiplier(ItemNo: Code[20]): Integer
    var
        Item: Record Item;
        ProductionBOMLine: Record "Production BOM Line";
        Multiplier: Integer;
    begin
        Multiplier := 0;
        if Item.Get(ItemNo) then begin
            ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
            ProductionBOMLine.SetFilter("Production BOM No.", Item."Production BOM No.");
            if ProductionBOMLine.FindSet() then
                repeat
                    Item.Reset();
                    Item.SetRange("Replenishment System", Item."Replenishment System"::"Prod. Order");
                    Item.SetFilter("Gen. Prod. Posting Group", 'MELLEM');
                    Item.SetFilter("No.", ProductionBOMLine."No.");
                    Multiplier += Item.Count;
                until ProductionBOMLine.Next() = 0;
        end;
        if Multiplier = 0 then
            Multiplier := 1;
        exit(Multiplier);
    end;

    /// <summary>
    /// Retrieves the first production body item in the BOM of a specified item.
    /// </summary>
    /// <param name="ItemNo">The Item No. to process.</param>
    /// <returns>The Item No. of the first production body item as Code[20].</returns>
    procedure GetIFirstProductionBody(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
        ProductionBOMLine: Record "Production BOM Line";
    begin
        if Item.Get(ItemNo) then begin
            ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
            ProductionBOMLine.SetFilter("Production BOM No.", Item."Production BOM No.");
            if ProductionBOMLine.FindSet() then
                repeat
                    Item.Reset();
                    Item.SetFilter("Gen. Prod. Posting Group", '%1|%2|%3', 'RV-KROPPE', 'MELLEM', 'MELLEM RÅ');
                    Item.SetFilter("No.", ProductionBOMLine."No.");
                    if Item.FindFirst() then
                        exit(Item."No.");
                until ProductionBOMLine.Next() = 0;
        end;
        exit('');
    end;
    #endregion

    #region Send an Email from AL
    /// <summary>
    /// Sends an email using AL code.
    /// </summary>
    /// <param name="EmailAddressText">The recipient's email address.</param>
    /// <param name="SubjectText">The subject of the email.</param>
    /// <param name="BodyText">The body content of the email.</param>
    procedure SendEmail(EmailAddressText: Text; SubjectText: Text; BodyText: Text)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        EmailMessage.Create(EmailAddressText,
                          SubjectText,
                          BodyText);

        Email.Send(EmailMessage);
    end;
    #endregion

    #region 080 Self-insured limit check with warning on sales order.
    /// <summary>
    /// Checks the customer's credit limit, including self-insured and insured limits, and displays warnings based on the SCANPAN Setup configuration.
    /// </summary>
    /// <param name="CustomerRec">Customer record to check credit limits for.</param>
    /// <param name="SalesHeader">Sales Header record associated with the customer.</param>
    procedure CheckCustomerCreditLimit(CustomerRec: Record Customer; SalesHeader: Record "Sales Header")
    var
        ScanpanSetup: Record "SCANPAN Setup"; // Added reference to SCANPAN Setup to access new warning settings
        Balance: Decimal;                  // Customer's current balance in LCY
        SelfInsuredLimit: Decimal;         // Customer's self-insured credit limit in LCY
        InsuredCreditLimit: Decimal;       // Customer's standard credit limit in LCY - Atradius Credit Insurance
        TotalSalesOrdersAmount: Decimal;   // Total sum of all sales orders for the customer
        WarningSelfInsuredLbl: Label 'Warning the Customer is over Self-Insured Credit Limit (LCY) \%1 \Self-Insurance (LCY): %2\Balance (LCY): %3\Total Sales Orders (LCY): %4', Comment = '%1 = CustomerName, %2 = Self-Insurance in LCY, %3 = Balance in LCY, %4 = Total Sales Orders Amount in LCY';
        WarningCreditLimitLbl: Label 'Warning the Customer is over Insured Credit Limit (LCY) \%1 \Insured Credit Limit (LCY): %2\Balance (LCY): %3\Total Sales Orders (LCY): %4', Comment = '%1 = CustomerName, %2 = Credit Limit in LCY, %3 = Balance in LCY, %4 = Total Sales Orders Amount in LCY';
    begin
        // Retrieve SCANPAN Setup values
        if not ScanpanSetup.Get() then
            Error('SCANPAN Setup record not found.');

        // Calculate necessary values
        CustomerRec.CalcFields("Balance (LCY)");
        Balance := CustomerRec."Balance (LCY)";
        InsuredCreditLimit := CustomerRec."Credit Limit (LCY)";
        SelfInsuredLimit := CustomerRec."Self-Insured (LCY)";
        TotalSalesOrdersAmount := GetTotalSalesOrdersAmount(CustomerRec."No.");

        if GuiAllowed then begin
            // Check self-insured limit if warning is enabled in SCANPAN Setup
            if ScanpanSetup."Show SelfInsured Warning" then
                if SelfInsuredLimit > 0 then
                    if SelfInsuredLimit > InsuredCreditLimit then // Only proceed if SelfInsuredLimit is greater than CreditLimit
                        if Balance > SelfInsuredLimit then
                            Message(
                                WarningSelfInsuredLbl,
                                CustomerRec."No." + ' ' + CustomerRec.Name,
                                SelfInsuredLimit,
                                Balance,
                                TotalSalesOrdersAmount
                            );


            // Check standard credit limit if warning is enabled in SCANPAN Setup
            if ScanpanSetup."Show CreditMax Warning" then
                if InsuredCreditLimit > 0 then
                    if InsuredCreditLimit > SelfInsuredLimit then  // Only proceed if CreditLimit is greater than SelfInsuredLimit
                        if Balance > InsuredCreditLimit then
                            Message(
                                WarningCreditLimitLbl,
                                CustomerRec."No." + ' ' + CustomerRec.Name,
                                InsuredCreditLimit,
                                Balance,
                                TotalSalesOrdersAmount
                            );
        end;
    end;

    // Calculates the total sum of all sales orders for the given customer number
    procedure GetTotalSalesOrdersAmount(CustomerNo: Code[20]) TotalAmount: Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        TotalAmount := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);

        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                TotalAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        exit(TotalAmount);
    end;
    #endregion


    #region 083 Delete BackOrders Norway

    ///<summary>
    /// Version 1.0 - 2024.10.07 - Jesper Harder
    /// Handles deletion of sales orders and linked purchase orders for Norway, including the deletion of backorders.
    /// This procedure validates the deletion override condition, handles linked drop shipments, and deletes associated records.
    /// Original Version.
    ///</summary>
    procedure HandleSalesOrderDeletion(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        CurrDatabase: Record Database; // Not used effectively in the production code.
        ErrorCompanyNotScanpanNorge: Label 'This action can only be run for the company SCANPAN NORGE.';
        ConfirmDeleteOrder: Label 'Are you sure you want to delete the sales order along with any remaining backorders and linked purchase orders?';
        MessageCurrentCompany: Label 'Current Company: %1';
        ErrorDeliveredNotInvoiced: Label 'Sales order cannot be deleted as there are items delivered but not invoiced.';
        MessageOrderDeleted: Label 'Sales order %1 and all remaining backorders have been successfully deleted, and linked purchase orders have been handled.';
        ErrorNoShipmentPosted: Label 'Sales order cannot be deleted as no shipments have been posted yet.';
        ErrorOverrideNotSet: Label 'Sales order cannot be deleted because "Del. SOs With Rem. Qty. NOTO" is not set.';
        PurchaseLinesRemaining: Boolean;
    begin
        // ONLY IN TEST
        // This section restricts execution to the test environment.
        CurrDatabase.SetRange("My Database", true);
        if CurrDatabase.FindFirst() then
            if CurrDatabase.FindFirst() then
                if CurrDatabase."Database Name" <> 'BC_TEST' then
                    Message('Must run in BC_TEST, Current is %1', CompanyName);
        // Consider refactoring for more efficient testing checks and usage in production. You are setting range and finding twice redundantly.

        // Check if the company is "SCANPAN NORGE" before proceeding.
        if CompanyName.ToUpper() <> 'SCANPAN NORGE' then
            Error(ErrorCompanyNotScanpanNorge);
        // Ensure that this validation is needed to prevent accidental deletions outside Norway.

        // Confirm with the user before proceeding
        if not Confirm(ConfirmDeleteOrder) then
            exit;
        // Always a good practice to confirm deletion.

        // Check if the deletion override condition is set
        if SalesHeader."Del. SO's With Rem. Qty. NOTO" then begin
            // Validate if the sales order has at least one posted shipment
            SalesShipmentHeader.Reset();
            SalesShipmentHeader.SetRange("Order No.", SalesHeader."No.");
            if not SalesShipmentHeader.IsEmpty then begin
                // Check if there are any delivered but not invoiced items
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Qty. Shipped Not Invoiced", '>0');
                if not SalesLine.IsEmpty then
                    Error(ErrorDeliveredNotInvoiced);
                // This ensures that you do not delete orders with pending invoices.

                // Iterate through each sales line to find linked purchase orders
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat
                        if SalesLine."Drop Shipment" then
                            // Find the linked purchase order
                            if SalesLine."Purchase Order No." <> '' then
                                if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, SalesLine."Purchase Order No.") then begin
                                    PurchaseLinesRemaining := false;

                                    PurchaseLine.Reset();
                                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                    PurchaseLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
                                    if not PurchaseLine.IsEmpty then
                                        PurchaseLinesRemaining := true;

                                    // If the purchase order has PurchaseLinesRemaining := false then delete the order
                                    if PurchaseLinesRemaining = false then
                                        Message('PurchaseHeader.Delete(true)');
                                    // Should implement the actual delete logic here. Message function is currently a placeholder.
                                end;
                    until SalesLine.Next() = 0;

                // Delete the sales order along with any remaining quantities (backorders) if all purchase lines are deleted
                if not PurchaseLinesRemaining then begin
                    Message('SalesHeader.Delete(true)');
                    // Should implement the actual delete logic here. Message function is currently a placeholder.
                    Message(MessageOrderDeleted, SalesHeader."No.");
                end else
                    Error('Sales order cannot be deleted as not all purchase order lines have been deleted.');
            end else
                Error(ErrorNoShipmentPosted);
        end else
            Error(ErrorOverrideNotSet);
    end;
    #endregion


    #region 096 JobQueue hardening to make sure it executes as expected    
    procedure RestartJobQueue()
    var
        Company: Record Company;
        JobQueueEntry: Record "Job Queue Entry";
    begin

        Company.Reset();
        Company.FindSet();
        repeat
            // Change to the company
            if Company.Name <> '' then begin
                JobQueueEntry.ChangeCompany(Company.Name);
                JobQueueEntry.Reset();
                JobQueueEntry.SetRange("Recurring Job", true);
                if JobQueueEntry.FindSet() then
                    repeat
                        if (JobQueueEntry.Status = JobQueueEntry.Status::Ready) or
                           (JobQueueEntry.Status = JobQueueEntry.Status::Error) then
                            JobQueueEntry.Restart();
                    until JobQueueEntry.Next() = 0;
            end;
        until Company.Next() = 0;
    end;
    #endregion


}