

page 50072 "FIFO Item Inflow Lines"
{
    /// <summary>
    /// 2025.09             Jesper Harder       115.1       Item Fifo list page
    /// Underliste: alle åbne vareposteringer med resterende antal (>0) i FIFO-rækkefølge
    /// </summary>

    PageType = ListPart;
    //ApplicationArea = All;
    SourceTable = "Item Ledger Entry";
    SourceTableView =
        SORTING("Posting Date", "Entry No.") ORDER(Ascending)
        WHERE("Remaining Quantity" = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Entries)
            {
                field("Posting Date"; "Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Entry No."; "Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Entry Type"; "Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Document No."; "Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Quantity"; Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Location Code"; "Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
            }
        }
    }
    procedure SetFilters(GenProdGrp: Code[20]; ProdLine: Code[20])
    var
        Item: Record Item;
    begin
        Item.Reset();
        if GenProdGrp <> '' then
            Item.SetRange("Gen. Prod. Posting Group", GenProdGrp);
        if ProdLine <> '' then
            Item.SetRange("Product Line Code", ProdLine);

        if Item.GetFilters() <> '' then
            Rec.SetFilter("Item No.", Item.GetFilter("No."))
        else
            Rec.SetRange("Item No.");

        CurrPage.Update(false);
    end;

}


