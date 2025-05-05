pageextension 50120 ScanpanSetup extends "SCANPAN Setup"
{
    ///<summary>
    ///
    /// 2024.09             Jesper Harder       080         Self-insured limit check with warning on sales order.
    /// This page extension adds warning settings fields to the SCANPAN Setup page to provide configuration options for displaying warnings related to self-insured and credit maximum situations.
    ///</summary>
    layout
    {
        addlast(Content)
        {
            group(WarningSettings)
            {
                Caption = 'Warning Settings';

                // Field to indicate whether to show a warning for self-insured situations
                field("Show SelfInsured Warning"; "Show SelfInsured Warning")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a warning should be displayed for self-insured situations.';
                }
                
                // Field to indicate whether to show a warning when the credit maximum is reached
                field("Show CreditMax Warning"; "Show CreditMax Warning")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a warning should be displayed when the credit maximum is reached.';
                }
            }
        }
    }
}