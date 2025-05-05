
table 50111 "RecursiveBOMtemp"
{
 
    /// <summary>
    /// 
    /// 2024.10             Jesper Harder       093         Recursive BoM Listing of items. Inspiration from NAV5 sql
    /// 
    /// </summary>
    Caption = 'Recursive Bill of Material table Temporary';
    TableType = Temporary;
    DataClassification = ToBeClassified;

    fields
    {
        // General Fields
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "FirstNewItemMaster"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // Item Master Fields
        field(3; "ItemMaster"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No."; // Relate to Item table
        }
        field(4; "ItemMasterDescription"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "BOMlevel"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(6; "ItemBomMaster"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No."; // Relate to Item table
        }
        field(7; "BomItem"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No."; // Relate to Item table
        }
        field(8; "BomItemDescription"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "BOMQuantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1 : 5;
        }
        field(10; "BOMBaseUnitCode"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure"."Code";
        }

        // Cost Calculated
        field(11; "ScrapPercentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1 : 5;
        }

        field(12; MaterialCostCalc; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
        }
        field(13; CapacityCostCalc; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
        }
        field(14; OverheadCostCalc; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
        }
        field(15; TotalCostCalc; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
        }



        //
        // Revealing filter columns
        //

        //
        // Production Filters
        //
        field(100; Prod_Coating; Code[50])
        {
            Caption = 'Prod Coating';
        }
        field(101; Prod_ItemSize; Code[50])
        {
            Caption = 'Prod Item Size';
        }
        field(102; Prod_ItemBrand; Code[50])
        {
            Caption = 'Prod Item Brand';
        }
        field(103; Prod_ABCDcategory; Code[20])
        {
            Caption = 'Prod ABCD Category';
        }
        field(104; Prod_ItemBodyType; Enum EnumItemBodyType)
        {
            Caption = 'Prod Item Body Type';
        }
        field(105; Prod_ProductUsage; Code[50])
        {
            Caption = 'Prod Product Usage';
        }
        field(106; Prod_ProductLineCode; Code[50])
        {
            Caption = 'Prod Product Line Code';
        }
        field(107; Prod_ItemCategoryCode; Code[20])
        {
            Caption = 'Prod Item Category Code';
        }
        field(108; Prod_ProductGroupCode; Code[50])
        {
            Caption = 'Prod Product Group Code';
        }
        field(109; Prod_ItemNoDescription; Text[100])
        {
            Caption = 'Prod Item No Description';
        }
        field(110; Prod_CostingMethod; Enum "Costing Method")
        {
            Caption = 'Prod Costing Method';
        }
        field(111; Prod_GenProdPostingGroup; Code[20])
        {
            Caption = 'Prod Gen Prod Posting Group';
        }
        field(112; Prod_InventoryPostingGroup; Code[20])
        {
            Caption = 'Prod Inventory Posting Group';
        }

        //
        // BOM Filters
        //
        field(113; ProdBOM_ABCDcategory; Code[20])
        {
            Caption = 'Prod BOM ABCD Category';
        }
        field(114; ProdBOM_Coating; Code[50])
        {
            Caption = 'Prod BOM Coating';
        }
        field(115; ProdBOM_GenProdPostingGroup; Code[20])
        {
            Caption = 'Prod BOM Gen Prod Posting Group';
        }
        field(116; ProdBOM_InventoryPostingGroup; Code[20])
        {
            Caption = 'Prod BOM Inventory Posting Group';
        }
        field(117; ProdBOM_ItemBodyType; Enum EnumItemBodyType)
        {
            Caption = 'Prod BOM Item Body Type';
        }
        field(118; ProdBOM_ItemBrand; Code[50])
        {
            Caption = 'Prod BOM Item Brand';
        }
        field(119; ProdBOM_ItemCategoryCode; Code[50])
        {
            Caption = 'Prod BOM Item Category Code';
        }
        field(120; ProdBOM_ItemNoDescription; Text[100])
        {
            Caption = 'Prod BOM Item No Description';
        }
        field(121; ProdBOM_CostingMethod; Enum "Costing Method")
        {
            Caption = 'Prod BOM Costing Method';
        }
        field(122; ProdBOM_ItemSize; Code[50])
        {
            Caption = 'Prod BOM Item Size';
        }
        field(123; ProdBOM_PackingMethod; Code[20])
        {
            Caption = 'Prod BOM Packing Method';
        }
        field(124; ProdBOM_ProductGroupCode; Code[50])
        {
            Caption = 'Prod BOM Product Group Code';
        }
        field(125; ProdBOM_ProductLineCode; Code[50])
        {
            Caption = 'Prod BOM Product Line Code';
        }
        field(126; ProdBOM_ProductUsage; Code[50])
        {
            Caption = 'Prod BOM Product Usage';
        }
    }





    keys
    {
        key(PK; ItemMaster, BOMlevel, BOMitem)
        {
            Clustered = true;
        }
        key(EntryNo; "Entry No.")
        {

        }
    }

}
