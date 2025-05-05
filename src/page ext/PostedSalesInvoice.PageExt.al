/// <summary>
/// PageExtension "PostedSalesInvoiceExtSC" (ID 50056) extends Record Posted Sales Invoice.
/// </summary>
///
/// <remarks>
///
/// 2023.08             Jesper Harder               044     LTS Export Invoice Warehouse
///
/// </remarks>
pageextension 50056 PostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addlast(content)
        {
            group(scanpan)
            {
                Caption = 'WEB Orders (SCANPAN)';

                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Email field.';
                    Visible = true;
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Sell-to Phone No. field.';
                    Visible = true;
                }
            }
        }

        addlast(scanpan)
        {
            field(PaymentID1; Rec.PaymentID)
            {
                ApplicationArea = Basic, Suite;
                Importance = Standard;
                ToolTip = 'Specifies the value of the Payment ID field.';
                Visible = true;
            }
            field("External Document No.1"; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
                Visible = true;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            //044     LTS Export Invoice Warehouse
            action(LTSsendNedInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send all new Invoices to LTS';
                Image = "Invoicing-Send";
                ToolTip = 'Send all new Invoices to LTS';
                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    LTSOutboundExport: Report "NOTO LTS Outbound Export";
                    Text000Lbl: Label 'All new Invoices processed and sent to LTS\Check LTS system for status.';
                begin
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetFilter("Toll System Sent NOTO", '%1', false);
                    SalesInvoiceHeader.FindSet();
                    //LTSOutboundExport.SetSkipTollSystemSentCheck();
                    LTSOutboundExport.SetTableView(SalesInvoiceHeader);
                    LTSOutboundExport.Run();
                    CurrPage.Update();
                    Message(Text000Lbl);
                end;
            }
        }
    }
}
