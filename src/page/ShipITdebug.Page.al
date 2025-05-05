//SHIPITREMOVE
/*

page 50051 "ShipITdebug"
{
    /// <summary>
    /// Page ShipITdebug (ID 50029).
    /// </summary>
    ///
    /// <remarks>
    ///
    /// 2023.04.04                  Jesper Harder           021     Shows debuginfo for inconsistent Sales Lines and Transport Order Lines
    ///
    /// </remarks>
    /// 

    AdditionalSearchTerms = 'Scanpan';
    Caption = 'ShipIT Debug';
    Editable = false;
    PageType = List;
    Permissions =
        tabledata "IDYS Transport Order Line" = RM,
        tabledata "Sales Line" = R;
    SourceTable = "Sales Line";
    //SourceTableTemporary = true;
    SourceTableView = where("IDYS Quantity Sent" = filter('>0')
                            , "Quantity Shipped" = filter(0)
                            );
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite;

    layout
    {
        area(Content)
        {
            repeater(SaleLinesShipIT)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the quantity of the sales order line.';
                }
                field("IDYS Quantity Sent"; Rec."IDYS Quantity Sent")
                {
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies the quantity that has been sent.';
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    BlankNumbers = BlankZero;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
                }
                field(ShippedDif; ShippedDif)
                {
                    BlankNumbers = BlankZero;
                    Caption = 'ShipIT Qty sent not Shipped';
                    ToolTip = 'Specifies the value of the ShipIT Qty sent not Shipped field.';
                }
                field(TransportOrderNo; TransportOrderNo)
                {
                    Caption = 'Transport Order No.';
                    Style = Unfavorable;
                    StyleExpr = DiffDetected;
                    ToolTip = 'Specifies the value of the Transport Order No. field.';
                }
                field(DiffDetected; DiffDetected)
                {
                    Caption = 'Error detected';
                    Style = Unfavorable;
                    StyleExpr = DiffDetected;
                    ToolTip = 'Specifies the value of the Error detected field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ClearErrors)
            {
                Caption = 'Clear ShipIT errors';
                Image = Delete;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Clears ShipIT errors.';
                //PromotedCategory = Category9;

                trigger OnAction()
                begin
                    //Message(TransportOrderNo);
                    FixIDYSTransportOrderLine(TransportOrderNo);
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        IDYSTransportOrderLine: record "IDYS Transport Order Line";

        DiffDetected: Boolean;
        ShippedDif: Decimal;
        TransportOrderNo: Text[30];

    trigger OnAfterGetRecord()
    var
    begin
        ShippedDif := Rec."IDYS Quantity Sent" - Rec."Quantity Shipped";
        if ShippedDif < 0 then ShippedDif := 0;
        DiffDetected := ShippedDif <> 0;
        //IDYSTransportOrderLine.SetFilter("Source Document Type", '%1', IDYSTransportOrderLine."Source Document Type"::"0");
        IDYSTransportOrderLine.SetFilter("Source Document Table No.", '36');
        IDYSTransportOrderLine.SetFilter("Source Document No.", Rec."Document No.");
        IDYSTransportOrderLine.SetFilter("Source Document Line No.", Format(Rec."Line No."));
        IDYSTransportOrderLine.SetFilter("Item No.", Rec."No.");
        TransportOrderNo := '';
        if IDYSTransportOrderLine.FindFirst() then TransportOrderNo := IDYSTransportOrderLine."Transport Order No.";
    end;

    local procedure FixIDYSTransportOrderLine(MyTransportorderNo: Text[30])
    var
        MyIDYSTransportOrderLine: Record "IDYS Transport Order Line";
        ConfirmLbl: Label 'There was found %1 saleslines. Do you want to proceed?', Comment = '%1 = Indicates number of found lines.'; //, Locked = true;
        text000Lbl: Label 'Abort';
    begin
        MyIDYSTransportOrderLine.SetRange("Transport Order No.", MyTransportorderNo);
        if not Confirm(StrSubstNo(ConfirmLbl, MyIDYSTransportOrderLine.Count), false) then
            Error(text000Lbl);
        MyIDYSTransportOrderLine.ModifyAll("Source Document Line No.", 0);
    end;
}
*/