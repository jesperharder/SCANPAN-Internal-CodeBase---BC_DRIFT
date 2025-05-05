



/// <summary>
/// PageExtension PriceListLineReview (ID 50061) extends Record Price List Line Review.
/// </summary>
/// 
/// <remarks>
/// 
/// Version List
/// 
/// 2022.04             Jesper Harder                   Added PageExt added "Unit List Price"
/// 
/// </remarks>
pageextension 50061 "PriceListLineReview" extends "Price List Line Review"
{
    layout
    {
        addafter("Line Discount %") { field("Unit List Price1"; Rec."Unit List Price") { ApplicationArea = All; ToolTip = 'Specifies the value of the Unit List Price field.'; } }
    }
}