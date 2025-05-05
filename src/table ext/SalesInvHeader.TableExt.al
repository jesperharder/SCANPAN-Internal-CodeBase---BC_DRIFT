



/// <summary>
/// TableExtension SalesInvHeader (ID 50026) extends Record Sales Invoice Header.
/// </summary>
/// <remarks>
/// 2023.10             Jesper Harder       044         LTS Drop Shipment exclude from Exports
/// </remarks>
tableextension 50026 SalesInvHeader extends "Sales Invoice Header"
{

    fields
    {
        //044
        field(50000; "Drop Shipment"; Boolean)
        {
            Description = 'Displays if any lines are marked Drop Shipment.';
            Caption = 'Drop Shipment.';
            CalcFormula = exist("Sales Invoice Line" where("Document No." = field("No."),
                                                           "Drop Shipment" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}