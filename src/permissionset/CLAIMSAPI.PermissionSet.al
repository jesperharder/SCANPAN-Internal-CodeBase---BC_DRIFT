permissionset 50100 "CLAIMS API"
{
    Assignable = true;
    Caption = 'Claims API';

    Permissions =
        table "ClaimsLoginEntry" = X,
        tabledata "ClaimsLoginEntry" = RIMD,
        page "ClaimsLoginAPI" = X,
        codeunit "ClaimsLoginMgt" = X,
        table Customer = X,
        tabledata Customer = R,
        table Company = X,
        tabledata Company = R;

}
