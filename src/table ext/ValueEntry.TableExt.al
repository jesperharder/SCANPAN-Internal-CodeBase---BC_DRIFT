/// <summary>
/// TableExtension ValueEntry (ID 50014) extends Record Value Entry.
/// </summary>
/// <remarks>
///
/// 2023.07             Jesper Harder           036         Value Entry, new fields, Added Code
///
/// </remarks>
tableextension 50015 "ValueEntry" extends "Value Entry"
{
    fields
    {
        field(50000; "Product Line Code"; code[20])
        {
            Caption = 'Product Line Code';
            TableRelation = "NOTO Item Categories".code where("Category Code" = const(ProductLineCode));
        }
    }
}