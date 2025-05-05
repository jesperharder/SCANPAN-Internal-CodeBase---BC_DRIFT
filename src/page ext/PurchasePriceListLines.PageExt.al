



/// <summary>
/// PageExtension "PurchasePriceListLines" (ID 50032) extends Record Purchase Price List Lines.
/// </summary>
pageextension 50032 PurchasePriceListLines extends "Purchase Price List Lines"
{

    layout
    {
        modify("Work Type Code") { Visible = false; }
        modify("Variant Code") { Visible = false; }
        modify(Description) { Visible = false; }
        modify("Allow Line Disc.") { Visible = false; }
        modify("Allow Invoice Disc.") { Visible = false; }
    }

}
