/// <summary>
/// Page "SCANPANSalesLine" (ID 50020).
/// </summary>
///
/// <remarks>
///
/// 2023.03             Jesper Harder       005         Added
/// 2023.03.27          Jesper Harder       015         Flowfield Tariff - SalesLine
/// 2024.04             Jesper Harder       065         Filter and output of ItemUnitQuantity added
///
/// </remarks>
///
page 50020 "SalesLine"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite, Service;
    Caption = 'Sales Line';
    Editable = true;
    PageType = List;
    Permissions =
        tabledata Customer = R,
        tabledata Item = R,
        tabledata "Sales Header" = R,
        tabledata SalesLineTMP = RIMD,
        tabledata "Salesperson/Purchaser" = R;
    QueryCategory = 'Sales Order List';
    SourceTable = SalesLineTMP;
    //SourceTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const("Order"));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(detaling)
            {
                ShowCaption = false;

                field(CustomerNoFilter; CustomerNoFilter)
                {
                    Caption = 'Sell-To Customer Filter';
                    Editable = true;
                    TableRelation = Customer;
                    ToolTip = 'Specifies the value of the Sell-To Customer Filter field.';
                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(SalesPersonFilter; SalesPersonFilter)
                {
                    Caption = 'Salesperson Filter';
                    Editable = true;
                    TableRelation = "Salesperson/Purchaser";
                    ToolTip = 'Specifies the value of the Salesperson Filter field.';
                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(CountryFilter; CountryFilter)
                {
                    Caption = 'Country Filter';
                    Editable = true;
                    TableRelation = "Country/Region";
                    ToolTip = 'Specifies the value of the Country Filter field.';
                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(ItemUnitsFilter; ItemUnitsFilter)
                {
                    Caption = 'Units Filter';
                    Editable = true;
                    TableRelation = "Unit of Measure";
                    ToolTip = 'Specifies the value of the Unit of Measure Filter field.';
                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(OutstandingQuantityFilter; OutstandingQuantityFilter)
                {
                    Caption = 'Toggle Outstanding Quantity';
                    Enabled = true;
                    ToolTip = 'Toggle Outstanding Quantity filter.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(QtyShippedNotInvoicedFilter; QtyShippedNotInvoicedFilter)
                {
                    Caption = 'Toggle Shipped Not Invoiced';
                    Enabled = true;
                    ToolTip = 'Toggle Shipped Not Invoiced Quantity filter.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(ToggleHeadlines; ToggleHeadlines)
                {
                    Caption = 'Toggle Headlines';
                    Enabled = true;
                    ToolTip = 'Toggle show Headlines.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
            }

            repeater(Control1)
            {
                Editable = false;

                //ShowCaption = false;
                field("Line No."; "Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ToolTip = 'Specifies the value of the Document Status field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesOrderPage: Page "Sales Order";
                    begin
                        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Document No.");
                        SalesOrderPage.SetRecord(SalesHeader);
                        SalesOrderPage.Run();
                    end;
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-To Customer No. field.';
                    trigger OnDrillDown()
                    var
                        Customers: Record Customer;
                        CustomerPage: Page "Customer Card";
                    begin
                        Customers.Get(Rec."Sell-To Customer No.");
                        CustomerPage.SetRecord(Customers);
                        CustomerPage.Run();
                    end;
                }
                field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
                {
                    Style = StrongAccent;
                    StyleExpr = ToggleSellToCustomerNameStyle;
                    ToolTip = 'Specifies the value of the Sell-To Customer Name field.';
                }
                field("Ship-To Name"; Rec."Ship-To Name")
                {
                    ToolTip = 'Specifies the value of the Ship-To Name field.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnDrillDown()
                    var
                        Items: Record Item;
                        ItemPage: Page "Item Card";
                    begin
                        Items.Get(Rec."No.");
                        ItemPage.SetRecord(Items);
                        ItemPage.Run();
                    end;
                }
                field("Item Cross-Reference No."; Rec."Item Cross-Reference No.")
                {
                    ToolTip = 'Specifies the value of the Item Cross-Reference No. field.';
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ToolTip = 'Specifies the value of the Tariff No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ItemUnitCode; ItemUnitCode)
                {
                    ToolTip = 'Specifies the value of the Item Unit Code field.';
                }
                field(ItemUnitQuantity; ItemUnitQuantity)
                {
                    ToolTip = 'Specifies the value of the ItemUnitQuantity field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Quantity; Rec."Quantity")
                {
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Outstanding Quantity field.';
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Qty. Shipped Not Invoiced field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Outstanding Amount field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Planned Shipment Date field.';
                }
                field("External Ref."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                    trigger OnDrillDown()
                    var
                        SalesPerson: Record "Salesperson/Purchaser";
                        SalesPersonPage: Page "Salesperson/Purchaser Card";
                    begin
                        SalesPerson.Get(Rec."Salesperson Code");
                        SalesPersonPage.SetRecord(SalesPerson);
                        SalesPersonPage.Run();
                    end;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the value of the Order Priority field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite, Service;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
            }
        }
    }
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        OutstandingQuantityFilter: Boolean;

        QtyShippedNotInvoicedFilter: Boolean;
        ToggleHeadlines: Boolean;

        ToggleSellToCustomerNameStyle: Boolean;
        CountryFilter: code[50];
        CustomerNoFilter: Code[50];
        SalesPersonFilter: code[50];
        ItemUnitsFilter: code[50];

    trigger OnInit()
    var
    begin
        ToggleHeadlines := true;
        ScanpanMiscellaneous.FillSalesLineListPage(Rec, false, '', '', '', false, true, '');
    end;

    trigger OnAfterGetRecord()
    var
    begin
        ToggleSellToCustomerNameStyle := false;
        if Rec."Document No." = '' then ToggleSellToCustomerNameStyle := true;
    end;

    local procedure UpdateFilters()
    var
    begin
        ScanpanMiscellaneous.FillSalesLineListPage(Rec, QtyShippedNotInvoicedFilter, SalesPersonFilter, CountryFilter, CustomerNoFilter, OutstandingQuantityFilter, ToggleHeadlines, ItemUnitsFilter);
    end;
}
