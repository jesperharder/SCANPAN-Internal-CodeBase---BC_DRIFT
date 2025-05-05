page 50041 ScanpanCardPart
{
    /// <summary>
    /// Page object 50041 ScanpanCardPart.
    /// This page serves as a CardPart that contains job queue information and intercompany document status for
    /// Scanpan's companies in different regions (e.g., Denmark, Norway, and a master company).
    /// The page displays job queue failures, intercompany purchase/sales document buffers, and pending synchronization entries.
    /// </summary>


    // Additional search terms used for finding the page.
    AdditionalSearchTerms = 'Scanpan Pagepart';

    // Caption displayed for the page part.
    Caption = 'Scanpan CardPart';

    // Define the type of page as a CardPart.
    PageType = CardPart;

    // Refresh the page when it is activated.
    RefreshOnActivate = true;

    layout
    {
        // The content area layout for displaying different groups of data.
        area(Content)
        {
            // Cue group for displaying job queue data.
            cuegroup(jobque)
            {
                Caption = 'Job Queue';

                // Field for displaying failed job queue count in Denmark.
                field(JobqueFailedCountDK; JobqueueFailedCountDK)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Failed JobQueue DK';
                    StyleExpr = JobqueueStyleDK;
                    ToolTip = 'Shows the number of failed jobs in JobQueue.';

                    // Trigger to handle the drill-down action on the field.
                    trigger OnDrillDown()
                    var
                        JobQueueEntry: Record "Job Queue Entry";
                    begin
                        // Check if the company is "SCANPAN DANMARK" before proceeding.
                        if CompanyName.ToUpper() <> 'SCANPAN DANMARK' then error(ChangeCompanyErrorLbl);

                        // Set filters on job queue entries to only include non-recurring and unscheduled jobs with specific statuses.
                        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
                        JobQueueEntry.SetFilter(Scheduled, '%1', false);
                        JobQueueEntry.SetFilter(Status, '%1|%2|%3', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error, JobQueueEntry.Status::"On Hold");

                        // Open the page to display the job queue entries.
                        Page.Run(Page::"Job Queue Entries", JobQueueEntry);
                    end;
                }

                // Field for displaying failed job queue count in Norway.
                field(JobqueFailedCountNO; JobqueueFailedCountNO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Failed JobQueue NO';
                    StyleExpr = JobqueueStyleNO;
                    ToolTip = 'Shows the number of failed jobs in JobQueue.';

                    // Trigger to handle the drill-down action on the field.
                    trigger OnDrillDown()
                    var
                        JobQueueEntry: Record "Job Queue Entry";
                    begin
                        // Check if the company is "SCANPAN NORGE" before proceeding.
                        if CompanyName.ToUpper() <> 'SCANPAN NORGE' then error(ChangeCompanyErrorLbl);

                        // Set filters on job queue entries to only include non-recurring and unscheduled jobs with specific statuses.
                        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
                        JobQueueEntry.SetFilter(Scheduled, '%1', false);
                        JobQueueEntry.SetFilter(Status, '%1|%2|%3', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error, JobQueueEntry.Status::"On Hold");

                        // Open the page to display the job queue entries.
                        Page.Run(Page::"Job Queue Entries", JobQueueEntry);
                    end;
                }

                // Field for displaying failed job queue count in the master company.
                field(JobqueFailedCountMA; JobqueueFailedCountMA)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Failed JobQueue Master';
                    StyleExpr = JobqueueStyleMA;
                    ToolTip = 'Shows the number of failed jobs in JobQueue.';

                    // Trigger to handle the drill-down action on the field.
                    trigger OnDrillDown()
                    var
                        JobQueueEntry: Record "Job Queue Entry";
                    begin
                        // Check if the company is "_MASTER" before proceeding.
                        if CompanyName.ToUpper() <> '_MASTER' then error(ChangeCompanyErrorLbl);

                        // Set filters on job queue entries to only include non-recurring and unscheduled jobs with specific statuses.
                        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
                        JobQueueEntry.SetFilter(Scheduled, '%1', false);
                        JobQueueEntry.SetFilter(Status, '%1|%2|%3', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error, JobQueueEntry.Status::"On Hold");

                        // Open the page to display the job queue entries.
                        Page.Run(Page::"Job Queue Entries", JobQueueEntry);
                    end;
                }
            }

            // Cue group for displaying intercompany document buffer information.
            cuegroup(intercompany)
            {
                Caption = 'InterCompany';

                // Field for displaying Danish purchase buffer document count.
                field(PurchaseCountDK; PurchaseDocCountDK)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DK IIC Purchase Buffer';
                    StyleExpr = PurchaseStyleDK;
                    ToolTip = 'Shows the number of Danish Purchase Buffer documents, not processed.';

                    // Trigger to handle the drill-down action on the field.
                    trigger OnDrillDown()
                    var
                        IICBuffer: Page "ITI IIC Purch. Buf. Doc. List";
                    begin
                        if CompanyName.ToUpper() <> 'SCANPAN DANMARK' then error(ChangeCompanyErrorLbl);
                        IICBuffer.Run();
                    end;
                }

                // Field for displaying Danish sales buffer document count.
                field(SalesCountDK; SalesDocCountDK)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DK IIC Sales Buffer';
                    StyleExpr = SalesStyleDK;
                    ToolTip = 'Shows the number of Danish Sales Buffer documents, not processed.';

                    trigger OnDrillDown()
                    var
                        IICBuffer: Page "ITI IIC S. Buffer Doc. List";
                    begin
                        if CompanyName.ToUpper() <> 'SCANPAN DANMARK' then error(ChangeCompanyErrorLbl);
                        IICBuffer.Run();
                    end;
                }

                // Field for displaying Norwegian purchase buffer document count.
                field(PurchaseCountNO; PurchaseDocCountNO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'NO IIC Purchase Buffer';
                    StyleExpr = PurchaseStyleNO;
                    ToolTip = 'Shows the number of Norwegian Purchase Buffer documents, not processed.';

                    trigger OnDrillDown()
                    var
                        IICBuffer: Page "ITI IIC Purch. Buf. Doc. List";
                    begin
                        if CompanyName.ToUpper() <> 'SCANPAN NORGE' then error(ChangeCompanyErrorLbl);
                        IICBuffer.Run();
                    end;
                }

                // Field for displaying Norwegian sales buffer document count.
                field(SalesCountNO; SalesDocCountNO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'NO IIC Sales Buffer';
                    StyleExpr = SalesStyleNO;
                    ToolTip = 'Shows the number of Norwegian Sales Buffer documents, not processed.';

                    trigger OnDrillDown()
                    var
                        IICBuffer: Page "ITI IIC S. Buffer Doc. List";
                    begin
                        if CompanyName.ToUpper() <> 'SCANPAN NORGE' then error(ChangeCompanyErrorLbl);
                        IICBuffer.Run();
                    end;
                }
            }

            // Cue group for displaying master data synchronization status.
            cuegroup(MasterData)
            {
                Caption = 'MasterData';

                // Field for displaying pending synchronization entries count.
                field(ITINumberOfPendingSyncEntries; ITINumberOfPendingSyncEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sync. entries';
                    ToolTip = 'Displays the number of pending sync. entries.';
                    StyleExpr = ITIStylePendingSyncEntries;

                    trigger OnDrillDown()
                    var
                        ITIReplicationHeader: Record "ITI Replication Header";
                    begin
                        if CompanyName.ToUpper() <> '_MASTER' then error(ChangeCompanyErrorLbl);
                        ITIReplicationHeader.SetFilter("No. of Pending Sync. Entries", '<>0');
                        Page.Run(Page::"ITI Replication List", ITIReplicationHeader);
                    end;
                }
            }
        }
    }

    // Variable definitions for handling job queue failures, document buffer counts, and styles.
    var
        JobqueueFailedCountDK: Integer;
        JobqueueStyleDK: Text;
        JobqueueFailedCountNO: Integer;
        JobqueueStyleNO: Text;
        JobqueueFailedCountMA: Integer;
        JobqueueStyleMA: Text;
        PurchaseDocCountDK: Integer;
        PurchaseDocCountNO: Integer;
        SalesDocCountDK: Integer;
        SalesDocCountNO: Integer;
        ChangeCompanyErrorLbl: Label 'Please change company first.';
        PurchaseStyleDK: Text;
        PurchaseStyleNO: Text;
        SalesStyleDK: Text;
        SalesStyleNO: Text;
        ITINumberOfPendingSyncEntries: Integer;
        ITIStylePendingSyncEntries: Text;


    /*
        trigger OnOpenPage()
        var
            ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        begin
            ScanpanMiscellaneous.RestartJobQueue();
        end;
    */


    // Trigger to execute when the current record is retrieved.
    trigger OnAfterGetCurrRecord()
    begin
        // Initialize styles to empty strings.
        SalesStyleDK := '';
        SalesStyleNo := '';
        PurchaseStyleDK := '';
        PurchaseStyleNO := '';
        JobqueueStyleDK := '';
        JobqueueStyleNO := '';
        JobqueueStyleMA := '';
        ITIStylePendingSyncEntries := '';

        // Refresh buffers and job queue data.
        PurchaseHeaderBuffer();
        SalesHeaderBuffer();
        JobQueueDK();
        JobQueueNO();
        JobQueueMA();
        ITINumberOfSyncEntries();
    end;

    // Local procedure to calculate job queue data for Denmark.
    local procedure JobQueueDK()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset();
        JobQueueEntry.ChangeCompany('SCANPAN Danmark');
        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
        JobQueueEntry.SetFilter(Scheduled, '%1', false);
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error);
        JobqueueFailedCountDK := JobQueueEntry.Count;

        if JobqueueFailedCountDK <> 0 then
            JobqueueStyleDK := 'Unfavorable';

        // Filter further for IIC related entries.
        JobQueueEntry.SetFilter(Status, '%1|%2|%3', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error, JobQueueEntry.Status::"On Hold");
        JobQueueEntry.SetFilter("Object Caption to Run", '*IIC*');
        JobqueueFailedCountDK += JobQueueEntry.Count;

        if JobqueueFailedCountDK <> 0 then
            JobqueueStyleDK := 'Unfavorable';
    end;

    // Local procedure to calculate job queue data for Norway.
    local procedure JobQueueNO()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset();
        JobQueueEntry.ChangeCompany('SCANPAN Norge');
        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
        JobQueueEntry.SetFilter(Scheduled, '%1', false);
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error);
        JobqueueFailedCountNO := JobQueueEntry.Count;

        if JobqueueFailedCountNO <> 0 then
            JobqueueStyleNO := 'Unfavorable';

        // Filter further for IIC related entries.
        JobQueueEntry.SetFilter(Status, '%1|%2|%3', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error, JobQueueEntry.Status::"On Hold");
        JobQueueEntry.SetFilter("Object Caption to Run", '*IIC*');
        JobqueueFailedCountNO += JobQueueEntry.Count;

        if JobqueueFailedCountNO <> 0 then
            JobqueueStyleNO := 'Unfavorable';
    end;

    // Local procedure to calculate job queue data for the master company.
    local procedure JobQueueMA()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.ChangeCompany('_Master');
        JobQueueEntry.SetFilter("Recurring Job", '%1', true);
        JobQueueEntry.SetFilter(Scheduled, '%1', false);
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Ready, JobQueueEntry.Status::Error);
        JobqueueFailedCountDK := JobQueueEntry.Count;

        if JobqueueFailedCountDK <> 0 then
            JobqueueStyleMA := 'Unfavorable';
    end;

    // Local procedure to calculate purchase header buffer counts.
    local procedure PurchaseHeaderBuffer()
    var
        ITIIICPurchaseHeaderBuffer: Record "ITI IIC Purchase Header Buffer";
        InvoiceCountNO: Integer;
    begin
        ITIIICPurchaseHeaderBuffer.ChangeCompany('SCANPAN Danmark');
        ITIIICPurchaseHeaderBuffer.Reset();
        PurchaseDocCountDK := ITIIICPurchaseHeaderBuffer.Count;

        if PurchaseDocCountDK <> 0 then
            PurchaseStyleDK := 'Unfavorable';

        // For Norway.
        ITIIICPurchaseHeaderBuffer.ChangeCompany('SCANPAN Norge');
        ITIIICPurchaseHeaderBuffer.Reset();
        PurchaseDocCountNO := ITIIICPurchaseHeaderBuffer.Count;

        if PurchaseDocCountNO <> 0 then
            PurchaseStyleNO := 'Unfavorable';

        // Check for invoices.
        ITIIICPurchaseHeaderBuffer.SetFilter("Document Type", '%1', ITIIICPurchaseHeaderBuffer."Document Type"::Invoice);
        InvoiceCountNO := ITIIICPurchaseHeaderBuffer.Count;

        if InvoiceCountNO <> 0 then begin
            PurchaseDocCountNO := InvoiceCountNO;
            PurchaseStyleNO := 'Favorable';
        end;
    end;

    // Local procedure to calculate sales header buffer counts.
    local procedure SalesHeaderBuffer()
    var
        ITIIICSalesHeaderBuffer: Record "ITI IIC Sales Header Buffer";
    begin
        ITIIICSalesHeaderBuffer.ChangeCompany('SCANPAN Danmark');
        ITIIICSalesHeaderBuffer.Reset();
        SalesDocCountDK := ITIIICSalesHeaderBuffer.Count;

        if SalesDocCountDK <> 0 then
            SalesStyleDK := 'Unfavorable';

        ITIIICSalesHeaderBuffer.ChangeCompany('SCANPAN Norge');
        ITIIICSalesHeaderBuffer.Reset();
        SalesDocCountNO := ITIIICSalesHeaderBuffer.Count;

        if SalesDocCountNO <> 0 then
            SalesStyleNO := 'Unfavorable';
    end;

    // Local procedure to calculate the number of pending sync entries.
    local procedure ITINumberOfSyncEntries()
    var
        ITIRecordSyncEntry: Record "ITI Record Sync Entry";
        ITIReplicationHeader: Record "ITI Replication Header";
    begin
        ITIStylePendingSyncEntries := '';
        ITIReplicationHeader.Reset();
        ITIReplicationHeader.ChangeCompany('_Master');
        ITIReplicationHeader.SetFilter("Has Error", '%1', true);

        if not ITIReplicationHeader.IsEmpty then begin
            ITINumberOfPendingSyncEntries := 1;
            ITIStylePendingSyncEntries := 'Unfavorable';
        end else begin
            ITIReplicationHeader.Reset();
            ITIRecordSyncEntry.Reset();
        end;
    end;
}
