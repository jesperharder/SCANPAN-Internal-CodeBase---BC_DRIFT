


/// <summary>
/// Enum EnumProductionOrderStatus (ID 50004).
/// </summary>
/// <remarks>
/// 
/// 2023.03.30                  Jesper Harder               020     PriceList Source Data Code start.
/// 2023.04.10                  Jesper Harder               022     Porting the PanPlan project to AL/Code.
/// </remarks>

enum 50004 "EnumProductionOrderStatus"
{
    caption = 'Production Order Status';
    Extensible = true;

    value(0; "Simulated")
    {
        Caption = 'Simulated';
    }
    value(1; "Planned")
    {
        Caption = 'Planned';
    }
    value(2; "Firm Planned")
    {
        Caption = 'Firm Planned';
    }
    value(3; "Released")
    {
        Caption = 'Released';
    }
    value(4; "Finished")
    {
        Caption = 'Finished';
    }

    //022
    value(5; "Receipts")
    {
        Caption = 'Receipts';
    }
}

