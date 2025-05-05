/// <summary>
/// Query QueryTest (ID 50001).
/// </summary>
/// <remarks>
/// 2023.05.01              Jesper Harder                       028     SalesCommision
/// </remarks>
query 50002 "Query SalesCreditNote" 
{
    Caption = 'Query Sales Commission';
    QueryType = Normal;

    elements
    {
        dataitem(Customer; Customer)
        {
            column(CustomerNo; "No.")
            {
                Caption = 'Customer No.';
            }
            column(CustomerName; Name)
            {
                Caption = 'Customer Name';
            }
            dataitem(Sales_Cr_Memo_Header;"Sales Cr.Memo Header")
            {

                DataItemLink = "Bill-to Customer No." = Customer."No.";
                filter(Posting_Date; "Posting Date") { }
                column(InvoiceNo; "No.")
                {
                    Caption = 'Invoice No.';
                }
                column(InvoiceSalespersonCode; "Salesperson Code")
                {
                    Caption = 'Invoice Salesperson Code';
                }
                column(Currency_Code; "Currency Code")
                {
                    Caption = 'Invoice Currency Code';
                }
                column(Currency_Factor; "Currency Factor")
                {
                    Caption = 'Invoice Currency Factor';
                }
                column(PostingDate; "Posting Date")
                {
                }

                dataitem(Salesperson_Purchaser; "Salesperson/Purchaser")
                {
                    DataItemLink = Code = Sales_Cr_Memo_Header."Salesperson Code";
                    column("Code"; "Code")
                    {
                    }
                    column(Name; Name)
                    {
                    }
                    column(Commission; "Commission %")
                    {
                    }
                    dataitem(InvoiceLine; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = Sales_Cr_Memo_Header."No.";
                        DataItemTableFilter = Type = const(Item);
                        column(Amount; Amount)
                        {
                            Method = Sum;
                        }
                        dataitem(Campaign; Campaign)
                        {
                            DataItemLink = "No." = InvoiceLine."Document No.";
                            column(No_; "No.")
                            { }
                            column(Description; Description)
                            { }
                            column(Starting_Date; "Starting Date")
                            { }
                            column(Ending_Date; "Ending Date")
                            { }
                        }
                    }
                }
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
