codeunit 50040 "ClaimsLoginMgt"
{
    Permissions =
    tabledata "ClaimsLoginEntry" = RIMD,
    tabledata Customer = R,
    tabledata Company = R;

    procedure ProcessLogin(var ClaimsLoginEntry: Record "ClaimsLoginEntry")
    var
        Customer: Record Customer;
        ExpectedLedger: Code[10];
    begin
        ClaimsLoginEntry.Authenticated := false;
        ClaimsLoginEntry.Ledger := '';
        Clear(ClaimsLoginEntry."Company Id");
        ClaimsLoginEntry."Customer No." := '';
        ClaimsLoginEntry."Shop ID" := '';
        ClaimsLoginEntry.Name := '';
        ClaimsLoginEntry."Language Code" := '';
        ClaimsLoginEntry."Allow Qty On Claims" := false;
        ClaimsLoginEntry."Error Message" := '';

        ExpectedLedger := GetLedgerFromCompany();
        ClaimsLoginEntry.Ledger := ExpectedLedger;
        ClaimsLoginEntry."Company Id" := GetCompanyId();

        if ClaimsLoginEntry."Country Code" = '' then begin
            ClaimsLoginEntry."Error Message" := 'Country code is required.';
            exit;
        end;

        if UpperCase(ClaimsLoginEntry."Country Code") <> UpperCase(ExpectedLedger) then begin
            ClaimsLoginEntry."Error Message" := StrSubstNo(
                'Country %1 does not match current company ledger %2.',
                ClaimsLoginEntry."Country Code",
                ExpectedLedger);
            exit;
        end;

        if ClaimsLoginEntry.Username = '' then begin
            ClaimsLoginEntry."Error Message" := 'Username is required.';
            exit;
        end;

        if ClaimsLoginEntry.Password = '' then begin
            ClaimsLoginEntry."Error Message" := 'Password is required.';
            exit;
        end;

        Customer.Reset();
        Customer.SetRange("ClaimsUser", ClaimsLoginEntry.Username);
        Customer.SetFilter("ClaimsCode", '<>%1', '');
        Customer.SetRange(Blocked, Customer.Blocked::" ");

        if not Customer.FindFirst() then begin
            ClaimsLoginEntry."Error Message" := 'User not found or blocked for claims.';
            exit;
        end;

        if Customer."ClaimsCode" <> ClaimsLoginEntry.Password then begin
            ClaimsLoginEntry."Error Message" := 'Invalid username or password.';
            exit;
        end;

        ClaimsLoginEntry.Authenticated := true;
        ClaimsLoginEntry."Customer No." := Customer."No.";
        ClaimsLoginEntry."Shop ID" := Customer."Old Customer No.";
        ClaimsLoginEntry.Name := Customer.Name;
        ClaimsLoginEntry."Language Code" := Customer."Language Code";
        ClaimsLoginEntry."Allow Qty On Claims" := Customer."Allow Claims Quantity";
        ClaimsLoginEntry."Error Message" := '';
    end;

    local procedure GetLedgerFromCompany(): Code[10]
    begin
        case CompanyName() of
            'SCANPAN Danmark':
                exit('DK');
            'SCANPAN Norge':
                exit('NO');
            else
                exit(CopyStr(UpperCase(CompanyName()), 1, 10));
        end;
    end;

    local procedure GetCompanyId(): Guid
    var
        Company: Record Company;
        EmptyGuid: Guid;
    begin
        Company.SetRange(Name, CompanyName());
        if Company.FindFirst() then
            exit(Company.SystemId);

        Clear(EmptyGuid);
        exit(EmptyGuid);
    end;
}
