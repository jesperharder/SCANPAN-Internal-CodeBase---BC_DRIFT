table 50025 "SalesOrderLineTemp"
{
    ///<summary>
    /// 2024.09  Jesper Harder  081  API displaying Sales orders for integration with Makes You Local
    ///</summary>

    Caption = 'SalesOrderLineTemp';
    TableType = Temporary;

    fields
    {
        field(1; "Company Name"; Text[30]) { Caption = 'Company Name'; }
        field(100; "Order No."; Code[20]) { Caption = 'Order No.'; }
        field(105; "Document Status"; Enum "Sales Document Status") { Caption = 'Document Status'; }
        field(110; "Order Date"; Date) { Caption = 'Order Date'; }
        field(120; "Customer No."; Code[20]) { Caption = 'Customer No.'; }
        field(130; "Customer Name"; Text[100]) { Caption = 'Customer Name'; }
        field(140; "Address"; Text[100]) { Caption = 'Address'; }
        field(150; "Address 2"; Text[100]) { Caption = 'Address 2'; }
        field(160; "City"; Text[50]) { Caption = 'City'; }
        field(170; "Post Code"; Code[20]) { Caption = 'Post Code'; }
        field(180; "Country/Region Code"; Code[10]) { Caption = 'Country/Region Code'; }
        field(190; "Contact"; Text[100]) { Caption = 'Contact'; }
        field(195; "Phone No."; Text[30]) { Caption = 'Phone No.'; }
        field(196; "Email"; Text[100]) { Caption = 'Email'; }
        field(200; "Line No."; Integer) { Caption = 'Line No.'; }
        field(210; "Item Type"; Enum "Sales Line Type") { Caption = 'Item Type'; }
        field(220; "Item No."; Code[20]) { Caption = 'Item No.'; }
        field(230; Description; Text[100]) { Caption = 'Description'; }
        field(235; "Quantity to Ship"; Decimal) { Caption = 'Quantity to Ship'; }
        field(236; "Quantity Shipped"; Decimal) { Caption = 'Quantity Shipped'; }
        field(240; Quantity; Decimal) { Caption = 'Quantity'; }
        field(250; "Line Amount"; Decimal) { Caption = 'Line Amount'; }
        // Existing fields...

        field(260; "Shipping Agent Code"; Text[250]) { Caption = 'Shipping Agent Code'; }
        field(261; "Shipping Agent Name"; Text[50]) { Caption = 'Shipping Agent Name'; }
        field(262; "Shipping Agent URL"; Text[250]) { Caption = 'Shipping Agent URL'; } // Shortened
        field(270; "Shipping Agent Service Code"; Text[250]) { Caption = 'Shipping Agent Service Code'; }
        field(271; "Shipping Agent Service Name"; Text[100]) { Caption = 'Shipping Agent Service Name'; }
        field(280; "Track & Trace Number"; Text[250]) { Caption = 'Track & Trace Number'; }
        field(281; "Track & Trace URL"; Text[250]) { Caption = 'Track & Trace URL'; }
        // Add other fields as needed
    }

    keys
    {
        key(PK; "Order No.", "Line No.") { Clustered = true; }
    }
}
