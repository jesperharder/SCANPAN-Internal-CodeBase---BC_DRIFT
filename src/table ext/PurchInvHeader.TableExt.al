





/// <summary>
/// TableExtension PurchInvHeader (ID 50025) extends Record Purch. Inv. Header.
/// </summary>
/// <remarks>
/// 2023.10             Jesper Harder       044         LTS Drop Shipment exclude from Exports
/// </remarks>
tableextension 50025 PurchInvHeader extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "Drop Shipment"; Boolean)
        {
            Description = 'Displays if any lines are marked Drop Shipment.';
            Caption = 'Drop Shipment.';
            CalcFormula = exist("Purch. Inv. Line" where("Document No." = field("No."),
                                                         "Drop Shipment" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}