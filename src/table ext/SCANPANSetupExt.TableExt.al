

tableextension 50033 "SCANPANSetupExt" extends "SCANPAN Setup"
{
    ///<summary>
    ///
    /// 2024.09             Jesper Harder       080         Self-insured limit check with warning on sales order.
    /// This table extension adds fields to the SCANPAN Setup table to enable configuration options for displaying warnings related to self-insured and credit maximum situations.
    ///</summary>
    fields
    {
        // Field to indicate whether to show a warning for self-insured situations
        field(11; "Show SelfInsured Warning"; Boolean)
        {
            Caption = 'Show SelfInsured Warning';
        }

        // Field to indicate whether to show a warning when the credit maximum is reached
        field(12; "Show CreditMax Warning"; Boolean)
        {
            Caption = 'Show CreditMax Warning';
        }
    }
}