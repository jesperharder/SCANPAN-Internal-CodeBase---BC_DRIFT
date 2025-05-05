




/// <summary>
/// Table InventoryJournalStatus (ID 50004).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
/// 
/// </remarks>

table 50004 "InventoryJournalStatus"
{


    Caption = 'Inventory Journal Status';
    DataClassification = ToBeClassified;
    Permissions = 
        tabledata InventoryJournalStatus = rimd;


    fields
    {

        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Inventory Journal ID"; text[30])
        {
            Caption = 'Inventory Journal ID';
        }
        field(30; "Ressource ID"; code[20])
        {
            Caption = 'Ressource ID';
        }
        field(40; "Shelf No."; text[30])
        {
            Caption = 'Shelf No.';
        }
        field(50; "Item No."; code[20])
        {
            Caption = 'Item No.';
        }
        field(60; "Item Description"; text[100])
        {
            Caption = 'Item Description';
        }
        field(70; "Base Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            BlankZero = true;
            Caption = 'Base Quantity';
        }
        field(80; "Reported Quatity"; Decimal)
        {
            BlankNumbers = BlankZero;
            BlankZero = true;
            Caption = 'Reported Quantity';
        }
        field(90; "Difference Quatity"; Decimal)
        {
            BlankNumbers = BlankZero;
            BlankZero = true;
            Caption = 'Difference Quantity';
        }

    }
    /*
        Inventory Journal ID
        Inventory Journal Name     

        Ressource ID
        Shelf No.

        Item No.
        Item Description

        BaseQty - ref Inventory Journal ID
        Reported Qty
        Difference Qty

    */
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "Ressource ID", "Shelf No.", "Item No.")
        { }
    }


}