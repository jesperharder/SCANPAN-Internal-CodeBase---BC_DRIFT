page 50050 ClaimReturnReasonTransList
{
    PageType = List;
    SourceTable = ClaimReturnReasonTranslation;
    ApplicationArea = All;
    Caption = 'Claim Return Reason Translations';
    UsageCategory = Administration;

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
                    ToolTip = 'Specifies the claims language code. Only ENG, DAN, NOR, DEU and FRA are allowed.';
                }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}
