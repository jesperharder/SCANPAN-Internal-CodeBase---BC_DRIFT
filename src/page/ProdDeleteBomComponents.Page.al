




page 50039 ProdDeleteBomComponents
{

    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Delete BOM components';
    PageType = List;
    SourceTable = "Where-Used Line";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(Content)
        {
            repeater(repeater)
            {

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item that the base item or production BOM is assigned to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the item to which the item or production BOM component is assigned.';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Production BOM No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
            }
        }

    }


}