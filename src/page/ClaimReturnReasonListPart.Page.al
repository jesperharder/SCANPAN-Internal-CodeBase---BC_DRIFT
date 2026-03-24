page 50048 ClaimReturnReasonListPart
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
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(EnglishDescription; EnglishDescription)
                {
                    ApplicationArea = All;
                    Caption = 'English Description';
                    Editable = false;
                }
                field(HasEnglishTranslation; HasEnglishTranslation)
                {
                    ApplicationArea = All;
                    Caption = 'Has English Translation';
                    Editable = false;
                }
            }
        }
    }

    var
        ClaimsApiMgt: Codeunit ClaimsApiMgt;
        EnglishDescription: Text[100];
        HasEnglishTranslation: Boolean;

    trigger OnAfterGetRecord()
    begin
        HasEnglishTranslation := ClaimsApiMgt.GetEnglishReturnReasonTranslation(Rec.Code, EnglishDescription);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Code, '0|1|2|3|4|5|6|7|8|9|0*|1*|2*|3*|4*|5*|6*|7*|8*|9*');
    end;
}
