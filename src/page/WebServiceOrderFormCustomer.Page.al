/// <summary>
/// Page WebServiceOrderFormCustomer (ID 50031).
/// </summary>
///
/// <remarks>///
///
/// 2023.04.18                  Jesper Harder                   024     SalesOrderForm WebServices used in Excel Sales Order Forms.
///
/// </remarks>
page 50032 "WebServiceOrderFormCustomer"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = 'WebServices Sales Orderform Customers';
    Editable = false;
    PageType = List;
    Permissions =
        tabledata Customer = R;
    SourceTable = Customer;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(repeater1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Customer No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Customer Name';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Old Customer No."; Rec."Old Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Alternative Customer No. field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
            }
        }
    }
}

/*

SELECT    	Name
			, No_
			, Name
			, [Country_Region Code]
FROM      	dbo.[SCANPAN A_S$Customer] AS CU
WHERE       ([Salesperson Code] = 'DE4')
ORDER BY CU.Name ASC

*/
