



pageextension 50026 "WhseWorkerWMSRoleCenterExtSC" extends "Whse. Worker WMS Role Center"
{

    /// <summary>
    /// PageExtension SCANPAN Whse. W. WMS Role Cent (ID 50026) extends Record Whse. WMS Role Center.
    /// 
    /// Version list
    /// 2022.12             Jesper Harder       0193        Added modifications
    /// 2023.03.18          Jesper Harder       009         Bin Content. Functionality to identify potiential Transfer Orders 
    /// 2024.07             Jesper Harder       072         Pallet Manifest v2 fetch from new tasklet tables and use PostedSalesShipment as base table
    /// 2025.02             Jesper Harder       106.01      Action to Shipmondo Shipment Request List
    /// </summary>


    layout
    {

        addfirst(rolecenter)
        {
            part(ScanpanCardPart; ScanpanCardPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan';
            }
        }
    }

    actions
    {
        addfirst(sections)
        {
            group("SCANPAN")
            {
                Caption = 'SCANPAN';
                Image = "List";
                ToolTip = 'Shortcuts SCANPAN';

                group("WhseToolSet")
                {
                    Caption = 'Warehouse Tools';
                    ToolTip = 'Collection of Warehouse tools.';

                    action("Warehouse Shipment List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Warehouse Shipment List';
                        Image = Warehouse;
                        RunObject = Page "Warehouse Shipment List";
                        ToolTip = 'List and Create Scanpan Warehouse Shipments.';
                    }
                    action("Warehouse Picks")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Warehouse Shipment List';
                        Image = PickLines;
                        RunObject = Page "Warehouse Picks";
                        ToolTip = 'List and Create Scanpan Warehouse Shipments.';

                    }
                    action("Pick Worksheet")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pick Worksheet';
                        Image = Warehouse;
                        RunObject = Page "Pick Worksheet";
                        ToolTip = 'Create picking linje for all Shipments.';
                    }
                    action("Warehouse Pick")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Warehouse Pick List';
                        Image = Warehouse;
                        RunObject = Page "Warehouse Picks";
                        ToolTip = 'Pickorders awaiting handling.';
                    }

                    //SHIPITREMOVE
                    /*
                    action("IDYS Transport Order List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport Orders';
                        Image = Warehouse;
                        RunObject = Page "IDYS Transport Order List";
                        ToolTip = 'Transport Orders and Transsmart link.';
                    }
                    */

                    // 106.01
                    action("Shipmondo Shipment Request List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Shipmondo Shipment Error';
                        Image = Warehouse;
                        RunObject = Page "XTESCT Shipment Request List";
                        ToolTip = 'List Shipments with errors.';
                    }

                    action("Posted Whse. Shipment List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Whse. Shipment List';
                        Image = Warehouse;
                        RunObject = Page "Posted Whse. Shipment List";
                        ToolTip = 'List of Posted Warehouse Shipments.';
                    }
                    action("Posted Sales Shipments")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Shipments';
                        Image = Warehouse;
                        RunObject = Page "Posted Sales Shipments";
                        ToolTip = 'List of Posted Sales Shipments.';
                    }
                    action("Bin Contents1")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bin Contents';
                        Image = Warehouse;
                        RunObject = Page "Bin Contents";
                        ToolTip = 'List of Bin Contents.';
                    }

                }
                group("Warehouse Reports")
                {
                    Caption = 'Warehouse Reports';
                    ToolTip = 'Collection of Warehouse related reports.';
                    action("Address Label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Address Labels';
                        Image = Report;
                        RunObject = Report "Adresselabel";
                        ToolTip = 'Prints Address labels from Customer, Vendor, Manually.';
                    }
                    action("Shelf Face label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Shelf face';
                        Image = Report;
                        RunObject = Report "Hyldelabel";
                        ToolTip = 'Prints Shelf Face labels.';
                    }
                    action("Item label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Item Label';
                        Image = Report;
                        RunObject = Report Varelabel;
                        ToolTip = 'Prints Item labels.';
                    }
                    action("Licenseplate")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Licenseplate';
                        Image = Report;
                        RunObject = Report "Licenseplate";
                        ToolTip = 'Prints Licenseplates used with Tasklet.';
                    }

                    //072
                    action("Shipment inventory")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Shipment inventory';
                        Image = Report;
                        RunObject = Report PalletShipmentReport;
                        ToolTip = 'Prints Shipment Pallet inventory.';
                    }
                    action("Pallet label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Pallet Label';
                        Image = Report;
                        RunObject = Report "Scanpan Pallelabel";
                        ToolTip = 'Prints labels for wrapped pallets.';
                    }




                }
            }

        }

    }
}
