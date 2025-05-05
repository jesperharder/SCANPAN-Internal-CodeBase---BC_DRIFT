




codeunit 50012 "SubscriberShipmondo"
{
    /// <summary>
    /// 2024.06.13          Jesper Harder                   Fix from ExtionsionIT, better handling for Shipmondo PackageType on Tasklet
    /// 2024.10             Jesper Harder       084         Shipmondo Add Mobile Number To Sales Header, PickUpPoint
    /// 2024.10             Jesper Harder       089         XtensionIT Shipmondo Add Pick-up Point
    /// 2024.10             Jesper Harder       091         Create Customs, Shipmondo, XtensionIT
    /// 2024.10             Jesper Harder       092         Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// 2024.12             Jesper Harder       099         Shipmondo, XtensionIT, Validate WaybillType for Tasklet to pickup transporter
    /// 2024.12             Jesper Harder       100         Shipmondo, XtensionIT, Customer name must not exceed 35 chars
    /// 2024.12             Jesper Harder       102         Shipmondo E-Mail validator
    /// 2025.03             Jesper Harder       84.2        Shipmondo Set Shipping information Transfer Order
    /// </summary>


    EventSubscriberInstance = StaticAutomatic;



    /// Fix from ExtionsionIT, better handling for Shipmondo PackageType on Tasklet
    #region Package Types following 3 Primary Key fields combination
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Pack Lookup", 'OnLookupOnPackagesToShip_OnAfterAddStepToLicensePlate', '', false, false)]
    local procedure ChangeDataTableOnPackAndShip(_LicensePlate: Record "MOB License Plate"; var _Step: Record "MOB Steps Element")
    var
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        DataTableName: Text;
    begin
        if LowerCase(_Step.Get_name()) <> 'packagetype' then
            exit;

        if not WhseShipmentHeader.Get(_LicensePlate."Whse. Document No.") then
            exit;

        if WhseShipmentHeader."Shipping Agent Code" = '' then
            exit;

        DataTableName := StrSubstNo('%1_%2_%3', 'PackageTypeTable', CreateValidDataTableName(WhseShipmentHeader."Shipping Agent Code"), CreateValidDataTableName(WhseShipmentHeader."Shipping Agent Service Code"));
        _Step.Set_dataTable(DataTableName);  // 'PackageTypeTable_ShippingAgentCode_ShippingAgentService'
        _Step.Save();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Reference Data", 'OnGetReferenceData_OnAddDataTables', '', true, true)]
    local procedure OnGetReferenceData_OnAddDataTablesForPackageType(var _DataTable: Record "MOB DataTable Element")
    var
        ShippingAgent: Record "Shipping Agent";
        MobPackageType: Record "MOB Package Type";
        MobPackageSetup: Record "MOB Mobile WMS Package Setup";
        OldServiceCode: Text;
    begin
        // Create a DataTable for each combination of Shipping Agent and Package Types
        if ShippingAgent.FindSet() then
            repeat
                OldServiceCode := '--';
                MobPackageSetup.SetCurrentKey("Shipping Agent", "Shipping Agent Service Code", "Package Type");
                MobPackageSetup.SetRange("Shipping Agent", ShippingAgent.Code);
                if MobPackageSetup.FindSet() then
                    repeat
                        if MobPackageSetup."Shipping Agent Service Code" <> OldServiceCode then begin
                            _DataTable.InitDataTable(StrSubstNo('%1_%2_%3', 'PackageTypeTable', CreateValidDataTableName(ShippingAgent.Code), CreateValidDataTableName(MobPackageSetup."Shipping Agent Service Code")));
                            _DataTable.Create_CodeAndName('', '');
                            OldServiceCode := MobPackageSetup."Shipping Agent Service Code";
                        end;
                        if MobPackageType.Get(MobPackageSetup."Package Type") then
                            if MobPackageType.Description <> '' then
                                _DataTable.Create_CodeAndName(MobPackageType.Code, MobPackageType.Description)
                            else
                                _DataTable.Create_CodeAndName(MobPackageType.Code, MobPackageType.Code);
                    until MobPackageSetup.Next() = 0;
            until ShippingAgent.Next() = 0;
    end;

    local procedure CreateValidDataTableName(_InputText: Text): Text
    var
        OutputText: Text;
    begin
        OutputText := _InputText;
        OutputText := ConvertStr(OutputText, ' ', '_');
        OutputText := ConvertStr(OutputText, '.', '_');
        OutputText := ConvertStr(OutputText, ',', '_');
        OutputText := ConvertStr(OutputText, '-', '_'); // Is valid in Xml tag name but unsupported in Android App
        exit(OutputText);
    end;
    #endregion

    // 084,
    // Several checks and fixes is done in the referred procedure
    #region 084         Shipmondo Add Mobile Number To Sales Header
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"XTESSC Shipment Attributes", 'OnAfterGetDefaultReceiver_OnBeforeAssignReceiver', '', true, true)]
    local procedure OnAfterGetDefaultReceiver_OnBeforeAssignReceiver(var TempCustomer: Record Customer temporary; WaybillHeader: Record "XTECSC Waybill Header")
    begin
        ShipmondoUpdateWaybillDetails(TempCustomer, WaybillHeader);
    end;
    #endregion


    #region 091 Create Customs, Shipmondo, XtensionIT


    //Fix16 2024.11.08 By XtensionIT by CMS@xtensionit.com 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"XTESCT License Plate Mgt", 'OnAfterCreateWaybillFromLicensePlate', '', false, false)]

    local procedure LicensePlateMgt_OnAfterCreateWaybillFromLicensePlate(WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WaybillHeader: Record "XTECSC Waybill Header"; WaybillLine: Record "XTECSC Waybill Line")
    var
        ShippingAgentServices: Record "Shipping Agent Services";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        CustomsLine: Record "XTECSC Customs Line";
        ShipmentUoM: Record "XTECSC Shipment UoM";
        IDocumentLineDataProvider: Interface "IDocument Line Data Provider XTE";

        // Fix19
        Item: Record Item;
    begin
        if not ShippingAgentServices.Get(WaybillHeader."Shipping Agent Code", WaybillHeader."Shipping Agent Service Code") then
            exit;

        if ShippingAgentServices."XTECSC Customs Type" = ShippingAgentServices."XTECSC Customs Type"::"Default (None)" then
            exit;

        // Insert potentional additional exit cases here

        CustomsLine.Reset();
        CustomsLine.SetRange("Source Type", WaybillLine."Source Type");
        CustomsLine.SetRange("Source No.", WaybillLine."Source No.");
        CustomsLine.DeleteAll(false);
        // Do note that this will also delete CustomsLines on already send Waybill Lines.

        // Add more filters if this is a issue.

        WarehouseShipmentLine.Reset();
        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
        WarehouseShipmentLine.SetFilter("Qty. to Ship", '<>0');
        WarehouseShipmentLine.SetFilter("Source Document", '%1|%2|%3', WarehouseShipmentLine."Source Document"::"Sales Order", WarehouseShipmentLine."Source Document"::"Service Order", WarehouseShipmentLine."Source Document"::"Outbound Transfer");

        if not WarehouseShipmentLine.FindSet(false) then
            exit;

        // Not repeat Process Only first line 21.2.2025 repeat
        IDocumentLineDataProvider := WaybillHeader."Source Type";

        Clear(CustomsLine);
        CustomsLine.Validate("Waybill Line No.", WaybillLine."Line No.");
        CustomsLine.Validate("Source Type", WaybillLine."Source Type");
        CustomsLine.Validate("Source No.", WaybillLine."Source No.");
        CustomsLine.Validate("Line No.", WarehouseShipmentLine."Line No.");
        // Normal Fields
        CustomsLine.Validate("Item No.", WarehouseShipmentLine."Item No.");
        CustomsLine.Validate(Description, WarehouseShipmentLine.Description);
        CustomsLine.Validate(Quantity, WarehouseShipmentLine."Qty. to Ship");


        // Fix19           
        if ShippingAgentServices."XTECSC Customs Type" = ShippingAgentServices."XTECSC Customs Type"::"Assign total value" then begin
            if Item.Get(WarehouseShipmentLine."Item No.") then //Fix 19 Try Item NetWeight
                CustomsLine.Validate("Unit Weight", Item."Net Weight" * WarehouseShipmentLine."Qty. to Ship") // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.
            else
                CustomsLine.Validate("Unit Weight", IDocumentLineDataProvider.GetWeight(WarehouseShipmentLine.SystemId) * WarehouseShipmentLine."Qty. to Ship"); // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.

            CustomsLine.Validate("Unit Value", IDocumentLineDataProvider.GetAmount(WarehouseShipmentLine.SystemId, false) * WarehouseShipmentLine."Qty. to Ship"); // Sets the "Amount Including VAT" from the related source line e.g. sales line, transferline etc.               
        end;

        if ShippingAgentServices."XTECSC Customs Type" = ShippingAgentServices."XTECSC Customs Type"::"Assign Unit Value" then begin
            if Item.Get(WarehouseShipmentLine."Item No.") then //Fix 19 Try Item NetWeight
                CustomsLine.Validate("Unit Weight", Item."Net Weight") // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.
            else
                CustomsLine.Validate("Unit Weight", IDocumentLineDataProvider.GetWeight(WarehouseShipmentLine.SystemId)); // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.
            CustomsLine.Validate("Unit Value", IDocumentLineDataProvider.GetAmount(WarehouseShipmentLine.SystemId, false)); // Sets the "Amount Including VAT" from the related source line e.g. sales line, transfer line etc.

            // Try 20 JH 6.1.2025 - Always Set Unit Weight and Value to 1 in customs.
            CustomsLine.Validate("Unit Weight", 1);
            CustomsLine.Validate("Unit Value", 1);
        end;

        /* Original XtensionIT code
                    if ShippingAgentServices."XTECSC Customs Type" = ShippingAgentServices."XTECSC Customs Type"::"Assign total value" then begin
                        CustomsLine.Validate("Unit Weight", IDocumentLineDataProvider.GetWeight(WarehouseShipmentLine.SystemId) * WarehouseShipmentLine."Qty. to Ship"); // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.
                        CustomsLine.Validate("Unit Value", IDocumentLineDataProvider.GetAmount(WarehouseShipmentLine.SystemId, false) * WarehouseShipmentLine."Qty. to Ship"); // Sets the "Amount Including VAT" from the related source line e.g. sales line, transferline etc.               
                    end;

                    if ShippingAgentServices."XTECSC Customs Type" = ShippingAgentServices."XTECSC Customs Type"::"Assign Unit Value" then begin
                        CustomsLine.Validate("Unit Weight", IDocumentLineDataProvider.GetWeight(WarehouseShipmentLine.SystemId)); // Sets the Gross/Net Weight from the related source line e.g. sales line, transfer line etc.
                        CustomsLine.Validate("Unit Value", IDocumentLineDataProvider.GetAmount(WarehouseShipmentLine.SystemId, false)); // Sets the "Amount Including VAT" from the related source line e.g. sales line, transfer line etc.
                    end;
        */

        CustomsLine.Validate("Currency Code", IDocumentLineDataProvider.GetCurrencyCode(WaybillLine."Document Guid", true)); // Sets the Currency code of related source document e.g. sales header, transfer header etc.
                                                                                                                             // CustomsLine.Validate("Tariff No.", 'This is set during OnValidate Item No. - If you want to overrule, then do it here');
        CustomsLine.Insert(true);
        // Not repeat Process Only first line 21.2.2025 until WarehouseShipmentLine.Next() = 0;

        // 2024.12.5, does this resolve database table locking on WayBillLine?
        /*
            Jeg har et enkelt bud, der er meget teknisk.
            Mig bekendt lytter i på "OnAfterCreateWaybillFromLicensePlate" som har fat i Waybill Line.

            Hvad hvis to brugere er endt med at kalde dette event inden den første har nået at slippe recorden?
            Du kan evt, prøve at tilføje en Clear(WaybillLine); i slutningen af jeres lytter - Vi er færdig med den når dette event køres.
        */
        Clear(WaybillLine);
        //

    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure WarehouseShipmentLine_OnAfterInsertEvent(var Rec: Record "Warehouse Shipment Line"; RunTrigger: Boolean)
    var
    /*
            SalesHeader: Record "Sales Header";
            TransferHeader: Record "Transfer Header";
            WarehouseShipmentHeader: Record "Warehouse Shipment Header";
            Settings: Record "XTECSC Settings";
            WaybillHeader: Record "XTECSC Waybill Header";
            WaybillManager: Codeunit "XTECSC Waybill Manager";
            ShipmentType: Enum "XTECSC Shipment Type";
            IWaybillManager: Interface "XTECSC Waybill Manager";
    */
    begin

        UpdateWayBillType(Rec);

        /*
                if Rec.IsTemporary() then
                    exit;

                //if not RunTrigger then
                //    exit;

                if not Settings.IsExtensionActive() then
                    exit;

                case Rec."Source Document" of
                    Rec."Source Document"::"Sales Order":
                        begin
                            if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Source No.") then
                                exit;

                            IWaybillManager := ShipmentType::"Sales Order";
                            IWaybillManager.CreateWaybill(SalesHeader.SystemId);
                        end;
                    Rec."Source Document"::"Outbound Transfer":
                        begin
                            if not TransferHeader.Get(Rec."Source No.") then
                                exit;

                            IWaybillManager := ShipmentType::"Transfer Order";
                            IWaybillManager.CreateWaybill(TransferHeader.SystemId);
                        end;
                    else
                        exit;
                end;

                // fix17 - Make sure Transporter information is written to the WaybillHeader on the order
                // 099 Shipmondo, XtensionIT, Validate WaybillType for Tasklet to pickup transporter
                WarehouseShipmentHeader.Get(Rec."No.");
                WaybillManager.MigrateWaybillHeadersToWarehouseShipment(WarehouseShipmentHeader);
                WaybillHeader.Get(WarehouseShipmentHeader.SystemId);
                WaybillHeader.Validate("Waybill Type");
        */
    end;


    // fix18 - Try this on AfterRelease of Warehouse document
    // fix17 - Make sure Transporter information is written to the WaybillHeader on the order
    // 099 Shipmondo, XtensionIT, Validate WaybillType for Tasklet to pickup transporter
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnAfterRelease', '', false, false)]
    local procedure OnAfterReleaseWhseShipmentRelease(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseShipmentLine: Record "Warehouse Shipment Line");
    begin
        UpdateWayBillType(WarehouseShipmentLine);
    end;

    #endregion




    /// <summary>
    /// 
    /// 
    /// Shipmondo and XtensionIT helper code
    /// 
    /// 
    /// </summary>

    #region Shipmondo XIT helper and fix code

    // 084 Shipmondo Add Mobile Number To Sales Header
    // 089 XtensionIT Shipmondo Add Pick-up Point
    // 100 Shipmondo, XtensionIT, Customer name must not exceed 35 chars
    local procedure ShipmondoUpdateWaybillDetails(var TempCustomer: Record Customer temporary; var WaybillHeader: Record "XTECSC Waybill Header")
    var

        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        TypeImplemented: Boolean;
        IsOutboundTransfer: Boolean;
    begin

        TypeImplemented := false;
        IsOutboundTransfer := false;



        // Source is Warehouse Shipment
        if WaybillHeader."Source Type" = WaybillHeader."Source Type"::"Warehouse Shipment" then begin
            WarehouseShipmentLine.Reset();
            WarehouseShipmentLine.SetRange("No.", WaybillHeader."Source No.");

            if WarehouseShipmentLine.FindFirst() then begin
                if WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Sales Order" then
                    if SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseShipmentLine."Source No.") then
                        TypeImplemented := true;

                if WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Outbound Transfer" then
                    if TransferHeader.Get(WarehouseShipmentLine."Source No.") then begin
                        TypeImplemented := true;
                        IsOutboundTransfer := true;
                    end;
            end;
        end;

        // Source is Posted Sales Shipment
        if WaybillHeader."Source Type" = WaybillHeader."Source Type"::"Posted Sales Shipment" then
            if SalesShipmentLine.Get(WaybillHeader."Source No.", 10000) then
                if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesShipmentLine."Order No.") then
                    TypeImplemented := true;


        // Source is Sales Order
        if WaybillHeader."Source Type" = WaybillHeader."Source Type"::"Sales Order" then
            if SalesHeader.Get(SalesHeader."Document Type"::Order, WaybillHeader."Source No.") then
                TypeImplemented := true;


        // Exit error if Type is not implemented
        if not TypeImplemented then
            Error('Scanpan FIX 084 Not implemented - ExtensionIT Shipmondo.\Sales Header %1, %2', WaybillHeader."Source Type", WaybillHeader."Source No.");


        // 84.2 Set Shipping information Transfer Order
        case WaybillHeader."Source Type" of
            //WaybillHeader."Source Type"::"Posted Service Shipment",
            //WaybillHeader."Source Type"::"Posted Transfer Shipment",
            //WaybillHeader."Source Type"::"Service Order",
            //WaybillHeader."Source Type"::"Transfer Order":
            WaybillHeader."Source Type"::"Posted Sales Shipment",
            WaybillHeader."Source Type"::"Sales Order",
            WaybillHeader."Source Type"::"Warehouse Shipment":
                begin
                    if not IsOutboundTransfer then begin
                        // Common logic for these source types
                        TempCustomer.Name := CopyStr(TempCustomer.Name, 1, 35); // 100 Shipmondo, XtensionIT, Customer name must not exceed 35 chars
                        TempCustomer."E-Mail" := SalesHeader."Sell-to E-Mail";
                        ValidateAndSetEmail(TempCustomer); // 102 Validate and add dummy email if blank.
                        TempCustomer."Mobile Phone No." := SalesHeader."Sell-to Phone No."; // 084
                        WaybillHeader."Pick-up Point" := ShipmondoGetRestOfShipToAddress2AfterPakkeshop(SalesHeader); // 89 PickupPoint

                        // 84 Normalize Phonenumber when Norway
                        if SalesHeader."Sell-to Customer No." = '1010' then
                            ShipmondoNormalizePhoneNumberNorway(TempCustomer, SalesHeader);
                    end;

                    if isOutboundTransfer then begin
                        // Separate logic for Transfer Order
                        ValidateAndSetEmail(TempCustomer); // 102 Validate and add dummy email if blank.
                        TempCustomer."Mobile Phone No." := '4587741400';
                        TempCustomer.Name := CopyStr(TransferHeader."Transfer-to Name", 1, 35); // 100 Shipmondo, XtensionIT, Customer name must not exceed 35 chars
                        TempCustomer.Address := TransferHeader."Transfer-to Address";
                        TempCustomer.City := TransferHeader."Transfer-to City";
                        TempCustomer."Post Code" := TransferHeader."Transfer-to Post Code";
                        TempCustomer."Country/Region Code" := TransferHeader."Trsf.-to Country/Region Code";
                        TempCustomer.Contact := TransferHeader."Transfer-to Contact";
                    end;

                end else
                        // Default case
                        Error('Unhandled Source Type')
        end;






        // Assign values
        /*
        if TypeImplemented then begin

            TempCustomer.Name := CopyStr(TempCustomer.Name, 1, 35); // 100 Shipmondo, XtensionIT, Customer name must not exceed 35 chars
            TempCustomer."E-Mail" := SalesHeader."Sell-to E-Mail";
            ValidateAndSetEmail(TempCustomer); // 102 Validate and add dummy email if blank.
            TempCustomer."Mobile Phone No." := SalesHeader."Sell-to Phone No."; // 084
            WaybillHeader."Pick-up Point" := ShipmondoGetRestOfShipToAddress2AfterPakkeshop(SalesHeader); // 89 PickupPoint

            // 84 Normalize Phonenumber when Norway
            if SalesHeader."Sell-to Customer No." = '1010' then
                ShipmondoNormalizePhoneNumberNorway(TempCustomer, SalesHeader);
        end;
        */
    end;


    // 102 Shipmondo E-Mail Validator
    local procedure ValidateAndSetEmail(var TempCustomer: Record Customer)
    var
        AtPos: Integer;
        DotPos: Integer;
        IsValidEmail: Boolean;
        LocalPart: Text;
    begin
        // Check if the email field is empty and set dummy E-Mail
        if TempCustomer."E-Mail" = '' then
            TempCustomer."E-Mail" := 'service@scanpan.dk';

        // Find the positions of '@' and the first '.' after '@'
        AtPos := StrPos(TempCustomer."E-Mail", '@');
        DotPos := StrPos(CopyStr(TempCustomer."E-Mail", AtPos + 1), '.') + AtPos;

        // Email must contain '@' and '.' after '@' and have at least one character between '@' and '.'
        IsValidEmail := (AtPos > 0) and (DotPos > AtPos + 1) and (DotPos < StrLen(TempCustomer."E-Mail"));

        // Additional check: Ensure no consecutive dots in the local part (before '@')
        if IsValidEmail then begin
            LocalPart := CopyStr(TempCustomer."E-Mail", 1, AtPos - 1);
            if StrPos(LocalPart, '..') > 0 then
                IsValidEmail := false;
        end;

        // Perform a basic validation check on the email
        if not IsValidEmail then
            Error('The email address "%1" is invalid. Please correct it.', TempCustomer."E-Mail");
    end;

    // 89 Shipmondo helper code for Pick-up Point
    local procedure ShipmondoGetRestOfShipToAddress2AfterPakkeshop(var SalesHeader: Record "Sales Header"): Text[80]
    var
        ShipToAddress2: Text[80];
        SearchText: Text[20];
        Position: Integer;
        RestOfString: Text[80];
    begin
        ShipToAddress2 := SalesHeader."Ship-to Address 2";
        SearchText := 'Pakkeshop:';
        Position := StrPos(ShipToAddress2, SearchText); // Find the position of 'Pakkeshop:'
        // If the text is found
        if Position > 0 then
            RestOfString := CopyStr(ShipToAddress2, Position + StrLen(SearchText), MaxStrLen(ShipToAddress2)) // Get the rest of the string after 'Pakkeshop:'
        else
            RestOfString := ''; // Return an empty string if 'Pakkeshop:' is not found

        exit(RestOfString);
    end;


    // 84 Shipmondo helper code for fixing phonenumbers
    local procedure ShipmondoNormalizePhoneNumberNorway(var TempCustomer: Record Customer; SalesHeader: Record "Sales Header")
    var
        PhoneNumber: Text;
    begin
        // Remove spaces from the phone number
        PhoneNumber := DELCHR(SalesHeader."Sell-to Phone No.", '=', ' ');

        // Check if the phone number is empty after removing spaces
        if PhoneNumber = '' then begin
            TempCustomer."Mobile Phone No." := '+4790000000';
            exit;
        end;

        // Add the +47 prefix if it's missing
        if STRPOS(PhoneNumber, '+47') <> 1 then
            PhoneNumber := '+47' + PhoneNumber;

        // Check if the phone number matches the +479 or +474 prefix
        if (COPYSTR(PhoneNumber, 1, 4) = '+479') and (STRLEN(PhoneNumber) = 11) then
            exit // Number starts with +479 and is of correct length (11 characters)
        else
            if (COPYSTR(PhoneNumber, 1, 4) = '+474') and (STRLEN(PhoneNumber) = 11) then
                exit // Number starts with +474 and is of correct length (11 characters)
            else
                TempCustomer."Mobile Phone No." := '+4790000000'; // If the phone number doesn't match the format, set to +4790 followed by '0000000'
    end;


    // fix18 - Try this on AfterRelease of Warehouse document
    // fix17 - Make sure Transporter information is written to the WaybillHeader on the order
    // 099 Shipmondo, XtensionIT, Validate WaybillType for Tasklet to pickup transporter
    local procedure UpdateWayBillType(var WarehouseShipmentLine: Record "Warehouse Shipment Line");
    var
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        XTECSCSettings: Record "XTECSC Settings";
        XTECSCWaybillHeader: Record "XTECSC Waybill Header";
        XTECSCWaybillManager: Codeunit "XTECSC Waybill Manager";
        ShipmentType: Enum "XTECSC Shipment Type";
        IWaybillManager: Interface "XTECSC Waybill Manager";
    begin
        if not XTECSCSettings.IsExtensionActive() then
            exit;

        case WarehouseShipmentLine."Source Document" of
            WarehouseShipmentLine."Source Document"::"Sales Order":
                begin
                    if not SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseShipmentLine."Source No.") then
                        exit;

                    IWaybillManager := ShipmentType::"Sales Order";
                    IWaybillManager.CreateWaybill(SalesHeader.SystemId);
                end;
            WarehouseShipmentLine."Source Document"::"Outbound Transfer":
                begin
                    if not TransferHeader.Get(WarehouseShipmentLine."Source No.") then
                        exit;

                    IWaybillManager := ShipmentType::"Transfer Order";
                    IWaybillManager.CreateWaybill(TransferHeader.SystemId);
                end;
            else
                exit;
        end;

        // fix17 - Make sure Transporter information is written to the WaybillHeader on the order
        // 099 Shipmondo, XtensionIT, Validate WaybillType for Tasklet to pickup transporter
        WarehouseShipmentHeader.Get(WarehouseShipmentLine."No.");
        XTECSCWaybillManager.MigrateWaybillHeadersToWarehouseShipment(WarehouseShipmentHeader);
        XTECSCWaybillHeader.Get(WarehouseShipmentHeader.SystemId);
        XTECSCWaybillHeader.Validate("Waybill Type");
    end;

    #endregion

}