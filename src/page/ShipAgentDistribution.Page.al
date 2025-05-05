page 50058 "ShipAgentDistribution"
{
    /// <summary>
    /// 2024.10 Jesper Harder 092 Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// </summary>

    AdditionalSearchTerms = 'Scanpan, Shipping, Distribution, PostCode';
    ApplicationArea = All;
    Caption = 'Shipping Agent Distribution';
    Editable = true;
    PageType = List;
    SourceTable = "ShippingAgentDistribution";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the shipping agent.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the distribution entry.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'Specifies the country code related to this distribution entry.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the distribution entry.';
                }
                field("Range"; Rec.Range)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Range associated with this entry.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewEntry)
            {
                ApplicationArea = All;
                Caption = 'New Distribution Entry';
                ToolTip = 'Creates a new distribution entry for the shipping agent.';
                Image = New;

                trigger OnAction()
                var
                    NewRecord: Record "ShippingAgentDistribution";
                begin
                    NewRecord.Init();
                    if Page.RunModal(0, NewRecord) = Action::OK then begin
                        NewRecord.Insert(true);
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
}
