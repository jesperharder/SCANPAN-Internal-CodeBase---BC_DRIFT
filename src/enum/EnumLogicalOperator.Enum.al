




/// <summary>
/// Enum EnumLogicalOperator (ID 50015).
/// </summary>
/// <remarks>
/// 
/// 2023.08         Jesper Harder               045     Mandatory Fields setup
/// 
/// </remarks>

enum 50015 EnumLogicalOperator
{

    caption = 'Mandatory Setup Logical Operators';
    Extensible = true;

    value(0; "Equal")
    {
        Caption = 'Equal';
    }
    value(1; "Not")
    {
        Caption = 'Not';
    }
}