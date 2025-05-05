


/// <summary>
/// 
/// 2024.06             Jesper Harder       068         Add Page Production BOM Line
/// 
/// </summary>
page 50029 "ProdBomLine"
{
    AdditionalSearchTerms = 'Scanpan,Production';
    ApplicationArea = Basic, Suite;
    Caption = 'Production BOM Line';
    Editable = false;
    PageType = List;

    SourceTable = "Production BOM Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater("fields")
            {

                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Production BOM No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of production BOM line.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the production BOM line.';
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units of the component are required to produce the parent item.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which this production BOM is valid.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which this production BOM is no longer valid.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the routing link code.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
            }
        }
    }
}