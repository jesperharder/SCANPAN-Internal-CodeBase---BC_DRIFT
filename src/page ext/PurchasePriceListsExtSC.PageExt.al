


/// <summary>
/// PageExtension "PurchasePriceListsExtSC" (ID 50031) extends Record Purchase pric.
/// </summary>
pageextension 50031 PurchasePriceListsExtSC extends "Purchase Price Lists"
{
    layout
    {
        addfirst(Control1)
        {
            field(Code1; Rec.Code)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unique identifier of the price list.';
            }
        }

    }

}
