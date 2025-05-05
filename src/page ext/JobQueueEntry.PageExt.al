pageextension 50092 "JobQueueEntry" extends "Job Queue Entries"
{
    /// <summary>
    /// 2023.10 - Jesper Harder - Initial version - Adds functionality to reset failed jobs to "Ready" status.
    /// 2023.10            Jesper Harder        054         JobQueue Set failed to ready
    /// 
    /// PageExtension JobQueueEntry (ID 50092) extends Record "Job Queue Entries".
    /// This page extension adds custom actions and views to manage job queue entries, 
    /// with a focus on handling jobs that have failed and setting them back to a "Ready" state.
    /// Additionally, custom filters are added to create specific views that categorize jobs 
    /// based on their status, scheduling, and other attributes.
    /// </summary>

    actions
    {
        addfirst(processing)
        {

            group(scanpan)
            {
                Caption = 'Scanpan'; // A custom action group named 'Scanpan' added to the "Processing" section
                action(FailedJob)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set all Failed to Ready'; // Action caption shown to the user
                    Image = ChangeStatus; // Icon representing the action
                    Promoted = true;
                    PromotedCategory = Process; // Sets the action to be promoted in the Process group
                    ToolTip = 'All failed is set to Ready and Run JobQueue once is executed.'; // Tooltip for the action
                    trigger OnAction()
                    var
                    begin
                        // Calls the procedure that resets failed jobs to 'Ready' status
                        SetFailedToReady();
                    end;
                }


                // This action is commented out for future use
                /*
                action(RestartJob)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Restart all InterCompany'; // Caption for restarting all InterCompany jobs
                    ToolTip = 'Restarts all Inter Company.'; // Tooltip explaining the action
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                    begin
                        RestartIIC(); // Calls the RestartIIC procedure (currently commented out)
                    end;
                }
                */

            }
        }
    }

    views
    {
        addfirst
        {
            // Adds multiple views to the page, each with its own filter criteria
            view(LTSView)
            {
                Caption = 'LTS'; // A view to filter jobs with a specific Object ID to Run
                //--OrderBy = Descending("No."); // Order by job number (commented out)
                Filters = where("Object ID to Run" = filter('50005'));
            }
            view(IICView)
            {
                Caption = 'IIC'; // Filters jobs with captions containing 'IIC'
                //--OrderBy = Descending("No.");
                Filters = where("Object Caption to Run" = filter('*IIC*'));
            }
            view(NotScheduledView)
            {
                Caption = 'Not Scheduled'; // Shows jobs that are not scheduled
                //--OrderBy = Descending("No.");
                Filters = where(Scheduled = filter(false));
            }
            view(NotScheduledButRecurringJobView)
            {
                Caption = 'Not Scheduled but Recurring Job'; // Filters jobs that are recurring but not scheduled
                //--OrderBy = Descending("No.");
                Filters = where(Scheduled = filter(false),
                                "Recurring Job" = filter(true));
            }
            view(ErrorAndRunningStatusView)
            {
                Caption = 'Error and Running Job'; // Filters jobs that are either in 'Error' or 'In Process' status
                //--OrderBy = Descending("No.");
                Filters = where(Status = filter('Error|In Process'));
            }
        }
    }

    // Local procedure to set failed jobs to 'Ready' status
    local procedure SetFailedToReady()
    var
        JobQueueEntry: Record "Job Queue Entry"; // Record variable for accessing Job Queue Entries
        JobQueueManagement: Codeunit "Job Queue Management"; // Codeunit variable to manage job queue entries
    begin

        // Filtering jobs that are either in 'Error' or 'Ready' status, unscheduled, and recurring
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Error, JobQueueEntry.Status::Ready);
        JobQueueEntry.SetRange(Scheduled, false);
        JobQueueEntry.SetRange("Recurring Job", true);

        if JobQueueEntry.FindSet() then
            repeat
                RestartJobQueue(JobQueueEntry.ID);
            // Runs each job once using the JobQueueManagement Codeunit
            // Warning wil require user to accept for each job beeing run
            //JobQueueManagement.RunJobQueueEntryOnce(JobQueueEntry);
            until JobQueueEntry.Next() = 0;
    end;



    procedure RestartJobQueue(JobQueueEntryId: Code[38])
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntry.Get(JobQueueEntryId) then begin
            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
            JobQueueEntry.Modify();
            Commit(); // Ensures changes are saved before re-enabling
            JobQueueEntry.Status := JobQueueEntry.Status::Ready;
            JobQueueEntry.Modify();
            Commit();
        end;
    end;


}
