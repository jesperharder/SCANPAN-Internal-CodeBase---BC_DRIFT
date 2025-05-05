





/// <summary>
/// pageextension 50022 "SCANPAN Routing Lines" extends "Routing Lines"
/// </summary>
pageextension 50022 "SCANPANRoutingLines" extends "Routing Lines"
{
    layout
    {
        addafter("Run Time") { field("Run Time Unit of Meas. Code1"; Rec."Run Time Unit of Meas. Code") { ApplicationArea = All; ToolTip = 'Specifies the unit of measure code that applies to the run time of the operation.'; } }
        addafter(Description) { field("Routing Link Code74149"; Rec."Routing Link Code") { ApplicationArea = All; ToolTip = 'Specifies the routing link code.'; } }

    }
}
