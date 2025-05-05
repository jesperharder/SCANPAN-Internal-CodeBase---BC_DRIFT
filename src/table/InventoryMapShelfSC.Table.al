


/// <summary>
/// Table InventoryJournal (ID 50003).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
/// 
/// </remarks>
/// 
table 50003 "InventoryMapShelfSC"
{

    Caption = 'Inventory Map Shelf No.';
    DataClassification = ToBeClassified;

Permissions = 
        tabledata InventoryMapShelfSC = rimd;

    fields
    {

        field(10; "Ressource Name"; code[20])
        {
            Caption = 'Ressouce Name';
        }
        field(20; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
        }

    }

    keys
    {
        key(PK; "Ressource Name", "Shelf No.")
        {
            Clustered = true;
        }
    }
}