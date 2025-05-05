//SHIPITREMOVE

/// <summary>
/// TableExtension IDYSTransportOrderLine (ID 50010) extends Record IDYS Transport Order Line.
/// </summary>
///
/// <remarks>
/// 2023.05.01                  Jesper Harder                   027         Add Shipment tracking
/// </remarks>
///


/*
tableextension 50010 "IDYSTransportOrderLine" extends "IDYS Transport Order Line"
{
    fields
    {
        field(50000; "Document Date"; date)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore';

            Caption = 'Transport Order Document Date';
            Description = 'Transport Order Document Date.';
            //FieldClass = FlowField;
            //CalcFormula = lookup(
            //    "IDYS Transport Order Header"."Document Date" where("No." = field("Transport Order No.")));
        }
        field(50001; "Tracking No."; code[50])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not in use anymore';

            Caption = 'Tracking No.';
            Description = 'Shows IDYS Transport Order Tracking No.';
            //FieldClass = FlowField;
            //CalcFormula = lookup(
            //    "IDYS Transport Order Header"."Tracking No." where("No." = field("Transport Order No.")));
        }
    }
}
*/