




/// <summary>
/// PageExtension TransferOrderSubformExtSC (ID 50044) extends Record Transfer Order Subform.
/// </summary>
pageextension 50044 "TransferOrderSubformExtSC" extends "Transfer Order Subform"
{
    layout
    {
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Qty. to Ship")
        moveafter("Qty. to Ship"; "Quantity Shipped")
        moveafter("Quantity Shipped"; "Container ID NOTO")
        moveafter("Container ID NOTO"; "Qty. to Receive")
        moveafter("Qty. to Receive"; "Quantity Received")
        moveafter("Quantity Received"; "Shipment Date")
        moveafter("Shipment Date"; "Receipt Date")
        moveafter("Receipt Date"; "Container No.")
        moveafter("Container No."; "Bill of Lading No. NOTO")


    }
}