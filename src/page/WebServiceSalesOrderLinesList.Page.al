
page 50053 "WebServiceSalesOrderLinesList"
{
    ///<summary>
    /// 2024.09  Jesper Harder  081  API displaying Sales orders for integration with Makes You Local
    ///
    /// Defines a Business Central page that lists sales order lines from two companies.
    /// Combines data from Sales Header and Sales Line tables into a temporary table.
    /// Displays order details, customer information, item data, and shipment status.
    /// Uses ChangeCompany to fetch data from 'SCANPAN Norge' and 'SCANPAN Danmark'.
    /// Facilitates integration with "Makes You Local" by providing consolidated sales data.
    ///</summary>

    Caption = 'Sales Order Lines API';           // Sets the caption of the page
    AdditionalSearchTerms = 'Scanpan, Makes You Local, API, WEB, WebInterface'; // Additional Search Terms
    PageType = List;                              // Specifies that this is a List page
    SourceTable = "SalesOrderLineTemp";           // Sets the source table to our temporary table
    SourceTableTemporary = true;                  // Indicates that the source table is a temporary table
    Editable = false;
    UsageCategory = Lists;                        // Places the page under the "Lists" category in the navigation
    ApplicationArea = All;                        // Makes the page available in all application areas

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company from which the sales order originates.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the unique number assigned to the sales order.';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the current status of the sales order document.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the date on which the sales order was created.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the number of the customer who placed the sales order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the name of the customer who placed the sales order.';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the primary address of the customer.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays additional address information for the customer.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the city where the customer is located.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the postal code of the customer''s address.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country or region code for the customer''s address.';
                }
                field("Contact"; Rec."Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Provides the contact person or information for the customer.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the phone number of the customer.';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the email address of the customer.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the line number within the sales order, representing a specific item or service.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of item on the sales line, such as Item, Resource, or G/L Account.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the unique number of the item or resource on the sales line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Provides a description of the item or service on the sales line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the total quantity ordered for the item or service on this sales line.';
                }
                field("Quantity to Ship"; Rec."Quantity to Ship")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the quantity remaining to be shipped for this sales line.';
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the quantity that has already been shipped for this sales line.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the total amount for this sales line.';
                }
                // Existing fields...

                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the shipping agent handling this order.';
                }
                field("Shipping Agent Name"; Rec."Shipping Agent Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the name of the shipping agent handling this order.';
                }
                field("Shipping Agent URL"; Rec."Shipping Agent URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the website URL of the shipping agent.';
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the shipping service used for this order.';
                }
                field("Shipping Agent Service Name"; Rec."Shipping Agent Service Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Provides the name of the shipping service used for this order.';
                }
                field("Track & Trace Number"; Rec."Track & Trace Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Provides the tracking number to trace the shipment of this order.';
                }
                field("Track & Trace URL"; Rec."Track & Trace URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Provides the full URL for tracking this shipment.';
                }
                // Add other fields as needed with appropriate tooltips
            }
        }
    }

    actions
    {
        // Add actions if necessary
    }

    var
        SalesLine: Record "Sales Line";                   // Record variable for Sales Line table
        SalesHeader: Record "Sales Header";               // Record variable for Sales Header table
        "XTECSCShipmentLog": Record "XTECSC Shipment Log";        // Record variable for Shipment Log table
        ShippingAgent: Record "Shipping Agent";           // Record variable for Shipping Agent
        ShippingAgentServices: Record "Shipping Agent Services"; // Record variable for Shipping Agent Service
        CompanyNames: array[3] of Text[30];               // Array to hold company names
        CurrentCompanyName: Text[30];                     // Variable to hold the current company name

    trigger OnOpenPage()
    var
        i: Integer;                                       // Loop counter
    begin
        // Ensure the temporary table is empty
        Rec.DeleteAll();

        // Define the companies to fetch data from
        CompanyNames[1] := 'SCANPAN Norge';
        CompanyNames[2] := 'SCANPAN Danmark';

        // Loop through each company
        for i := 1 to 2 do begin
            CurrentCompanyName := CompanyNames[i];

            // Set up record variables for the company
            SalesHeader.ChangeCompany(CurrentCompanyName);
            SalesLine.ChangeCompany(CurrentCompanyName);
            "XTECSCShipmentLog".ChangeCompany(CurrentCompanyName);
            ShippingAgent.ChangeCompany(CurrentCompanyName);
            ShippingAgentServices.ChangeCompany(CurrentCompanyName);

            // Filter Sales Header to include only Sales Orders
            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);

            // Apply Sell-to Customer No. filters based on the company
            if CurrentCompanyName = 'SCANPAN Norge' then
                SalesHeader.SetRange("Sell-to Customer No.", '8245')    // Filter for Norge
            else
                SalesHeader.SetFilter("Sell-to Customer No.", '1919|1921'); // Filter for Danmark

            // Loop through the filtered Sales Headers
            if SalesHeader.FindSet() then
                repeat
                    // Retrieve Sales Lines for this Sales Header
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", SalesHeader."No.");

                    // Loop through the Sales Lines
                    if SalesLine.FindSet() then
                        repeat
                            // Initialize temporary record
                            Rec.Init();
                            Rec."Company Name" := CurrentCompanyName;
                            Rec."Order No." := SalesHeader."No.";
                            Rec."Document Status" := SalesHeader.Status;
                            Rec."Order Date" := SalesHeader."Order Date";
                            Rec."Customer No." := SalesHeader."Sell-to Customer No.";
                            Rec."Customer Name" := SalesHeader."Sell-to Customer Name";
                            Rec."Address" := SalesHeader."Sell-to Address";
                            Rec."Address 2" := SalesHeader."Sell-to Address 2";
                            Rec."City" := SalesHeader."Sell-to City";
                            Rec."Post Code" := SalesHeader."Sell-to Post Code";
                            Rec."Country/Region Code" := SalesHeader."Sell-to Country/Region Code";
                            Rec."Contact" := SalesHeader."Sell-to Contact";
                            Rec."Phone No." := SalesHeader."Sell-to Phone No.";
                            Rec."Email" := SalesHeader."Sell-to E-Mail";
                            Rec."Line No." := SalesLine."Line No.";
                            Rec."Item Type" := SalesLine.Type;
                            Rec."Item No." := SalesLine."No.";
                            Rec.Description := SalesLine.Description;
                            Rec.Quantity := SalesLine.Quantity;
                            Rec."Quantity to Ship" := SalesLine."Outstanding Quantity";
                            Rec."Quantity Shipped" := SalesLine."Quantity Shipped";
                            Rec."Line Amount" := SalesLine."Line Amount";

                            // Fetch Shipping Information from Shipment Log
                            "XTECSCShipmentLog".Reset();
                            "XTECSCShipmentLog".SetRange("Shipment Type", "XTECSCShipmentLog"."Shipment Type"::"Sales Order");
                            "XTECSCShipmentLog".SetRange("Order No.", SalesHeader."No.");
                            // ShipmentLog.SetRange("Order Line No.", SalesLine."Line No."); // Uncomment if needed
                            if "XTECSCShipmentLog".FindLast() then begin
                                Rec."Shipping Agent Code" := "XTECSCShipmentLog"."Shipping Agent";
                                Rec."Shipping Agent Service Code" := "XTECSCShipmentLog"."Shipping Agent Service";
                                Rec."Track & Trace Number" := "XTECSCShipmentLog"."Track & Trace Number";

                                // Lookup Shipping Agent Name and URL
                                ShippingAgent.Reset();
                                ShippingAgent.SetRange("Code", "XTECSCShipmentLog"."Shipping Agent");
                                if ShippingAgent.FindFirst() then begin
                                    Rec."Shipping Agent Name" := ShippingAgent.Name;
                                    Rec."Shipping Agent URL" := ShippingAgent."Internet Address";
                                end else begin
                                    Rec."Shipping Agent Name" := '';
                                    Rec."Shipping Agent URL" := '';
                                end;

                                // Lookup Shipping Agent Service Name
                                ShippingAgentServices.Reset();
                                ShippingAgentServices.SetRange("Shipping Agent Code", "XTECSCShipmentLog"."Shipping Agent");
                                ShippingAgentServices.SetRange("Code", "XTECSCShipmentLog"."Shipping Agent Service");
                                if ShippingAgentServices.FindFirst() then
                                    Rec."Shipping Agent Service Name" := ShippingAgentServices.Description
                                else
                                    Rec."Shipping Agent Service Name" := '';

                                // Construct the Track & Trace URL
                                if Rec."Shipping Agent URL" <> '' then
                                    Rec."Track & Trace URL" := StrSubstNo(Rec."Shipping Agent URL", Rec."Track & Trace Number")
                                else
                                    Rec."Track & Trace URL" := '';
                            end else begin
                                Rec."Shipping Agent Code" := '';
                                Rec."Shipping Agent Service Code" := '';
                                Rec."Track & Trace Number" := '';
                                Rec."Shipping Agent Name" := '';
                                Rec."Shipping Agent URL" := '';
                                Rec."Shipping Agent Service Name" := '';
                                Rec."Track & Trace URL" := '';
                            end;

                            // Insert into temporary table
                            Rec.Insert();
                        until SalesLine.Next() = 0;    // Move to the next Sales Line
                until SalesHeader.Next() = 0;          // Move to the next Sales Header

            // Reset ChangeCompany for the next iteration
            SalesHeader.ChangeCompany('');
            SalesLine.ChangeCompany('');
            "XTECSCShipmentLog".ChangeCompany('');
            ShippingAgent.ChangeCompany('');
            ShippingAgentServices.ChangeCompany('');
        end;
    end;
}
