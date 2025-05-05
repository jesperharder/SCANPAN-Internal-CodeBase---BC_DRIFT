




/// <summary>
/// Page InventoryRessources (ID 50027).
/// </summary>
/// <remarks>
/// 
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
/// 
/// </remarks>
page 50027 "InventoryRessources"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory Ressources';
    //UsageCategory = Lists;
    Editable = false;
    //ApplicationArea = All;
    PageType = List;
    Permissions =
        tabledata InventoryRessourceID = R;
    SourceTable = InventoryRessourceID;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Ressouce ID"; Rec."Ressouce ID")
                {
                    ToolTip = 'Specifies the value of the Ressource ID field.';
                }
            }
        }
    }

}