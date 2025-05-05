


codeunit 50033 RestartAllJobQueue
{
    trigger OnRun()
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        ScanpanMiscellaneous.RestartJobQueue();
    end;
}