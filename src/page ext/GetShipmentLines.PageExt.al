

pageextension 50076 "GetShipmentLines" extends "Get Shipment Lines"
{
    /// <summary>
    /// PageExtension GetShipmentLines (ID 50076) extends Record Get Shipment Lines.
    /// 2023.07.14          Jesper Harder       035         Post TransportOrderID through
    /// 2024.10             Jesper Harder       092         Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// </summary>

    layout
    {
        addlast(Control1)
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code2")
            {
                ApplicationArea = All;
                ToolTip = 'The Shipping agent used for the transport.';
            }
            field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code2")
            {
                ApplicationArea = All;
                ToolTip = 'The Service Code used with the Shipping Agent.';
            }
            field("Distribution Code"; Rec."Distribution Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the distribution code associated with the shipping agent.';
            }
            field("Distribution Country Code"; Rec."Distribution Country Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the country code related to the shipping agent distribution.';
            }
            field("Distribution Description"; Rec."Distribution Description")
            {
                ApplicationArea = All;
                ToolTip = 'Provides a description of the shipping agent distribution.';
            }
            field("Distribution Range"; Rec."Distribution Range")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the range associated with this distribution entry.';
            }
            field("Posted Sales Ship-to Post Code"; PostedSalesShipToPostCode)
            {
                Caption = 'Ship-To Post Code';
                ToolTip = 'Shows the Post Code the shipment is send to.';
                ApplicationArea = All;

            }
            field("Posted Sales Shipment"; PostedSalesOrderNo)
            {
                Caption = 'Sales Order No.';
                ApplicationArea = All;
                ToolTip = 'Shows the associated Sales Order No.';
            }
        }
    }
    var
        PostedSalesOrderNo: code[20];
        PostedSalesShipToPostCode: Code[40];

    trigger OnAfterGetRecord()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ShippingAgentDistribution: Record "ShippingAgentDistribution";
        StartRange: Integer;
        EndRange: Integer;
        PostCodeInt: Integer;
        SeparatorPos: Integer;
        RangeStartText: Text;
        RangeEndText: Text;
    begin
        // Clear fields initially
        Clear(Rec."Distribution Code");
        Clear(Rec."Distribution Country Code");
        Clear(Rec."Distribution Description");
        Clear(Rec."Distribution Range");

        // Check if Sales Shipment Header exists
        if not SalesShipmentHeader.Get(Rec."Document No.") then
            exit;

        PostedSalesOrderNo := Rec."Order No.";
        PostedSalesShipToPostCode := SalesShipmentHeader."Ship-to Post Code" + SalesShipmentHeader."Ship-to Post Code";

        // Set initial filters on ShippingAgentDistribution based on Shipping Agent Code and Country Code
        ShippingAgentDistribution.SetRange("Shipping Agent Code", SalesShipmentHeader."Shipping Agent Code");
        ShippingAgentDistribution.SetRange("Country Code", SalesShipmentHeader."Ship-to Country/Region Code");

        // Convert Ship-to Post Code to integer for comparison
        if not Evaluate(PostCodeInt, SalesShipmentHeader."Ship-to Post Code") then
            exit;

        // Iterate over ShippingAgentDistribution records with matching Shipping Agent Code and Country Code
        if ShippingAgentDistribution.FindSet() then
            repeat
                // Parse the Range field
                SeparatorPos := StrPos(ShippingAgentDistribution.Range, '..');
                if SeparatorPos > 0 then begin
                    // Extract start and end of the range
                    RangeStartText := CopyStr(ShippingAgentDistribution.Range, 1, SeparatorPos - 1);
                    RangeEndText := CopyStr(ShippingAgentDistribution.Range, SeparatorPos + 2);

                    // Convert start and end range values to integers
                    if Evaluate(StartRange, RangeStartText) and Evaluate(EndRange, RangeEndText) then
                        // Check if PostCodeInt falls within the range
                        if (PostCodeInt >= StartRange) and (PostCodeInt <= EndRange) then begin
                            // Populate fields if a match is found
                            Rec."Distribution Code" := ShippingAgentDistribution.Code;
                            Rec."Distribution Country Code" := ShippingAgentDistribution."Country Code";
                            Rec."Distribution Description" := ShippingAgentDistribution.Description;
                            Rec."Distribution Range" := ShippingAgentDistribution.Range;
                            exit; // Exit after the first match
                        end;
                end;
            until ShippingAgentDistribution.Next() = 0;
    end;
}
