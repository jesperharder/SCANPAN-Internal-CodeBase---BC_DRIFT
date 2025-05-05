


page 50061 "ProdControllingRecursiveBOM"
{
     /// <summary>
    /// 
    /// 2024.10             Jesper Harder       093         Recursive BoM Listing of items. Inspiration from NAV5 sql
    /// 
    /// </summary>

    PageType = Worksheet;
    SourceTable = "RecursiveBOMtemp";
    SourceTableView = sorting("Entry No.") order(ascending);
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Prod. Controlling Recursive BOM List';
    AdditionalSearchTerms = 'Controlling, Production, Recursive, BOM, Bill of Materials, Costing';
    Editable = true;



    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                Editable = true;
                field(ItemFilter; ItemFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Item Filter';
                    ToolTip = 'Enter an item number or a range of item numbers to filter the calculation.';
                    TableRelation = Item;
                    trigger OnValidate()
                    begin
                        BuildBoMlist();
                    end;
                }
                field(ShowFilterFields; ShowFilterFields)
                {
                    ApplicationArea = All;
                    Caption = 'Show Filter fields';
                    ToolTip = 'Show all filter fields in list. Can also be shown in page filters.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }

            group(BoMRecords)
            {
                ShowCaption = false;
                Editable = false;

                repeater(Repeater)
                {
                    ShowCaption = false;

                    field("Entry No."; Rec."Entry No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                        Visible = ShowHidenFields;
                    }
                    field(ItemMaster; Rec.ItemMaster)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ItemMaster field.', Comment = '%';
                        Style = Strong; // Style to apply when highlighted
                        StyleExpr = IsHighlightedItem;

                    }
                    field(ItemMasterDescription; Rec.ItemMasterDescription)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ItemMasterDescription field.', Comment = '%';
                        Style = Strong; // Style to apply when highlighted
                        StyleExpr = IsHighlightedItem;

                    }
                    field(ItemBomMaster; Rec.ItemBomMaster)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ItemBomMaster field.', Comment = '%';
                        Visible = ShowHidenFields;
                    }
                    field(BomItem; Rec.BomItem)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BomItem field.', Comment = '%';
                    }
                    field(BomItemDescription; Rec.BomItemDescription)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BomItemDescription field.', Comment = '%';
                    }
                    field(BOMlevel; Rec.BOMlevel)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BOMlevel field.', Comment = '%';
                    }
                    field(ScrapPercentage; Rec.ScrapPercentage)
                    {
                        ApplicationArea = All;
                        BlankZero = true;
                        ToolTip = 'Specifies the value of the ScrapPercentage field.', Comment = '%';
                    }
                    field(BOMQuantity; Rec.BOMQuantity)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BOMQuantity field.', Comment = '%';
                    }
                    field(BOMBaseUnitCode; Rec.BOMBaseUnitCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BOMBaseUnitCode field.', Comment = '%';
                    }

                    // Cost Calculated
                    field(MaterialCostCalc; Rec.MaterialCostCalc)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the MaterialCostCalc field.', Comment = '%';
                    }
                    field(CapacityCostCalc; Rec.CapacityCostCalc)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CapacityCostCalc field.', Comment = '%';
                    }
                    field(OverheadCostCalc; Rec.OverheadCostCalc)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the OverheadCostCalc field.', Comment = '%';
                    }
                    field(TotalCostCalc; Rec.TotalCostCalc)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the TotalCostCalc field.', Comment = '%';
                    }




                    // Revealing filter columns
                    // Production Filters
                    field(Prod_Coating; Rec.Prod_Coating)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_Coating field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ItemSize; Rec.Prod_ItemSize)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ItemSize field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ItemBrand; Rec.Prod_ItemBrand)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ItemBrand field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ABCDcatehory; Rec.Prod_ABCDcategory)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ABCDcatehory field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ItemBodyType; Rec.Prod_ItemBodyType)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ItemBodyType field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ProductUsage; Rec.Prod_ProductUsage)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ProductUsage field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ProductLineCode; Rec.Prod_ProductLineCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ProductLineCode field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ItemCategoryCode; Rec.Prod_ItemCategoryCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ItemCategoryCode field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ProductGroupCode; Rec.Prod_ProductGroupCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ProductGroupCode field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_ItemNoDescription; Rec.Prod_ItemNoDescription)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_ItemNoDescription field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_CostingMethod; Rec.Prod_CostingMethod)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_CostingMethod.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_GenProdPostingGroup; Rec.Prod_GenProdPostingGroup)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_GenProdPostingGroup field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }
                    field(Prod_InventoryPostingGroup; Rec.Prod_InventoryPostingGroup)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Prod_InventoryPostingGroup field.', Comment = '%';
                        Style = Favorable;
                        StyleExpr = true;
                        Visible = ShowFilterFields;
                    }

                    // BOM Filters
                    field(ProdBOM_ABCDcategory; Rec.ProdBOM_ABCDcategory)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ABCDcatehory field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_Coating; Rec.ProdBOM_Coating)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_Coating field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_GenProdPostingGroup; Rec.ProdBOM_GenProdPostingGroup)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_GenProdPostingGroup field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_InventoryPostingGroup; Rec.ProdBOM_InventoryPostingGroup)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_InventoryPostingGroup field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ItemBodyType; Rec.ProdBOM_ItemBodyType)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ItemBodyType field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ItemBrand; Rec.ProdBOM_ItemBrand)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ItemBrand field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ItemCategoryCode; Rec.ProdBOM_ItemCategoryCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ItemCategoryCode field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ItemNoDescription; Rec.ProdBOM_ItemNoDescription)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ItemNoDescription field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_CostingMethod; Rec.ProdBOM_CostingMethod)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_CostingMethod.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ItemSize; Rec.ProdBOM_ItemSize)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ItemSize field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_PackingMethod; Rec.ProdBOM_PackingMethod)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_PackingMethod field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ProductGroupCode; Rec.ProdBOM_ProductGroupCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ProductGroupCode field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ProductLineCode; Rec.ProdBOM_ProductLineCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ProductLineCode field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }
                    field(ProdBOM_ProductUsage; Rec.ProdBOM_ProductUsage)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ProdBOM_ProductUsage field.', Comment = '%';
                        Visible = ShowFilterFields;
                    }


                }
            }
            group(GroupTotals)
            {
                ShowCaption = false;
                Editable = false;

                group(CostShares)
                {
                    Caption = 'Costshares Master Item';

                    field(RolledUpMaterialCost; RolledUpMaterialCost)
                    {
                        Caption = 'Rolled-up Material Cost';
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                        ToolTip = 'Specifies the value of the RolledUpMaterialCost field.';
                    }
                    field(RolledUpCapacityCost; RolledUpCapacityCost)
                    {
                        Caption = 'Rolled-up Capacity Cost';
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                        ToolTip = 'Specifies the value of the RolledUpCapacityCost field.';
                    }
                    field(RolledUpOverheadCost; RolledUpOverheadCost)
                    {
                        Caption = 'Rolled-up Overhead Cost';
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                        ToolTip = 'Specifies the value of the RolledUpOverheadCost field.';
                    }
                    field(UnitCost; UnitCost)
                    {
                        Caption = 'Unit Cost';
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                        ToolTip = 'Specifies the value of the UnitCost field.';
                    }
                }
                group(GroupSelectedItem)
                {
                    Caption = 'Selected Item';
                    field(SelectedMasterItem; SelectedMasterItem)
                    {
                        Caption = 'Selected Master Item';
                        ToolTip = 'Specifies the value of the SelectedMasterItem field.';

                    }
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(CalculateAllBoM)
            {
                ApplicationArea = All;
                Caption = 'Calculate BoM';
                ToolTip = 'Executes the CalculateAllBoM action based on the specified item number filter.';
                Image = ExplodeBOM;

                trigger OnAction()
                begin
                    BuildBoMlist();
                end;
            }
        }
        area(Navigation)
        {

            group(SortingActions)
            {
                Caption = 'Sort By';

                action(SortByEntryNo)
                {
                    Image = SortAscending;
                    Caption = 'Sort by Entry';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Sort by Entry action.';
                    trigger OnAction()
                    var
                        RecursiveBOMtemp: Record "RecursiveBOMtemp";
                    begin
                        // Sort by Entry No.
                        RecursiveBOMtemp.Copy(Rec); // Copy the current record to retain filters
                        RecursiveBOMtemp.SETCURRENTKEY("Entry No.");
                        CurrPage.SetTableView(RecursiveBOMtemp);
                    end;
                }
                action(SortByItemMasterBOMlevelBomItem)
                {
                    Image = SortAscending;
                    Caption = 'Sort by (ItemMaster, BOMlevel, BomItem)';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Sort by (ItemMaster, BOMlevel, BomItem) action.';
                    trigger OnAction()
                    begin
                        Rec.SetCurrentKey(ItemMaster, BOMlevel, BomItem);
                        Rec.Ascending(true);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsHighlightedItem := true;
    end;


    trigger OnAfterGetRecord()
    begin
        // alter the highlighting of fields
        if Rec.CurrentKey = 'Entry No.' then
            IsHighlightedItem := Rec.FirstNewItemMaster;
    end;


    trigger OnAfterGetCurrRecord()
    begin
        // Display CostShares from Item Card
        CalculateCostShares();

        // alter the highlighting of fields
        if Rec.CurrentKey = 'Entry No.' then
            IsHighlightedItem := Rec.FirstNewItemMaster;

    end;



    var
        ItemFilter: Text[100]; // Allows range or specific item number
        ShowFilterFields: Boolean;
        ShowHidenFields: Boolean;
        IsHighlightedItem: Boolean;
        RolledUpMaterialCost: Decimal;
        RolledUpCapacityCost: Decimal;
        RolledUpOverheadCost: Decimal;
        UnitCost: Decimal;
        SelectedMasterItem: Code[20];


    local procedure BuildBoMlist()
    var
        RecursiveBOMCalculation: Codeunit "RecursiveBOMCalculation";
        DialogLbl: Label 'Bill-of-Material calculation complete for filter: "%1"', Comment = '%1 = the filter used.';
    begin
        // Pass the ItemNoFilter to the codeunit for processing
        RecursiveBOMCalculation.CalculateAllProductionBOMLines(ItemFilter, Rec); // Assuming the codeunit method accepts a filter parameter

        // Refresh and show completion message
        Rec.FindFirst();
        Message(DialogLbl, ItemFilter);
    end;


    local procedure CalculateCostShares()
    var
        Item: Record Item;
    begin

        "RolledUpMaterialCost" := 0;
        "RolledUpCapacityCost" := 0;
        "RolledUpOverheadCost" := 0;
        UnitCost := 0;
        SelectedMasterItem := '';

        Item.Reset();
        if not Item.Get(xRec.ItemMaster) then
            exit;
        // Selected MasterItem
        SelectedMasterItem := Item."No.";
        // Material Cost
        "RolledUpMaterialCost" += Item."Rolled-up Material Cost";
        // Capacity Cost
        "RolledUpCapacityCost" += Item."Rolled-up Capacity Cost";
        // Indirect Overhead Cost
        RolledUpOverheadCost += Item."Rolled-up Mfg. Ovhd Cost" + Item."Rolled-up Cap. Overhead Cost";

        // Unit Cost from Item Card
        UnitCost := Item."Unit Cost";
    end;


}
