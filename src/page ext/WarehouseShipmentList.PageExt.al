pageextension 50046 "WarehouseShipmentList" extends "Warehouse Shipment List"
{
    /// <summary>
    /// 
    /// This page extension adds additional fields and actions to the Warehouse Shipment List page.
    /// It also modifies the sorting order to display the highest number first.
    /// 
    /// Version History:
    /// 2023.03.08          Jesper Harder       0193        Added Description field.
    /// 2024.10             Jesper Harder       082         Modified list to show highest number first in reverse order.
    /// 2024.10                                             Added to show Shipper information
    /// 2024.12             Jesper Harder       101         Show WaybillHeader Shipping Agent Code on WarehouseShipmentList
    /// </summary>

    layout
    {
        // Add additional fields at the end of the existing controls.
        addafter("Location Code")
        {
            // Adds the Description field to the list.
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies a short description.';
            }
            // Adds the Warehouse Pick No. field to the list.
            field("Warehouse Pick No."; Rec."Warehouse Pick No.")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the warehouse pick number.';
            }

            // 101
            field(WayBillShipAgentCode; Rec.WayBillShipAgentCode)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the Shipping Agent Code on the WayBill.';
            }

            field("Shipping Agent Code1"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the Shipping Agent Code';
            }
            field("Shipping Agent Service Code1"; Rec."Shipping Agent Service Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the Shipping Agent Service Code';
            }
            field("Shipment Method Code1"; Rec."Shipment Method Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the Shipment Method Code';
            }
        }
    }
    actions
    {
        // Add a new action to the Navigation menu.
        addlast(Navigation)
        {
            action(WHSEPickBalance)
            {
                Caption = 'Warehouse Pick Balance List';
                ToolTip = 'Shows bin and shipment balance.';
                Image = Warehouse;
                ApplicationArea = All;
                // Runs the specified page when the action is triggered.
                RunObject = page "WMSPickBinBalance";
            }
        }
    }
    // Trigger to sort the list in descending order by "No." when the page opens.
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
        CurrPage.Update();
    end;
}

