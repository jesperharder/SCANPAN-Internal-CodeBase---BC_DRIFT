/// <summary>
/// Page Addresses (ID 50005).
/// </summary>
/// <remarks>
/// 2023.08             Jesper Harder       046         Addresses Customer and Vendor
/// </remarks>

page 50005 "Addresses"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'All Customer Addresses';
    PageType = List;
    Permissions =
        tabledata "Address List" = RIMD,
        tabledata Vendor = R;
    SourceTable = "Address List";
    //SourceTableTemporary = true;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater("Customers")
            {
                field(LineNo; Rec.LineNo)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Visible = isvisible;
                }
                field(AddressType; Rec.AddressType)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Address Type field.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Address Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Address Line 1"; Rec."Address Line 1")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Address Line 1 field.';
                }
                field("Address Line 2"; Rec."Address Line 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Address Line 2 field.';
                }
                field("House Number"; Rec."House Number")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the House Number field.';
                }
                field(ZipCode; Rec.ZipCode)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Zip Code field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the E-mail field.';
                }
                field(Phone; Rec.Phone)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Phone field.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Contact field.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Shipping Agent Code field.';
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Shipping Method Code field.';
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Shipment Code field.';
                }
            }
        }
    }

    var
        isvisible: Boolean;

    trigger OnOpenPage()
    var
        Vendor: Record Vendor;
        AddressesCustomerQuery: Query AddressesCustomer;
        AddressTypeEnum: enum "Address Types";
        LineNoInteger: Integer;
        LastCustomerNo: Text[100];
    begin
        if AddressesCustomerQuery.Open() then begin
            while AddressesCustomerQuery.Read() do begin
                if AddressesCustomerQuery.CustomerNo <> LastCustomerNo then begin
                    LastCustomerNo := AddressesCustomerQuery.CustomerNo;
                    LineNoInteger += 1;
                    Rec.Init();
                    Rec.LineNo := LineNoInteger;
                    Rec.AddressType := AddressTypeEnum::Customer;
                    Rec.Code := AddressesCustomerQuery.CustomerNo;
                    Rec.Name := AddressesCustomerQuery.CustomerName;
                    Rec."Address Line 1" := AddressesCustomerQuery.CustomerAddress1;
                    Rec."Address Line 2" := AddressesCustomerQuery.CustomerAddress2;
                    Rec.ZipCode := AddressesCustomerQuery.CustomerPostCode;
                    Rec.City := AddressesCustomerQuery.CustomerCity;
                    Rec.Province := AddressesCustomerQuery.CustomerCounty;
                    Rec.Country := AddressesCustomerQuery.CustomerCountryRegionCode;
                    Rec."E-mail" := AddressesCustomerQuery.CustomerEMail;
                    Rec.Phone := AddressesCustomerQuery.CustomerPhoneNo;
                    Rec.Contact := AddressesCustomerQuery.CustomerContact;
                    Rec."Shipping Agent Code" := AddressesCustomerQuery.CustomerShippingAgentCode;
                    Rec."Shipping Agent Service Code" := AddressesCustomerQuery.CustomerShippingAgentServiceCode;
                    Rec."Shipment Method Code" := AddressesCustomerQuery.CustomerShipmentMethodCode;
                    Rec."House Number" := GetStreetNumber(AddressesCustomerQuery.CustomerAddress1);

                    Rec.Insert(true);
                end;
                if AddressesCustomerQuery.ShipToCode <> '' then begin
                    LineNoInteger += 1;
                    Rec.Init();
                    Rec.LineNo := LineNoInteger;
                    Rec.AddressType := AddressTypeEnum::"Customer Ship-To";
                    Rec.Code := AddressesCustomerQuery.CustomerNo + '(' + AddressesCustomerQuery.ShipToCode + ')';
                    Rec.Name := AddressesCustomerQuery.ShipToName;
                    Rec."Address Line 1" := AddressesCustomerQuery.ShipToAddress;
                    Rec."Address Line 2" := AddressesCustomerQuery.ShipToAddress2;
                    Rec.ZipCode := AddressesCustomerQuery.ShipToPostCode;
                    Rec.City := AddressesCustomerQuery.ShipToCity;
                    Rec.Province := AddressesCustomerQuery.ShipToCounty;
                    Rec.Country := AddressesCustomerQuery.ShipToCountryRegionCode;
                    Rec."E-mail" := AddressesCustomerQuery.ShipToEMail;
                    Rec.Phone := AddressesCustomerQuery.ShipToPhoneNo;
                    Rec.Contact := AddressesCustomerQuery.ShipToContact;
                    Rec."Shipping Agent Code" := AddressesCustomerQuery.shiptoShippingAgentCode;
                    Rec."Shipping Agent Service Code" := AddressesCustomerQuery.ShipToShippingAgentServiceCode;
                    Rec."Shipment Method Code" := AddressesCustomerQuery.ShipToShipmentMethodCode;
                    Rec."House Number" := GetStreetNumber(AddressesCustomerQuery.ShipToAddress);
                    Rec.Insert(true);
                end;
            end;
            AddressesCustomerQuery.Close();
        end;
        //Vendor
        Vendor.Reset();
        Vendor.FindSet();
        repeat
            LineNoInteger += 1;
            Rec.Init();
            Rec.LineNo := LineNoInteger;
            Rec.AddressType := AddressTypeEnum::Vendor;
            Rec.Code := Vendor."No.";
            Rec.Name := Vendor.Name;
            Rec."Address Line 1" := Vendor.Address;
            Rec."Address Line 2" := Vendor."Address 2";
            Rec.ZipCode := Vendor."Post Code";
            Rec.City := Vendor.City;
            Rec.Province := Vendor.County;
            Rec.Country := Vendor."Country/Region Code";
            Rec."E-mail" := Vendor."E-Mail";
            Rec.Phone := Vendor."Phone No.";
            Rec.Contact := Vendor.Contact;
            Rec."Shipping Agent Code" := Vendor."Shipping Agent Code";
            Rec."Shipping Agent Service Code" := '';
            Rec."Shipment Method Code" := Vendor."Shipment Method Code";
            Rec."House Number" := GetStreetNumber(Vendor.Address);
            Rec.Insert(true);
        until Vendor.Next() = 0;
    end;

    local procedure GetStreetNumber(AddressText: Text[100]): Text[100]
    var
        i: Integer;
    begin
        i := AddressText.LastIndexOf(' ');
        if i > 0 then exit(CopyStr(AddressText, i, StrLen(AddressText)));
    end;
}
