
pageextension 50020 "OrderProcessorRoleCenter" extends "Order Processor Role Center"
{
    /// <summary>
    /// PageExtension OrderProcessorRoleCenter (ID 50020) extends Record Order Processor Role Center.
    /// </summary>
    /// <remarks>
    ///
    /// Version list
    /// 2022.12            Jesper Harder        0193        Added modifications
    /// 2023.01            Jesper Harder        0193        Added Claims Import report
    /// 2023.04            Jesper Harder        025         Order Processor Role Center Hide various actionsHide various actions
    /// 2024.06             Jesper Harder       070         Customers Over Credit Limit TILE
    /// 2024.08             Jesper Harder       076         Cue for Sales Comparison
    /// 2024.11             Jesper Harder       097         Monitor select JobQueue from role center
    /// </remarks>

    layout
    {
        addafter(Control104)
        {
            // 076
            part(SalesCompAndRealized; "SalesCompareAndRealized")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan Sales';
            }
            // 097
            part(ScanpanProcessesCardPart; ScanpanCardPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan Process status';
            }
            // 070
            part(CustomerOverCreditLimit; "CustomersOverCreditLimit")
            {
                ApplicationArea = All;
                Caption = 'Customers Over Credit Limit';
            }
        }
    }

    actions
    {
        // 025
        modify("Item Journals") { Visible = false; }
        modify("SalesJournals") { Visible = false; }
        modify(CashReceiptJournals) { Visible = false; }
        modify("Transfer Orders") { Visible = false; }
        addlast(sections)
        {
            group("SCANPAN")
            {
                Caption = 'SCANPAN';
                Image = "List";
                ToolTip = 'Shortcuts SCANPAN';
                group("Campaign related")
                {
                    Caption = 'Campaigns';
                    ToolTip = 'Campaign Shortcuts';
                    action("Campaigns")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Campaign List';
                        Image = Campaign;
                        RunObject = Page "Campaign List";
                        ToolTip = 'Show Campaign List';
                    }
                    action("Campaign Segments")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Campaign Segment groups';
                        Image = Campaign;
                        RunObject = Page "Segment List";
                        ToolTip = 'Show Campaign Segment groups ';
                    }
                    action("Campaign Mail Groups")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Campaign Mail groups';
                        Image = Campaign;
                        RunObject = Page "Mailing Groups";
                        ToolTip = 'Show Campaign Mail groups ';
                    }
                }
                group("Continia related")
                {
                    Caption = 'Continia';
                    ToolTip = 'Continia Shortcuts';

                    action("Document Capture")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Capture';
                        Image = Customer;
                        RunObject = Page "CDC Document Categories";
                        ToolTip = 'Åbner for indskannede dokumenter pr. forretningsområde';
                    }
                }
                group("Claims related")
                {
                    Caption = 'Claims';
                    ToolTip = 'Claims';
                    action("Claims")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Claims sync.status';
                        Image = Administration;
                        RunObject = Page "NOTOClaims";
                        ToolTip = 'Show Syncronized from Claims Web';
                    }
                    action("Import Claims")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Claims';
                        Image = Administration;
                        RunObject = Report "NOTO Import Claims";
                        ToolTip = 'Import Claims from Web.';
                    }
                }
                group("Sales related")
                {
                    Caption = 'Sales';
                    ToolTip = 'Hurtig genvej til særlige SCANPAN salgsgenveje.';
                    action("Aut. deleted backorders")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aut. deleted backorders';
                        Image = Sales;
                        RunObject = Page "NOTO Deleted Sales Orders Info";
                        ToolTip = 'Shows a list of automatically deltede backorders';
                    }
                    action("Sales Line")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Line';
                        Image = Sales;
                        RunObject = Page "SalesLine";
                        ToolTip = 'Shows all Sales Lines and array of filters.';
                    }
                    action("IC Tracking")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inter Company Tracking';
                        Image = Sales;
                        RunObject = Page IICTracking_BC;
                        ToolTip = 'Shows Tracking information from DK+NO Inter Company.';
                    }
                }
                group("Sales Reports")
                {
                    Caption = 'Sales Reports';
                    ToolTip = 'Collection of Sales related reports.';
                    action("Address Label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Address Labels';
                        Image = Report;
                        RunObject = Report "Adresselabel";
                        ToolTip = 'Prints Address labels from Customer, Vendor, Manually.';
                    }
                    action("DebitorAddresses")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Debitor Addresses';
                        Image = Campaign;
                        RunObject = report DebitorAddress;
                        ToolTip = 'Print or export to Excel, Debitor adresses and emails.';
                    }

                    action("Customs Declaration")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Customs Declaration';
                        Image = Report;
                        RunObject = Report "Customs Declaration";
                        ToolTip = 'Prints detailed Item information.';
                    }
                    action("Sales Orderlines")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Sales Orderlines';
                        Image = Report;
                        RunObject = Report "Ordrebeholdning";
                        ToolTip = 'Prints all orderlines aggregated.';
                    }
                    action("Sales Pricelist")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Sales  Pricelist';
                        Image = Report;
                        RunObject = Report "Salgsprisliste";
                        ToolTip = 'Prints Sales Pricelists.';
                    }
                }
            }
        }
    }
}
