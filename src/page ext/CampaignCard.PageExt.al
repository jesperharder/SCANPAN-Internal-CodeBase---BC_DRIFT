

pageextension 50082 "CampaignCard" extends "Campaign Card"
/// <summary>
/// PageExtension CampaignCard (ID 50082) extends Record Campaign Card.
/// </summary>
///
/// <remarks>
/// 2023.06.12          Jesper Harder       034         Campaign statistics
/// 2025.03             Jesper Harder       108.1       Campaign Comments in Factbox extension
/// </remarks>

{
    layout
    {
        moveafter(Description; "Campaign Purpose NOTO")


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
    //var
    //enm: enum "Comment Line Table Name";

}