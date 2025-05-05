




/// <summary>
/// TableExtension UserSetup (ID 50018).
/// </summary>
/// 
/// <remarks>
/// 2023.09             Jesper Harder       047         Restrict changes to user setup and General ledger posting dates
/// </remarks>
/// 
tableextension 50018 "User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "Allow Edit Posting Dates"; Boolean)
        {
            Caption = 'Allow Edit Posting Dates';
        }
    }
}