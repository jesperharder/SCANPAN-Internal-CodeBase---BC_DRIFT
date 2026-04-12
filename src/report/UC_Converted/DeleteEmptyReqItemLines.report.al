#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
report 50021 "DeleteEmptyReqItemLines"
{
    /// <summary>
    /// Processing-only report that deletes requisition worksheet lines where Type = Item and No. is blank.
    /// </summary>
    /// <remarks>
    /// 2025.02             AI Assistant                 Delete empty requisition worksheet item lines via report
    /// </remarks>

    Caption = 'Delete Empty Requisition Item Lines';
    AdditionalSearchTerms = 'Scanpan,Requisition,Worksheet,Delete,Empty';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = Planning;

    dataset
    {
        dataitem(ReqLine; "Requisition Line")
        {
            DataItemTableView =
                SORTING("Worksheet Template Name", "Journal Batch Name", Type, "No.")
                ORDER(Ascending)
                WHERE(Type = CONST(Item), "No." = CONST(''));
            RequestFilterFields = "Worksheet Template Name", "Journal Batch Name";

            trigger OnPreDataItem()
            begin
                ReqLine.LockTable();
            end;

            trigger OnAfterGetRecord()
            begin
                ReqLine.Delete(true);
                DeletedCount += 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Information)
                {
                    Caption = 'Information';
                    field(Instructions; InstructionText)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Instructions';
                        Editable = false;
                        MultiLine = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            InstructionText := InstructionLbl;
        end;
    }

    trigger OnPreReport()
    begin
        TemplateFilterTxt := ReqLine.GetFilter("Worksheet Template Name");
        BatchFilterTxt := ReqLine.GetFilter("Journal Batch Name");

        if TemplateFilterTxt = '' then
            Error(TemplateFilterRequiredLbl);

        if BatchFilterTxt = '' then
            Error(BatchFilterRequiredLbl);

        if GuiAllowed then
            if not Confirm(ConfirmDeleteLbl, false, TemplateFilterTxt, BatchFilterTxt) then begin
                UserCancelled := true;
                CurrReport.Break();
            end;
    end;

    trigger OnPostReport()
    begin
        if UserCancelled then
            exit;

        if DeletedCount = 0 then begin
            if GuiAllowed then
                Message(NothingDeletedLbl);
        end else begin
            if GuiAllowed then
                Message(DeletedCountMsgLbl, DeletedCount);
        end;
    end;

    var
        DeletedCount: Integer;
        TemplateFilterTxt: Text;
        BatchFilterTxt: Text;
        UserCancelled: Boolean;
        InstructionText: Text[250];
        InstructionLbl: Label 'This report deletes requisition worksheet lines where the Type is Item and the No. field is blank. Set Worksheet Template Name and Journal Batch Name filters before you run it.';
        ConfirmDeleteLbl: Label 'Do you want to delete requisition worksheet lines with Type Item and blank No.?\\Template: %1\\Batch: %2';
        NothingDeletedLbl: Label 'No requisition worksheet lines with Type Item and blank No. were found for the specified filters.';
        DeletedCountMsgLbl: Label '%1 requisition worksheet line(s) were deleted.';
        TemplateFilterRequiredLbl: Label 'Set a filter on Worksheet Template Name before running the report.';
        BatchFilterRequiredLbl: Label 'Set a filter on Journal Batch Name before running the report.';
}