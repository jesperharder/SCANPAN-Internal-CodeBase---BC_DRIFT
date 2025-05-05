

/// <summary>
/// Enum SCANPAN_ItemCrossReferenceTypes (ID 50000).
/// </summary>
/// <remarks>
/// 
/// 2023.03.30                  Jesper Harder               020     PriceList Source Data Code start.
/// 
/// </remarks>

enum 50000 "EnumItemReferenceTypes"
{
    Caption = 'Enum Item Reference Types';
    Extensible = true;

    value(0; "Barcode")
    {
        Caption = 'Barcode';
    }
    value(1; "Item Unit")
    {
        Caption = 'Item Unit';
    }
}
