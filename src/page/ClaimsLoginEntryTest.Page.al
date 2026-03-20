page 50287 "ClaimsLoginEntryTest"
{
    PageType = List;
    SourceTable = "ClaimsLoginEntry";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Country Code"; Rec."Country Code") { ApplicationArea = All; }
                field(Username; Rec.Username) { ApplicationArea = All; }
                field(Password; Rec.Password) { ApplicationArea = All; }
                field(Authenticated; Rec.Authenticated) { ApplicationArea = All; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; }
            }
        }
    }
}
