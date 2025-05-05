





/// <summary>
/// Page ProdControllingItemMap (ID 50042).
/// </summary>
/// <remarks>
/// 2023.10             Jesper Harder       056         Coating Description on Production Orders
/// </remarks>
page 50042 ProdControllingItemMap
{
    AdditionalSearchTerms = 'Scanpan, Controlling, Production';
    Caption = 'SCANPAN Production Controlling Item Map';

    PageType = List;
    UsageCategory = Lists;
    ShowFilter = true;
    ApplicationArea = Basic, Suite;

    SourceTable = ProdControllingItemMap;
    Permissions =
        tabledata ProdControllingItemMap = RIMD;

    layout
    {
        area(Content)
        {
            repeater(ItemMap)
            {

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Coating; Rec.Coating)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Coating Name field.';
                }
            }
        }

    }



}