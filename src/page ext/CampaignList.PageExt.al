

pageextension 50016 "CampaignList" extends "Campaign List"
{
    /// <summary>
    /// PageExtension CampaignListExtSC (ID 50016) extends Record Campaign List.
    /// </summary>
    /// 
    /// <remarks>
    /// 
    /// Version list
    /// 2022.12             Jesper Harder       0193        Added modifications
    /// 2025.03             Jesper Harder       108.1       Campaign Comments in Factbox extension
    /// 
    /// </remarks>
    layout
    {
        addafter("Status Code")
        {
            field("Salesperson Code56262"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code of the salesperson responsible for the campaign.';
            }
        }

        // 108.1
        addlast(FactBoxes)
        {
            part(CampaignComments; "CampaignCommentsFactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table Name" = const(Campaign),
                                "No." = field("No.");
            }
        }

    }
}