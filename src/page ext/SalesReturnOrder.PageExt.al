/// <summary>
/// PageExtension Sales Return Order (ID 50068) extends Record Sales Return Order.
/// </summary>
/// 
/// <remarks>
/// 2023.05.10              Jesper Harder                           029 SalesReturnOrder - Added Sales Lines factbox
/// </remarks>   
pageextension 50069 "Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part(SalesLineFactBox; "Sales Line FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
        }
    }
}