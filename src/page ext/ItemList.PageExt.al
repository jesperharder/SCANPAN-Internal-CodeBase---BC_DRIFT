
pageextension 50005 "ItemList" extends "Item List"
{
    /// <summary>
    /// 50005 "ItemListExtSC" extends "Item List"
    /// </summary>

    /// <remarks>
    ///
    /// Version list
    /// 2022.12             Jesper Harder       0193    Added modifications
    /// 2022.12             Jesper Harder       0193    Fields added and rearrangede
    /// 2022.12             Jesper Harder       0193    Added View - ActiveSalesItems
    /// 2022.12             Jesper Harder       0193    OnOpenPage - Set page filters according to Selected User Role Center
    /// 2023.03             Jesper Harder       007     Added flowfield identifying Warehouse orders from Auning to Ryom Rec."Trans. RYOM-AUNING (Qty.)"
    /// 2023.07.23          Jesper Harder       042     Salesprice based on PurchasePrice Markup
    /// 2024.11             Jesper Harder       094         Fields in ItemCard for Costing factors
    /// </remarks>

    layout
    {
        modify("Substitutes Exist") { Visible = false; }
        modify("Assembly BOM") { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        modify("Unit Price") { Visible = false; }
        modify("Search Description") { Visible = true; }
        modify("Default Deferral Template Code") { Visible = false; }
        modify("Cost is Adjusted") { Visible = false; }



        addafter("Vendor No.")
        {
            field("Vendor Item No.1"; Rec."Vendor Item No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number that the vendor uses for this item.';
            }
        }
        addafter("Vendor No.")
        {
            field("Item Vendor Name1"; Rec."Item Vendor Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Item Vendor Name field.';
            }
        }
        addafter("Search Description")
        {
            field("ABCD Category1"; Rec."ABCD Category")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the ABCD Category field.';
            }
        }
        addafter("ABCD Category1")
        {
            field("Product Line Code1"; Rec."Product Line Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Product Line Code field.';
            }
        }
        addafter("Product Line Code1")
        {
            field("Gen. Prod. Posting Group1"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            }
        }
        addafter("Gen. Prod. Posting Group1")
        {
            field("Item Category Code1"; Rec."Item Category Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
            }
        }
        addafter("Item Category Code1")
        {
            field("Prod. Group Code1"; Rec."Prod. Group Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Product Group Code field.';
            }
        }
        addafter("Prod. Group Code1")
        {
            field("GTIN1"; Rec.GTIN)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).';
            }
        }

        addafter(GTIN1)
        {
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("Qty. in Transit"; Rec."Trans. RYOM-AUNING (Qty.)")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Trans. Outstanding RYOM-AUNING (Qty.) field.';
            }
        }
        addafter("Qty. in Transit")
        {
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.';
            }
        }
        addafter("Qty. on Prod. Order")
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
            }
        }
        addafter("Qty. on Purch. Order")
        {
            field("Planning Receipt (Qty.)12304"; Rec."Planning Receipt (Qty.)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Planning Receipt (Qty.) field.';
            }
        }



        //042
        addlast(Control1)
        {
            field(PriVendorPurchPriceLanded; PriVendorPurchPriceLanded)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Primary Vendor Purchase Landed Price';
                DecimalPlaces = 2 : 3;
                ToolTip = 'Calculates the Item Primary Vendor Price added Indirect Cost %.';
            }

            // 094
            field("Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rolled-up Material Cost field.', Comment = '%';
            }
            field("Single-Level Material Cost"; Rec."Single-Level Material Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Single-Level Material Cost field.', Comment = '%';
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

    views
    {
        addfirst
        {
            view(ActiveSalesItems)
            {
                Caption = 'Active Sales Items';
                Filters = where("Gen. Prod. Posting Group" = filter('BRUND|INTERN|EKSTERN'), Blocked = filter(0));
                OrderBy = ascending("No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        UserPersonalization: Record "User Personalization";
    begin
        ///<remarks>
        /// 0193
        /// Change filter according to User Role Profile
        /// </remarks>

        UserPersonalization.Get(UserSecurityId());

        if UserPersonalization."Profile ID" = '_SALG' then begin
            Rec.SetCurrentKey("No.");
            Rec.SetFilter(Rec."Gen. Prod. Posting Group", 'BRUND|INTERN|EKSTERN');
            Rec.SetFilter(Blocked, '0');
            Rec.Ascending(true);
            Rec.FindFirst();
        end;
        /*
                If UserPersonalization."Profile ID" = '_PRODUKTION' then begin
                    Rec.SetCurrentKey("No.");
                    Rec.SetFilter(Rec."Gen. Prod. Posting Group", 'MELLEM|MELLEM RÅ');
                    Rec.SetFilter(Blocked, '0');
                    Rec.Ascending(true);
                    Rec.FindFirst();
                end;
        */
    end;

    trigger OnAfterGetRecord()
    var
    begin
        PriVendorPurchPriceLanded := ScanpanMiscellaneous.ItemCalculatePurchaseLandedPrice(Rec);
    end;

    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        PriVendorPurchPriceLanded: Decimal;
}
