


pageextension 50122 XTECSCTrackAndTraceList extends "XTECSC Track And Trace List"
{

    ///<summary>
    ///
    /// 2024.10             Jesper Harder       086         XtensionIT Shipmondo Add Customer Information on PageExt XTECSC Track And Trace List
    ///                                                     Moved to report 50016 "UpdateXTESCSSTrackAndTrace"
    ///</summary>

    layout
    {
    }


    trigger OnOpenPage()
    begin
        // Remove filter page
        Rec.SetRange("Local Timestamp");

        Rec.SetCurrentKey("Local Timestamp");
        Rec.Ascending(false);
        Rec.FindFirst();
    end;
}
