
/// <summary>
/// PageExtension SalesInvoiceSubformExtSC (ID 50017) extends Record Sales Invoice Subform.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50017 "SalesInvoiceSubformExtSC" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Type") { Visible = true; QuickEntry = false; }
        modify("No.") { Visible = true; QuickEntry = true; }
        modify(Description) { Visible = true; QuickEntry = false; }
        modify(Quantity) { Visible = true; QuickEntry = true; }

        modify("Next Amount Per Unit") { Visible = true; QuickEntry = false; }
        modify("Unit Price") { Visible = true; QuickEntry = false; }
        modify("Unit Price minus discount") { Visible = true; QuickEntry = false; }
        modify("Location Code") { Visible = true; QuickEntry = false; }
        modify("Bin Code") { Visible = true; QuickEntry = false; }
        modify("Unit of Measure Code") { Visible = true; QuickEntry = false; }
        modify("Line Discount %") { QuickEntry = false; }
        modify("Line Amount") { QuickEntry = false; }

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

        moveafter(Type; "No.")
        moveafter("No."; Description)
        moveafter(Description; Quantity)
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Unit Price")
        moveafter("Unit Price"; "Unit Price minus discount")
        moveafter("Unit Price minus discount"; "Line Amount")
        moveafter("Line Amount"; "Location Code")
        moveafter("Location Code"; "Bin Code")

        addafter(ShortcutDimCode5)
        {
            field("Gross Weight68964"; Rec."Gross Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gross Weight field.';
            }
            field("Net Weight92763"; Rec."Net Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Weight field.';
            }
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tariff No. field.';
            }
        }

        addafter("Line Discount %")
        {
            field("Transport Order No.48137"; Rec."Transport Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Order No. field.';
            }
        }
    }
}