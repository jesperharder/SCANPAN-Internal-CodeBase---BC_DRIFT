/// <summary>
/// Page PurchLines_SC (ID 50017).
/// </summary>
///
/// 2023.03             Jesper Harder                   016     Purchase Lines
///
page 50017 "PurchLines"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'SCANPANPurchLines';
    PageType = List;
    SourceTable = "Purchase Line";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    Permissions =
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = R;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Buy-from Vendor Name"; PurchaseHeader."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor Name.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of items that remains to be received.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the received item that has been posted as received but that has not yet been posted as invoiced.';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order Date.';
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Planned Receipt Date.';
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Promiced Receipt Date.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(SCANPAN)
            {
                action(ReceivedNotInvoiced)
                {
                    Image = Action;
                    Caption = 'Received Not Invoiced';
                    ToolTip = 'Toggle Received Not Invoiced.';
                    trigger OnAction()
                    var
                    begin
                        ToggleReceivedNotInvoiced();
                    end;
                }
            }
        }
    }

    var
        PurchaseHeader: Record "Purchase Header";
        ToggleRecvedNotInvoiced: Boolean;

    trigger OnAfterGetRecord()
    var
    begin
        PurchaseHeader.Get(Rec."Document Type", Rec."Document No.")
    end;

    local procedure ToggleReceivedNotInvoiced()
    var
    begin
        ToggleRecvedNotInvoiced := not ToggleRecvedNotInvoiced;
        Rec.SetRange("Qty. Rcd. Not Invoiced");
        if ToggleRecvedNotInvoiced then Rec.SetFilter("Qty. Rcd. Not Invoiced", '<>0');
    end;
}
