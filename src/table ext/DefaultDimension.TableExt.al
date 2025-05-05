


/// 2024.05             Jesper Harder       066         Test for Correct Chain Dimension value on Customer
tableextension 50031 DefaultDimension extends "Default Dimension"
{

    fields
    {
        //066
        field(50000; "Dimension Value Type"; Option)
        {
            Caption = 'Dimension Value Type';
            OptionCaption = 'Standard,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Standard,Heading,Total,"Begin-Total","End-Total";

            //TableRelation = "Dimension Value";
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value"."Dimension Value Type" where(
                                "Dimension Code" = field("Dimension Code"),
                                 Code = field("Dimension Value Code")
                                ));
        }
    }
}


