/// <summary>
/// TableExtension ProdOrderLine (ID 50009) extends Record Prod. Order Line.
/// </summary>
/// <remarks>
/// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts
/// </remarks>
tableextension 50009 "ProdOrderLine" extends "Prod. Order Line"
{
    fields
    {
        field(50000; Int; Integer)
        {
            Caption = 'Int';
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;
            ObsoleteReason = 'To be removed.';
            ObsoleteTag = '17.0';
        }

        //57
        field(50002; "Set Quantity"; Decimal)
        {
            Caption = 'Set Multiplier';
        }
        field(50003; "Finished Set Quantity"; Decimal)
        {
            Caption = 'Finished Set Quantity';
        }
        field(50004; "Remaining Set Quantity"; Decimal)
        {
            Caption = 'Remaining Set Quantity';
        }
        field(50005; "Item Category Code"; code[20])
        {
            Caption = 'Item Category Code';
            fieldClass = Flowfield;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
        }
        field(50006; "Quantity SetQuantity"; Decimal)
        {
            Caption = 'Quantity SetQuantity';
        }
    }
}