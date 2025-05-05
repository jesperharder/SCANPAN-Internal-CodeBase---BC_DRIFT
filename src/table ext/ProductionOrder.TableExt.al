/// <summary>
/// TableExtension "SCANPANProductionOrder" (ID 50007) extends Record Production Order.
/// </summary>
/// <remarks>
///
/// 2023.03.17                      Jesper Harder                        008     Released Production Added flowfield for Finished + Remaining Quantity
///
/// </remarks>

tableextension 50007 "ProductionOrder" extends "Production Order"
{
    fields
    {
        //008
        field(50000; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Prod. Order Line"."Finished Quantity" WHERE(
                                                        "Status" = field(Status),
                                                        "Prod. Order No." = field("No."),
                                                        "Item No." = field("Source No.")

            ));
        }
        //008
        field(50001; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Prod. Order Line"."Remaining Quantity" WHERE(
                                                        "Status" = field(Status),
                                                        "Prod. Order No." = field("No."),
                                                        "Item No." = field("Source No.")

            ));
        }
        field(50002; "Component Lines Count"; integer)
        {
            Caption = 'Component Lines Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Prod. Order Component" where(
                                                    Status = field(Status),
                                                    "Prod. Order No." = field("No.")
                                                    ));
        }
    }
}
