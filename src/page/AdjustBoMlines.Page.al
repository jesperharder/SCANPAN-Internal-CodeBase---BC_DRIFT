page 50054 AdjustBoMlines
{
    ///<summary>
    /// 2024.10             Jesper Harder       087         Adjust Multiple BoM lines
    /// Adds functionality to adjust the Quantity Per factor for Bill of Material lines.
    ///</summary>
    AdditionalSearchTerms = 'SCANPAN, BOM, Controlling';
    Caption = 'Adjust BOM Lines';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'BOM Adjustment Parameters';
                field("AdjustQtyPerFactor"; QuantityPerFactor)
                {
                    ApplicationArea = All;
                    Caption = 'Adjust Quantity Per Factor';
                    ToolTip = 'Enter the factor by which the Quantity Per should be adjusted for the selected Bill of Material lines.';
                    DecimalPlaces = 4;
                    // Field for entering the adjustment factor for Quantity Per. Supports up to 4 decimal places.
                }
            }
        }
    }

    var
        QuantityPerFactor: Decimal; // Variable to store the Quantity Per adjustment factor

    /// <summary>
    /// Returns the value of QuantityPerFactor entered by the user.
    /// </summary>
    /// <returns>The Quantity Per adjustment factor as a Decimal value.</returns>
    procedure ReturnQuantityPerFactor(): Decimal
    begin
        exit(QuantityPerFactor); // Return the user-entered adjustment factor
    end;
}