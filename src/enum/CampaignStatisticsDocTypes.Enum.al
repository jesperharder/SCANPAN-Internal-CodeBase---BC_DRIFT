/// <summary>
/// Enum CampaignStatistics DocTypes (ID 50007).
/// </summary>
/// <remarks>
/// 2023.06.12                  Jesper Harder               034 Campaign statistics Added Code
/// </remarks>
enum 50007 "CampaignStatistics DocTypes"
{
    Extensible = true;

    value(0; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(1; "Invoice")
    {
        Caption = 'Invoice';
    }

    value(2; "Forecast")
    {
        Caption = 'Forecast';
    }
}
