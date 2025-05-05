



/// <summary>
/// Page Scanpan API Setup (ID 50008).
/// </summary>
///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>
page 50008 "Scanpan API Setup"
{


    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'Scanpan API Setup';
    PageType = List;
    SourceTable = "Scanpan API Setup";
    UsageCategory = Lists;
    Permissions =
        tabledata "Scanpan API Setup" = RIMD;

    layout
    {

        area(Content)
        {
            repeater("Control1")
            {

                field(LineNo; Rec.LineNo)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Profile Name"; Rec."Profile Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Profile Name field.';
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Request Type field.';
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the URL field.';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Password field.';
                }
                field("Subscription key"; Rec."Subscription key")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Subscription key field.';
                }
            }

        }

    }

}