


/// <summary>
/// /// 2024.05             Jesper Harder       067         Add fields to facilitate Datawarehouse fields
/// </summary>
enum 50020 CountryMarketType
{
    Caption = 'Country Market Type';
    Extensible = false;

    value(0; None)
    {
        Caption = ' ';
    }
    value(1; Focus)
    {
        Caption = 'Focus';
    }
    value(2; Secondary)
    {
        Caption = 'Secondary';
    }
    value(3; Growth)
    {
        Caption = 'Growth';
    }
}
