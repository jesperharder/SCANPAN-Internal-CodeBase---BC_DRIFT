


/// 2024.05             Jesper Harder       066         Test for Correct Chain Dimension value on Customer
pageextension 50107 DefaultDimensions extends "Default Dimensions"
{
    layout
    {
        addafter("Value Posting")
        {
            //066
            field("Dimension Value Type"; rec."Dimension Value Type")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the purpose of the dimension value.';
            }
        }
    }
}