/// <summary>
/// Enum Enum Controlling Documents (ID 50008).
/// </summary>
/// <remarks>
///
/// 2023.03.13          Jesper Harder                   001 Production Controlling
///
/// </remarks>
enum 50008 "Enum Controlling Documents"
{
    caption = 'Enum Controlling Documents';

    value(0; "Transfer Order")
    {
        Caption = 'Transfer Order';
    }
    value(1; "Released PO")
    {
        Caption = 'Released Production Order';
    }
    value(2; "Firm PO")
    {
        Caption = 'Firmed Production Order';
    }
}