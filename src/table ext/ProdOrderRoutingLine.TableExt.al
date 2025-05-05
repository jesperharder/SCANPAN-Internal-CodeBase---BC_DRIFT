




/// <summary>
/// TableExtension ProdOrderRoutingLine (ID 50027) extends Record prod.
/// </summary>
/// <remarks>
/// 2023.10            Jesper Harder        055         Priority and Description P.Order RoutingLines
/// </remarks>
tableextension 50027 "ProdOrderRoutingLine" extends "Prod. Order Routing Line"
{
    fields
    {
        field(50010; "Priority"; Integer)
        {
            Caption = 'Priority';
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(50015; "Comment"; text[150])
        {
            Caption = 'Comment';
        }

        /*
                field(50016; "Coating"; Text[50])
                {
                    Caption = 'Coating';
                    Editable = false;
                    TableRelation = ProdControllingItemMap;
                }
        */

    }


}