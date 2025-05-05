pageextension 50041 "ItemCard" extends "Item Card"
{
    /// <summary>
    /// PageExtension ItemCardExtSC (ID 50041) extends Record Item Card.
    /// 2024.06             Jesper Harder       069         ItemBodyType, Enum, TableExtension and PageExtension
    /// 2024.11             Jesper Harder       094         Fields in ItemCard for Costing factors
    /// </summary>

    layout
    {
        addlast(ItemCategorySales)
        {
            field("ItemBodyType"; Rec."ItemBodyType")
            {
                ApplicationArea = All;
                Caption = 'Item Body Type';
                ToolTip = 'Specifies the body type of the item, such as Steel Brushed, Steel Polished, Aluminium, etc.';
            }
        }
        addafter("Costs & Posting")
        {
            group("Cost Roll-Up")
            {
                Caption = 'Cost Roll-Up';
                Editable = false;

                group(SingleLevel)
                {
                    Caption = 'Single-Level';

                    field("Single-Level Material Cost"; Rec."Single-Level Material Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the material cost at a single level for this item.';
                    }
                    field("Single-Level Capacity Cost"; Rec."Single-Level Capacity Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the single-level capacity cost for this item.';
                        Importance = Additional;
                    }
                    field("Single-Level Subcontrd. Cost"; Rec."Single-Level Subcontrd. Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Single-Level Subcontrd. Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                    field("Single-Level Cap. Ovhd Cost"; Rec."Single-Level Cap. Ovhd Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Single-Level Cap. Ovhd Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                    field("Single-Level Mfg. Ovhd Cost"; Rec."Single-Level Mfg. Ovhd Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Single-Level Mfg. Ovhd Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                }
                group(RolledUp)
                {
                    Caption = 'Rolled-Up';


                    field("Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the total rolled-up material cost for this item.';
                    }
                    field("Rolled-up Capacity Cost"; Rec."Rolled-up Capacity Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the rolled-up capacity cost for this item.';
                        Importance = Additional;
                    }
                    field("Rolled-up Subcontracted Cost"; Rec."Rolled-up Subcontracted Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Rolled-up Subcontracted Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                    field("Rolled-up Mfg. Ovhd Cost"; Rec."Rolled-up Mfg. Ovhd Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Rolled-up Mfg. Ovhd Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                    field("Rolled-up Cap. Overhead Cost"; Rec."Rolled-up Cap. Overhead Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Rolled-up Cap. Overhead Cost field.', Comment = '%';
                        Importance = Additional;
                    }
                }
                group(Costing)
                {
                    Caption = 'Costing';

                    field("Indirect Cost %2"; Rec."Indirect Cost %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the indirect cost percentage associated with this item.';
                        Importance = Additional;
                    }
                    field("Overhead Rate2"; Rec."Overhead Rate")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the overhead rate applied to this item.';
                        Importance = Additional;
                    }
                    field("Unit Cost2"; Rec."Unit Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                    }
                }
            }
        }
    }

    actions
    {
#pragma warning disable AL0432
        modify("Cross Re&ferences")
#pragma warning restore AL0432
        {
            Visible = false;
        }
    }
}
