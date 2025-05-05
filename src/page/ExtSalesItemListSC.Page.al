/// <summary>
/// Page SCANPANItemListSalesExt (ID 50018).
/// </summary>
///
/// <remarks>
///
///  2023.03.12             Jesper Harder                   0292    Sales Tools Item List Available.
///
/// </remarks>
page 50018 "ExtSalesItemListSC"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Sales Ext Item List';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    Permissions =
        tabledata Item = R,
        tabledata "Item Translation" = R;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(filters)
            {
                Caption = 'Filter';

                group(filter1)
                {
                    ShowCaption = false;

                    field(FilterItemNo; FilterItemNo)
                    {
                        Caption = 'Item No.';
                        TableRelation = Item."No." where("Inventory Posting Group" = const('INTERN|EKSTERN|BRUND'));
                        ToolTip = 'Set filter on Item No.';
                        trigger OnValidate()
                        var
                        begin
                            SetFilters();
                        end;
                    }
                }
                group(filter2)
                {
                    ShowCaption = false;

                    field(FilterItemProdGroupCode; FilterInventoryPostingGroup)
                    {
                        Caption = 'Item Inventory Posting Group Code';
                        TableRelation = "Inventory Posting Group" where(Code = const('INTERN|EKSTERN|BRUND'));
                        ToolTip = 'Set filter on Inventory Posting Group Code.';
                        trigger OnValidate()
                        var
                        begin
                            SetFilters();
                        end;
                    }
                }
            }
            repeater(General)
            {
                Editable = false;
                field(GTIN; Rec.GTIN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).';
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description; ItemTranslation.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Calculated Available NOTO"; Rec."Calculated Available NOTO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculated Available field.';
                }
                field("Calculated Available Date NOTO"; Rec."Calculated Available Date NOTO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calculated Available Date field.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
                }
                field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.';
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
                }
                field("Item Brand"; Rec."Item Brand")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Brand field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("Product Line Code"; Rec."Product Line Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Line Code field.';
                }
                field("Product Usage"; Rec."Product Usage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Usage field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                }
                field("ABCD Category"; Rec."ABCD Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ABCD Category field.';
                }
            }
        }
    }
    var
        ItemTranslation: Record "Item Translation";
        FilterInventoryPostingGroup: code[20];
        FilterItemNo: code[20];

    trigger OnInit()
    var
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Inventory Posting Group", '%1|%2|%3', 'INTERN', 'EKSTERN', 'BRUND');
        Rec.FilterGroup(0);
    end;

    trigger OnOpenPage()
    var
    begin
        Rec.FilterGroup(-1);
        Rec.SetFilter("Gen. Prod. Posting Group", '%1|%2|%3', 'INTERN', 'EKSTERN', 'BRUND');
        Rec.SetCurrentKey("Inventory Posting Group");
        Rec.FilterGroup(0);
        Rec.FindFirst();
    end;

    trigger OnAfterGetRecord()
    var
    begin
        if not ItemTranslation.Get('DAN', Rec."No. 2") then ItemTranslation.Description := Rec.Description;
    end;

    local procedure SetFilters()
    var
    begin
        Rec.SetRange("No.");
        if FilterItemNo <> '' then
            Rec.SetFilter("No.", FilterItemNo);

        Rec.SetRange("Inventory Posting Group");
        if FilterInventoryPostingGroup <> '' then
            Rec.SetFilter("Inventory Posting Group", FilterInventoryPostingGroup);

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
