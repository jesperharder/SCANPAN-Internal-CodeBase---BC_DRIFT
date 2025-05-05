

pageextension 50125 ShippingAgents extends "Shipping Agents"
{
    /// <summary>
    /// 2024.10 Jesper Harder 092 Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// </summary>

    actions
    {
        addafter("&Line") // Place it near the existing navigation actions
        {
            action("Shipping Agent Distribution")
            {
                Caption = 'Shipping Agent Distribution';
                ApplicationArea = All;
                ToolTip = 'View and edit the distribution settings for this shipping agent.';
                Image = ShipAddress;
                RunObject = page "ShipAgentDistribution";
                RunPageLink = "Shipping Agent Code" = field(Code); // Links the record based on "Shipping Agent Code"
            }
        }
    }
}
