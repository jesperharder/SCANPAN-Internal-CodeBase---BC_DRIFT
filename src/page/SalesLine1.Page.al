


/// <summary>
/// Page "SCANPANSalesLine" (ID 50020).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03                     Jesper Harder                   005     Added
/// 2023.03.27                  Jesper Harder                   015     Flowfield Tariff - SalesLine   
/// 
/// </remarks>
/// 
/// 


page 50034 "SalesLine1"
{
    ApplicationArea = Basic, Suite, Service;
    AdditionalSearchTerms = 'Scanpan';
    Caption = '(DEV)Sales Line';
    PageType = Document;
    SourceTable = SalesLineTMP;
    //SourceTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const("Order"));
    UsageCategory = Lists;
    QueryCategory = 'Sales Order List';
    Editable = true;

    layout
    {

        area(Content)
        {
            group(detaling)
            {
                ShowCaption = false;

                field(CustomerNoFilter; CustomerNoFilter)
                {
                    Editable = true;
                    Caption = 'Sell-To Customer Filter';
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
                    Editable = true;
                    Caption = 'Salesperson Filter';
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
                    Editable = true;
                    Caption = 'Country Filter';
                    TableRelation = "Country/Region";
                    ToolTip = 'Specifies the value of the Country Filter field.';
                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(OutstandingQuantityFilter; OutstandingQuantityFilter)
                {
                    Enabled = true;
                    Caption = 'Toggle Outstanding Quantity';
                    ToolTip = 'Toggle Outstanding Quantity filter.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(QtyShippedNotInvoicedFilter; QtyShippedNotInvoicedFilter)
                {
                    Enabled = true;
                    Caption = 'Toggle Shipped Not Invoiced';
                    ToolTip = 'Toggle Shipped Not Invoiced Quantity filter.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;
                }
                field(ToggleHeadlines; ToggleHeadlines)
                {
                    Enabled = true;
                    Caption = 'Toggle Headlines';
                    ToolTip = 'Toggle show Headlines.';

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilters();
                    end;

                }
            }

        }
    }

    var
        SCANPANmisc: Codeunit ScanpanMiscellaneous;
        CustomerNoFilter: Code[50];
        SalesPersonFilter: code[50];
        CountryFilter: code[50];

        QtyShippedNotInvoicedFilter: Boolean;
        OutstandingQuantityFilter: Boolean;

        ToggleSellToCustomerNameStyle: Boolean;
        ToggleHeadlines: Boolean;

    trigger OnInit()
    var
    begin
        ToggleHeadlines := true;
        SCANPANmisc.FillSalesLineListPage(Rec, false, '', '', '', false, true, '');
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
        SCANPANmisc.FillSalesLineListPage(Rec, QtyShippedNotInvoicedFilter, SalesPersonFilter, CountryFilter, CustomerNoFilter, OutstandingQuantityFilter, ToggleHeadlines, '');
    end;




}

