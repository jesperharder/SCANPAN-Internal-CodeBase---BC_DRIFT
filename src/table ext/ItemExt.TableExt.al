/// <summary>
/// TableExtension SCANPAN Item (ID 50000) extends Record Item.
/// </summary>
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193    Added modifications
/// 2023.03             Jesper Harder       007     Added flowfield identifying Warehouse orders from Auning to Ryom
/// 2023.07.23          Jesper Harder       042     Salesprice based on PurchasePrice Markup
/// 2024.06             Jesper Harder       069     ItemBodyType, Enum, TableExtension and PageExtension
///
/// </remarks>
tableextension 50000 "ItemExt" extends Item
{
    fields
    {
        field(50000; "Item Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name WHERE("No." = field("Vendor No.")));
            Editable = false;
            fieldClass = Flowfield;
        }
        field(50001; "Trans. RYOM-AUNING (Qty.)"; Decimal)
        {
            fieldClass = Flowfield;
            CalcFormula = sum("Transfer Line"."Outstanding Qty. (Base)" where("Derived From Line No." = const(0),
                                                                               "Item No." = field("No."),
                                                                               "Transfer-from Code" = const('RYOM'),
                                                                               "Transfer-to Code" = const('AUNING'),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Receipt Date" = field("Date Filter"),
                                                                               "Unit of Measure Code" = field("Unit of Measure Filter")
            ));
            Caption = 'Trans. Outstanding RYOM-AUNING (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        //042
        field(50002; "MarkupPurchaseprice"; Decimal)
        {
            ObsoleteState = removed;
            ObsoleteReason = 'Not used 042';
            Caption = 'Markup Purchase price';
        }
        field(50003; "Purch.price pri.vendor"; Decimal)
        {
            ObsoleteState = removed;
            ObsoleteReason = 'Not used 042';
            Caption = 'Last Purchase price Primary Vendor';
        }
        field(50004; "Purch.price Markup pct"; Decimal)
        {
            ObsoleteState = removed;
            ObsoleteReason = 'Not used 042';
            Caption = 'Purchase Price Markup pct';
            TableRelation = "Inventory Setup";
            FieldClass = FlowField;
            CalcFormula = lookup("Inventory Setup".PriceMarkupPct where("Primary Key" = const('')));
        }

        //069
        field(50005; "ItemBodyType"; Enum "EnumItemBodyType")
        {
            Caption = 'Item Body Type';
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Calculated Available NOTO", "Calculated Available Date NOTO", "Calculated Available Ext. NOTO") { }
    }
}