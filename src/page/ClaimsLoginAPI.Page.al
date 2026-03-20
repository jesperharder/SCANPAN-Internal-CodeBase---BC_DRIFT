page 50288 "ClaimsLoginAPI"
{
    PageType = API;
    APIPublisher = 'scanpan';
    APIGroup = 'claims';
    APIVersion = 'v1.0';
    EntityName = 'claimsLogin';
    EntitySetName = 'claimsLogins';
    SourceTable = "ClaimsLoginEntry";

    ODataKeyFields = "Entry No.";

    DelayedInsert = true;
    Extensible = false;
    Editable = true;

    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;

    Permissions =
    tabledata "ClaimsLoginEntry" = RIMD,
    tabledata Customer = R,
    tabledata Company = R;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'entryNo';
                    Editable = false;
                }
                field(createdAt; Rec."Created At")
                {
                    ApplicationArea = All;
                    Caption = 'createdAt';
                    Editable = false;
                }
                field(countryCode; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Caption = 'countryCode';
                }
                field(username; Rec.Username)
                {
                    ApplicationArea = All;
                    Caption = 'username';
                }
                field(password; Rec.Password)
                {
                    ApplicationArea = All;
                    Caption = 'password';
                }
                field(authenticated; Rec.Authenticated)
                {
                    ApplicationArea = All;
                    Caption = 'authenticated';
                    Editable = false;
                }
                field(ledger; Rec.Ledger)
                {
                    ApplicationArea = All;
                    Caption = 'ledger';
                    Editable = false;
                }
                field(companyId; Rec."Company Id")
                {
                    ApplicationArea = All;
                    Caption = 'companyId';
                    Editable = false;
                }
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNo';
                    Editable = false;
                }
                field(name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'name';
                    Editable = false;
                }
                field(languageCode; Rec."Language Code")
                {
                    ApplicationArea = All;
                    Caption = 'languageCode';
                    Editable = false;
                }
                field(allowQtyOnClaims; Rec."Allow Qty On Claims")
                {
                    ApplicationArea = All;
                    Caption = 'allowQtyOnClaims';
                    Editable = false;
                }
                field(errorMessage; Rec."Error Message")
                {
                    ApplicationArea = All;
                    Caption = 'errorMessage';
                    Editable = false;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ClaimsLoginMgt: Codeunit "ClaimsLoginMgt";
        ClaimsLoginEntry: Record "ClaimsLoginEntry";
    begin
        if Rec."Entry No." = 0 then
            Rec."Entry No." := GetNextEntryNo();

        Rec."Created At" := CurrentDateTime;

        ClaimsLoginMgt.ProcessLogin(Rec);

        // Password should only be used for validation and never returned to the caller.
        Rec.Password := '';

        exit(true);
    end;

    local procedure GetNextEntryNo(): Integer
    var
        ClaimsLoginEntry: Record "ClaimsLoginEntry";
    begin
        if ClaimsLoginEntry.FindLast() then
            exit(ClaimsLoginEntry."Entry No." + 1);

        exit(1);
    end;
}
