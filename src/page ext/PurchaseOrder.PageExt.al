/// <summary>
/// PageExtension DSV Purchase Order (ID 50087) extends Record Purchase Order.
/// </summary>
/// ///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>

pageextension 50087 "PurchaseOrder" extends "Purchase Order"
{
    layout
    {
        addlast(content)
        {
            group(DSV)
            {
                Caption = 'DSV';

                field(TransportMode; rec.TransportMode)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the TransportMode field.';
                }
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            group(DsvActions)
            {
                Caption = 'DSV API';
                Image = Interaction;

                action("DSVCreateOrder")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DSV Create Order (Ctrl+Shift+D)';
                    Image = ExportShipment;
                    ShortcutKey = 'Ctrl+Shift+D';
                    ToolTip = 'Send and create the current Purchase Order in DSV API.';
                    trigger OnAction()
                    var
                    begin
                        DSVAPI.DSVCreateOrder(0, Rec."No.", false);
                    end;
                }
                action("DSVCancelOrder")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DSV Cancel Order';
                    Image = ExportShipment;
                    ToolTip = 'Cancel the current Purchase Order in DSV API.';
                    trigger OnAction()
                    var
                    begin
                        DSVAPI.DSVCreateOrder(0, Rec."No.", true);
                    end;
                }

                action("DSVGetOrderStatus")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DSV Get Status';
                    Image = GetOrder;
                    ToolTip = 'Get Current orderstatus from DSV.';
                    trigger OnAction()
                    var
                    begin
                        DSVAPI.DSVGetOrder(1, Rec."No.");
                    end;
                }
            }
        }
    }
    var
        DSVAPI: Codeunit DSVAPI;
}