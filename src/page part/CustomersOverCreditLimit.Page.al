page 50047 "CustomersOverCreditLimit"
{
    /// <summary>
    /// 2024.06 Jesper Harder 070 Customers Over Credit Limit TILE
    /// 2024.09 Jesper Harder 080 Self-insured limit check with warning on sales order.
    ///
    /// This page lists customers whose balance exceeds their assigned credit limit or self-insured limit.
    /// The page uses a temporary source table and calculates the total amount exceeding these limits.
    /// This is useful for monitoring and managing customer credit risk.
    /// </summary>

    PageType = CardPart;
    SourceTableTemporary = true;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(KeepTogether)
            {
                ShowCaption = false;

                group(CustomerListGroup)
                {
                    Caption = 'Customer List (Use Toggle View to show Totals)';
                    ShowCaption = true;
                    Visible = not ShowTotal;

                    repeater(Group)
                    {
                        field("Customer No."; Rec."No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer No.';
                            ToolTip = 'Unique ID for the customer.';
                            DrillDown = true;
                            DrillDownPageId = "Customer Card";

                            trigger OnDrillDown()
                            begin
                                PAGE.Run(PAGE::"Customer Card", Rec);
                            end;
                        }

                        field("Balance (LCY)"; Rec."Balance (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Balance (LCY)';
                            ToolTip = 'Current balance of the customer in LCY.';
                            DecimalPlaces = 0;
                        }

                        field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Credit Limit (LCY)';
                            ToolTip = 'Assigned credit limit for the customer in LCY.';
                            DecimalPlaces = 0;
                            StyleExpr = StyleExprCreditLimit;
                        }

                        field("Self-Insured (LCY)"; Rec."Self-Insured (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Self-Insured Limit (LCY)';
                            ToolTip = 'Self-insured credit limit for the customer in LCY.';
                            DecimalPlaces = 0;
                            StyleExpr = StyleExprSelfInsured;
                        }
                    }
                }

                group(TotalGroup)
                {
                    Caption = 'Totals Exceeding Limits (Use Toggle View to show details)';
                    ShowCaption = true;
                    Visible = ShowTotal;

                    field(TotalOverCreditLimit; TotalOverCreditLimit)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Over Credit Limit (LCY)';
                        ToolTip = 'Total exceeding credit limits (balances minus credit limits).';
                        DecimalPlaces = 0;
                    }

                    field(TotalOverSelfInsured; TotalOverSelfInsured)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Over Self-Insured Limit (LCY)';
                        ToolTip = 'Total exceeding self-insured limits (balances minus self-insured limits).';
                        DecimalPlaces = 0;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ToggleView)
            {
                Caption = 'Toggle View';
                ToolTip = 'Switch between showing the customer list and totals.';
                Image = Change;

                trigger OnAction()
                begin
                    ShowTotal := not ShowTotal;
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        ShowTotal: Boolean;
        TotalOverCreditLimit: Decimal;
        TotalOverSelfInsured: Decimal;
        StyleExprSelfInsured: Text;
        StyleExprCreditLimit: Text;

    trigger OnOpenPage()
    var
        Customer: Record Customer;
    begin
        ShowTotal := true;

        InitializeTotals();

        if Customer.FindSet() then
            repeat
                Customer.CalcFields("Balance (LCY)");
                if ShouldInsertCustomer(Customer) then begin
                    Rec := Customer;
                    Rec.Insert();
                end;
            until Customer.Next() = 0;

        CalculateTotals();

        if Rec.FindFirst() then;
    end;

    trigger OnAfterGetRecord()
    begin
        SetStyleExpressions(Rec);
    end;

    local procedure InitializeTotals()
    begin
        TotalOverCreditLimit := 0;
        TotalOverSelfInsured := 0;
    end;

    local procedure ShouldInsertCustomer(Customer: Record Customer): Boolean
    var
        CreditLimitTriggered: Boolean;
    begin
        CreditLimitTriggered := false;

        if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)") and
           (Customer."Credit Limit (LCY)" >= Customer."Self-Insured (LCY)") then begin
            CreditLimitTriggered := true;
            TotalOverCreditLimit += Customer."Balance (LCY)" - Customer."Credit Limit (LCY)";
            exit(true);
        end;

        if (not CreditLimitTriggered) and
           (Customer."Balance (LCY)" > Customer."Self-Insured (LCY)") and
           (Customer."Self-Insured (LCY)" >= Customer."Credit Limit (LCY)") then begin
            TotalOverSelfInsured += Customer."Balance (LCY)" - Customer."Self-Insured (LCY)";
            exit(true);
        end;

        exit(false);
    end;

    local procedure CalculateTotals()
    begin
        TotalOverCreditLimit := TotalOverCreditLimit;
        TotalOverSelfInsured := TotalOverSelfInsured;
    end;

    local procedure SetStyleExpressions(Customer: Record Customer)
    begin
        StyleExprCreditLimit := '';
        StyleExprSelfInsured := '';

        // Set style for Credit Limit based on the percentage the balance exceeds the limit
        if (Customer."Credit Limit (LCY)" > 0) then
            if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)") then
                if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)" * 1.25) then
                    StyleExprCreditLimit := 'Unfavorable'
                else
                    if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)" * 1.15) then
                        StyleExprCreditLimit := 'Attention'
                    else
                        if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)" * 1.10) then
                            StyleExprCreditLimit := 'Strong'
                        else
                            StyleExprCreditLimit := 'Favorable';



        // Set style for Self-Insured based on the percentage the balance exceeds the limit
        if (Customer."Self-Insured (LCY)" > 0) then
            if (Customer."Balance (LCY)" > Customer."Self-Insured (LCY)") then
                if (Customer."Balance (LCY)" > Customer."Self-Insured (LCY)" * 1.25) then
                    StyleExprSelfInsured := 'Unfavorable'
                else
                    if (Customer."Balance (LCY)" > Customer."Self-Insured (LCY)" * 1.15) then
                        StyleExprSelfInsured := 'Attention'
                    else
                        if (Customer."Balance (LCY)" > Customer."Self-Insured (LCY)" * 1.10) then
                            StyleExprSelfInsured := 'Strong'
                        else
                            StyleExprSelfInsured := 'Favorable';

    end;
}
