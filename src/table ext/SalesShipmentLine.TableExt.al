//SHIPITREMOVE

tableextension 50012 "SalesShipmentLine" extends "Sales Shipment Line"
{
    /// <summary>
    /// TableExtension SalesShipmentLine (ID 50012) extends Record Sales Shipment Line.
    /// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
    /// 2024.10             Jesper Harder       092         Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// </summary>

    fields
    {
        field(50000; "Transport Order Id"; Code[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore';
            Caption = 'Transport Order No.';
            Editable = false;
        }
        field(50001; "Transport Order No2"; Code[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore ShipIT';
            Caption = 'Transport Order No.';
            FieldClass = FlowField;
            //CalcFormula = lookup("Posted Whse. Shipment Line"."Transport Order No." where("Posted Source No." = field("Document No.")));
        }
        field(50002; "Shipping Agent Code"; Code[20])
        {
            Caption = 'Transport Shipping Agent Code';
            //ShipIT 
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore ShipIT';
            //FieldClass = FlowField;
            //CalcFormula = lookup("IDYS Transport Order Header"."Shipping Agent Code" where("No." = field("Transport Order No2")));
        }
        field(50003; "Shipping Agent Service Code"; Code[20])
        {
            Caption = 'Transport Shipping Agent Service Code';
            //ShipIT 
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore ShipIT';
            //FieldClass = FlowField;
            //CalcFormula = lookup("IDYS Transport Order Header"."Shipping Agent Service Code" where("No." = field("Transport Order No2")));
        }

        field(50004; "Shipping Agent Code2"; Code[20])
        {
            Caption = 'Transport Shipping Agent Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Shipping Agent Code" where("No." = field("Document No.")));
        }
        field(50005; "Shipping Agent Service Code2"; Code[20])
        {
            Caption = 'Transport Shipping Agent Service Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Shipping Agent Service Code" where("No." = field("Document No.")));
        }

        // 092 New fields with lookups to ShippingAgentDistribution table
        field(50006; "Distribution Code"; Code[20])
        {
            Caption = 'Distribution Code';
        }
        field(50007; "Distribution Country Code"; Code[10])
        {
            Caption = 'Distribution Country Code';
        }
        field(50008; "Distribution Description"; Text[100])
        {
            Caption = 'Distribution Description';
        }
        field(50009; "Distribution Range"; Text[100])
        {
            Caption = 'Distribution Range';
        }
    }
}
