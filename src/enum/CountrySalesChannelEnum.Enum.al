

/// <summary>
/// 2024.05             Jesper Harder       067         Add fields to facilitate Datawarehouse fields
/// </summary>

enum 50021 CountrySalesChannelEnum
{
    Extensible = false;
    Caption = 'Country Sales Channel';

    value(0; None)
    {
        Caption = ' ';
    }
    value(1; Agent)
    {
        Caption = 'Agent';
    }
    value(2; Distributor)
    {
        Caption = 'Distributor';
    }
    value(3; Own)
    {
        Caption = 'Own';
    }
}
 