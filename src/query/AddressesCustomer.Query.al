



/// <summary>
/// Query Addresses (ID 50004).
/// </summary>
/// <remarks>
/// 2023.08             Jesper Harder       046         Addresses Customer and Vendor
/// </remarks>
query 50004 "AddressesCustomer"
{

    Caption = 'Displays all Customer addresses.';
    QueryType = Normal;
    Permissions =
        tabledata Customer = R,
        tabledata "Ship-to Address" = R;

    elements
    {
        dataitem(Customer; Customer)
        {
            column("CustomerNo"; "No.")
            {
                Caption = 'Customer No.';
            }
            column("CustomerName"; Name)
            {
                Caption = 'Customer Name';
            }
            column(CustomerAddress1; Address)
            {
                Caption = 'Customer Address 1';
            }
            column(CustomerAddress2; "Address 2")
            {
                Caption = 'Customer Address 2';
            }
            column(CustomerPostCode; "Post Code")
            {
            }
            column(CustomerCity; City)
            {
            }
            column(CustomerCountryRegionCode; "Country/Region Code")
            {
            }
            column(CustomerCounty; County)
            {
            }
            column(CustomerEMail; "E-Mail")
            {
            }
            column(CustomerPhoneNo; "Phone No.")
            {
            }
            column(CustomerContact; Contact)
            {
            }
            column(CustomerMobilePhoneNo; "Mobile Phone No.")
            {
            }
            column(CustomerShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(CustomerShippingAgentCode; "Shipping Agent Code")
            {
            }
            column(CustomerShippingAgentServiceCode; "Shipping Agent Service Code")
            {
            }
            dataitem(CustomerShipTox; "Ship-to Address")
            {
                DataItemLink = "Customer No." = Customer."No.";
                SqlJoinType = LeftOuterJoin;

                column(ShipToCode; Code)
                {
                    Caption = 'Customer Ship-To Code';
                }
                column("ShipToName"; Name)
                {
                    Caption = 'Customer Ship-To Name';
                }
                column(ShipToAddress; Address)
                {
                }
                column(ShipToAddress2; "Address 2")
                {
                }
                column(ShipToPostCode; "Post Code")
                {
                }
                column(ShipToCity; City)
                {
                }
                column(ShipToCountryRegionCode; "Country/Region Code")
                {
                }
                column(ShipToCounty; County)
                {
                }
                column(ShipToCustomerNo; "Customer No.")
                {
                }
                column(ShipToEMail; "E-Mail")
                {
                }
                column(ShipToPhoneNo; "Phone No.")
                {
                }
                column(ShipToContact; Contact)
                {
                }
                column(ShipToShippingAgentCode; "Shipping Agent Code")
                {
                }
                column(ShipToShipmentMethodCode; "Shipment Method Code")
                {
                }
                column(ShipToShippingAgentServiceCode; "Shipping Agent Service Code")
                {
                }
            }
        }
    }
}