/// <summary>
/// Table InvoiceLines (ID 50013).
/// </summary>
/// <remarks>
/// 2023.05.01              Jesper Harder                       028     SalesCommision
/// </remarks>

table 50013 "DocumentLines"
{
    DataCaptionFields = "Customer Name", "Customer No.", "Document Type", "Document No.";
    Caption = 'Invoice Lines';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Line No."; integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
        }
        field(3; "Customer Name"; text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Posting Date"; date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; enum "Enum Posted Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; code[20])
        {
            Caption = 'Document No.';
        }
        field(7; "Salesperson Code"; code[20])
        {
            Caption = 'Salesperson Code';
        }
        field(8; "Salesperson Name"; text[100])
        {
            Caption = 'Salesperson Name';
        }
        field(9; "Salesperson Commission %"; integer)
        {
            Caption = 'Salespersion Commission %';
        }
        field(10; "Campaign Code"; code[20])
        {
            Caption = 'Campaign Code';
        }
        field(11; "Campaign Name"; text[100])
        {
            Caption = 'Campaign Name';
        }
        field(12; "Starting Date"; date)
        {
            Caption = 'Campaign Starting Date';
        }
        field(13; "Ending Date"; date)
        {
            Caption = 'Campaign Ending Date';
        }
        field(14; "Currency Code"; code[20])
        {
            Caption = 'Currency Code';
        }
        field(15; "Currency Factor"; decimal)
        {
            Caption = 'Currency Factor';
        }
        field(16; "Item No."; code[20])
        {
            Caption = 'Item No.';
        }
        field(17; "Item Desription"; text[100])
        {
            Caption = 'Item Description';
        }
        field(18; "Amount(RV)"; decimal)
        {
            Caption = 'Amount(RV)';
            BlankNumbers = BlankZero;
        }
        field(19; "Quantity"; decimal)
        {
            Caption = 'Quantity';
            BlankNumbers = BlankZero;
        }
        field(20; "Commission Amount(RV)"; decimal)
        {
            Caption = 'Commission Amount(RV)';
            BlankNumbers = BlankZero;
        }
        field(21; "Amount"; decimal)
        {
            Caption = 'Amount';
            BlankNumbers = BlankZero;
        }
        field(22; "Commission Amount"; decimal)
        {
            Caption = 'Commission Amount';
            BlankNumbers = BlankZero;
        }
        field(100; "Show Lines"; boolean)
        {
            Caption = 'Show Lines';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount", "Amount(RV)", Quantity, "Commission Amount", "Commission Amount(RV)";
        }
        key("CAMPAIGN"; "Campaign Code")
        {
            SumIndexFields = "Amount", "Amount(RV)", Quantity, "Commission Amount", "Commission Amount(RV)";
        }
        key("POSTINGDATE"; "Posting Date")
        { }
    }
}