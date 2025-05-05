


/// <summary>
/// TableExtension CapacityLedgerEntry (ID 50029) extends Record Capacity Ledger Entry.
/// </summary>
/// <remarks>
/// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts
/// </remarks>
tableextension 50029 "CapacityLedgerEntry" extends "Capacity Ledger Entry"
{
    fields
    {
        field(50000; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line".Status where("Prod. Order No." = field("Order No.")));
        }
        field(50005; "Item Category Code"; code[20])
        {
            Caption = 'Item Category Code';
            fieldClass = Flowfield;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
        }
    }
}