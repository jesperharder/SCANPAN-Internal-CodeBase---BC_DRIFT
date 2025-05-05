/// <summary>
/// PageExtension RoutingToolsExtSC (ID 50002) extends Record Routing Tools.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>
pageextension 50002 "RoutingToolsExtSC" extends "Routing Tools"
{
    layout
    {
        addfirst(Control1) { field("Operation No.63937"; Rec."Operation No.") { ApplicationArea = All; Width = 2; ToolTip = 'Specifies the value of the Operation No. field.'; } }
    }
}

