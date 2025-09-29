

page 50071 "FIFO Item Inflow"
{
    /// <summary>
    /// 2025.09             Jesper Harder       115.1       Item Fifo list page
    /// Hovedside: viser varen og et underafsnit med FIFO-tilgange
    /// </summary>

    PageType = Card;
    //ApplicationArea = All;
    Caption = 'FIFO Item Inflows';
    AdditionalSearchTerms = 'SCANPAN, FIFO, BATCH, LOT';
    UsageCategory = Lists;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(ItemInfo)
            {
                Editable = false;
                Caption = 'Item';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what you are selling.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(GenProdPostingGroupFilter; GenProdPostingGroupFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Gen. Prod. Posting Group';
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
                field(ProductLineCodeFilter; ProductLineCodeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Product Line Code';
                    ToolTip = 'Specifies the value of the Product Line Code field.';
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
            }
            part(FIFOEntries; "FIFO Item Inflow Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
    }

    var
        GenProdPostingGroupFilter: Code[20];
        ProductLineCodeFilter: Code[20];

    local procedure ApplyFilters()
    begin
        CurrPage.FIFOEntries.PAGE.SetFilters(GenProdPostingGroupFilter, ProductLineCodeFilter);
    end;

    trigger OnOpenPage()
    begin
        ApplyFilters();
    end;
}