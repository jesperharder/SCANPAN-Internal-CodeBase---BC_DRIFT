
/// <summary>
/// PageExtension SalesOrderSubformExtSC (ID 50013) extends Record Sales Order Subform.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2022.12             Jesper Harder       0193        Added Scanpan Group, added SystemUser created, modified
/// 2023.01             Jesper Harder       0193        Added field for Barcode on sales order line ref. FLowField in TableExt 50002 SCANPAN_SalesLine
/// 
/// </remarks>

pageextension 50013 "SalesOrderSubform" extends "Sales Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedAt1; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Visible = true;
                QuickEntry = false;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.';
            }
            field(CreatedBy2; CreatedBy)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'SystemCreatedBy';
                QuickEntry = false;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.';
            }
            field(SystemModifiedAt1; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Visible = true;
                QuickEntry = false;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.';
            }
            field(ModifiedBy2; ModifiedBy)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'SystemModifiedBy';
                QuickEntry = false;
                ToolTip = 'Specifies the value of the SystemModifiedBy field.';
            }
        }

        addafter("No.") { field("Item Cross-Reference No.1"; "Item Cross-Reference No.") { ApplicationArea = All; ToolTip = 'Specifies the value of the Item Cross-Reference No. field.'; } }


        //Quick Entry
        modify("Type") { Visible = true; QuickEntry = false; }
        modify("No.") { Visible = true; QuickEntry = true; }
        modify(Description) { Visible = true; QuickEntry = false; }
        modify(Quantity) { Visible = true; QuickEntry = true; }
        modify("Drop Shipment") { Visible = true; QuickEntry = false; }

        modify("Item Reference No.") { Visible = true; QuickEntry = false; }
        modify("Next Amount Per Unit") { Visible = true; QuickEntry = false; }
        modify("Unit Price") { Visible = true; QuickEntry = false; }
        modify("Unit Price minus discount") { Visible = true; QuickEntry = false; }
        modify("Location Code") { Visible = true; QuickEntry = false; }
        modify("Bin Code") { Visible = true; QuickEntry = false; }
        modify("Unit of Measure Code") { Visible = true; QuickEntry = false; }
        modify("Used Campaign NOTO") { Visible = true; QuickEntry = false; }
        modify("Yearcode Text") { QuickEntry = false; }
        modify("Line Discount %") { QuickEntry = false; }
        
        //SHIPITREMOVE
        /*
        modify("IDYS Quantity To Send") { QuickEntry = false; }
        modify("IDYS Quantity Sent") { QuickEntry = false; }
        modify("IDYS Tracking No.") { QuickEntry = false; }
        modify("IDYS Tracking URL") { QuickEntry = false; }
        */
        
        modify("Line Amount") { QuickEntry = false; }
        modify("Qty. to Ship") { QuickEntry = false; }
        modify("Qty. to Invoice") { QuickEntry = false; }
        modify("Planned Shipment Date") { QuickEntry = false; }
        modify("Requested Delivery Date") { Visible = true; QuickEntry = false; }
        modify("Purchasing Code") { QuickEntry = false; Visible = true; }
        modify("IC Partner Code") { QuickEntry = false; Visible = true; }
        modify("Priority NOTO") { QuickEntry = false; }

        modify("Return Reason Code") { QuickEntry = false; Visible = true; }

        modify("Qty. to Assemble to Order") { Visible = false; }
        modify("Reserved Quantity") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }

        modify("Shortcut Dimension 1 Code") { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify(ShortcutDimCode5) { Visible = false; }
        modify(ShortcutDimCode6) { Visible = false; }
        modify(ShortcutDimCode7) { Visible = false; }
        modify(ShortcutDimCode8) { Visible = false; }

        modify("TRCUDF1") { Visible = false; }
        modify("TRCUDF2") { Visible = false; }
        modify("TRCUDF3") { Visible = false; }
        modify("TRCUDF4") { Visible = false; }
        modify("TRCUDF5") { Visible = false; }
        modify(TRCPriceException) { Visible = false; }

        modify("ITI IIC Package Tracking No.") { Visible = false; }




        addlast(Control28) { field("Shipping Agent Service Code1"; Rec."Shipping Agent Service Code") { ApplicationArea = All; ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.'; } }
        addlast(Control1) { field("ABCD Category"; Rec."ABCD Category") { ApplicationArea = All; Visible = true; QuickEntry = false; Editable = false; ToolTip = 'Specifies the value of the ABCD Category field.'; } }

        moveafter(Type; "No.")
        moveafter("No."; Description)
        moveafter(Description; Quantity)
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Drop Shipment")
        moveafter("Drop Shipment"; "Next Amount Per Unit")
        moveafter("Next Amount Per Unit"; "Unit Price")
        moveafter("Unit Price"; "Unit Price minus discount")
        moveafter("Unit Price minus discount"; "Line Amount")
        moveafter("Line Amount"; "Location Code")
        moveafter("Location Code"; "Bin Code")

        moveafter("ITI IIC Drop Shipment"; "Purchasing Code")

        movebefore("Quantity Shipped"; "Qty. to Ship")
        moveafter("Line Amount"; "Line Discount %")
        addafter("Quantity Invoiced")
        {
            field("Requested Delivery Date1"; Rec."Requested Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                QuickEntry = false;
            }
        }


        /*
        addlast(Control1)
        {
            field("Prepayment %71433"; Rec."Prepayment %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for sales.';
            }
            field("Prepmt. Line Amount19178"; Rec."Prepmt. Line Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.';
            }
            field("Prepmt. Amt. Inv.36387"; Rec."Prepmt. Amt. Inv.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the prepayment amount that has already been invoiced to the customer for this sales line.';
            }
            field("Prepmt. Amt. Incl. VAT11403"; Rec."Prepmt. Amt. Incl. VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. Amt. Incl. VAT field.';
            }
            field("Prepayment Amount12589"; Rec."Prepayment Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment Amount field.';
            }
            field("Prepmt. VAT Base Amt.83457"; Rec."Prepmt. VAT Base Amt.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. VAT Base Amt. field.';
            }
            field("Prepayment VAT %27715"; Rec."Prepayment VAT %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment VAT % field.';
            }
            field("Prepmt. VAT Calc. Type11122"; Rec."Prepmt. VAT Calc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. VAT Calc. Type field.';
            }
            field("Prepayment VAT Identifier23757"; Rec."Prepayment VAT Identifier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment VAT Identifier field.';
            }
            field("Prepmt Amt to Deduct69522"; Rec."Prepmt Amt to Deduct")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
            }
            field("Prepmt Amt Deducted89994"; Rec."Prepmt Amt Deducted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
            }
            field("Prepayment Line40251"; Rec."Prepayment Line")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment Line field.';
            }
            field("Prepmt. Amount Inv. Incl. VAT35760"; Rec."Prepmt. Amount Inv. Incl. VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. Amount Inv. Incl. VAT field.';
            }
            field("Prepmt. Amount Inv. (LCY)59516"; Rec."Prepmt. Amount Inv. (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. Amount Inv. (LCY) field.';
            }
            field("Prepmt. VAT Amount Inv. (LCY)75527"; Rec."Prepmt. VAT Amount Inv. (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. VAT Amount Inv. (LCY) field.';
            }
        }
        */


    }
    var
        CreatedBy: Text[100];
        ModifiedBy: Text[100];

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CreatedBy := '';
        ModifiedBy := '';
        if User.Get(Rec.SystemCreatedBy) then CreatedBy := User."User Name";
        if User.Get(Rec.SystemModifiedBy) then ModifiedBy := User."User Name";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;

}
