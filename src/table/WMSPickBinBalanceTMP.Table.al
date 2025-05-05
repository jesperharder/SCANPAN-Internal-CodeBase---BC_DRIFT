

/// <summary>
/// Table "SCANPANWMSPickBinBalance" (ID 50008).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03                     Jesper Harder                   002             Check warehouse balance in Bin
/// 
/// </remarks>  
table 50008 "WMSPickBinBalanceTMP"
{
    Caption = 'TMP Pick Bin Balance';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Item No"; Code[20])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
        }
        field(3; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(6; "Pick Quantity"; Decimal)
        {
            Caption = 'Pick Quantity';
            DataClassification = ToBeClassified;
        }
        field(7; "Bin Quantity"; Decimal)
        {
            Caption = 'Bin Quantity';
            DataClassification = ToBeClassified;
        }
        field(8; "Bin Quantity Balance"; Decimal)
        {
            Caption = 'Bin Quantity Balance';
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
