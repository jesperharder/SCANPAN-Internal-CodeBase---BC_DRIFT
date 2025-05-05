
//SHIPITREMOVE

/// <summary>
/// PageExtension "IDYSTranspOrderLstExtSC" (ID 50039) extends Record IDYS Transport Order List .
/// </summary>

/*
pageextension 50039 IDYSTranspOrderLstExtSC extends "IDYS Transport Order List"
{

    layout
    {
        moveafter("Shipping Agent Service Code"; "Name (Ship-to)")

        addafter("Shipping Agent Code")
        {
            field("Total Count of Packages1"; Rec."Total Count of Packages")
            {
                ApplicationArea = All;
            }
        }

    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        Rec.FindFirst();
    end;

}
*/