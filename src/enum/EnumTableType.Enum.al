 




/// <summary>
/// Enum EnumTableType (ID 50010).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
/// 
/// </remarks>
enum 50010 "EnumTableType"
{

    caption = 'Mandatory Fields Setup';
    Extensible = true;

    value(0; "Customer")
    {
        Caption = 'Customer';
    }

    value(1; "Vendor")
    {
        Caption = 'Vendor';
    }

    value(2; "Item")
    {
        Caption = 'Item';
    }

}