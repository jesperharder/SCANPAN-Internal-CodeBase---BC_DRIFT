





/// <summary>
/// TableExtension Tariff Number (ID 50020) extends Record Tariff Number.
/// </summary>
/// <remarks>
/// 2023.09            Jesper Harder        050         Duty Percentage to Tariff page 
/// </remarks>
tableextension 50020 "Tariff Number" extends "Tariff Number"
{
    fields
    {
        field(50000; "Duty Percentage"; Decimal)
        {
            Caption = 'Duty Percentage';
            DecimalPlaces = 0 : 5;
        }
    }
}