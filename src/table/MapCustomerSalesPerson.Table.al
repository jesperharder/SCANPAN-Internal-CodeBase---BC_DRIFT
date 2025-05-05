
/// <summary>
/// Table "ExtSalesMapSalesView" (ID 50002).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.24              Jesper Harder               014 External Sales ToolBox - 3.2023          Code start.
/// 
/// </remarks>
table 50002 "MapCustomerSalesPerson"
{
    Caption = 'Ext Sales Map SalesPerson';
    DataClassification = ToBeClassified;

    Permissions = tabledata MapCustomerSalesPerson = rimd;

    fields
    {
        field(1; UserName; Code[50])
        {
            //TableRelation = User."User Name";
            Caption = 'User Name';
            DataClassification = ToBeClassified;
        }
        field(2; CustomerSalesCode; Code[20])
        {
            Caption = 'Customer Sales Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(3; ShowAllCustomers; Boolean)
        {
            Caption = 'Show All Customers';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; UserName, CustomerSalesCode)
        {
            Clustered = true;
        }
    }
}

