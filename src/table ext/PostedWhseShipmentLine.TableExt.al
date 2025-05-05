/// <summary>
/// TableExtension PostedWhseShipmentLine (ID 50013) extends Record Posted Whse. Shipment Line.
/// </summary>
/// <remarks>
/// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
/// </remarks>
tableextension 50013 "PostedWhseShipmentLine" extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(50000; "Transport Order No."; code[20])
        {
            Caption = 'Transport Order No.';
            DataClassification = ToBeClassified;
        }
        field(50001; "Transport Order No2"; Code[20])
        {
            Caption = 'Transport Order No2.';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Whse. Shipment Header"."Transport Order No."
                        where("No." = field("No.")));
        }
    }
}