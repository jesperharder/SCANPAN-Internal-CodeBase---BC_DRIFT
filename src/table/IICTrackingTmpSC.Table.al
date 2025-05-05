



/// <summary>
/// Table "SCANPANTMPIICTracking" (ID 50012).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.22                        Jesper Harder                           012     IIC tracking Norway Denmark.
/// 
/// </remarks>      
/// 
table 50012 "IICTrackingTmpSC"
{
    Caption = 'SCANPANTMPIICTracking';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(10; Company; Text[50])
        {
            Caption = 'Company Name';
        }
        field(20; "Invoice No."; code[30])
        {
            Caption = 'Invoice No. (NO)';
        }
        field(30; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No. (NO)';
        }
        field(35; "Sell-To Customer Name (NO)"; text[100])
        {
            Caption = 'Sell-To Customer Name (NO)';
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No. (NO)';
            TableRelation = "Sales Invoice Header";
        }
        field(50; "Sales Shipment No. (NO)"; code[30])
        {
            Caption = 'Sales Shipment No. (NO)';
        }
        field(60; "Purchase Order No."; code[30])
        {
            Caption = 'Purchase Order No. (NO)';
        }
        field(70; "Sales Shipment No. (DK)"; code[30])
        {
            Caption = 'Sales Shipment No. (DK)';
        }
        field(80; "Sales Ship Posting Date (DK)"; Date)
        {
            Caption = 'Sales Shipment Posting Date (DK)';
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
