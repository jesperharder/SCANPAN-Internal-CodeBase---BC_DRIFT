



pageextension 50095 "ChangeLogEntries" extends "Change Log Entries"
{
    /// <summary>
    /// PageExtension ChangeLogEntries (ID 50095) extends Record Change Log Entries.
    /// 2025.10.08 Jesper Harder: Added views for common scenarios.
    /// 2025.10.08 Jesper Harder: Added filter to show last month's changes by default.
    /// </summary>


    layout
    {
        addafter("Table Caption")
        {
            field("Table No.44238"; Rec."Table No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the table containing the changed field.';
            }
            field("Primary Key16202"; Rec."Primary Key")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the primary key or keys of the changed field.';
            }
        }
    }

    views
    {
        addlast
        {
            // Debitor (Customer)
            view("Debitor - Spærret")
            {
                Caption = 'Debitor - Spærret';
                Filters =
                where(
                    "Table No." = filter(18 | 287),
                    "Field Caption" = const('Spærret')
                );
            }

            // Kreditor (Vendor)
            view("Kreditor - Bankfelter")
            {
                Caption = 'Kreditor - Bankfelter';
                Filters =
                where(
                    "Table No." = filter(23 | 288 | 402 | 454),
                    "Field Caption" = filter('Bankregistreringsnr.|Bankkontonr.|Foretrukken bankkontokode')
                );
            }

            // Ændringslog indstillinger
            view("Ændringslog indstillinger")
            {
                Caption = 'Ændringslog indstillinger';
                Filters =
                where(
                    "Table No." = filter(402 | 403 | 404)
                );
            }

            // Godkendelsespost
            view("Godkendelsespost")
            {
                Caption = 'Godkendelsespost';
                Filters =
                where(
                    "Table No." = const(454)
                );
            }

            // Opgavekø
            view("Opgavekø")
            {
                Caption = 'Opgavekø';
                Filters =
                where(
                    "Table No." = const(472)
                );
            }
        }
    }



    local procedure ApplyLastMonthFilter()
    var
        FirstOfLastMonth: Date;
        LastOfLastMonth: Date;
        StartDateTime: DateTime;
        EndDateTime: DateTime;
    begin
        // Calculate last month date range (based on Work Date)
        FirstOfLastMonth := CalcDate('<CM-1M>', WorkDate());
        LastOfLastMonth := CalcDate('<CM-1D>', WorkDate());

        // Convert to DateTime boundaries
        StartDateTime := CreateDateTime(FirstOfLastMonth, 0T);
        EndDateTime := CreateDateTime(LastOfLastMonth, 235959T);

        // Only apply if no filter currently set
        if Rec.GetFilter("Date and Time") = '' then
            Rec.SetRange("Date and Time", StartDateTime, EndDateTime);
    end;

    trigger OnOpenPage()
    begin
        ApplyLastMonthFilter();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Reapply if user switches view (filter lost)
        ApplyLastMonthFilter();
    end;
}
