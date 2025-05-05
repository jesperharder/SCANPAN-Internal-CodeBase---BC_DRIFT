/// <summary>
/// Page Invoice Lines (ID 50035).
/// </summary>
/// <remarks>
/// 2023.05.01              Jesper Harder                       028     SalesCommision
/// 2023.06.15              Jesper Harder                       028     Changes to layout
/// </remarks>

page 50035 "Sales Commission"
{
    AdditionalSearchTerms = 'Scanpan, Salesperson';
    ApplicationArea = All;
    Caption = 'Sales Commission (Items)';
    Editable = false;
    PageType = List;
    Permissions = 
        tabledata Campaign = R,
        tabledata Customer = R,
        tabledata "Sales Cr.Memo Header" = R,
        tabledata "Sales Cr.Memo Line" = R,
        tabledata "Sales Invoice Header" = R,
        tabledata "Sales Invoice Line" = R,
        tabledata "Salesperson/Purchaser" = R;
    SourceTable = "DocumentLines";
    SourceTableView = sorting("Posting Date") order(ascending);
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Visible = HideLineDetails;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                    Visible = HideLineDetails;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                    Visible = HideLineDetails;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                }
                field("Salesperson Name"; Rec."Salesperson Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Name field.';
                }
                field("Salesperson Commission %"; Rec."Salesperson Commission %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salespersion Commission % field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Visible = HideLineDetails;
                }
                field("Item Desription"; Rec."Item Desription")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Visible = HideLineDetails;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Visible = HideLineDetails;
                }
                field("Campaign Code"; Rec."Campaign Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Campaign Code field.';
                    Visible = HideLineDetails;
                }
                field("Campaign Name"; Rec."Campaign Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Campaign Name field.';
                    Visible = HideLineDetails;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Campaign Starting Date field.';
                    Visible = HideLineDetails;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Campaign Ending Date field.';
                    Visible = HideLineDetails;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Commission Amount field.';
                }
                field("Amount(RV)"; Rec."Amount(RV)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount(RV) field.';
                    Visible = HideLineDetails;
                }
                field("Commission Amount(RV)"; Rec."Commission Amount(RV)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Commission Amount(RV) field.';
                    Visible = HideLineDetails;
                }
            }

            group(totals)
            {
                Enabled = TotalsVisible;
                ShowCaption = false;
                Visible = HideLineDetails;

                field(TotalAmount; TotalAmount)
                {
                    Visible = HideLineDetails;
                    ToolTip = 'Specifies the value of the TotalAmount field.';
                    Caption = 'Total Amount';
                }
                field(TotalAmountRV; TotalAmountRV)
                {
                    Visible = HideLineDetails;
                    ToolTip = 'Specifies the value of the TotalAmountRV field.';
                    Caption = 'Total Amount RV';
                }
                field(TotalCommission; TotalCommission)
                {
                    Visible = HideLineDetails;
                    ToolTip = 'Specifies the value of the TotalCommission field.';
                    Caption = 'Total Commission';
                }
                field(TotalCommissionRV; TotalCommissionRV)
                {
                    Visible = HideLineDetails;
                    ToolTip = 'Specifies the value of the TotalCommissionRV field.';
                    Caption = 'Total Commission RV';
                }
            }
        }
    }
    var
        HideLineDetails: Boolean;
        TotalAmount: Decimal;
        TotalAmountRV: Decimal;
        TotalCommission: Decimal;
        TotalCommissionRV: Decimal;
        LineNo: Integer;
        TotalsVisible: Boolean;

    //Testing Local change of language ID

    trigger OnInit()
    begin
        HideLineDetails := false;
        TotalsVisible := false;
    end;

    trigger OnOpenPage()
    var
        Customers: Record Customer;
        TempDocumentLines: Record "DocumentLines" temporary;
        varFilterPageBuilder: FilterPageBuilder;
        Text001Lbl: Label 'Sales Commision';
    begin

        varFilterPageBuilder.PageCaption := Text001Lbl;

        varFilterPageBuilder.AddRecord('PageFilter', TempDocumentLines);
        varFilterPageBuilder.AddField('PageFilter', TempDocumentLines."Posting Date");
        varFilterPageBuilder.AddField('PageFilter', TempDocumentLines."Show Lines");

        varFilterPageBuilder.AddRecord('Customers', Customers);
        varFilterPageBuilder.AddField('Customers', Customers."No.");
        varFilterPageBuilder.AddField('Customers', Customers."Salesperson Code");

        //varFilterPageBuilder.AddRecord('Campaigns', Campaigns);
        //varFilterPageBuilder.AddField('Campaigns', Campaigns."No.");

        varFilterPageBuilder.RunModal();

        BuildDataSetInvoice(varFilterPageBuilder);
        BuildDataSetCreditNote(varFilterPageBuilder);
    end;

    trigger OnAfterGetRecord()
    var
    begin
    end;

    trigger OnAfterGetCurrRecord()
    begin
        /*
        Rec.CalcSums(Amount, "Amount(RV)", "Commission Amount", "Commission Amount(RV)");
        TotalAmount := Rec.Amount;
        TotalAmountRV := Rec."Amount(RV)";
        TotalCommission := Rec."Commission Amount";
        TotalCommissionRV := rec."Commission Amount(RV)";
        CurrPage.Update(false);
        */
    end;

    local procedure BuildDataSetCreditNote(FilterPageBuilder: FilterPageBuilder)
    var
        CampaignLookup: Record Campaign;
        Campaigns: Record Campaign;
        Customers: Record Customer;
        TempDocumentLines: Record "DocumentLines" temporary;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
        ShowLines: Boolean;

        AmountDec: Decimal;
        AmountRV: Decimal;
        Commission: Decimal;
        CommissionRV: Decimal;
        PostingDateFilter: Text[100];
    begin
        Customers.SetView(FilterPageBuilder.GetView('Customers'));
        Campaigns.SetView(FilterPageBuilder.GetView('Campaigns'));
        if Campaigns.HasFilter then CampaignLookup.CopyFilters(Campaigns);
        TempDocumentLines.SetView(FilterPageBuilder.GetView('PageFilter'));
        PostingDateFilter := CopyStr(TempDocumentLines.GetFilter("Posting Date"), 1, 100);

        ShowLines := false;
        case TempDocumentLines.GetFilter("Show Lines") of
            'Ja':
                ShowLines := true;
            'Yes':
                ShowLines := true;
        end;
        //Toggle Fields visibility
        HideLineDetails := ShowLines;

        if Customers.FindSet() then
            repeat
                SalesCrMemoHeader.SetFilter("Bill-to Customer No.", Customers."No.");
                SalesCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
                if SalesCrMemoHeader.FindSet() then
                    repeat
                        Rec.Init();
                        Rec."Show Lines" := ShowLines;
                        Rec."Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
                        Rec."Customer Name" := SalesCrMemoHeader."Bill-to Name";
                        Rec."Document Type" := Rec."Document Type"::"Posted Sales Ceredit Memo";
                        Rec."Document No." := SalesCrMemoHeader."No.";
                        Rec."Posting Date" := SalesCrMemoHeader."Posting Date";
                        Rec."Currency Factor" := SalesCrMemoHeader."Currency Factor";
                        if Rec."Currency Factor" = 0 then Rec."Currency Factor" := 1;
                        Rec."Currency Code" := SalesCrMemoHeader."Currency Code";
                        //if Rec."Currency Code" = '' then Rec."Currency Code" := 'DKR';
                        Rec."Salesperson Code" := SalesCrMemoHeader."Salesperson Code";
                        if SalesPersonPurchaser.Get(SalesCrMemoHeader."Salesperson Code") then begin
                            Rec."Salesperson Name" := SalesPersonPurchaser.Name;
                            Rec."Salesperson Commission %" := SalesPersonPurchaser."Commission %";
                        end;

                        //Document Lines
                        AmountDec := 0;
                        AmountRV := 0;
                        Commission := 0;
                        CommissionRV := 0;

                        SalesCrMemoLine.SetFilter("Document No.", SalesCrMemoHeader."No.");
                        SalesCrMemoLine.SetFilter(Type, '%1', SalesCrMemoLine.Type::Item);
                        SalesCrMemoLine.SetFilter("Quantity (Base)", '<>0');
                        if SalesCrMemoLine.FindSet() then begin

                            repeat
                                if ShowLines then begin
                                    Rec."Item No." := SalesCrMemoLine."No.";
                                    Rec."Item Desription" := SalesCrMemoLine.Description;
                                    Rec.Quantity := -SalesCrMemoLine."Quantity (Base)";
                                    Rec.Amount := -SalesCrMemoLine."Line Amount";
                                    Rec."Amount(RV)" := Rec.Amount / Rec."Currency Factor";

                                    if Rec."Salesperson Commission %" <> 0 then begin
                                        Rec."Commission Amount" := Rec.Amount * (Rec."Salesperson Commission %" / 100);
                                        Rec."Commission Amount(RV)" := Rec."Commission Amount" / Rec."Currency Factor";
                                    end;

                                    LineNo += 1;
                                    Rec."Line No." := LineNo;
                                    if Rec.Insert() then;
                                end else
                                    //Only Headers
                                    if not ShowLines then begin
                                        AmountDec += -SalesCrMemoLine."Line Amount";
                                        AmountRV := AmountDec / Rec."Currency Factor";

                                        if Rec."Salesperson Commission %" <> 0 then begin
                                            Commission := AmountDec * (Rec."Salesperson Commission %" / 100);
                                            CommissionRV := Commission / Rec."Currency Factor";
                                        end;
                                    end;
                            until SalesCrMemoLine.Next() = 0;
                            //Only Headers
                            if not ShowLines then begin
                                Rec.Amount := AmountDec;
                                Rec."Amount(RV)" := AmountRV;
                                Rec."Commission Amount" := Commission;
                                Rec."Commission Amount(RV)" := CommissionRV;

                                LineNo += 1;
                                Rec."Line No." := LineNo;
                                if Rec.Insert() then;
                            end;
                        end;
                    until SalesCrMemoHeader.Next() = 0;
            until Customers.Next() = 0;

        //Totals
        if Rec.FindSet() then begin

            Rec.CalcSums(Amount, "Amount(RV)", "Commission Amount", "Commission Amount(RV)");
            TotalAmount := Rec.Amount;
            TotalAmountRV := Rec."Amount(RV)";
            TotalCommission := Rec."Commission Amount";
            TotalCommissionRV := rec."Commission Amount(RV)";
        end;
        if Rec.FindFirst() then;
    end;

    local procedure BuildDataSetInvoice(FilterPageBuilder: FilterPageBuilder)
    var
        CampaignLookup: Record Campaign;
        Campaigns: Record Campaign;
        Customers: Record Customer;
        TempDocumentLines: Record "DocumentLines" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesPersonPurchaser: Record "Salesperson/Purchaser";

        ShowLines: Boolean;

        AmountDec: Decimal;
        AmountRV: Decimal;
        Commission: Decimal;
        CommissionRV: Decimal;
        PostingDateFilter: Text[100];
    begin
        Customers.SetView(FilterPageBuilder.GetView('Customers'));
        Campaigns.SetView(FilterPageBuilder.GetView('Campaigns'));
        if Campaigns.HasFilter then CampaignLookup.CopyFilters(Campaigns);
        TempDocumentLines.SetView(FilterPageBuilder.GetView('PageFilter'));
        PostingDateFilter := CopyStr(TempDocumentLines.GetFilter("Posting Date"), 1, 100);

        ShowLines := false;
        case TempDocumentLines.GetFilter("Show Lines") of
            'Ja':
                ShowLines := true;
            'Yes':
                ShowLines := true;
        end;
        //Toggle Fields visibility
        HideLineDetails := ShowLines;

        if Customers.FindSet() then
            repeat
                SalesInvoiceHeader.SetFilter("Bill-to Customer No.", Customers."No.");
                SalesInvoiceHeader.SetFilter("Posting Date", PostingDateFilter);
                if SalesInvoiceHeader.FindSet() then
                    repeat
                        Rec.Init();
                        Rec."Show Lines" := ShowLines;
                        Rec."Customer No." := SalesInvoiceHeader."Bill-to Customer No.";
                        Rec."Customer Name" := SalesInvoiceHeader."Bill-to Name";
                        Rec."Document Type" := Rec."Document Type"::"Posted Sales Invoice";
                        Rec."Document No." := SalesInvoiceHeader."No.";
                        Rec."Posting Date" := SalesInvoiceHeader."Posting Date";
                        Rec."Currency Factor" := SalesInvoiceHeader."Currency Factor";
                        if Rec."Currency Factor" = 0 then Rec."Currency Factor" := 1;
                        Rec."Currency Code" := SalesInvoiceHeader."Currency Code";
                        //if Rec."Currency Code" = '' then Rec."Currency Code" := 'DKR';
                        Rec."Salesperson Code" := SalesInvoiceHeader."Salesperson Code";
                        if SalesPersonPurchaser.Get(SalesInvoiceHeader."Salesperson Code") then begin
                            Rec."Salesperson Name" := SalesPersonPurchaser.Name;
                            Rec."Salesperson Commission %" := SalesPersonPurchaser."Commission %";
                        end;

                        //Document Lines
                        AmountDec := 0;
                        AmountRV := 0;
                        Commission := 0;
                        CommissionRV := 0;

                        SalesInvoiceLine.SetFilter("Document No.", SalesInvoiceHeader."No.");
                        SalesInvoiceLine.SetFilter(Type, '%1', SalesInvoiceLine.Type::Item);
                        SalesInvoiceLine.SetFilter("Quantity (Base)", '<>0');
                        if SalesInvoiceLine.FindSet() then begin

                            repeat
                                if ShowLines then begin
                                    //CAMPAIGNS LOOP

                                    Rec."Item No." := SalesInvoiceLine."No.";
                                    Rec."Item Desription" := SalesInvoiceLine.Description;
                                    Rec.Quantity := SalesInvoiceLine."Quantity (Base)";

                                    Rec."Campaign Code" := SalesInvoiceLine."Used Campaign NOTO";

                                    if CampaignLookup.Get(SalesInvoiceLine."Used Campaign NOTO") then begin
                                        Rec."Campaign Name" := CampaignLookup.Description;
                                        Rec."Starting Date" := CampaignLookup."Starting Date";
                                        Rec."Ending Date" := CampaignLookup."Ending Date";
                                    end;

                                    Rec.Amount := SalesInvoiceLine."Line Amount";
                                    Rec."Amount(RV)" := Rec.Amount / Rec."Currency Factor";

                                    if Rec."Salesperson Commission %" <> 0 then begin
                                        Rec."Commission Amount" := Rec.Amount * (Rec."Salesperson Commission %" / 100);
                                        Rec."Commission Amount(RV)" := Rec."Commission Amount" / Rec."Currency Factor";
                                    end;

                                    LineNo += 1;
                                    Rec."Line No." := LineNo;
                                    if Rec.Insert() then;
                                end else
                                    //Only Headers
                                    if not ShowLines then begin
                                        AmountDec += SalesInvoiceLine."Line Amount";
                                        AmountRV := AmountDec / Rec."Currency Factor";

                                        if Rec."Salesperson Commission %" <> 0 then begin
                                            Commission := AmountDec * (Rec."Salesperson Commission %" / 100);
                                            CommissionRV := Commission / Rec."Currency Factor";
                                        end;
                                    end;
                            until SalesInvoiceLine.Next() = 0;
                            //Only Headers
                            if not ShowLines then begin
                                Rec.Amount := AmountDec;
                                Rec."Amount(RV)" := AmountRV;
                                Rec."Commission Amount" := Commission;
                                Rec."Commission Amount(RV)" := CommissionRV;

                                LineNo += 1;
                                Rec."Line No." := LineNo;
                                if Rec.Insert() then;
                            end;
                        end;
                    until SalesInvoiceHeader.Next() = 0;
            until Customers.Next() = 0;

        //Totals
        if Rec.FindSet() then begin

            Rec.CalcSums(Amount, "Amount(RV)", "Commission Amount", "Commission Amount(RV)");
            TotalAmount := Rec.Amount;
            TotalAmountRV := Rec."Amount(RV)";
            TotalCommission := Rec."Commission Amount";
            TotalCommissionRV := rec."Commission Amount(RV)";
        end;
        if Rec.FindFirst() then;
    end;
}