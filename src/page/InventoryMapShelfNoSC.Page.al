/// <summary>
/// Page InventoryStatusSC (ID 50025).
/// </summary>
///
/// <remarks>
///
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
///
/// </remarks>
page 50025 "InventoryMapShelfNoSC"
{
    AdditionalSearchTerms = 'Scanpan';
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory Map Shelf No.';
    PageType = List;
    SourceTable = InventoryMapShelfSC;
    //UsageCategory = Lists;

    Editable = true;
    Permissions =
        tabledata InventoryMapShelfSC = RIMD;

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Ressource Name"; Rec."Ressource Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ressouce Name field.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                }
            }
        }
    }
}