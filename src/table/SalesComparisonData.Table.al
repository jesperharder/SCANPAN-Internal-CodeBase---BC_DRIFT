table 50024 "SalesComparisonData"
{
    /// <summary>
    /// 2024.08             Jesper Harder       076         Sales Comparison Data
    ///
    /// Summary of Recent Changes:
    /// - Due to limitations in renaming fields after deployment, field names remain unchanged.
    /// - Adjusted captions for fields to shorter versions using the Caption property to accommodate limited display space.
    /// - Captions prioritize key information for better readability in the user interface.
    /// - Ensured data integrity by keeping field names consistent while improving user experience.
    /// </summary>

    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Identity field that auto-increments
            Caption = 'ID';
        }
        field(2; "Sales Order Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Orders';
        }
        field(3; "Sales Amount INTERN"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'INTERN Orders';
        }
        field(4; "Sales Amount EKSTERN"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'EKSTERN Orders';
        }
        field(5; "Distinct Campaigns"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Distinct Campaigns';
        }
        field(6; "Sales Index"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Growth (%)';
        }
        field(7; "Budget Vs Actual"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales vs. Budget (%)';
        }
        field(8; "Last Update"; DateTime)
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Update';
        }
        field(9; "Budget Amount INTERN"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'INTERN Budget';
        }
        field(10; "Budget Amount EKSTERN"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'EKSTERN Budget';
        }
        field(11; "Total Budget Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Budget';
        }
        // Obsolete fields
        field(12; "Realized Sales Amount INTERN"; Decimal)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used.';
            DataClassification = ToBeClassified;
        }
        field(13; "Realized Sales Amount EKSTERN"; Decimal)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used.';
            DataClassification = ToBeClassified;
        }
        field(14; "Total Realized Sales Amount"; Decimal)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used.';
            DataClassification = ToBeClassified;
        }
        // New fields for YTD Sales Amounts with shorter captions
        field(15; "YTD Sales Amount INTERN"; Decimal)
        {
            Caption = 'YTD Sales INTERN';
        }
        field(16; "YTD Sales Amount EKSTERN"; Decimal)
        {
            Caption = 'YTD Sales EKSTERN';
        }
        field(17; "Total YTD Sales Amount"; Decimal)
        {
            Caption = 'Total YTD Sales';
        }
        field(18; "Last Year YTD Sales Amount INTERN"; Decimal)
        {
            Caption = 'Last YTD Sales INTERN';
        }
        field(19; "Last Year YTD Sales Amount EKSTERN"; Decimal)
        {
            Caption = 'Last YTD Sales EKSTERN';
        }
        field(20; "Total Last Year YTD Sales Amount"; Decimal)
        {
            Caption = 'Total Last YTD Sales';
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
