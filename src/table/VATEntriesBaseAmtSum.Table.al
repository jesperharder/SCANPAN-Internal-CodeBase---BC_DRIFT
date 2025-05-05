
/// 
/// 2024.04             Jesper Harder       063         EU tax system
/// 

table 50023 "VATEntriesBaseAmtSum"
{
    Caption = 'VATEntriesBaseAmtSum';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }

        field(8; Base; Decimal)
        {
            //Method = Sum;
            AutoFormatType = 1;
            Caption = 'Base';
            Editable = false;
        }
        field(12; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
        }
        field(13; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(19; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(44; "Additional-Currency Base"; Decimal)
        {
            //Method = Sum;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Additional-Currency Base';
            Editable = false;
        }
        field(55; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(59; "EU Service"; Boolean)
        {
            Caption = 'EU Service';
            Editable = false;
        }
        field(90; "EU Country/Region Code"; Code[10])
        {
            Caption = 'EU Country/Region Code';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    local procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GeneralLedgerSetup.Get();
            GLSetupRead := true;
        end;
        exit(GeneralLedgerSetup."Additional Reporting Currency");
    end;

}