



table 50010 "ExtSalesLines"
{
    Caption = 'Temprary Sales Lines Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    Extensible = false;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }


        field(2; "Sell-to Customer Name"; text[100])
        {
        }

        field(3; "Sell-to Customer No."; code[20])
        {
        }
        field(4; "Ship-to Name"; text[100])
        {
        }

        field(5; "Document No."; code[20])
        {
        }
        field(6; "Type"; Text[20])
        {
        }
        field(7; "No."; code[20])
        {
        }
        field(8; Description; text[100])
        {
        }
        field(9; "Used Campaign NOTO"; text[100])
        {
        }
        field(10; CampaignsDescription; text[100])
        {
        }
        field(11; Quantity; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(12; "Outstanding Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(13; "Qty. to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(14; "Quantity Shipped"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(15; "Qty. Shipped Not Invoiced"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(16; "Qty. to Invoice"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(17; "Quantity Invoiced"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(18; "Line Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(19; "Currency Code"; code[20])
        {
        }
        field(20; "Salesperson Code"; code[20])
        {
        }
        field(21; "Requested Delivery Date"; Date)
        {
        }
        field(22; "ChainGroup Code"; code[20])
        {
        }
        field(23; "ChainGroup Name"; text[100])
        {
        }
        field(24; "SalesLine LineNo"; Integer)
        {
            BlankNumbers = BlankZero;
        }
        field(100; SetStyleExpr; Boolean)
        {
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
