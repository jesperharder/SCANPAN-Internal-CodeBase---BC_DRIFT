


/// <summary>
/// Table ProdControllingRoutes (ID 50014).
/// </summary>
/// <remarks>
/// 2023.05.11                      Jesper Harder                           030     List All Routing Lines
/// 2023.10                         Jesper Harder                           001     Production Controlling, RoutingLines Priority, Short Comments
/// </remarks>
table 50014 "ProdControllingRoutes"
{
    Caption = 'ProdControllingRoutes';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        //Header Information
        field(1; "Line No."; Integer)
        {
            Caption = 'line No.';
            DataClassification = ToBeClassified;
        }
        field(10; "No."; code[20])
        {
            Caption = 'No.';
        }
        field(20; Description; text[100])
        {
            Caption = 'Description';
        }
        field(40; Status; enum "Routing Status")
        {
            Caption = 'Status';
        }
        field(50; LastDateModified; Date)
        {
            Caption = 'Last Date Modified';
        }
        field(60; Comment; Boolean)
        {
            Caption = 'Has Comment';
        }

        //Lines Information
        field(100; OperationNo; code[20])
        {
            Caption = 'Operation No.';
        }
        field(105; "Routing Priority"; Integer)
        {
            Caption = 'Routing Priority';
        }
        field(110; "Line_Type"; enum "Capacity Type Routing")
        {
            Caption = 'Type';
        }
        field(120; Line_No; code[20])
        {
            Caption = 'Ressource No.';
        }
        field(130; Line_Description; Text[100])
        {
            Caption = 'Ressouce Description';
        }
        field(140; RoutingLinkCode; Code[20])
        {
            Caption = 'Routing Link Code';
        }
        field(150; SetupTime; Decimal)
        {
            BlankZero = true;
            Caption = 'Setup Time';
        }
        field(160; RunTime; Decimal)
        {
            BlankZero = true;
            Caption = 'Runt Time';
        }
        field(170; RunTimeUnitofMeasCode; Code[20])
        {
            Caption = 'Runt Time Unit of Measure Code';
        }
        field(180; WaitTime; Decimal)
        {
            BlankZero = true;
            Caption = 'Wait Time';
        }
        field(190; MoveTime; Decimal)
        {
            BlankZero = true;
            Caption = 'Move Time';
        }
        field(200; FixedScrapQuantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Fixed Scrap Quantity';
        }
        field(210; ScrapFactor; Decimal)
        {
            BlankZero = true;
            Caption = 'Scrap Factor';
        }
        field(220; ConcurrentCapacities; Decimal)
        {
            BlankZero = true;
            Caption = 'Concurrent Capacities';
        }
        field(230; SendAheadQuantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Send Ahead Quantity';
        }
        field(240; UnitCostper; Decimal)
        {
            BlankZero = true;
            Caption = 'Unit Cost per';
        }
        field(500; "isModified"; Boolean)
        {
            Caption = 'Modified Rec.';
        }

    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    var
    begin
        Rec.isModified := true;
        if Rec.Modify() then;
    end;
}
