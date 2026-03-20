
page 50290 ClaimReturnReasonListPart
{
    PageType = ListPart;
    SourceTable = "Return Reason";
    ApplicationArea = All;
    Caption = 'Claim Return Reasons';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Keep this aligned with the old SQL rule:
        // only numeric return reason codes are relevant for claims.
        Rec.SetFilter(Code, '0|1|2|3|4|5|6|7|8|9|0*|1*|2*|3*|4*|5*|6*|7*|8*|9*');
    end;
}
