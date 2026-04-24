codeunit 50035 "Prod. Dashboard Pref. Mgt."
{
    Permissions = tabledata "Prod. Dashboard User Pref." = RIMD;

    procedure GetOrCreatePreference(var Preference: Record "Prod. Dashboard User Pref.")
    begin
        Preference.Reset();
        Preference.SetRange("User Security ID", UserSecurityId());
        Preference.SetRange("Company Name", CopyStr(CompanyName, 1, MaxStrLen(Preference."Company Name")));
        Preference.SetRange("Page ID", Page::ProdControllingDashboard);

        if Preference.FindFirst() then
            exit;

        Preference.Init();
        ApplyIdentity(Preference);
        ApplyDefaults(Preference);
        Preference.Insert();
    end;

    procedure SavePreference(var Preference: Record "Prod. Dashboard User Pref.")
    var
        ExistingPreference: Record "Prod. Dashboard User Pref.";
    begin
        ApplyIdentity(Preference);
        ValidatePreference(Preference);

        if ExistingPreference.Get(Preference."User Security ID", Preference."Company Name", Preference."Page ID") then begin
            ExistingPreference.TransferFields(Preference, false);
            ExistingPreference.Modify();
            Preference := ExistingPreference;
            exit;
        end;

        Preference.Insert();
    end;

    procedure ResetPreference(var Preference: Record "Prod. Dashboard User Pref.")
    begin
        ApplyIdentity(Preference);
        ApplyDefaults(Preference);
        SavePreference(Preference);
    end;

    procedure ApplyDefaults(var Preference: Record "Prod. Dashboard User Pref.")
    begin
        Preference."Use Current Date" := true;
        Preference."Date Filter" := Format(Today);
        Preference."Period Type" := Preference."Period Type"::Week;
        Preference."Period Length" := 12;
        Preference."Production Date Selection" := Preference."Production Date Selection"::"Starting Date";
        Preference."Chart Type" := Preference."Chart Type"::Column;
        Preference."Chart Data Type" := Preference."Chart Data Type"::"Planned Quantity";
        Preference."Combined Chart" := false;

        Preference.Simulated := true;
        Preference.Planned := true;
        Preference."Firm Planned" := true;
        Preference.Released := true;
        Preference.Finished := true;

        Preference."Visible Foundry" := true;
        Preference."Visible All Presses" := true;
        Preference."Visible Press 1" := true;
        Preference."Visible Press 2" := true;
        Preference."Visible Press 3" := true;
        Preference."Visible Press 4" := true;
        Preference."Visible Press 5" := true;
        Preference."Visible Press 6" := true;
        Preference."Visible Press 7" := true;
        Preference."Visible Press 8" := true;

        Preference."Visible Processing" := true;
        Preference."Visible Coating 1" := true;
        Preference."Visible Coating 2" := true;
        Preference."Visible Lathe 1" := true;
        Preference."Visible Lathe 2" := true;
        Preference."Visible Lathe 3" := true;
        Preference."Visible Polishing" := true;
        Preference."Visible Scrubbing" := true;

        Preference."Visible Packaging" := true;
        Preference."Visible Packaging Chart" := true;
        Preference."Visible Installing Handle" := true;
        Preference."Visible Riveting" := true;
    end;

    local procedure ApplyIdentity(var Preference: Record "Prod. Dashboard User Pref.")
    begin
        Preference."User Security ID" := UserSecurityId();
        Preference."Company Name" := CopyStr(CompanyName, 1, MaxStrLen(Preference."Company Name"));
        Preference."Page ID" := Page::ProdControllingDashboard;
        Preference."User ID" := CopyStr(Database.UserId, 1, MaxStrLen(Preference."User ID"));
    end;

    local procedure ValidatePreference(Preference: Record "Prod. Dashboard User Pref.")
    var
        EmptyGuid: Guid;
    begin
        Clear(EmptyGuid);
        if Preference."User Security ID" = EmptyGuid then
            Error('The production dashboard preference cannot be saved because the user security ID is empty.');

        if Preference."Company Name" = '' then
            Error('The production dashboard preference cannot be saved because the company name is empty.');

        if Preference."Page ID" = 0 then
            Error('The production dashboard preference cannot be saved because the page ID is empty.');

        if Preference."Period Length" <= 0 then
            Error('The production dashboard period length must be greater than zero. Current value: %1.', Preference."Period Length");

        if Preference."Date Filter" = '' then
            Error('The production dashboard date filter must not be empty.');

        if not (Preference.Simulated or Preference.Planned or Preference."Firm Planned" or Preference.Released or Preference.Finished) then
            Error('The production dashboard must have at least one production order status selected.');
    end;
}
