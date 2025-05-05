/// <summary>
/// PageExtension SalesLineFactBox (ID 50081) extends Record Sales Line FactBox.
/// </summary>
///
/// <remarks>
///
/// 2023.07.24              Jesper Harder                   039     Factbox Item Availability FUTURE
///
/// </remarks>
pageextension 50081 "SalesLineFactBox" extends "Sales Line FactBox"
{
    layout
    {
        addafter("Item Availability")
        {
            field(ItemAvailabilityTotal; SalesInfoPaneManagement.CalcAvailability(SalesLine2))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Availability future';
                DecimalPlaces = 0 : 5;
                DrillDown = true;
                ToolTip = 'Specifies how may units of the item on the sales line are available, in inventory or incoming.';

                trigger OnDrillDown()
                begin
                    ItemAvailabilityFormsMgt.ShowItemAvailFromSalesLine(SalesLine2, ItemAvailabilityFormsMgt.ByEvent());
                    CurrPage.Update(true);
                end;
            }
            field(ItemCalculatedAvailable; Item."Calculated Available NOTO")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Calculated Available';
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies the value of the Item Calculated Available field.';
            }
            field(ItemCalculatedAvailableDate; Item."Calculated Available Date NOTO")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Calculated Available date';
                ToolTip = 'Specifies the value of the Item Calculated Available date field.';
            }

        }
    }
    var
        Item: Record Item;
        SalesLine2: Record "Sales Line";
        ItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";


    trigger OnAfterGetCurrRecord()
    var
    begin
        SalesLine2.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
        if SalesLine2."Planned Shipment Date" <> 0D then SalesLine2."Planned Shipment Date" := CALCDATE('<+5Y>', SalesLine2."Shipment Date");
        if SalesLine2."Shipment Date" <> 0D then SalesLine2."Shipment Date" := CalcDate('<+5Y>', SalesLine2."Shipment Date");
        if SalesLine2."Planned Delivery Date" <> 0D then SalesLine2."Planned Delivery Date" := CalcDate('<+5Y>', SalesLine2."Planned Delivery Date");
        //Rec2."Requested Delivery Date" := CalcDate('<+1Y>',Rec2."Requested Delivery Date");


        Item."Calculated Available NOTO" := 0;
        Item."Calculated Available Date NOTO" := 0D;
        if Item.Get(Rec."No.") then;

    end;

}