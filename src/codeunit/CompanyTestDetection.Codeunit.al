



codeunit 50003 "CompanyTestDetection"
{

    /// <summary>
    /// Codeunit "TestCompany" (ID 50003).
    /// </summary>
    /// <remarks>
    /// 
    /// 2023.07             Jesper Harder           041     Test for Company environment
    /// 
    /// </remarks>
    /// 



#if CLEAN18
    trigger OnRun()
    begin
        OnAfterCompanyOpen();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterCompanyOpen', '', false, false)]
    local procedure OnAfterCompanyOpen();
    var
        CurrDB: Record Database;
        Text000Lbl: Label 'Warning\You are in the Test Invironment\ "%1"\%2', Comment = '%1 = Displays the current database name., %2 = Curremnt Company Name';
    begin
        if not GuiAllowed then
            exit;

        CurrDB.SetRange("My Database", true);
        if CurrDB.FindFirst() then
            if CurrDB."Database Name" <> 'BC_DRIFT' then
                Message(Text000Lbl, CurrDB."Database Name", CompanyName);
    end;
#endif
}

