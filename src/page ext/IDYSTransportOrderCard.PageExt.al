
//SHIPITREMOVE

/// <summary>
/// PageExtension IDYSTransportOrderCard (ID 50073) extends Record IDYS Transport Order Card.
/// </summary>

/*
pageextension 50073 "IDYSTransportOrderCard" extends "IDYS Transport Order Card"
{


    actions
    {
        addafter(Archive)
        {
            action(UpdateTransportOrderIDs)
            {
                Image = UpdateShipment;
                Caption = 'WriteBack Order No., To Shipment';
                ToolTip = 'Writes back Transport Order No., to Sales Shipment and Warehouse Shipment documents.';
                trigger OnAction()
                var
                    PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
                    PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
                    DocumentNo: text[9];
                begin
                    DocumentNo := CopyStr(Rec.Description, StrLen(Rec.Description) - 7, 8);
                    PostedWhseShipmentLine.Reset();
                    PostedWhseShipmentLine.SetFilter("Whse. Shipment No.", DocumentNo);
                    if PostedWhseShipmentLine.FindSet() then begin
                        PostedWhseShipmentLine.ModifyAll("Transport Order No.", Rec."No.", false);
                        PostedWhseShipmentHeader.Get(PostedWhseShipmentLine."No.");
                        PostedWhseShipmentHeader."Transport Order No." := Rec."No.";
                        PostedWhseShipmentHeader.Modify();
                    end;
                end;
            }
        }
    }


}
*/