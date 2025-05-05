/// <summary>
/// TableExtension "SalesHeaderExt" (ID 50006) extends Record Sales Header.
/// </summary>
///
/// <remarks>
///
/// 2023.03.23             Jesper Harder       013         Display DropShip Purchase Order No. On Sales Order List
/// </remarks>
tableextension 50006 "SalesHeaderSC" extends "Sales Header"
{
    fields
    {
        //013
        field(50000; "Drop Shipment Order No."; code[30])
        {
            Caption = 'Drop Shipment Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Document No." where("Document Type" = const(Order),
                                                                       "Drop Shipment" = const(true),
                                                                       "Sales Order No." = field("No.")));
        }
    }
}