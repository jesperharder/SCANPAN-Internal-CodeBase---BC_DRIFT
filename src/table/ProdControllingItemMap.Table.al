



/// <summary>
/// Table ProdControllingItemMap (ID 50021).
/// </summary>
/// <remarks>
/// 2023.10             Jesper Harder       056         Coating Description on Production Orders
/// </remarks>
table 50021 "ProdControllingItemMap"
{
    Caption = 'SCANPAN Production Controlling Item Map';
    DataClassification = ToBeClassified;

    Permissions = tabledata MapCustomerSalesPerson = rimd;
    
    fields
    {

        field(10; "Item No."; code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(20; "Coating"; text[50])
        {
            Caption = 'Coating Name';
        }
    }

    keys
    {
        key(PK; "Item No.", Coating)
        {
            Clustered = true;
        }
    }

}