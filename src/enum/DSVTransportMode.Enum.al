




/// <summary>
/// Enum DSVTransportMode (ID 50017).
/// </summary>
/// ///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>

enum 50017 "DSVTransportMode"
{

    value(0; "SEA")
    {
        Caption = 'Oceanfreight (SEA)';
    }
    value(1; "AIR")
    {
        Caption = 'Airfreight (AIR)';
    }
    value(2; "ROAD")
    {
        Caption = 'Roadfreight (ROAD)';
    }
    value(3; "COU")
    {
        Caption = 'Courier/Express (COU)';
    }
} 