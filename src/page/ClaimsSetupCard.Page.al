page 50305 ClaimsSetupCard
{
    PageType = Card;
    SourceTable = ClaimsSetup;
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Claims Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Setup';

                field(ClaimsEnabled; Rec.ClaimsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the claims solution is enabled.';
                }
                field(ItemPostingGroupFilter; Rec.ItemPostingGroupFilter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which item posting groups are allowed in claims item lookup.';
                }
                field(DefaultLanguageFallback1; Rec.DefaultLanguageFallback1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first fallback language for item descriptions.';
                }
                field(DefaultLanguageFallback2; Rec.DefaultLanguageFallback2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the second fallback language for item descriptions.';
                }
            }
        }
    }
}
