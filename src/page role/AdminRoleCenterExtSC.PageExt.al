/// <summary>
/// PageExtension AdminRoleCenterExtSC (ID 50000) extends Record Administrator Role Center.
/// </summary>
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2023.04.04          Jesper Harder       021         Shows debuginfo for inconsistent Sales Lines and Transport Order Lines
/// 2023.04.18          Jesper Harder       024         SalesOrderForm WebServices used in Excel Sales Order Forms.
/// 2024.08             Jesper Harder       076         Cue for Sales Comparison
///
/// </remarks>

pageextension 50000 "AdminRoleCenterExtSC" extends "Administrator Role Center"
{
    layout
    {

        addfirst(rolecenter)
        {
            part(ScanpanCardPart; ScanpanCardPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan';
            }
            //076
            part(SalesCompAndRealized; "SalesCompareAndRealized")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan Sales';
            }
            part(CustomerOverCreditLimit; "CustomersOverCreditLimit")
            {
                ApplicationArea = All;
                Caption = 'Customers Over Credit Limit';
            }

        }
    }
    actions
    {
        moveafter("P&urchase Analysis"; "&Sales Analysis")
        addfirst(sections)
        {
            group(Group1)
            {
                Caption = 'SCANPAN';
                Image = "List";
                ToolTip = 'Techincal SCANPAN';
                group(Group2)
                {
                    Caption = 'System Information';
                    ToolTip = 'Collection of System Information';

                    /*
                    action("Debug ShipIT")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Debug ShipIT';
                        Image = AboutNav;
                        RunObject = Page "ShipITdebug";
                        ToolTip = 'Shows inconsistent sales and transport order lines.';
                    }
                    */
                    action("License Information")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'License Information List';
                        Image = AboutNav;
                        RunObject = Page BC_LICENSE_INFORMATION_SC;
                        ToolTip = 'Show BC License Information List';
                    }
                    action("License Persionssion")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'License Persionssion List';
                        Image = AboutNav;
                        RunObject = Page "BC_LICENSE_PERMISSION_SC";
                        ToolTip = 'Show License Permission List';
                    }
                }
                group(Group3)
                {
                    Caption = 'WebServices';
                    ToolTip = 'WebServices for various purposes.';

                    action("Web Services")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Web Services';
                        Image = ServiceSetup;
                        RunObject = page "Web Services";
                        ToolTip = 'View all Web Services.';
                    }
                    action("Pricelist Item Source Data")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'WebService Pricelist Source Data';
                        Image = PriceAdjustment;
                        RunObject = page "WebServiceSalesPriceListSource";
                        ToolTip = 'Base for extracting Item Data to external calculation.';
                    }
                    action("Sales Orderform Items")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'WebService Sales Orderform Items';
                        Image = ItemWorksheet;
                        RunObject = page "WebServiceOrderFormItems";
                        ToolTip = 'Base for extracting Item Data to be used in Sales Orderforms.';
                    }
                    action("Sales Orderform Customer")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'WebService Sales Orderform Customer';
                        Image = ItemWorksheet;
                        RunObject = page "WebServiceOrderFormCustomer";
                        ToolTip = 'Base for extracting Customer Data to be used in Sales Orderforms.';
                    }
                }
            }
        }
    }
}
