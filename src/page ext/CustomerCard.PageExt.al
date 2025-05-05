pageextension 50035 "CustomerCard" extends "Customer Card"
{
    /// <summary>
    /// PageExtension "CustomerCardExtSC" (ID 50035) extends the Customer Card.
    /// </summary>
    /// <remarks>
    /// 2023.11             Jesper Harder       059         Added PO Number City, broke lookup for Web Customers.
    /// 2024.09             Jesper Harder       080         Added self-insured limit check with warning on sales order.
    /// 2024.10             Jesper Harder       090         Field for Claims, allow reporting quantity
    /// </remarks>

    layout
    {
        // Adds a bank field to the Payments group on the Customer Card page
        addlast(Payments)
        {
            field(Bank1; Rec.Bank)
            {
                ApplicationArea = all;
                ToolTip = 'Choose what Bank information to show on certain documents.';
            }
        }

        // Adds a new Scanpan group after the Shipping section
        addafter(Shipping)
        {
            group(ScanpanGroup)
            {
                Caption = 'Scanpan';

                group(Misc)
                {
                    ShowCaption = false;
                    // Additional fields can be added here later if needed
                }

                group(Claims)
                {
                    Caption = 'Claims settings';

                    field(ClaimsUser; Rec.ClaimsUser)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the Claims Username used in the Claims Web application.';
                    }

                    field(ClaimsCode; Rec.ClaimsCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the Claims Code used in the Claims Web application.';
                    }

                    // 090
                    field("Allow Claims Quantity"; Rec."Allow Claims Quantity")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies is the Claims Customer is allowed to type quantity for each claim on the Claims Web application.';
                    }
                }
            }
        }

        // 080 Adds the Self-Insured Limit field after the "Credit Limit (LCY)" section
        addafter("Credit Limit (LCY)")
        {
            field("Self-Insured Limit (LCY)"; Rec."Self-Insured (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Self-Insured Limit (LCY) for the customer.';
                StyleExpr = SelfInsuredStyleTxt;
            }
        }
    }


    //080
    var
        SelfInsuredStyleTxt: Text;

    trigger OnAfterGetCurrRecord()
    begin

        SetSelfInsuredCreditLimitStyle();
    end;

    local procedure SetSelfInsuredCreditLimitStyle()
    var
        BalanceExhausted: Boolean;
    begin
        SelfInsuredStyleTxt := '';
        BalanceExhausted := false;
        if REc."Self-Insured (LCY)" > 0 then
            BalanceExhausted := Rec."Balance (LCY)" >= Rec."Self-Insured (LCY)";
        if BalanceExhausted then
            SelfInsuredStyleTxt := 'Unfavorable';
    end;
}
