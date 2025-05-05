



/// <summary>
/// Table API Setup (ID 50020).
/// </summary>
/// <remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>

table 50020 "Scanpan API Setup"
{
    Caption = 'API Setup Table';
    DataClassification = ToBeClassified;

    Permissions = tabledata "Scanpan API Setup" = rimd;

    fields
    {
        field(1; LineNo; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Profile Name"; code[20])
        {
            Caption = 'Profile Name';
        }

        field(20; "Request Type"; Enum "Http Request Type")
        {
            Caption = 'Request Type';
        }

        field(30; "URL"; text[200])
        {
            Caption = 'URL';
        }

        field(40; "User Name"; text[100])
        {
            Caption = 'User Name';
        }
        field(50; "Password"; text[100])
        {
            Caption = 'Password';
        }
        field(60; "Subscription key"; text[100])
        {
            Caption = 'Subscription key';
        }
    }

    keys
    {
        key(Key1; LineNo)
        {
            Clustered = true;
        }
    }
}