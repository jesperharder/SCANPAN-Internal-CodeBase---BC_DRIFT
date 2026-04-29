page 50289 ClaimsAdmin
{
    PageType = Card;
    SourceTable = ClaimsSetup;
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Claims Admin';

    layout
    {
        area(content)
        {
            group(GeneralSetup)
            {
                Caption = 'General Setup';
                InstructionalText = 'Use this section to maintain the shared default setup for the claims solution.';

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

            group(AllowedReturnReasonsInfo)
            {
                Caption = 'Allowed Return Reasons';
                InstructionalText = 'Claims uses Business Central return reasons as error types. Only numeric codes are intended for claims.';


                part(ClaimReturnReasons; ClaimReturnReasonListPart)
                {
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }
            group(ReturnReasonTranslationInfo)
            {
                Caption = 'Return Reason Translations';
                InstructionalText = 'Maintain claims-specific return reason translations here. English (ENG) should exist for all return reasons used in claims.';


                part(ClaimReturnReasonTranslations; ClaimRetReasonTransLstPart)
                {
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }

            group(ProductUsageReasonInfo)
            {
                Caption = 'Product Usage to Return Reason Mapping';
                InstructionalText = 'Maintain which return reasons are allowed for each product usage used in claims.';


                part(ClaimProductUsageReasons; ClaimProdUsageReasonLstPart)
                {
                    ApplicationArea = All;
                }
            }
            group(YearCodesInfo)
            {
                Caption = 'Year Codes';
                InstructionalText = 'Maintain claims year codes and valid date intervals here instead of the old local SQL setup.';


                part(ClaimYearCodes; ClaimYearCodeListPart)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenYearCodes)
            {
                ApplicationArea = All;
                Caption = 'Open Year Codes';
                Image = List;

                trigger OnAction()
                begin
                    Page.Run(Page::ClaimYearCodeList);
                end;
            }

            action(OpenProductUsageReasons)
            {
                ApplicationArea = All;
                Caption = 'Open Product Usage Reasons';
                Image = List;

                trigger OnAction()
                begin
                    Page.Run(Page::ClaimProductUsageReasonList);
                end;
            }

            action(OpenReturnReasonTranslations)
            {
                ApplicationArea = All;
                Caption = 'Open Return Reason Translations';
                Image = List;

                trigger OnAction()
                begin
                    Page.Run(Page::ClaimReturnReasonTransList);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureSetupExists();
    end;

    local procedure EnsureSetupExists()
    begin
        if Rec.Get('SETUP') then
            exit;

        Rec.Init();
        Rec.PrimaryKey := 'SETUP';
        Rec.Insert(true);
    end;

}
