/// <summary>
/// PageExtension InventorySetupExtSC (ID 50024) extends Record Inventory Setup.
/// </summary>
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193    Added modifications
/// 2023.07.23          Jesper Harder       042     Salesprice based on PurchasePrice Markup
/// </remarks>

pageextension 50024 "InventorySetup" extends "Inventory Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(ScanpanEAN)
            {
                Caption = 'Scanpan EAN Setup';

                field("EAN Country Code"; Rec."EAN Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EAN Country Code';
                    ToolTip = 'EAN Country';
                }
                field("EAN Company No."; Rec."EAN Company No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EAN Company No.';
                    ToolTip = 'EAN Country No. Code';
                }
                field("Last EAN Code Used"; Rec."Last EAN Code Used")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Last EAN Code Used';
                    ToolTip = 'Last uset EAN number';
                }
                field("Use Bar Code Type"; Rec."Use Bar Code Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Use Bar Code Type';
                    ToolTip = 'Use EAN code type';
                }
                field("UPC Prefix"; Rec."UPC Prefix")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'UPC Prefix';
                    ToolTip = 'UPC prefix';
                }
                field("UPC Company No."; Rec."UPC Company No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'UPC Company No.';
                    ToolTip = 'UPC Company No.';
                }
                field("Last UPC Code Used"; Rec."Last UPC Code Used")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Last UPC Code Used';
                    ToolTip = 'Last used UPC code';
                }
            }
            group(ScanpanPriceMarkup)
            {
                Caption = 'Scanpan Price';
                field(PriceMarkupPct; Rec.PriceMarkupPct)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salesprice Markup pct';
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Specifies the value of the Salesprice Purchase Markup pct field.';
                }
            }
        }
    }
}
