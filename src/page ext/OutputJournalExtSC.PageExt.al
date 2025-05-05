

/// <summary>
/// PageExtension "OutputJournalExtSC" (ID 50042) extends Record Output Journal.
/// </summary>
/// 
/// <remarks>
/// 
///  2023.03.08             Jesper Harder               0193        From user design
/// 
/// </remarks>      
pageextension 50042 OutputJournalExtSC extends "Output Journal"
{
    layout
    {
        moveafter(ShortcutDimCode3; "Stop Time")
        moveafter("Cap. Unit of Measure Code"; "Output Quantity")

        moveafter("Shortcut Dimension 1 Code"; "Applies-to Entry")
        moveafter(Description; "Shortcut Dimension 2 Code")
        moveafter("Unit of Measure Code"; "Stop Code")
        moveafter("Stop Code"; "Stop Time")

    }
}
