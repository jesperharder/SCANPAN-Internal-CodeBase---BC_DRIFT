


/// <summary>
/// Enum PeriodLength (ID 50016).
/// </summary>
/// <remarks>
/// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts
/// </remarks>
enum 50016 "PeriodType"
{
    Extensible = true;

    value(0; "Date")
    {
        Caption = 'Date';
    }
    value(1; "Week")
    {
        Caption = 'Week';
    }

    value(2; "Month")
    {
        Caption = 'Month';
    }

    value(3; "Quarter")
    {
        Caption = 'Quarter';
    }

    value(4; "Year")
    {
        Caption = 'Year';
    }
}