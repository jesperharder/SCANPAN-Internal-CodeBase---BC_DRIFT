


/// <summary>
/// PageExtension ForNAVReports (ID 50001) extends Record ForNAV Reports.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50001 "ForNAVReports" extends "ForNAV Reports"
{
    layout
    {
        addafter("Current Report Layout") { field(Layout14991; Rec.Layout) { ApplicationArea = All; ToolTip = 'Specifies the value of the Layout field.'; } }
    }
}
