



/// <summary>
/// Table CampaignStatistics (ID 50015).
/// </summary>
/// <remarks>
/// 2023.06.12                  Jesper Harder               034 Campaign statistics Added Code
/// </remarks> 
table 50015 "CampaignStatistics"
{
    Caption = 'CampaignStatistics';
    TableType = Temporary;

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(12; "Campaign Code"; Code[20])
        {
            Caption = 'Campaign Code';
            DataClassification = ToBeClassified;
            TableRelation = Campaign;
        }
        field(13; "Campaign Name"; Text[100])
        {
            Caption = 'Campaign Name';
            DataClassification = ToBeClassified;
        }
        /*
        field(14; "Campaign Type"; Enum "CampaignStatistics DocTypes")
        {
            Caption = 'Campaign Type';
            DataClassification = ToBeClassified;
        }
        */
        field(14; "Campaign Type"; Option)
        {
            Caption = 'Campaign Type';
            DataClassification = ToBeClassified;
            OptionMembers = Campaign,Assortment;
            OptionCaption = 'Campaign,Assortment';
        }
        field(15; "Campaign Purpose"; Text[100])
        {
            Caption = 'Campaign Purpose';
            DataClassification = ToBeClassified;
        }
        field(16; "Chain"; Text[100])
        {
            Caption = 'Customer Chain';
            DataClassification = ToBeClassified;
        }
        field(17; "Chain Group"; Text[100])
        {
            Caption = 'Customer Chain Group';
            DataClassification = ToBeClassified;
        }
        field(18; "SalesPerson Code"; code[20])
        {
            Caption = 'SalesPersconCode';
            DataClassification = ToBeClassified;
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(21; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(30; "Document Type"; enum "CampaignStatistics DocTypes")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(31; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            TableRelation =
                if ("Document Type" = const("Sales Order")) "Sales Header" where("Document Type" = const("Order"))
            else
            if ("Document Type" = const("Invoice")) "Sales Invoice Header"
            else
            if ("Document Type" = const("Forecast")) "Production Forecast Entry";
        }
        field(32; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(33; "Amount(RV)"; Decimal)
        {
            Caption = 'Amount(RV)';
            DataClassification = ToBeClassified;
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(34; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            BlankZero = true;
            BlankNumbers = BlankZero;
        }
        field(40; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
        field(41; "Currency Description"; Text[100])
        {
            Caption = 'Currency Description';
            DataClassification = ToBeClassified;
        }
        field(22; "Country Code"; Code[20])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount(RV)", Quantity;
        }
        key(KEY1; "Campaign Code")
        {
            SumIndexFields = Amount, "Amount(RV)", Quantity;
        }
    }
}
