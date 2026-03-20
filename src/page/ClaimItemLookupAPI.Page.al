page 50293 "ClaimItemLookupAPI"
{
    PageType = API;
    APIPublisher = 'scanpan';
    APIGroup = 'claims';
    APIVersion = 'v1.0';
    EntityName = 'claimItemLookup';
    EntitySetName = 'claimItemLookups';
    SourceTable = Item;
    SourceTableView = where("Gen. Prod. Posting Group" = filter('INTERN | EKSTERN | BRUND'));
    Caption = 'Claim Item Lookup API';
    DelayedInsert = false;
    ODataKeyFields = "No.";
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(number; Rec."No.") { Caption = 'Item Number'; }
                field(requestedLanguageCode; RequestedLanguageCode) { Caption = 'Requested Language Code'; }
                field(displayDescription; DisplayDescription) { Caption = 'Display Description'; }
                field(baseDescription; Rec.Description) { Caption = 'Base Description'; }
                field(productUsage; Rec."Product Usage") { Caption = 'Product Usage'; }
                field(languageCodeUsed; LanguageCodeUsed) { Caption = 'Language Code Used'; }
                field(blocked; Rec.Blocked) { Caption = 'Blocked'; }
                field(salesBlocked; Rec."Sales Blocked") { Caption = 'Sales Blocked'; }
            }
        }
    }

    var
        ClaimsApiMgt: Codeunit ClaimsApiMgt;
        DisplayDescription: Text[100];
        LanguageCodeUsed: Code[10];
        RequestedLanguageCode: Code[10];

    trigger OnAfterGetRecord()
    begin
        ClaimsApiMgt.ResolveItemLookup(Rec, RequestedLanguageCode, DisplayDescription, LanguageCodeUsed);
    end;
}


