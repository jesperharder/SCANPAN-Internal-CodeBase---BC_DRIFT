/// <summary>
/// Page "ExtSalesCustomerSales" (ID 50024).
/// </summary>
Page 50024 ExtSalesCustomerSales
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Sales Ext Customer Sales';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    Permissions =
        tabledata Customer = R,
        tabledata "Default Dimension" = R,
        tabledata "Dimension Value" = R;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(filter)
            {
            }
            group(linesrepeater)
            {
                repeater(general)
                {
                    field("No."; Rec."No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Customer No.';
                        Visible = True;
                    }
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Customer Name';
                        Visible = True;
                    }
                    field(ChainGroup; Rec.ChainGroup)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Chaingroup';
                        Visible = True;
                    }
                    field("Chain Name"; Rec."Chain Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Chain Name';
                        Visible = True;
                    }
                    field(Chain; Rec.Chain)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Chain';
                        Visible = True;
                    }
                    field(SalesCurrMonth; SalesCurrMonth)
                    {
                        Caption = 'Sales Current Month';
                        ApplicationArea = All;
                        BlankNumbers = BlankZero;
                        BlankZero = true;
                        DecimalPlaces = 0;
                        ToolTip = 'Specifies Customer Sales Current Month.';
                        Visible = True;
                    }
                    field(SalesYTD; SalesYTD)
                    {
                        Caption = 'Sales Year-To-Date';
                        ApplicationArea = All;
                        BlankNumbers = BlankZero;
                        BlankZero = true;
                        DecimalPlaces = 0;
                        ToolTip = 'Specifies Customer Sales Year To Date.';
                        Visible = True;
                    }
                }
            }
        }
    }

    var
        //Inspiration
        EndOfCurrentYear: date;
        StartOfCurrentYear: date;
        SalesCurrMonth: Decimal;

        SalesYTD: Decimal;

    trigger OnInit()
    var
    begin
        StartOfCurrentYear := CALCDATE('<-CY>', Today);
        EndOfCurrentYear := CALCDATE('<+CY>', Today);
    end;

    trigger OnAfterGetRecord()
    var
        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";

    begin
        if DefaultDimension.Get('18', Rec."No.", 'KÆDE') then begin
            //Rec.Chain := DefaultDimension."Dimension Value Code";
            DimensionValue.Get('KÆDE', DefaultDimension."Dimension Value Code");
            Rec."Chain Name" := CopyStr(DimensionValue.Name, 1, 10);

            //YTD
            Rec.SetFilter("Date Filter", '%1..%2', StartOfCurrentYear, EndOfCurrentYear);
            SalesYTD := CalculateAmtOfSaleLCY();

            //CURR MONTH
            Rec.SETRANGE("Date Filter", CALCDATE('<-CM>', TODAY), CALCDATE('<+CM>', TODAY));
            SalesCurrMonth := CalculateAmtOfSaleLCY();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        //CurrPage.Update(false);
    end;

    local procedure CalculateAmtOfSaleLCY(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        with CustLedgerEntry do begin
            SetCurrentKey("Document Type", "Customer No.", "Posting Date");
            SetRange("Customer No.", Rec."No.");
            SetFilter("Posting Date", Rec.GetFilter("Date Filter"));
            for i := 1 to 2 do begin
                case i of
                    1:
                        SetRange("Document Type", "Document Type"::Invoice);
                    2:
                        SetRange("Document Type", "Document Type"::"Credit Memo");
                end;
                CalcSums("Sales (LCY)");
                Amt := Amt + "Sales (LCY)";
            end;
            exit(Amt);
        end;
    end;
}