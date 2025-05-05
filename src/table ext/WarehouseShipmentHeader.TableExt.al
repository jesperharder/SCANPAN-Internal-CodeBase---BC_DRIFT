tableextension 50005 WarehouseShipmentHeader extends "Warehouse Shipment Header"
{
    /// <summary>
    /// TableExtension "WarehouseShipmentHeaderExtSC" (ID 50005) extends Record Warehouse Shipment Header.
    /// </summary>
    /// <remarks>
    /// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
    /// 2024.12             Jesper Harder       101         Show WaybillHeader Shipping Agent Code on WarehouseShipmentList
    /// </remarks>

    fields
    {
        field(50000; Description; Text[130])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50001; "Warehouse Pick No."; Code[20])
        {
            Caption = 'Warehouse Pick No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Activity Line"."No."
                where("Whse. Document No." = field("No."), "Whse. Document Type" = const(Shipment)));
        }

        //SHIPITREMOVE
        field(50002; "Transport Order No."; code[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore';
            Caption = 'Transport Order No.';
            DataClassification = ToBeClassified;
            //TableRelation = "IDYS Transport Order Header"."No.";
        }


        field(50003; "WayBillShipAgentCode"; code[20])
        {
            Caption = 'WayBill Shipping Agent Code';
            FieldClass = FlowField;
            CalcFormula = lookup("XTECSC Waybill Header"."Shipping Agent Code"
                where("Document Guid" = field(SystemId)));
        }
    }
}
