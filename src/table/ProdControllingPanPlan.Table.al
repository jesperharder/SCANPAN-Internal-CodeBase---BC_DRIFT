


/// <summary>
/// Table ProdControllingPanPlan (ID 50006).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.04.10      Jesper Harder               022     Porting the PanPlan project to AL/Code.
/// 
/// </remarks>
/// 
table 50006 "ProdControllingPanPlan"
{
    Caption = 'Production Controlling PanPlan Table';
    TableType = Temporary;
    DataClassification = AccountData;
    fields
    {
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Order No."; code[20])
        {
            Caption = 'Order Number';
        }
        field(30; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(40; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(50; "Remaining Quantity"; Integer)
        {
            Caption = 'Remaining Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(60; "Status"; Integer)
        {
            Caption = 'Order Status';
        }
        field(61; "Status Text"; Text[30])
        {
            Caption = 'Status Text';
        }
        field(70; "Order Item No."; code[20])
        {
            Caption = 'Item No.';
        }
        field(80; "Order Item Description"; text[100])
        {
            Caption = 'Item Description';
            //        public string Description1 { get; set; }
        }
        field(90; "Order Unit"; code[20])
        {
            Caption = 'Order Unit';
        }
        field(100; "Bom Item No."; code[20])
        {
            Caption = 'Bom Item No.';
            //    public string BOMItemNum { get; set; }
        }
        field(110; "Bom Description"; Text[100])
        {
            Caption = 'Bom Description';
            //   public string Description2 { get; set; }
        }
        field(120; "Bom Unit"; code[20])
        {
            Caption = 'Bom Unit';
        }
        field(130; "Bom Item Category Code"; Text[100])
        {
            Caption = 'Category';
        }
        field(140; "PO Item No. Level"; Text[10])
        {
            Caption = 'LevelOfProduction Level';
            //public LevelOfProduction Level { get; set; }
        }
        field(150; "Bom Item No. Level"; Text[10])
        {
            Caption = 'LevelOfProduction BomLevel';
            //public LevelOfProduction BOMLevel { get; set; }
        }
        field(160; "Bom Sorting"; Text[10])
        {
            Caption = 'Bom Sorting';
        }
        field(170; "Sorting"; Integer)
        {
            Caption = 'Sorting';
        }
        field(180; "Warehouse Quantity"; Integer)
        {
            Caption = 'Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(190; "Order Quantity"; Integer)
        {
            Caption = 'Order Quantity';
            BlankZero = true;
            BlankNumbers = BlankZero;
            //    public int OrderAmount { get; set; }
        }
        field(200; "Scrap percentage"; Decimal)
        {
            Caption = 'Scrap';
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(210; "Bom Expected Quantity"; Integer)
        {
            Caption = 'Expected';
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(220; "Bom Remaining Quantity"; Integer)
        {
            Caption = 'Bom Remaining';
            BlankZero = true;
            BlankNumbers = BlankZero;
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