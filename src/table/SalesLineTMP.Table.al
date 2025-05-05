


/// <summary>
/// Table "SCANPANTMPSalesLine" (ID 50009).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03                     Jesper                          005     Sales Lines Page 
/// 2023.03.27                  Jesper Harder                   015     Flowfield Tariff - SalesLine
/// 
/// </remarks>
/// 
table 50009 "SalesLineTMP"
{
    DataCaptionFields = "No.", Description;
    Caption = 'SCANPANTMPSalesLine';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }

        field(2; "Document No."; code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            //TableRelation = "Sales Header"."No." where ("Document Type" = Const("Order"));
        }
        field(3; "Sell-To Customer Name"; Text[100])
        {
            Caption = 'Sell-To Customer Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Type"; Text[20])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(5; "No."; code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Item Cross-Reference No."; code[50])
        {
            Caption = 'Item Cross-Reference No.';
            DataClassification = ToBeClassified;
        }
        field(7; Description; text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(10; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
        }
        field(11; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DataClassification = ToBeClassified;
        }
        field(12; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = ToBeClassified;
        }
        field(13; "Outstanding Amount"; Decimal)
        {
            Caption = 'Outstanding Amount';
            DataClassification = ToBeClassified;
        }
        field(14; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
        field(15; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
            DataClassification = ToBeClassified;
        }
        field(16; "Salesperson Code"; code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(17; "Country Code"; code[20])
        {
            Caption = 'Country Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(18; "Ship-To Name"; text[100])
        {
            Caption = 'Ship-To Name';
            DataClassification = ToBeClassified;
        }
        field(19; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(20; "External Document No."; Text[50])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        //015     Flowfield Tariff - SalesLine
        field(21; "Tariff No."; code[20])
        {
            Caption = 'Tariff No.';
            DataClassification = ToBeClassified;
        }
        field(22; "Priority"; Text[30])
        {
            Caption = 'Order Priority';
            DataClassification = ToBeClassified;
        }
        field(23; "Location Code"; code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(24; "Document Status"; Enum "Sales Document Status")
        {
            Caption = 'Document Status';
            DataClassification = ToBeClassified;
        }
        field(25; ItemUnitCode; code[20])
        {
            Caption = 'Item Unit Code';
        }
        field(26; ItemUnitQuantity; Integer)
        {
            Caption = 'ItemUnitQuantity';
            BlankZero = true;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount", Quantity;
        }
        key(Key1; "Sell-to Customer No.", "Document No.", "No.")
        {
            SumIndexFields = "Line Amount", Quantity;
        }

    }

}
