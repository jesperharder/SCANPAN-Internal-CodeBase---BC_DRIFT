

/// <summary>
/// pageextension 50007 "PriceListLinesExtSC" extends "Price List Lines"
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50007 "PriceListLinesExtSC" extends "Price List Lines"
{
    layout
    {
        addafter("Allow Line Disc.")
        {
            field("Source No.34177"; Rec."Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unique identifier of the source of the price on the price list line.';
            }
            field("Parent Source No.97763"; Rec."Parent Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the job to which the prices are assigned. If you choose an entity, the price list will be used only for that entity.';
            }
        }
        addafter("Work Type Code") { field("Source Type50933"; Rec."Source Type") { ApplicationArea = All; ToolTip = 'Specifies the type of the entity that offers the price or the line discount on the product.'; } }
        addafter("Unit Price") { field("Direct Unit Cost1"; Rec."Direct Unit Cost") { ApplicationArea = All; ToolTip = 'Specifies the cost of one unit of the selected product.'; } }
    }
}


