/// <summary>
/// Table "SCANPANTmpProdLines" (ID 50007).
/// </summary>
///
/// <remarks>
///
/// 2023.03.13          Jesper Harder                   001 Production Controlling
///
/// </remarks>
table 50007 "ProdControllingLinesTMP"
{
    Caption = 'SCANPANTmpProdLines';
    DataClassification = ToBeClassified;

#if not CLEAN17
    TableType = Temporary;
#else
    ObsoleteState = Pending;
    ObsoleteReason = 'Table will be marked as TableType=Temporary. Make sure you are not using this table to store records';
    ObsoleteTag = '17.0';
#endif

    fields
    {
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Order Type"; Enum "Enum Controlling Documents")
        {
            Caption = 'Order Type';
            DataClassification = ToBeClassified;
        }
        field(30; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(40; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(50; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(60; Quantity; Decimal)
        {
            Caption = 'Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(70; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(71; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(72; "Quantity Production Units"; Decimal)
        {
            Caption = 'Quantity Production Units';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(73; "Finished Qty Production Units"; Decimal)
        {
            Caption = 'Finished Quantity Production Units';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(74; "Remaining Qty Production Units"; Decimal)
        {
            Caption = 'Remaining Quantity Production Units';
            BlankZero = true;
            BlankNumbers = BlankZero;
            DataClassification = ToBeClassified;
        }
        field(80; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(90; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
        }
        field(100; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(110; Material; Text[100])
        {
            Caption = 'Material';
            DataClassification = ToBeClassified;
        }
        field(120; "Route Type"; Text[100])
        {
            Caption = 'Route Type';
            DataClassification = ToBeClassified;
        }
        field(130; YearWeek; Text[10])
        {
            Caption = 'YearWeek';
            DataClassification = ToBeClassified;
        }
        field(140; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
        }
        field(150; "Product Line Code"; code[20])
        {
            Caption = 'Product Line Code';
            DataClassification = ToBeClassified;
        }
        field(160; "ABCD Category"; Code[20])
        {
            Caption = 'ABCD Category';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
