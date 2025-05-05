

/// <summary>
/// TableExtension SCANPAN Inventory Setup (ID 50001) extends Record Inventory Setup.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2023.07.23          Jesper Harder       042     Salesprice based on PurchasePrice Markup
/// 
/// </remarks>
tableextension 50001 "InventorySetup" extends "Inventory Setup"
{
    fields
    {
        //0193
        field(50000; "EAN Country Code"; Code[2]) { Caption = 'EAN Country Code'; }
        field(50001; "EAN Company No."; Code[5]) { Caption = 'EAN Company No.'; }
        field(50002; "Last EAN Code Used"; code[5]) { Caption = 'Last EAN Code Used'; }

        field(50003; "Use Bar Code Type"; Option)
        {
            Caption = 'Use Bar Code Type';
            OptionCaption = 'UCC-12,EAN-13';
            OptionMembers = "UCC-12","EAN-13";
        }
        field(50004; "UPC Prefix"; Code[1]) { Caption = 'UPC Prefix'; }
        field(50005; "UPC Company No."; Code[5]) { Caption = 'UPC Company No.'; }
        field(50006; "Last UPC Code Used"; Code[5]) { Caption = 'Last UPC Code Used'; }

        //042
        field(50007; "PriceMarkupPct"; Decimal)
        {
            Caption = 'Salesprice Purchase Markup pct';
        }


    }
}
