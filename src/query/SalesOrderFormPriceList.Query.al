
/// <summary>
/// Query SalesOrderForm PriceList (ID 50000).
/// </summary>
/// <remarks>
/// https://community.dynamics.com/business/f/dynamics-365-business-central-forum/471027/group-by-in-al-query-like-sql
/// https://yzhums.com/14547/
/// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/webservices/use-filter-expressions-in-odata-uris
/// http://srvbcapp1.scanpan.dk:7148/BC_DRIFT/ODataV4/Company('SCANPAN%20Danmark')/SalesprislisteKildeData?$filter=No%20eq%20%2700104815%27
/// ?$filter=LanguageCode%20eq%20%27DEU%27%20and%20AssetNo%20eq%20%2728001200%27
/// 
/// </remarks>
query 50000 "SalesOrderForm PriceList"
{
    Caption = 'SalesOrderFormPriceList';
    //EntityName = 'SalesOrderFormItems';
    //EntitySetName = 'SalesOrderFormItems';
    //QueryType = API;


    elements
    {
        dataitem(Price_List_Line; "Price List Line")
        {
            DataItemTableFilter = "Asset Type" = const(Item),
                                  Status = const(Active),
                                  "Ending Date" = filter(''),
                                  "Source No." = filter('RRP'),
                                  "Currency Code" = filter('EUR');

            column(Asset_Type; "Asset Type")
            { }
            column(AssetNo; "Asset No.")
            { }
            column(Description; Description)
            { }
            column(CurrencyCode; "Currency Code")
            { }
            column(LineNo; "Line No.")
            { }
            column(Minimum_Quantity; "Minimum Quantity")
            { }
            column(UnitListPrice; "Unit List Price")
            { }
            column(UnitPrice; "Unit Price")
            { }
            column(UnitListPriceCurrency; "Unit List Price (Currency)")
            { }
            column(UnitPriceCurrency; "Unit Price (Currency)")
            { }
            column(VATBusPostingGrPrice; "VAT Bus. Posting Gr. (Price)")
            { }

            dataitem(Item_Translation; "Item Translation")
            {
                DataItemLink = "Item No." = Price_List_Line."Asset No.";

                column(LanguageCode; "Language Code")
                { }
                column(ItemTranslationDescription; Description)
                { }
            }
        }

    }

    trigger OnBeforeOpen()
    begin

    end;
}

