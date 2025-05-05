




/// <summary>
/// TableExtension Purchase Header (ID 50022) extends Record Purchase Header.
/// </summary>
/// ///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>
tableextension 50022 "Purchase Header" extends "Purchase Header"
{
    Caption = 'Extension table Purchase Header';

    fields
    {

        field(50000; "Transport API Sent"; Boolean)
        {
            Caption = 'Transport API Sent';
        }
        field(50001; "Transport API Sent date"; DateTime)
        {
            Caption = 'Transport API Sent date';
        }
        field(50500; "TransportMode"; enum DSVTransportMode)
        {
            Caption = 'TransportMode';
        }

    }
}
