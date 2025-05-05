




/// <summary>
/// Table InventoryRessourceID (ID 50005).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
/// 
/// </remarks>
table 50005 "InventoryRessourceID"
{
    TableType = Temporary;
    LookupPageId = InventoryRessources;
    Caption = 'Inventory Temporary Ressouce ID';

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Ressouce ID"; code[20])
        {
            Caption = 'Ressource ID';
        }
    }

    keys
    {
        key(PK; "Ressouce ID")
        {
            Clustered = true;
        }
    }
}