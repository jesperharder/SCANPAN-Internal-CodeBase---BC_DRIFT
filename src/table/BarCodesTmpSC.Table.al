


/// <summary>
/// Table SCANPAN Temptable BarCodes (ID 50000).
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>
table 50000 "BarCodesTmpSC"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Item No"; Code[20]) { Caption = 'Item No.'; }
        field(2; "Unit of Measure Code"; Code[10]) { Caption = 'UOM Code'; }
        field(3; "Num Barcodes"; Integer) { Caption = 'No. of Barcodes'; }
        field(4; "Create Now EAN"; Boolean) { Caption = 'Create EAN now'; }
        field(5; "Create Now UPC"; Boolean) { Caption = 'Create UPC now'; }
    }

    keys
    {
        key(Key1; "Item No", "Unit of Measure Code") { Clustered = true; }
    }
}
