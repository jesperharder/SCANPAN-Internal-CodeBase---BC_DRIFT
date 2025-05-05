


/// <summary>
/// PageExtension CDOE-MailRecipientsExtSC (ID 50038) extends Record CDO E-Mail Recipients.
/// </summary>
pageextension 50038 "CDOEMailRecipientsExtSC" extends "CDO E-Mail Recipients"
{
    actions
    {
        addlast(Navigation)
        {
            group(SCANPAN)
            {
                Caption = 'SCANPAN';
                Image = "List";
                ToolTip = 'Shortcuts SCANPAN';
                action("EditE-MailRecipientsList")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Complete E-Mail Recipients List';
                    Image = Campaign;
                    RunObject = Page "CDOE-MailRecipient";
                    ToolTip = 'See and Edit Complete E-Mail Recipients List';
                }
            }
        }
    }
}
