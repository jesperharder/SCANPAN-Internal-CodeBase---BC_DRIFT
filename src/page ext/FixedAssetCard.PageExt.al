




/// <summary>
/// PageExtension FixedAssetCard (ID 50104) extends Record Fixed Asset Card.
/// </summary>
pageextension 50104 "FixedAssetCard" extends "Fixed Asset Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; rec."Description 2")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
        }
    }
}