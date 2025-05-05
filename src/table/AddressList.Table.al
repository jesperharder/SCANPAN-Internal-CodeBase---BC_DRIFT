




/// <summary>
/// Table Address List (ID 50019).
/// </summary>
/// <remarks>
/// 2023.08             Jesper Harder       046         Addresses Customer and Vendor
/// </remarks> 

table 50019 "Address List"
{

    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "LineNo"; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "AddressType"; Enum "Address Types")
        {
            Caption = 'Address Type';
        }
        field(10; "Code"; Text[100])
        {
            Caption = 'Address Code';
        }
        field(15; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(20; "Address Line 1"; Text[100])
        {
            Caption = 'Address Line 1';
        }
        field(21; "Address Line 2"; Text[100])
        {
            Caption = 'Address Line 2';
        }
        field(22; "Address Line 3"; Text[100])
        {
            Caption = 'Address Line 3';
        }
        field(23; "House Number"; Text[100])
        {
            Caption = 'House Number';
        }
        field(25; "ZipCode"; Text[100])
        {
            Caption = 'Zip Code';
        }
        field(26; "City"; Text[100])
        {
            Caption = 'City';
        }
        field(27; "Province"; Text[100])
        {
            Caption = 'Province';
        }
        field(28; Country; Text[100])
        {
            Caption = 'Country';
        }
        field(30; "Phone"; Text[100])
        {
            Caption = 'Phone';
        }
        field(31; "E-mail"; Text[100])
        {
            Caption = 'E-mail';
        }
        field(32; "Contact"; Text[100])
        {
            Caption = 'Contact';
        }
        field(40; "Shipping Agent Code"; Text[100])
        {
            Caption = 'Shipping Agent Code';
        }
        field(41; "Shipping Agent Service Code"; Text[100])
        {
            Caption = 'Shipping Method Code';
        }
        field(42; "Shipment Method Code"; Text[100])
        {
            Caption = 'Shipment Code';
        }
    }

    keys
    {
        key(PK; "LineNo")
        {
            Clustered = true;
        }
    }
}