/// <summary>
/// Page Campaign Sales (ID 50037).
/// </summary>
///
/// <remarks>
/// 2023.06.12                  Jesper Harder               034 Campaign statistics
/// </remarks> 
page 50037 "CampaignSales"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Sales Campaign Sales';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = true;
    PageType = List;
    Permissions =
        tabledata Campaign = R,
        tabledata CampaignStatistics = RI,
        tabledata Currency = R,
        tabledata Customer = R,
        tabledata "Dimension Value" = R,
        tabledata Item = R,
        tabledata "Production Forecast Entry" = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Invoice Header" = R,
        tabledata "Sales Invoice Line" = R,
        tabledata "Sales Line" = R;
    SourceTable = CampaignStatistics;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            group(group1)
            {
                ShowCaption = false;
                repeater(Campaigns)
                {
                    Caption = 'Campaigns';

                    field("Line No."; Rec."Line No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Line No. field.';
                    }
                    field("Date"; Rec."Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Date field.';
                    }
                    field("Chain Group"; Rec."Chain Group")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer Chain Group field.';
                    }
                    field(Chain; Rec.Chain)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer Chain field.';
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
                    field("Country Code"; Rec."Country Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Country field.';
                    }

                    field(SalesPerson; Rec."SalesPerson Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the SalesPersconCode field.';
                    }
                    field("Campaign Code"; Rec."Campaign Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign Code field.';
                    }
                    field("Campaign Name"; Rec."Campaign Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign Name field.';
                    }
                    field("Campaign Type"; Rec."Campaign Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign Type field.';
                    }
                    field("Campaign Purpose"; Rec."Campaign Purpose")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Campaign Purpose field.';
                    }
                    field("Document Type"; Rec."Document Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Document Type field.';
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
                    field("Currency Description"; Rec."Currency Description")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Currency Description field.';
                    }
                    field("Item No."; Rec."Item No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Item No. field.';
                    }
                    field("Item Description"; Rec."Item Description")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Item Description field.';
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Quantity field.';
                    }
                    field(Amount; Rec.Amount)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Amount field.';
                    }
                    field("Amount(RV)"; Rec."Amount(RV)")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Amount(RV) field.';
                    }
                }
            }

            group(Totals)
            {
                field(TotalQuantity; TotalQuantity)
                {
                    Caption = 'Total Quantity';
                    ToolTip = 'Sum of Quantity.';
                }
                field(TotalAmount; TotalAmount)
                {
                    Caption = 'Total Amount';
                    ToolTip = 'Sum of Amount.';
                }
                field(TotalAmountRV; TotalAmountRV)
                {
                    Caption = 'Total Amount(RV)';
                    ToolTip = 'Sum og Amount RV.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("OpenFilterPage")
            {
                ApplicationArea = All;
                Caption = 'Update Contents', comment = '=Openes the filterpage and updates the page contents.';
                ToolTip = 'Updates the page based on filters set.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = UseFilters;

                trigger OnAction()
                var
                    CampaignStatistics: Record CampaignStatistics;
                    FilterPageBuilder: FilterPageBuilder;
                    PageCaptionLbl: label 'Filterpage';
                    FieldCaptionLbl: Label 'Campaign Fields';

                begin
                    CampaignStatistics.SetView(Rec.GetView());
                    FilterPageBuilder.AddRecord(FieldCaptionLbl, CampaignStatistics);
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics.Date);
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics."Campaign Code");
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics."Campaign Type");
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics."Campaign Purpose");
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics.Chain);
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics."Chain Group");
                    FilterPageBuilder.AddField(FieldCaptionLbl, CampaignStatistics."Country Code");
                    FilterPageBuilder.PageCaption := PageCaptionLbl;
                    if FilterPageBuilder.RunModal() then begin
                        Rec.SetView(FilterPageBuilder.GetView(FieldCaptionLbl));
                        GetDataSet(Format(Rec.GetFilter(Date)));
                    end;
                end;
            }
        }
    }



    /*
        views
        {
            view(DateFilter)
            {
                Caption = 'Filter Date';
                Filters = where("Date" = filter('Y'));
                OrderBy = ascending("Line No.");
                SharedLayout = true;
            }
            view(SalesOrder)
            {
                Caption = 'Show Sales Order';
                Filters = where("Document Type" = filter("Sales Order"));
                OrderBy = ascending("Line No.");
                SharedLayout = true;
            }
            view(Invoice)
            {
                Caption = 'Show Invoice';
                Filters = where("Document Type" = filter(Invoice));
                OrderBy = ascending("Line No.");
                SharedLayout = true;
            }
            view(Forecast)
            {
                Caption = 'Show Forecast';
                Filters = where("Document Type" = filter(Forecast));
                OrderBy = ascending("Line No.");
                SharedLayout = true;
            }
        }
    */



    var

        ScanpanMiscellaneous: codeunit ScanpanMiscellaneous;
        TotalAmount: Decimal;
        TotalAmountRV: Decimal;
        TotalQuantity: Decimal;
        LineNo: Integer;
        LastRecFilter: Text;
        LastDateFilter: Text;

    trigger OnInit()
    var
    begin
        //LastRecFilter := Rec.GetFilters;
        LastDateFilter := Rec.GetFilter("Date");
        //GetDataSet(Format(CalcDate('<CM-1M>', Today)));
    end;

    trigger OnAfterGetRecord()
    var

    begin
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        /*
        if LastDateFilter <> Rec.GetFilter("Date") then begin
            LastDateFilter := Rec.GetFilter("Date");
            GetDataSet(LastDateFilter)
        end;

        if LastRecFilter <> Rec.GetFilters then begin
            LastRecFilter := Rec.GetFilters();

            UpdateTotals();
        end
        */
    end;

    local procedure GetDataSet(DateRange: Text)
    var
        WindowDialog: Dialog;
        InfoLbl: Label 'Loading data. #1', Comment = '#1 Shows the businessarea being loaded.';
        Step: Integer;

    begin
        Rec.DeleteAll();
        WindowDialog.Open(InfoLbl, Step);
        WindowDialog.Update(1, 'Forecast');
        ScanpanMiscellaneous.CampaignSalesGetSalesForecasts(Rec, DateRange, LineNo);
        WindowDialog.Update(1, 'Salesorder');
        ScanpanMiscellaneous.CampaignSalesGetSalesOrders(Rec, DateRange, LineNo);
        WindowDialog.Update(1, 'Invoice');
        ScanpanMiscellaneous.CampaignSalesGetPostedSalesInvoice(Rec, DateRange, LineNo);
        UpdateTotals();
        WindowDialog.Close();
    end;

    local procedure UpdateTotals()
    begin
        if not Rec.IsEmpty then begin
            Rec.FindFirst();

            TotalQuantity := 0;
            TotalAmount := 0;
            TotalAmountRV := 0;

            repeat
                TotalQuantity += Rec.Quantity;
                TotalAmount += Rec.Amount;
                TotalAmountRV += Rec."Amount(RV)";
            until Rec.Next() = 0;
            Rec.FindFirst();
        end;
        CurrPage.Update(false);
    end;
}