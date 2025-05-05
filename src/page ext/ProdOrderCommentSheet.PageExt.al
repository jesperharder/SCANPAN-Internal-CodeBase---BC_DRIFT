


pageextension 50110 ProdOrderCommentSheet extends "Prod. Order Comment Sheet"
{
    layout
    {
        addafter(Date)
        {
            field("Prod. Order No.1"; Rec."Prod. Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
