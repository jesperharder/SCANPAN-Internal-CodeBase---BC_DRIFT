




/// <summary>
/// PageExtension "PurchaseOrderSubformExtSC" (ID 50055) extends Record Purchase Order Subform.
/// </summary>
pageextension 50055 PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        //moveafter(ShortcutDimCode6; "Bin Code")
        moveafter("Line Amount"; "Bin Code")
        moveafter("ITI IIC Package Tracking No."; "Container ID NOTO")
        moveafter("ITI IIC Package Tracking No."; "Bill of Lading No. NOTO")
        moveafter("Expected Receipt Date"; "Reserved Quantity")
        moveafter("Line Amount"; "Indirect Cost %")
        modify("No.") { Width = 5; }
        modify("Transfer Order No. NOTO") { Width = 5; }
        modify("Direct Unit Cost") { Width = 10; }
        modify("Qty. to Invoice") { Width = 6; }
        modify("Quantity Invoiced") { Width = 7; }
        modify("Line Amount") { Width = 9; }
        modify("Shortcut Dimension 1 Code") { Width = 7; }
        modify("Bill of Lading No. NOTO") { Width = 4; }

        moveafter("ITI IIC Production Started"; "Qty. to Assign")
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter(ShortcutDimCode6; "Tax Area Code")
        moveafter(TRCUDF5; "Tax Group Code")
        moveafter("Expected Receipt Date"; "Container ID NOTO")
        moveafter("Qty. to Invoice"; "Transfer Order No. NOTO")

        moveafter("Qty. to Invoice"; "Unit of Measure Code")
        moveafter("Qty. to Invoice"; "Bin Code")
        modify("Qty. to Receive")
        {
            Width = 9;
        }
        modify("Quantity Received")
        {
            Width = 9;
        }
        moveafter("Qty. to Invoice"; "Qty. to Receive")
        modify(Type)
        {
            Width = 11;
        }
        modify("Location Code")
        {
            Width = 6;
        }
        modify(Quantity)
        {
            Width = 5;
        }
        modify("Unit of Measure Code")
        {
            Width = 6;
        }
        moveafter("Line Amount"; ShortcutDimCode6)
        moveafter("Qty. to Receive"; "Planned Receipt Date")
        moveafter("Planned Receipt Date"; "Expected Receipt Date")

        moveafter("Qty. to Invoice"; "Promised Receipt Date")
        moveafter(ShortcutDimCode6; "Qty. to Receive")
        moveafter("Expected Receipt Date"; "Container ID NOTO")


    }
}
