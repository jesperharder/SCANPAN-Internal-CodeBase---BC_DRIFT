/// <summary>
/// TableExtension RoutingLine (ID 50023) extends Record Routing Line.
/// </summary>
/// <remarks>
/// 2023.10                         Jesper Harder                           001     Production Controlling, RoutingLines Priority, Short Comments
/// </remarks>
tableextension 50023 "RoutingLine" extends "Routing Line"
{
    fields
    {
        field(50000; "Routing Priority"; Integer)
        {
            Caption = 'Routing Priority';
        }
    }
}