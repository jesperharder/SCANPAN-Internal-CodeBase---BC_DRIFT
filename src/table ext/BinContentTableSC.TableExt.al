

/// <summary>
/// TableExtension "BinContentTableExt" (ID 50008) extends Record Bin Content.
/// </summary>
/// 
/// <remarks>
/// 
///  2023.03.18                 Jesper Harder               009     Bin Content Added flowfield Inventory Posting Group, Product Line
/// 
/// </remarks> 
tableextension 50008 "BinContentTableSC" extends "Bin Content"
{
    fields
    {
        field(50000; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Inventory Posting Group" WHERE("No." = field("Item No.")));
        }
        field(50001; "Product Line Code"; Code[50])
        {
            Caption = 'Product Line Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Line Code" where("No." = field("Item No.")));
        }
        field(50003; "Transfer Order No."; code[20])
        {
            Caption = 'Transfer Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Line"."Document No." where("Item No." = field("Item No.")));

        }
    }
}
