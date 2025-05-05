




/// <summary>
/// Page SCANPANExtSalesRoleCenter (ID 50016).
/// </summary>
/// 
/// <remarks>
/// 
///  2023.03.08                 Jesper Harder               0292        Rollecenter for Eksterne sælgere og agenter.
/// 
/// </remarks>  
page 50016 "ExtSalesRoleCenter"
{
    Caption = 'Sales Ext Role Center';
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {

            part(Part1; "ExtSalesLinesSC")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;

            }

            part(Part2; "ExtSalesItemListSC")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
            }
        }
    }



    actions
    {
        area(Sections)
        {
        }

        area(Embedding)
        {

            action(Action1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Salesline';
                Image = Sales;
                RunObject = Page "ExtSalesLinesSC";
                ToolTip = 'Shows Saleslines for current user.';
            }

            action(Action2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Sales;
                RunObject = Page "ExtSalesItemListSC";
                ToolTip = 'Shows Items for current user.';
            }

        }

        area(Processing)
        {
        }

        area(Creation)
        {
        }

        area(Reporting)
        {
        }
    }
}

// Creates a profile that uses the Role Center
profile _EXTSALES
{
    ProfileDescription = 'Rolecenter for Ext Salespersons.';
    RoleCenter = "ExtSalesRoleCenter";
    Caption = 'EXT SALES';
}
