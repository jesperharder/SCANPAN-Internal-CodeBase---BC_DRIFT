pageextension 50114 ProdOrderLineList extends "Prod. Order Line List"
{
    layout
    {
        addafter("Due Date")
        {
            field("Inventory Posting Group1";Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
