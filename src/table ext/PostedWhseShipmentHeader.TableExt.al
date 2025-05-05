






/// <summary>
/// TableExtension PostedWhseShipmentHeader (ID 50016) extends Record Posted Whse. Shipment Header.
/// </summary>
/// <remarks>
/// 
/// 2023.7.19                   Jesper Harder           035 Post TransportOrderID posted to Posted Whse. ShipmentLines through 14.7.2023 Added Code
/// 
/// </remarks>      
tableextension 50016 "PostedWhseShipmentHeader" extends "Posted Whse. Shipment Header"
{

    fields
    {
        field(50000; "Transport Order No.";code[20])
        {
            Caption = 'Transport Order No.';
            DataClassification = ToBeClassified;
        }
    }
}