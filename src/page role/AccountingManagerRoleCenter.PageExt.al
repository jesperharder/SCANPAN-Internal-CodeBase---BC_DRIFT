
pageextension 50101 "AccountingManagerRoleCenter" extends "Accounting Manager Role Center"
{
    /// <summary>
    /// PageExtension AccountingManagerRoleCenter (ID 50101) extends the "Accounting Manager Role Center".
    /// 
    /// This page extension adds custom parts for the Scanpan overview and a tile that highlights customers who have exceeded their credit limit.
    /// 
    /// Change Log:
    /// 2024.06             Jesper Harder       070         Added Customers Over Credit Limit TILE
    /// 2024.08             Jesper Harder       076         Cue for Sales Comparison
    /// </summary>

    layout
    {
        addfirst(rolecenter)
        {
            /// <summary>
            /// This part adds a custom card part specific to Scanpan, which provides a quick overview of relevant Scanpan data.
            /// </summary>
            part(ScanpanCardPart; ScanpanCardPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan';
            }

            /// <summary>
            /// This part adds a tile displaying customers who are over their credit limit.
            /// It helps Accounting Managers quickly identify customers that require follow-up due to credit overages.
            /// </summary>
            part(CustomerOverCreditLimit; CustomersOverCreditLimit)
            {
                ApplicationArea = All;
                Caption = 'Customers Over Credit Limit';
            }
            // 076 Cue for Sales Comparison
            group(SalesCompare)
            {
                ShowCaption = false;

                part(SalesCompAndRealized; "SalesCompareAndRealized")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Scanpan Sales';
                }
            }
        }
    }
}
