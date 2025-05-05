





/// <summary>
/// Page CDOE-MailRecipient_SC (ID 50010).
/// </summary>
page 50010 "CDOE-MailRecipient"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'SCANPAN_CDO E-Mail Recipient';
    PageType = List;
    SourceTable = "CDO E-Mail Recipient";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table"; Rec."Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document Code"; Rec."Document Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Code field.';
                }
                field("Recipient Type"; Rec."Recipient Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recipient Type field.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact No. field.';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Name field.';
                }
                field("Contact Company No."; Rec."Contact Company No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Company No. field.';
                }
                field("Contact E-Mail"; Rec."Contact E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact E-Mail field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Do not Attach Open Documents"; Rec."Do not Attach Open Documents")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Do not Attach Open Documents field.';
                }
                field("E-Mail Type"; Rec."E-Mail Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Mail Type field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(Address1; Address1)
                {
                    Caption = 'Address1';
                    ToolTip = 'Specifies the value of the Address1 field.';
                }
                field(Address2; Address2)
                {
                    Caption = 'Address2';
                    ToolTip = 'Specifies the value of the Address2 field.';
                }
                field(CountryRegion; CountryRegion)
                {
                    Caption = 'Country/Region';
                    ToolTip = 'Specifies the value of the Country/Region field.';
                }
                field(City; City)
                {
                    Caption = 'City';
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(PostNo; PostCode)
                {
                    Caption = 'Post Code';
                    ToolTip = 'Specifies the value of the Postnumber field.';
                }
                field("Customer Country/Region Code"; Rec."Customer Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Country/Region Code field.';
                }
                field("Customer SalesPerson"; Rec."Customer SalesPerson")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer SalesPerson Code field.';
                }
                field(LanguageCode; LanguageCode)
                {
                    Caption = 'Language Code';
                    ToolTip = 'Specifies the Language Code from the Customer.';
                }
            }
        }
    }

    var
        Address1: Text[100];
        Address2: Text[100];

        CountryRegion: Text[100];
        City: Text[100];
        PostCode: Text[100];

        Customer: Record Customer;
        LanguageCode: text[20];

    trigger OnAfterGetRecord()
    var

    begin
        Address1 := '';
        Address2 := '';
        CountryRegion := '';
        City := '';
        PostCode := '';
        LanguageCode := '';
        if Customer.Get(Rec."No.") then begin
            LanguageCode := Customer."Language Code";

            Address1 := Customer.Address;
            Address2 := Customer."Address 2";
            CountryRegion := Customer."Country/Region Code";
            City := Customer.City;
            PostCode := Customer."Post Code";
        end;


    end;





}
