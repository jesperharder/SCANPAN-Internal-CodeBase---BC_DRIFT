///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>
//https,//learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/httpclient/httpclient-post-method
//http://thedenster.com/2022/03/create-json-in-al/
codeunit 50006 "DSVAPI"
{
    Access = Public;
    Subtype = Normal;

    /// <summary>
    /// DSVGetOrder.
    /// </summary>
    /// <param name="APIProfileID">Integer.</param>
    /// <param name="PurchaseOrderNo">code[20].</param>
    procedure DSVGetOrder(APIProfileID: Integer; PurchaseOrderNo: code[20])
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
        ScanpanAPISetup: Record "Scanpan API Setup";

        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        ErrorResponseStatusLbl: Label 'Web service returned an error message:\\ Status code: %1\ Description: %2', Comment = '%1 = Http response status code; %2 = status text.';
        HttpContentText: Text;
        JSONResponseMessage: Text;
        jsonText: Text;
        jsonToken: JsonToken;
        jsonObject: JsonObject;
        jsonOrderArray: JsonArray;
        jsonOrderToken: JsonToken;
        StateTxt: Text;
    begin
        //Get API profile
        ScanpanAPISetup.Get(APIProfileID);

        //'K101118'
        HttpContentText := ScanpanAPISetup.URL + '/' + PurchaseOrderNo;

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Basic ' + Base64EncodeUserPwd(ScanpanAPISetup."User Name", ScanpanAPISetup.Password));
        HttpClient.DefaultRequestHeaders.Add('Host', 'api.dsv.com');
        HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        HttpClient.DefaultRequestHeaders.Add('Cache-Control', 'no-cache');
        HttpClient.DefaultRequestHeaders.Add('DSV-Subscription-Key', ScanpanAPISetup."Subscription key");

        HttpContent.Clear();
        //HttpContent.WriteFrom(HttpContentText);

        HttpHeaders.Clear();
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(HttpHeaders);

        HttpClient.Get(HttpContentText, HttpResponseMessage);

        if not HttpResponseMessage.IsSuccessStatusCode then
            Error(
                ErrorResponseStatusLbl,
                HttpResponseMessage.HttpStatusCode,
                HttpResponseMessage.ReasonPhrase);

        HttpResponseMessage.Content.ReadAs(jsonText);


        // Output the json as Text
        Message(ProcessJsonArrayWithFor(jsonText));
        //jsonObject.ReadFrom(jsonText);

        TempJSONBuffer.DeleteAll();
        TempJSONBuffer.ReadFromText(jsonText);

        // Raw output
        Message(jsonText);

    end;

    /// <summary>
    /// DSVAPIorders.
    /// </summary>
    /// <param name="APIProfileID">Integer.</param>
    /// <param name="PurchaseOrderNo">code[20].</param>
    procedure DSVCreateOrder(APIProfileID: Integer; PurchaseOrderNo: code[20]; CancelOrder: Boolean)
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
        ScanpanAPISetup: Record "Scanpan API Setup";

        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        ErrorResponseStatusLbl: Label 'Web service returned an error message:\\ Status code: %1\ Description: %2', Comment = '%1 = Http response status code; %2 = status text.';
        HttpContentText: Text;
        JSONResponseMessage: Text;
        jsonText: Text;
    begin
        //Get API profile
        ScanpanAPISetup.Get(APIProfileID);

        //'K101118'
        HttpContentText := CreateDSVOrderJSON(PurchaseOrderNo, CancelOrder);

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Basic ' + Base64EncodeUserPwd(ScanpanAPISetup."User Name", ScanpanAPISetup.Password));
        HttpClient.DefaultRequestHeaders.Add('Host', 'api.dsv.com');
        HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        HttpClient.DefaultRequestHeaders.Add('Cache-Control', 'no-cache');
        HttpClient.DefaultRequestHeaders.Add('DSV-Subscription-Key', ScanpanAPISetup."Subscription key");

        HttpContent.Clear();
        HttpContent.WriteFrom(HttpContentText);

        HttpHeaders.Clear();
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(HttpHeaders);

        HttpClient.Post(ScanpanAPISetup.URL, HttpContent, HttpResponseMessage);

        if not HttpResponseMessage.IsSuccessStatusCode then begin
            Message(
                ErrorResponseStatusLbl,
                HttpResponseMessage.HttpStatusCode,
                HttpResponseMessage.ReasonPhrase);

            Error(HttpContentText);
        end;
        HttpResponseMessage.Content.ReadAs(jsonText);

        TempJSONBuffer.DeleteAll();
        TempJSONBuffer.ReadFromText(jsonText);

        if TempJSONBuffer.FindSet() then
            repeat
                JSONResponseMessage += TempJSONBuffer.GetValue() + '\';
            until TempJSONBuffer.Next() = 0;

        Message(JSONResponseMessage);

        Message(HttpContentText);
        Message(jsonText);
    end;

    //Create the PurchaseOrderJSON
    //https,//www.dvlprlife.com/2022/12/dynamics-365-business-central-read-a-json-file-with-al/
    local procedure CreateDSVOrderJSON(PurchaseOrderNumber: code[20]; CancelOrder: Boolean): Text
    var
        Item: Record Item;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        DateTime: DateTime;
        CustomFieldsArray: JsonArray;
        JArray: JsonArray;
        OrderLinesArray: JsonArray;
        PackLinesArray: JsonArray;
        PartiesArray: JsonArray;
        CustomFieldsObject: jsonObject;
        JJsonObject: JsonObject;
        OrderLinesNested: JsonObject;
        OrderLinesObject: JsonObject;
        OrderObject: JsonObject;
        //PackLinesCustomFieldsObject: JsonObject;
        PackLinesObject: JsonObject;
        PartiesObject: JsonObject;
        NullJsonValue: JsonValue;
        JsonData: Text;
        DefaultTimeVar: Time;

        DSVTransportMode: Enum DSVTransportMode;
    begin
        NullJsonValue.SetValueToNull();
        Clear(JJsonObject);

        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseOrderNumber);
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetFilter("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.FindSet();

        //ORDER - Purchase Header
        #region OrderObject
        Clear(OrderObject);
        Clear(DefaultTimeVar);
        OrderObject.Add('IsCancelled', CancelOrder);
        OrderObject.Add('OrderNumber', PurchaseHeader."No.");
        OrderObject.Add('OrderNumberSplit', 0);

        DateTime := System.CreateDateTime(PurchaseHeader."Order Date", DefaultTimeVar);
        if DateTime = 0DT then
            OrderObject.Add('OrderDate', '')
        else
            OrderObject.Add('OrderDate', DateTime);

        OrderObject.Add('OrderGoodsDescription', 'goods api');

        OrderObject.Add('TransportMode', EnumConvertTransportMode(DSVTransportMode::SEA)); //OrderObject.Add('TransportMode', 'AIR');
                                                                                           //OrderObject.Add('ContainerMode', 'LCL');
                                                                                           //OrderObject.Add('ServiceLevel', 'SRV');


        DateTime := System.CreateDateTime(PurchaseHeader."Promised Receipt Date", DefaultTimeVar);
        if DateTime = 0DT then
            OrderObject.Add('EstimatedExWorksDate', '')
        else
            OrderObject.Add('EstimatedExWorksDate', DateTime); //OrderObject.Add('EstimatedExWorksDate', '2019-07-15T06:51:50.13Z');

        //OrderObject.Add('ActualExWorksDate', '2019-07-02T06:51:50.13Z');

        DateTime := System.CreateDateTime(PurchaseHeader."Requested Receipt Date", DefaultTimeVar);
        if DateTime = 0DT then
            OrderObject.Add('ExWorksRequiredBy', '')
        else
            OrderObject.Add('ExWorksRequiredBy', DateTime); //OrderObject.Add('ExWorksRequiredBy', '2019-05-12T06:51:50.13Z');

        //OrderObject.Add('DeliveryRequiredBy', '2019-07-02T06:51:50.13Z');

        //
        // alternativ bestillingsadresse, opslag her førtst
        //
        OrderObject.Add('OriginCountry', PurchaseHeader."Buy-from Country/Region Code"); //OrderObject.Add('OriginCountry', NullJsonValue);

        OrderObject.Add('Incoterm', PurchaseHeader."Shipment Method Code"); //OrderObject.Add('Incoterm', 'INC');

        //OrderObject.Add('AdditionalTerms', 'AT');
        //OrderObject.Add('AdditionalTermsUNLOCO', NullJsonValue);

        //OrderObject.Add('ActualVolume', 20);
        //OrderObject.Add('UnitOfVolume', 'M3');
        //OrderObject.Add('ActualWeight', 10);
        //OrderObject.Add('UnitOfWeight', 'KG');
        //OrderObject.Add('TotalPacks', 1);
        //OrderObject.Add('TotalQuantity', 50);
        //OrderObject.Add('PackType', 'PK');
        //OrderObject.Add('FollowUpDate', '2019-07-02T06:51:50.13Z');
        //OrderObject.Add('PortOfLoading', 'KO');
        //OrderObject.Add('PortOfDischarge', 'PO');

        if PurchaseHeader."Currency Code" = '' then
            OrderObject.Add('Currency', 'DKK')
        else
            OrderObject.Add('Currency', PurchaseHeader."Currency Code");//OrderObject.Add('Currency', 'OC');

        OrderObject.Add('ClientType', 'Buyer');

        //OrderObject.Add('TotalValue', 200);
        //OrderObject.Add('TotalInners', 30.5);
        //OrderObject.Add('TotalOuters', 10);
        //OrderObject.Add('BookingReference', NullJsonValue);
        //OrderObject.Add('TransitWarehouse', NullJsonValue);

        //OrderObject.Add('OnHandDate', NullJsonValue);
        //OrderObject.Add('PlannerCode', 'PC');

        OrderObject.Add('PlannerEmail', GetPurchaserEmail(PurchaseHeader."Purchaser Code")); //OrderObject.Add('PlannerEmail', 'planner@email.com');

        //OrderObject.Add('WarehouseReceiptNumber', NullJsonValue);

        /*
                OrderObject.Add('VehicleRegistration', 'vh');
                OrderObject.Add('TrailerNumber', 'tr');
                OrderObject.Add('Seal', 'seal');
                OrderObject.Add('ManifestNumber', 'manifest');
                OrderObject.Add('BookedInNumber', 'bookedin');
                OrderObject.Add('DispatchedDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('EstimatedReceiptDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('BookedInDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('CutOffDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('InvoiceDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('InvoiceNumber', 'inv');
                OrderObject.Add('ConfirmedDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('ConfirmationNumber', 'conf');
                OrderObject.Add('ContractNumber', 'cont');
                OrderObject.Add('GoodsReceiptNumber', 'goodsre');
                OrderObject.Add('GoodsReceiptDate', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('AuthorisedBy', 'auth');
                OrderObject.Add('AuthorisedToShip', '2019-07-02T06:51:50.13Z');
                OrderObject.Add('OrderType', 'PO');
                OrderObject.Add('EarliestShipDate', NullJsonValue);
                OrderObject.Add('LatestShipDate', NullJsonValue);
        */
        #endregion //OrderObject

        //PackLines
        #region PackLinesObject
        Clear(JArray);
        //REPEAT each per. orderline
        Clear(PackLinesObject);
        /*
                PackLinesObject.Add('PackageCount', 200);
                PackLinesObject.Add('PackType', 'PCK');
                PackLinesObject.Add('ContainerPackingOrder', 0);
                PackLinesObject.Add('Weight', 20);
                PackLinesObject.Add('UnitOfWeight', NullJsonValue);
                PackLinesObject.Add('Length', 10);
                PackLinesObject.Add('Height', 20);
                PackLinesObject.Add('Width', 5);
                PackLinesObject.Add('UnitOfDimension', NullJsonValue);
                PackLinesObject.Add('Volume', 1);
                PackLinesObject.Add('UnitOfVolume', 'CM3');
                PackLinesObject.Add('RefNumber', 'REF');
                PackLinesObject.Add('Description', NullJsonValue);
                PackLinesObject.Add('DetailedDescription', NullJsonValue);
                PackLinesObject.Add('HarmonisedCode', NullJsonValue);
                PackLinesObject.Add('Origin', NullJsonValue);
                PackLinesObject.Add('CommodityCode', NullJsonValue);
                PackLinesObject.Add('ContainerNumber', NullJsonValue);
                PackLinesObject.Add('Outturn', 0);
                PackLinesObject.Add('OutturnedLength', 0);
                PackLinesObject.Add('OutturnedHeight', 0);
                PackLinesObject.Add('OutturnedWidth', 0);
                PackLinesObject.Add('OutturnedWeight', 0);
                PackLinesObject.Add('OutturnedVolume', 0);
                PackLinesObject.Add('OutturnComment', NullJsonValue);
                PackLinesObject.Add('Pillaged', 0);
                PackLinesObject.Add('Damaged', 0);
                PackLinesObject.Add('LoadingMeters', 30);
                PackLinesObject.Add('MarksAndNumbers', 'marks');
                PackLinesObject.Add('ProductCode', 'PC001');
                PackLinesObject.Add('DangerousGoodsRef', NullJsonValue);
                PackLinesObject.Add('NoOfPallets', 0);
                PackLinesObject.Add('PackIdentifier', NullJsonValue);
                PackLinesObject.Add('DocumentRemarks1', NullJsonValue);
                PackLinesObject.Add('DocumentRemarks2', NullJsonValue);
                PackLinesObject.Add('DocumentRemarks3', NullJsonValue);
                PackLinesObject.Add('Sequence', 0);
                PackLinesObject.Add('Stackable', true);
                PackLinesObject.Add('OrderLineNumber', 1);

                //Nested - CustomFields should go here "CustomFields": [{
                //PackLinesCustomFieldsObject
                Clear(PackLinesCustomFieldsObject);
                Clear(JArray);
                PackLinesCustomFieldsObject.Add('Name', 'PK Addon1');
                PackLinesCustomFieldsObject.Add('Type', 'STR');
                PackLinesCustomFieldsObject.Add('Value', 'string');
                JArray.Add(PackLinesCustomFieldsObject);
                PackLinesObject.Add('CustomFields', JArray);
                //
                PackLinesObject.Add('PackageMarks', 'packmarks');

                //UNTIL PackLinesObject.NEXT = 0

                Clear(PackLinesArray);
                PackLinesArray.Add(PackLinesObject);
        */
        #endregion //PackLinesObject

        #region CustomFieldsObject
        //CustomFieldsObject
        //"CustomFields": [{
        //AddOn.CustomsDetails

        /*
                Clear(CustomFieldsObject);
                Clear(CustomFieldsArray);
                CustomFieldsObject.Add('Name', 'StringAddon');
                CustomFieldsObject.Add('Type', 'STR');
                CustomFieldsObject.Add('Value', 'string');
                CustomFieldsArray.Add(CustomFieldsObject);

                Clear(CustomFieldsObject);
                CustomFieldsObject.Add('Name', 'DateAddon');
                CustomFieldsObject.Add('Type', 'DAT');
                CustomFieldsObject.Add('Value', '2019-07-02T06:51:50.13Z');
                CustomFieldsArray.Add(CustomFieldsObject);

                Clear(CustomFieldsObject);
                CustomFieldsObject.Add('Name', 'BoolAddon');
                CustomFieldsObject.Add('Type', 'BOO');
                CustomFieldsObject.Add('Value', 'true');
                CustomFieldsArray.Add(CustomFieldsObject);

                Clear(CustomFieldsObject);

                CustomFieldsObject.Add('Name', 'IntAddon');
                CustomFieldsObject.Add('Type', 'INT');
                CustomFieldsObject.Add('Value', '20');
                CustomFieldsArray.Add(CustomFieldsObject);

                Clear(CustomFieldsObject);
                CustomFieldsObject.Add('Name', 'DecimalAddon');
                CustomFieldsObject.Add('Type', 'DEC');
                CustomFieldsObject.Add('Value', '50.57');
                CustomFieldsArray.Add(CustomFieldsObject);
                Clear(CustomFieldsObject);
        */

        CustomFieldsObject.Add('CustomFields', CustomFieldsArray);
        //
        #endregion //CustomFieldsObject

        //Parties
        #region PartiesObject
        //Repeat Parties one time per order
        // Loop TYPES
        //  "Type": "Buyer",
        //  "Type": "Supplier",
        //  "Type": "DeliveryTo",
        //  "Type": "Owner",
        //  "Type": "PickupFrom",
        Clear(PartiesObject);
        PartiesObject.Add('Type', 'Buyer');
        PartiesObject.Add('Code', '87741400');
        PartiesObject.Add('IsActive', true);
        PartiesObject.Add('FullName', 'SCANPAN A/S');
        PartiesObject.Add('ClosestPort', NullJsonValue);
        PartiesObject.Add('Currency', NullJsonValue);
        PartiesObject.Add('PhoneNumber', '+4587741400');
        PartiesObject.Add('Email', 'supplychain@scanpan.dk');
        PartiesObject.Add('VATNumber', 'DK80673612');
        PartiesObject.Add('RegisteredNumber', NullJsonValue);
        PartiesArray.Add(PartiesObject);

        Clear(PartiesObject);
        PartiesObject.Add('Type', 'Supplier');
        PartiesObject.Add('Code', PurchaseHeader."Buy-from Vendor No.");//PartiesObject.Add('Code', 'POSTSUP');
        PartiesObject.Add('IsActive', 'true');
        PartiesObject.Add('FullName', PurchaseHeader."Buy-from Vendor Name"); //PartiesObject.Add('FullName', 'Supplier Name');
        PartiesObject.Add('ClosestPort', NullJsonValue);
        PartiesObject.Add('Currency', PurchaseHeader."Currency Code");//PartiesObject.Add('Currency', 'Cur');
        PartiesObject.Add('PhoneNumber', 'PH');
        PartiesObject.Add('Email', 'email');
        PartiesObject.Add('VATNumber', PurchaseHeader."VAT Registration No.");//PartiesObject.Add('VATNumber', 'vat');
        PartiesObject.Add('RegisteredNumber', NullJsonValue);
        PartiesArray.Add(PartiesObject);

        /*
                Clear(PartiesObject);

                PartiesObject.Add('Type', 'DeliveryTo');
                PartiesObject.Add('Code', 'POSTDLV');
                PartiesObject.Add('IsActive', 'true');
                PartiesObject.Add('FullName', 'Delivery Name');
                PartiesObject.Add('ClosestPort', NullJsonValue);
                PartiesObject.Add('Currency', NullJsonValue);
                PartiesObject.Add('PhoneNumber', '012');
                PartiesObject.Add('Email', 'recption@email.com');
                PartiesObject.Add('VATNumber', '572018555');
                PartiesObject.Add('RegisteredNumber', 'RegisterNumber');
                PartiesArray.Add(PartiesObject);
        */
        Clear(PartiesObject);
        /*
                PartiesObject.Add('Type', 'Owner');
                PartiesObject.Add('Code', 'POSTOWN');
                PartiesObject.Add('IsActive', 'true');
                PartiesObject.Add('FullName', 'Owner Name');
                PartiesObject.Add('ClosestPort', NullJsonValue);
                PartiesObject.Add('Currency', NullJsonValue);
                PartiesObject.Add('PhoneNumber', '0123');
                PartiesObject.Add('Email', NullJsonValue);
                PartiesObject.Add('VATNumber', NullJsonValue);
                PartiesObject.Add('RegisteredNumber', NullJsonValue);
                PartiesArray.Add(PartiesObject);
        */
        Clear(PartiesObject);
        /*
                PartiesObject.Add('Type', 'PickupFrom');
                PartiesObject.Add('Code', 'DECNTAZ-0001175');
                PartiesObject.Add('IsActive', 'true');
                PartiesObject.Add('FullName', 'DECNTAZ-0001175');
                PartiesObject.Add('ClosestPort', NullJsonValue);
                PartiesObject.Add('Currency', NullJsonValue);
                PartiesObject.Add('PhoneNumber', NullJsonValue);
                PartiesObject.Add('Email', NullJsonValue);
                PartiesObject.Add('VATNumber', NullJsonValue);
                PartiesObject.Add('RegisteredNumber', NullJsonValue);
                PartiesObject.Add('EDICode', 'DECNTAZ');
                PartiesObject.Add('ExternalCode', NullJsonValue);
                PartiesObject.Add('Address', NullJsonValue);
                PartiesArray.Add(PartiesObject);
        */
        Clear(PartiesObject);

        //UNTIL PartiesObject.NEXT = 0
        #endregion PartiesObject

        #region OrderLinesObject
        Clear(OrderLinesArray);

        //OrderLines
        repeat //until PurchaseLine.Next() = 0;
            //Repeat OrderLines
            Clear(OrderLinesObject);
            //OrderLinesObject.Add('LineStatus', 'PLC');
            OrderLinesObject.Add('LineNo', PurchaseLine."Line No.");
            OrderLinesObject.Add('Partno', PurchaseLine."No.");
            OrderLinesObject.Add('Description', PurchaseLine.Description);
            OrderLinesObject.Add('UnitOfQuantity', PurchaseLine."Unit of Measure Code");
            OrderLinesObject.Add('Quantity', PurchaseLine.Quantity);
            OrderLinesObject.Add('QtyInvoiced', PurchaseLine."Quantity Invoiced");
            OrderLinesObject.Add('QtyBooked', NullJsonValue);
            OrderLinesObject.Add('QtyReceived', PurchaseLine."Qty. Received (Base)");
            OrderLinesObject.Add('QtyShipped', NullJsonValue);
            OrderLinesObject.Add('Volume', PurchaseLine."Unit Volume");
            OrderLinesObject.Add('UnitOfVolume', NullJsonValue);
            OrderLinesObject.Add('Weight', PurchaseLine."Gross Weight");
            OrderLinesObject.Add('UnitOfWeight', NullJsonValue);
            OrderLinesObject.Add('ItemPrice', PurchaseLine."Unit Cost");
            OrderLinesObject.Add('LinePrice', PurchaseLine."Line Amount");
            OrderLinesObject.Add('Length', 0);
            OrderLinesObject.Add('Width', 0);
            OrderLinesObject.Add('Height', 0);
            OrderLinesObject.Add('DimUnit', NullJsonValue);
            OrderLinesObject.Add('DangerousGoodsRef', NullJsonValue);
            OrderLinesObject.Add('ContainerNumber', NullJsonValue);
            //ItemCode - ToldTariff
            Item.Reset();
            if Item.Get(PurchaseLine."No.") then
                OrderLinesObject.Add('HarmonisedCode', Item."Tariff No.")
            else
                OrderLinesObject.Add('HarmonisedCode', NullJsonValue);
            /*
                        OrderLinesObject.Add('PackLineId', NullJsonValue);
                        OrderLinesObject.Add('InvoiceNumber', NullJsonValue);
                        OrderLinesObject.Add('ConfirmationNumber', NullJsonValue);
                        OrderLinesObject.Add('PartAttrib1', NullJsonValue);
                        OrderLinesObject.Add('PartAttrib2', NullJsonValue);
                        OrderLinesObject.Add('PartAttrib3', NullJsonValue);
                        OrderLinesObject.Add('SpecialInstructions', 'SI');
                        OrderLinesObject.Add('AdditionalInfo', 'AI');
                        OrderLinesObject.Add('ContractNumber', 'CN');
                        OrderLinesObject.Add('OriginCountry', 'CO');
                        OrderLinesObject.Add('DecimalPlaces', 0);
                        OrderLinesObject.Add('QuantityPerUnit', 0);
                        OrderLinesObject.Add('NetWeight', 0);
                        OrderLinesObject.Add('TransportMode', 'AIR');
                        OrderLinesObject.Add('EarliestShipDate', NullJsonValue);
                        OrderLinesObject.Add('LatestShipDate', NullJsonValue);
                        OrderLinesObject.Add('FreightClass', NullJsonValue);
                        OrderLinesObject.Add('ServiceLevel', NullJsonValue);
            */
            //NEST
            /*
                        //Inners
                        Clear(OrderLinesNested);
                        OrderLinesNested.Add('Value', '30.5');
                        OrderLinesNested.Add('Unit', 'M3');
                        OrderLinesObject.Add('Inners', OrderLinesNested);

                        //Outers
                        Clear(OrderLinesNested);
                        OrderLinesNested.Add('Value', '10');
                        OrderLinesNested.Add('Unit', 'KG');
                        OrderLinesObject.Add('Outers', OrderLinesNested);

                        OrderLinesArray.Add(OrderLinesObject);

                        //Nested Parties
                        //OrderLinesObject.Add('Parties', '[]');
                        Clear(OrderLinesNested);
                        Clear(JArray);
                        //OrderLinesNested.Add('XXXX', 'XXXX');
                        //JArray.Add(OrderLinesNested);
                        OrderLinesObject.Add('Parties', JArray);
            */
            //
            /*
                        Clear(OrderLinesObject);
                        OrderLinesObject.Add('EstimatedExWorksDate', '2019-07-02T06:51:50.13Z');
                        OrderLinesObject.Add('ExWorksRequiredBy', '2019-07-02T06:51:50.13Z');
                        OrderLinesObject.Add('DeliveryRequiredBy', '2019-07-02T06:51:50.13Z');
                        OrderLinesArray.Add(OrderLinesObject);
            */

            //Nested OrderLines-CustomFields
            //OrderLinesObject.Add('CustomFields', '[]');
            Clear(OrderLinesNested);
            Clear(JArray);

            //CN+TW is Aktiv Forædling
            if (PurchaseHeader."Buy-from Country/Region Code" = 'CN') or (PurchaseHeader."Buy-from Country/Region Code" = 'TW') then
                OrderLinesNested.Add('AddOn.CustomsDetails', 'Aktiv forædling')
            else
                OrderLinesNested.Add('AddOn.CustomsDetails', 'Nej');
            JArray.Add(OrderLinesNested);
            OrderLinesObject.Add('CustomFields', JArray);
            //
            OrderLinesArray.Add(OrderLinesObject);
        until PurchaseLine.Next() = 0;
        #endregion //OrderLinesObject

        //Finishing Json structure

        //Order Object Cont..
        //Build Json Structure
        #region #Order Object Cont.. Build Json Structure
        OrderObject.Add('PackLines', PackLinesArray);
        OrderObject.Add('CustomFields', CustomFieldsArray);

        //First put Requested Date, the if exists Promised Date
        if PurchaseHeader."Promised Receipt Date" = 0D then begin
            DateTime := System.CreateDateTime(PurchaseHeader."Requested Receipt Date", DefaultTimeVar);
            OrderObject.Add('RequiredExWorks', DateTime);
        end else begin
            DateTime := System.CreateDateTime(PurchaseHeader."Promised Receipt Date", DefaultTimeVar);
            OrderObject.Add('RequiredExWorks', DateTime);
        end;

        //Calculate +5 weeks for InStore Date
        if CalcDate('<+5W>', DT2Date(DateTime)) = 0D then
            OrderObject.Add('RequiredInStore', '')
        else
            OrderObject.Add('RequiredInStore', CalcDate('<+5W>', DT2Date(DateTime)));

        OrderObject.Add('Parties', PartiesArray);
        OrderObject.Add('ParentOrderNumber', NullJsonValue);
        OrderObject.Add('OrderLines', OrderLinesArray);
        #endregion

        JJsonObject.Add('Order', OrderObject);
        JJsonObject.WriteTo(JsonData);

        exit(JsonData);
    end;

    //Base64Encoding
    local procedure Base64EncodeUserPwd(UserName: Text[100]; Password: Text[100]): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        SubstFormatLbl: Label '%1:%2', Comment = '%1 = Username; %2 = Password', Locked = true;
        AuthString: Text;
    begin
        AuthString := StrSubstNo(SubstFormatLbl, UserName, Password);
        AuthString := Base64Convert.ToBase64(AuthString);
        exit(AuthString);
    end;

    #region Helper Code
    //https://www.kauffmann.nl/2020/07/16/converting-enum-values-in-al/
    local procedure EnumConvertTransportMode(Level: Enum DSVTransportMode): Text
    var
        OrdinalValue: Integer;
        Index: Integer;
        LevelName: Text;
    begin
        OrdinalValue := Level.AsInteger();
        Index := Level.Ordinals.IndexOf(OrdinalValue);
        LevelName := Level.Names.Get(Index);
        exit(LevelName);
    end;

    local procedure GetPurchaserEmail(PurchaserCode: code[20]): Text
    var
        SalespersonPurchaserRec: Record "Salesperson/Purchaser";
    begin
        if SalespersonPurchaserRec.Get(PurchaserCode) then exit(SalespersonPurchaserRec."E-Mail");
    end;

    /// <summary>
    /// getJsonTextField.
    /// </summary>
    /// <param name="o">JsonObject.</param>
    /// <param name="Member">Text.</param>
    /// <returns>Return value of type TextBuilder.</returns>
    procedure getJsonTextField(o: JsonObject; Member: Text): Text
    var
        Result: JsonToken;
    begin
        if o.Get(Member, Result) then
            exit(Result.AsValue().AsText());
    end;



    procedure ProcessJsonArrayWithFor(jsonText: Text): Text
    var
        JArray: JsonArray;
        JToken: JsonToken;
        SummaryText: Text;
        i: Integer;
    begin
        SummaryText := ''; // Initialize the summary text

        // Parse the JSON text into a JsonArray
        if not JArray.ReadFrom(jsonText) then
            Error('Invalid JSON array format.');

        // Iterate over the JSON array using a for loop
        for i := 0 to JArray.Count() - 1 do begin
            JArray.Get(i, JToken);
            SummaryText += ProcessJsonToken(JToken, 'Root Array', 0) + '\'; // Pass the initial level as 0
        end;

        exit(SummaryText); // Return the built summary
    end;

    procedure ProcessJsonToken(JToken: JsonToken; ParentKey: Text; Level: Integer): Text
    var
        NestedArray: JsonArray;
        NestedObject: JsonObject;
        NestedKey: Text;
        NestedToken: JsonToken;
        j: Integer;
        TokenSummary: Text;
        Indentation: Text;
        k: Integer;
    begin
        TokenSummary := ''; // Initialize token summary
        Indentation := ''; // Initialize indentation

        // Build indentation based on the current level
        for k := 1 to Level do
            Indentation += '..'; // Two dots per level

        if JToken.IsObject() then begin
            // Handle JSON Object
            NestedObject := JToken.AsObject();
            foreach NestedKey in NestedObject.Keys do begin
                TokenSummary += Indentation + NestedKey + ' : ';
                if NestedObject.Get(NestedKey, NestedToken) then
                    if NestedToken.IsValue then
                        TokenSummary += Format(NestedToken.AsValue()) + '\'
                    else
                        TokenSummary += ProcessJsonToken(NestedToken, NestedKey, Level + 1) + '\'; // Recursive call with increased level
            end;

        end else
            if JToken.IsArray() then begin
                // Handle JSON Array
                TokenSummary += Indentation + '\--- Array Name: ' + ParentKey + ' ---\' + '\';
                NestedArray := JToken.AsArray();
                for j := 0 to NestedArray.Count() - 1 do begin
                    NestedArray.Get(j, NestedToken);
                    TokenSummary += ProcessJsonToken(NestedToken, ParentKey + '[' + Format(j) + ']', Level + 1) + '\'; // Recursive call with increased level
                end;
            end else
                if JToken.IsValue then
                    // Handle JSON Value
                    TokenSummary += Indentation + ParentKey + ' : ' + Format(JToken.AsValue()) + '\'
                else
                    TokenSummary += Indentation + 'Unhandled JSON token type for ' + ParentKey + '.\';


        exit(TokenSummary);
    end;
    #endregion
}
