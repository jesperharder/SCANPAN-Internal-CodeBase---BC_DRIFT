



/// <summary>
/// Enum Address Types (ID 50011).
/// </summary>
/// <remarks>
/// 2023.08             Jesper Harder       046         Addresses Customer and Vendor
/// </remarks>

enum 50011 "Address Types"
{
    Extensible = true;
    value(0; "Customer")
    {
        Caption = 'Customer';
    }
    value(1; "Customer Ship-To")
    {
        Caption = 'Customer Ship-To';
    }
    value(2; "Vendor")
    {
        Caption = 'Vendor';
    }
}