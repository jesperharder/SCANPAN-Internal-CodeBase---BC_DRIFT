/// <summary>
/// Page SalesLine Subform (ID 50033).
/// </summary>
///
/// <remarks>
///
/// https://ivansingleton.dev/a-simple-way-to-filter-pages-in-business-central-using-filterpagebuilder/
///
/// </remarks>

page 50033 "SalesLine Subform"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = '(DEV)Sales Line Subform';
    Editable = false;
    PageType = List;
    Permissions =
        tabledata SalesLineTMP = R;
    QueryCategory = 'Sales Order List';
    SourceTable = SalesLineTMP;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Editable = false;

                //ShowCaption = false;
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Sales Order";
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Sell-To Customer No."; "Sell-To Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Sell-To Customer No. field.';
                }
                field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Style = StrongAccent;
                    StyleExpr = ToggleSellToCustomerNameStyle;
                    ToolTip = 'Specifies the value of the Sell-To Customer Name field.';
                }
                field("Ship-To Name"; "Ship-To Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Ship-To Name field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Item Card";
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Item Cross-Reference No."; Rec."Item Cross-Reference No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item Cross-Reference No. field.';
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Tariff No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Outstanding Quantity field.';
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Qty. Shipped Not Invoiced field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankNumbers = BlankZero;
                    DecimalPlaces = 0;
                    ToolTip = 'Specifies the value of the Outstanding Amount field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Planned Shipment Date field.';
                }
                field("External Ref."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Order Priority field.';
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action(ShowFilterpage)
            {
                ApplicationArea = all;
                Caption = 'Filterpage';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Filterpage action.';
                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    FilterPageCaptionLbl: Label 'Salesline Filter Page';
                begin
                    FilterPage.PageCaption := FilterPageCaptionLbl;
                    FilterPage.AddTable('SalesLine', Database::SalesLineTMP);
                    FilterPage.AddField('SalesLine', Rec."Country Code");
                    FilterPage.AddField('SalesLine', Rec."Salesperson Code");
                    FilterPage.AddField('SalesLine', Rec."Sell-To Customer No.");
                    FilterPage.AddField('SalesLine', Rec."Ship-To Name");
                    FilterPage.AddField('SalesLine', Rec."Outstanding Quantity", '<>0');
                    FilterPage.AddField('SalesLine', Rec."Qty. Shipped Not Invoiced", '<>0');
                    FilterPage.AddField('SalesLine', Rec.Type, 'Vare');

                    if FilterPage.RunModal() then begin
                        Rec.SetView(FilterPage.GetView('SalesLine'));
                        Rec.FindFirst();
                    end;
                end;
            }
        }
    }

    views
    {
        view(Salesperson)
        {
            Caption = 'Filter on Salesperson';
            Filters = where("Salesperson Code" = filter('*'));
        }
        view(Country)
        {
            Caption = 'Filter on Country';
            Filters = where("Country Code" = filter('*'));
        }
        view(ShippedNotInvoiced)
        {
            Caption = 'Show Shipped Not Invoiced';
            Filters = where("Qty. Shipped Not Invoiced" = filter('<>0'));
        }
        view(OutstandingQty)
        {
            Caption = 'Show Outstanding Quantity';
            Filters = where("Outstanding Quantity" = filter('<>0'));
        }
        view(ShowItemLines)
        {
            Caption = 'Disable Headers';
            Filters = where(Type = filter('VARE'));
        }
    }

    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;

        ToggleSellToCustomerNameStyle: Boolean;

    trigger OnInit()
    begin
        ScanpanMiscellaneous.FillSalesLineListPage(Rec, false, '', '', '', false, true, '');
    end;

    trigger OnAfterGetRecord()
    begin
        ToggleSellToCustomerNameStyle := false;
        if Rec."Document No." = '' then ToggleSellToCustomerNameStyle := true;
    end;
}