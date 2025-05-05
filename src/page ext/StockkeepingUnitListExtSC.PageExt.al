


/// <summary>
/// PageExtension "StockkeepingUnitListExtSC" (ID 50034) extends Record Stockkeeping Unit List.
/// </summary>
pageextension 50034 StockkeepingUnitListExtSC extends "Stockkeeping Unit List"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
            }
        }
        addafter("Vendor No.")
        {
            field("Reorder Point1"; Rec."Reorder Point")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
            }
            field("Safety Stock Quantity52170"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
            }
        }

        addafter(Inventory)
        {
            field("Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies for the SKU, the same as the field does on the item card.';
            }
        }
    }
}
