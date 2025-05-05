


/// <summary>
/// Enum EnumGetItemPurchasePrice (ID 50002).
/// </summary>
/// <remarks>
/// 
/// 2023.03.30                  Jesper Harder               020     PriceList Source Data Code start.
/// 
/// </remarks>

enum 50002 "EnumGetItemPurchasePrice"
{
    Caption = 'Enum to determine return values from Item Purchase Price';
    Extensible = false;

    value(0; "Direct Unit Cost")
    {
        Caption = 'Direct Unit Cost';
    }
    value(1; "Currency Code")
    {
        Caption = 'Currency Code';
    }

}
