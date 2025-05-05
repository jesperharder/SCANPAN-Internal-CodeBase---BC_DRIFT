
/// <summary>
/// TableExtension SalesShipmentHeader (ID 50017) extends Record Sales Shipment Header.
/// </summary>
/// <remarks>
/// 
/// 2023.7.19           Jesper Harder       035         Post TransportOrderID posted to Posted Whse. ShipmentLines through 14.7.2023 Added Code
/// 2024.07             Jesper Harder       072         Pallet Manifest v2 fetch from new tasklet tables and use PostedSalesShipment as base table
/// 
/// </remarks>      

tableextension 50017 "SalesShipmentHeader" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Transport Order No."; code[20])
        {
            Caption = 'Transport Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Whse. Shipment Line"."Transport Order No." where("Posted Source No." = field("No.")));
        }

        //072
        field(50001; "PostedWhseShipmentNo"; code[20])
        {
            Caption = 'Posted Whse. Shipment No.';
            FieldClass = FLowField;
            CalcFormula = lookup("Posted Whse. Shipment Line"."Whse. Shipment No." where("Posted Source No." = field("No.")));
        }
    }
}