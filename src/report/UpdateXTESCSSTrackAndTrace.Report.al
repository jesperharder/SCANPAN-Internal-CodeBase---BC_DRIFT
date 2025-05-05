

report 50016 "UpdateXTESCSSTrackAndTrace"
{
    ///<summary>
    ///
    /// 2024.10             Jesper Harder       086         XtensionIT Shipmondo Add Customer Information on PageExt XTECSC Track And Trace List
    ///</summary>


    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Update Track and Trace Log';
    ProcessingOnly = true;
    UsageCategory = Tasks;


    dataset
    {
        dataitem("XTECSC Shipment Log"; "XTECSC Shipment Log")
        {
            DataItemTableView = where("Receiver No." = const('')); // Filter for unprocessed records

            trigger OnAfterGetRecord()
            begin
                // Initialize
                PostedWhseShipmentLine.Reset();
                SalesShipmentHeader.Reset();

                // Is Shipment
                if "XTECSC Shipment Log"."Shipment Type" = "XTECSC Shipment Log"."Shipment Type"::"Warehouse Shipment" then begin
                    PostedWhseShipmentLine.SetRange("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
                    PostedWhseShipmentLine.SetRange("Whse. Shipment No.", "XTECSC Shipment Log"."Document No.");
                    if not PostedWhseShipmentLine.FindFirst() then
                        exit;

                    SalesShipmentHeader.SetRange("No.", PostedWhseShipmentLine."Posted Source No.");
                end;

                // Is Sales Order
                if "XTECSC Shipment Log"."Shipment Type" = "XTECSC Shipment Log"."Shipment Type"::"Sales Order" then
                    SalesShipmentHeader.SetRange("Order No.", "XTECSC Shipment Log"."Document No.");

                if not SalesShipmentHeader.FindFirst() then
                    exit;


                // Modify log
                Validate("Receiver No.", SalesShipmentHeader."Sell-to Customer No.");
                Validate("Receiver Name", SalesShipmentHeader."Ship-to Name");

                Modify(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Shipment Type"; "XTECSC Shipment Log"."Shipment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Selects the Shipment Type filter.';
                }
            }
        }
    }

    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
}
