



/// <summary>
/// Page SCANPANMapSalesPerson (ID 50015).
/// </summary>
/// 
/// <remarks>
/// 
///  2023.03.08                 Jesper Harder               0292        Adgang til Salgslinjeværktøj Eksterne Sælgere
/// 
/// </remarks>  

page 50015 "ExtSalesMapSalespersonSC"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Sales Ext Map Salesperson';
    PageType = List;
    Permissions =
        tabledata MapCustomerSalesPerson = RIMD;
    SourceTable = MapCustomerSalesPerson;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(UserName; Rec.UserName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Name in Business Central.';
                }
                field(CustomerSalesCode; Rec.CustomerSalesCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Sales Code field.';
                }
                field(ShowAllCustomers; Rec.ShowAllCustomers)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show All Customers field.';
                }
            }
        }
    }

}


