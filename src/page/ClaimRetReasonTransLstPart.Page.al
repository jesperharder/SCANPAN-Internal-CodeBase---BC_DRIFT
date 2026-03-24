page 50049 ClaimRetReasonTransLstPart
{
    PageType = ListPart;
    SourceTable = ClaimReturnReasonTranslation;
    ApplicationArea = All;
    Caption = 'Claim Return Reason Translations';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ReturnReasonCode; Rec.ReturnReasonCode) { ApplicationArea = All; }
                field(ReturnReasonBaseDescription; Rec.ReturnReasonBaseDescription) { ApplicationArea = All; }
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the claims language code. Only ENG, DAN, DEU and FRA are allowed.';
                }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}
