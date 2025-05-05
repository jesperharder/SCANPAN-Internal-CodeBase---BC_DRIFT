/// <summary>
/// Table SCANPANTMPProdFoundry (ID 50011).
/// </summary>
///
/// <remarks>
///
/// 2023.03.21                          Jesper Harder                               010     List Production Orders in STØBERI
///
/// </remarks>
table 50011 "ProdContllingRoutingLinesTMP"
{
    Caption = 'SCANPAN TMP Production Controlling Routing Lines';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Priority"; Integer)
        {
            Caption = 'Priority';
        }
        field(15; "Comment"; text[150])
        {
            Caption = 'Comment';
        }
        field(20; RoutingType; Text[50])
        {
            Caption = 'Ressource Type';
            Editable = false;
        }
        field(28; "Status"; enum "Production Order Status")
        {
            Caption = 'Production Order Status';
            Editable = false;
        }
        field(30; "Production Order No."; code[20])
        {
            Caption = 'Production Order No.';
            Editable = false;
            TableRelation = "Production Order" where(Status = const(Released));
        }
        field(35; "Ressource No."; Text[20])
        {
            Caption = 'Ressource No.';
            Editable = false;
        }
        field(40; "Routing Description"; text[100])
        {
            Caption = 'Ressource Name';
            Editable = false;
        }
        field(45; "Operation No."; Text[20])
        {
            Caption = 'Operation No.';
            Editable = false;
        }
        field(50; ItemNo; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
        }
        field(60; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
        }
        field(70; "Work Center Group Code"; Text[20])
        {
            Caption = 'Departmnet No.';
            Editable = false;
        }
        field(80; Quantity; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
        }
        field(90; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            Editable = false;
        }
        field(100; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            Editable = false;
        }
        field(101; "Finished Percentage"; Decimal)
        {
            Caption = 'Finished Percentage';
            Editable = false;
        }
        field(102; "Item Set Multiplier"; Integer)
        {
            Caption = 'Item Set Multiplier';
            editable = false;
        }
        field(103; "Remaining Set Quantity"; Decimal)
        {
            Caption = 'Remaining Set Quantity';
            editable = false;
        }
        field(104; "Finished Set Quantity"; Decimal)
        {
            Caption = 'Finished Set Quantity';
        }
        field(105; "Quantity Set"; Decimal)
        {
            Caption = 'Quantity Set';
        }
        field(110; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(120; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            Editable = false;
        }
        field(130; "Coating"; Text[50])
        {
            Caption = 'Coating';
            Editable = false;
            TableRelation = ProdControllingItemMap;
        }
        field(131; "Coating Item"; Text[50])
        {
            Caption = 'Coating Item';
            Editable = false;
            TableRelation = ProdControllingItemMap;
        }
        field(132; "First BOM Body"; code[20])
        {
            Caption = 'First BOM Body';
            Editable = false;
            TableRelation = Item;
        }

        field(200; "Modiified"; Boolean)
        {
            Caption = 'Modified record';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
        key(Key1; Modiified)
        {

        }
    }

    trigger OnModify()
    var
    begin
        Rec.Modiified := true;
        if Rec.Modify() then;
    end;
}
