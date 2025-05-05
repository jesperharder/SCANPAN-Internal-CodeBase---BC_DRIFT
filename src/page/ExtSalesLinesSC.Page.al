/// <summary>
/// Page SCANPANNotInvoicedSalesSubPage (ID 50014).
/// </summary>
///
/// <remarks>
///
///  2023.03.08                     Jesper Harder               0292               Salesperson Salesorder tools.
///
/// https://community.dynamics.com/business/b/that-nav-guy/posts/style-color
///
/// </remarks>
page 50014 "ExtSalesLinesSC"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Sales Ext SalesLines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    Permissions =
        tabledata Campaign = R,
        tabledata "Default Dimension" = R,
        tabledata "Dimension Value" = R,
        tabledata ExtSalesLines = RIMD,
        tabledata MapCustomerSalesPerson = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = R,
        tabledata User = R;
    SourceTable = ExtSalesLines;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(filter)
            {
                Caption = 'Filter';
                group(filter1)
                {
                    ShowCaption = false;

                    field(ChainGroupFilter; ChainGroupFilter)
                    {
                        Caption = 'Chaingroup Filter';
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('KÆDE'), "Dimension Value Type" = const(Standard));
                        ToolTip = 'Sets filter on Customer Chaingroup';
                        trigger OnValidate()
                        var
                        begin
                            SetFilterChainGroup();
                        end;
                    }
                }
                group(filter2)
                {
                    ShowCaption = false;
                }
            }
            group(linesrepeater)
            {
                ShowCaption = false;

                repeater(General)
                {
                    Editable = false;

                    field("Line No."; Rec."Line No.")
                    {
                        Caption = 'Line No.';
                        ToolTip = 'Specifies the value of the Line No. field.';
                    }
                    field("SalesLine LineNo"; Rec."SalesLine LineNo")
                    {
                        Caption = 'Salesline Line No.';
                        ToolTip = 'Specifies the value of the Salesline Line No. field.';
                        Visible = false;
                    }
                    field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Style = StrongAccent;
                        StyleExpr = StyleSellToCustomerName;
                        ToolTip = 'Specifies the Sales Header Sell-to Customer Name.';
                        Visible = true;
                    }
                    field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Sell-to Customer No.';
                        Visible = false;
                    }
                    field("Ship-to Name"; SalesHeaderGobal."Ship-to Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Sales Header Sell-to Customer Name.';
                        Visible = false;
                    }
                    field("Document No."; Rec."Document No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the document number.';
                        Visible = true;
                    }
                    field("Type"; Rec."Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the line type.';
                        Visible = false;
                    }
                    field("No."; Rec."No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Item of the record.';
                        Visible = true;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies a description of the item or service on the line.';
                        Visible = true;
                    }
                    field("Used Campaign NOTO"; Rec."Used Campaign NOTO")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Campaign Code.';
                        Visible = false;
                    }
                    field(CampaignsDescription; CampaignsGlobal.Description)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Campaign Description';
                        Visible = false;
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the quantity of the sales order line.';
                        Visible = true;
                    }
                    field("Outstanding Quantity"; Rec."Outstanding Quantity")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Outstanding Quantity.';
                        Visible = true;
                    }
                    field("Qty. to Ship"; Rec."Qty. to Ship")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the quantity of items that remain to be shipped.';
                        Visible = false;
                    }
                    field("Quantity Shipped"; Rec."Quantity Shipped")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
                        Visible = false;
                    }
                    field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Qty. Shipped Not Invd. (Base) field.';
                        Visible = false;
                    }
                    field("Qty. to Invoice"; Rec."Qty. to Invoice")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                        Visible = false;
                    }
                    field("Quantity Invoiced"; Rec."Quantity Invoiced")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
                        Visible = false;
                    }
                    field("Line Amount"; Rec."Line Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Line Amount.';
                        Visible = true;
                    }
                    field("Currency Code"; Rec."Currency Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Currency Code.';
                        Visible = false;
                    }
                    field("Salesperson Code"; Rec."Salesperson Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Salesperson Code.';
                        Visible = true;
                    }
                    field("Requested Delivery Date"; Rec."Requested Delivery Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Requested Delivery Date.';
                        Visible = true;
                    }
                    field("ChainGroup Code"; Rec."ChainGroup Code")
                    {
                        //Visible = false;
                        Caption = 'Chaingroup Code';
                        Importance = Additional;
                        ToolTip = 'Specifies the value of the Chaingroup Code field.';
                        Visible = false;
                    }
                    field("ChainGroup Name"; Rec."ChainGroup Name")
                    {
                        Caption = 'Chaingroup Name';
                        Importance = Standard;
                        ToolTip = 'Specifies the value of the Chaingroup Name field.';
                        Visible = false;
                    }
                }
            }
            group(Details)
            {
                Caption = 'Sales Details';

                group(CustomerDetails)
                {
                    Caption = 'Customer Order Details';
                    ShowCaption = false;

                    field(SellToCustomerName; SellToCustomerName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sell-To Customer Name';
                        Importance = Standard;
                        ToolTip = 'Shows selected line Sell-To Customer Name.';
                    }
                    field(ShipToName; ShipToName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ship-To Name';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Shows selected line Ship-To Name.';
                    }
                    field(DocumentNo; DocumentNoGlobal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Order No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Shows selected line Order No.';
                    }
                }
                group(AmountStats)
                {
                    ShowCaption = false;

                    field(SalesTotal; SalesTotal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Total';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Shows Total Sales Amount.';
                    }
                    field(CustomerTotal; CustomerTotal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Total';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Shows Customer Total of selected Customer No.';
                    }
                    field(OrderTotal; OrderTotal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Order Total';
                        Editable = false;
                        Importance = Standard;
                        ToolTip = 'Shows Order Total of selected Order No.';
                    }
                }
            }
        }
    }
    /*
    actions
    {
        area(Processing)
        {
            action(ToggleInvNotShpd)
            {
                Caption = 'Show Shipped Not Invoiced';
                ToolTip = 'Toggles lines with Shipped not Invoiced.';
                trigger OnAction()
                var
                begin
                    ToggleShippedNotInvoiced := Not ToggleShippedNotInvoiced;
                    ToggleNotInvoicedQty(ToggleShippedNotInvoiced);
                end;
            }
        }
    }
    */
    var

        CampaignsGlobal: Record Campaign;

        SalesHeaderGobal: Record "Sales Header";
        StyleSellToCustomerName: Boolean;

        DocumentNoGlobal: Code[20];
        CustomerTotal: Decimal;
        OrderTotal: Decimal;
        SalesTotal: Decimal;

        ChainGroupFilter: Text;
        SellToCustomerName: Text;
        ShipToName: Text;

    trigger OnInit()
    var

    begin
        FillSalesLines(Rec);
        SalesTotal := GetSalesTotal();
    end;

    trigger OnAfterGetRecord()
    var

    begin
        StyleSellToCustomerName := Rec.SetStyleExpr;
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        DocumentNoGlobal := Rec."Document No.";
        OrderTotal := GetOrderTotal(Rec."Document No.");
        CustomerTotal := GetCustomerTotal(Rec."Sell-to Customer No.");

        SellToCustomerName := '';
        ShipToName := '';
        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Document No.") then begin
            SellToCustomerName := SalesHeader."Sell-to Customer Name";
            ShipToName := SalesHeader."Ship-to Name";
        end;
    end;

    /// <summary>
    /// UpdateLines.
    /// </summary>
    /// <param name="ToggleNotInvoicedQtyBoolean">Boolean.</param>
    procedure ToggleNotInvoicedQty(ToggleNotInvoicedQtyBoolean: Boolean)
    var
    begin
        Rec.SetRange("Qty. Shipped Not Invoiced");
        if ToggleNotInvoicedQtyBoolean then Rec.SetFilter("Qty. Shipped Not Invoiced", '<>0');
        CurrPage.Update();
    end;

    local procedure FillSalesLines(var RecExtSalesLines: Record ExtSalesLines)
    var
        User: Record User;
        MapCustomerSalesPerson: Record MapCustomerSalesPerson;

        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";

        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        Campaigns: Record Campaign;
        LineNo: Integer;
        SalesPersonFilter: Text;
        SalesPersonFilterShowAll: Boolean;
        NewSalesOrder: code[20];
    begin
        NewSalesOrder := '';
        User.Get(UserSecurityId());
        MapCustomerSalesPerson.SetFilter(UserName, User."User Name");
        SalesPersonFilterShowAll := false;
        if MapCustomerSalesPerson.FindSet() then begin
            repeat
                if MapCustomerSalesPerson.ShowAllCustomers then SalesPersonFilterShowAll := true;
                if MapCustomerSalesPerson.CustomerSalesCode <> '' then SalesPersonFilter += MapCustomerSalesPerson.CustomerSalesCode + '|';
            until MapCustomerSalesPerson.Next() = 0;
            if SalesPersonFilter <> '' then SalesPersonFilter := Format(SalesPersonFilter, StrLen(SalesPersonFilter) - 1);
            SalesHeader.SetFilter("Salesperson Code", SalesPersonFilter);
            if SalesPersonFilterShowAll then SalesHeader.SetRange("Salesperson Code");
        end else
            Exit;

        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::Order);
        SalesLine.SetFilter("Document Type", '%1', SalesLine."Document Type"::Order);
        SalesLine.SetFilter(Type, '%1|%2', SalesLine.Type::Item, SalesLine.Type::"G/L Account");

        if SalesHeader.FindSet() then begin
            repeat
                SalesLine.SetFilter("Document No.", SalesHeader."No.");
                if NewSalesOrder <> SalesHeader."No." then begin
                    NewSalesOrder := SalesHeader."No.";
                    RecExtSalesLines.Init();
                    LineNo += 1;
                    RecExtSalesLines."Line No." := LineNo;
                    RecExtSalesLines."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                    RecExtSalesLines.SetStyleExpr := true;
                    if RecExtSalesLines.Insert() then;
                end;
                if SalesLine.FindSet() then
                    repeat
                        RecExtSalesLines.Init();
                        LineNo += 1;
                        RecExtSalesLines."Line No." := LineNo;
                        RecExtSalesLines."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                        RecExtSalesLines."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                        RecExtSalesLines."Ship-to Name" := SalesHeader."Ship-to Name";
                        RecExtSalesLines."Document No." := SalesHeader."No.";
                        RecExtSalesLines."SalesLine LineNo" := SalesLine."Line No.";
                        RecExtSalesLines."Type" := Format(SalesLine."Type");
                        RecExtSalesLines."No." := SalesLine."No.";
                        RecExtSalesLines.Description := SalesLine.Description;
                        RecExtSalesLines."Used Campaign NOTO" := SalesLine."Used Campaign NOTO";
                        if Campaigns.get(SalesLine."Used Campaign NOTO") then RecExtSalesLines.CampaignsDescription := Campaigns.Description;
                        RecExtSalesLines.Quantity := SalesLine.Quantity;
                        RecExtSalesLines."Outstanding Quantity" := SalesLine."Outstanding Qty. (Base)";
                        RecExtSalesLines."Qty. to Ship" := SalesLine."Qty. to Ship (Base)";
                        RecExtSalesLines."Quantity Shipped" := SalesLine."Qty. Shipped (Base)";
                        RecExtSalesLines."Qty. Shipped Not Invoiced" := SalesLine."Qty. Shipped Not Invoiced";
                        RecExtSalesLines."Qty. to Invoice" := SalesLine."Qty. to Invoice (Base)";
                        RecExtSalesLines."Quantity Invoiced" := SalesLine."Qty. Invoiced (Base)";
                        RecExtSalesLines."Line Amount" := SalesLine.Amount;
                        RecExtSalesLines."Currency Code" := SalesLine."Currency Code";
                        RecExtSalesLines."Salesperson Code" := SalesHeader."Salesperson Code";
                        RecExtSalesLines."Requested Delivery Date" := SalesLine."Requested Delivery Date";

                        //Customers.Get(SalesHeader."Sell-to Customer No.");
                        if DefaultDimension.Get('18', SalesHeader."Sell-to Customer No.", 'KÆDE') then begin
                            RecExtSalesLines."ChainGroup Code" := DefaultDimension."Dimension Value Code";
                            DimensionValue.Get('KÆDE', DefaultDimension."Dimension Value Code");
                            RecExtSalesLines."ChainGroup Name" := DimensionValue.Name;
                        end;

                        if RecExtSalesLines.Insert() then;
                    until SalesLine.Next() = 0;
            until SalesHeader.Next() = 0;
            RecExtSalesLines.SetCurrentKey("Sell-to Customer No.", "Document No.", "No.");
            if RecExtSalesLines.FindFirst() then;
        end;
    end;

    local procedure GetCustomerTotal(SellToCustomerNo: code[20]): Decimal;
    var
        ExtSalesLines: Record ExtSalesLines;
        Totals: Decimal;
    begin
        ExtSalesLines.Copy(Rec, true);
        ExtSalesLines.Reset();
        ExtSalesLines.SetFilter("Sell-to Customer No.", SellToCustomerNo);
        if ExtSalesLines.FindSet() then
            repeat
                Totals += ExtSalesLines."Line Amount";
            until ExtSalesLines.Next() = 0;
        exit(Totals);
    end;

    local procedure GetOrderTotal(DocumentNoOrderTotal: code[20]): Decimal;
    var
        ExtSalesLines: Record ExtSalesLines;
        Totals: Decimal;
    begin
        ExtSalesLines.Copy(Rec, true);
        ExtSalesLines.Reset();
        ExtSalesLines.SetFilter("Document No.", DocumentNoOrderTotal);
        if ExtSalesLines.FindSet() then
            repeat
                Totals += ExtSalesLines."Line Amount";
            until ExtSalesLines.Next() = 0;

        exit(Totals);
    end;

    local procedure GetSalesTotal(): Decimal;
    var
        ExtSalesLines: Record ExtSalesLines;
        Totals: Decimal;
    begin
        ExtSalesLines.Copy(Rec, true);
        ExtSalesLines.Reset();
        if ExtSalesLines.FindSet() then
            repeat
                Totals += ExtSalesLines."Line Amount";
            until ExtSalesLines.Next() = 0;

        exit(Totals);
    end;

    local procedure SetFilterChainGroup()
    var
    begin
        Rec.SetFilter("ChainGroup Code", ChainGroupFilter);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
