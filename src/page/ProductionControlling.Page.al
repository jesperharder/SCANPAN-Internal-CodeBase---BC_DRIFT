




page 50013 "ProductionControlling"
{
    /// <summary>
    /// Page SCANPANProductionLines (ID 50013).
    /// 2023.03.13          Jesper Harder                   001 Production Controlling
    /// 2024.10             Jesper Harder                   Code changes for better performance, Bom lookup not using build-in functions
    /// </summary>


    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Production Controlling Lines';
    DeleteAllowed = false;
    //Editable = false;
    PageType = List;
    Permissions =
        tabledata "BOM Buffer" = R,
        tabledata Item = R,
        tabledata "ProdControllingLinesTMP" = RIM,
        tabledata "Transfer Line" = R;
    SourceTable = "ProdControllingLinesTMP";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Selects)
            {
                Caption = 'Settings';

                group(Settings1)
                {
                    ShowCaption = false;

                    field(DateFormulaEndingDate; DateFormulaEndingDate)
                    {
                        Caption = 'Dateformula Ending Date';
                        DecimalPlaces = 0;
                        Editable = true;
                        ToolTip = 'Adjust the days for waringin in Ending Date.';
                        Width = 5;
                    }
                }
                group(Settings2)
                {
                    ShowCaption = false;

                    field(ShowTransferLines; ShowTransferLines)
                    {
                        Caption = 'Show Transfer Lines';
                        Editable = true;
                        ToolTip = 'Toggles calculation of Transfer Lines.';
                    }
                    field(ShowFirmPo; ShowFirmPo)
                    {
                        Caption = 'Show Firm Production Lines';
                        Editable = true;
                        ToolTip = 'Toggles calculation of Firmed Production Order Lines.';
                    }
                    field(ShowReleasedPO; ShowReleasedPO)
                    {
                        Caption = 'Show Released Production Lines';
                        Editable = true;
                        ToolTip = 'Toggles calculation of Released Production Order Lines.';
                    }
                }
            }
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Shows Line numbber.';
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Order Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Unfavorable;
                    StyleExpr = StyleExprEndingDateUnfaborable;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Finished Quantity field.';
                }
                field("Quantity Production Units"; Rec."Quantity Production Units")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity Production Units field.';
                }
                field("Remaining Qty Production Units"; Rec."Remaining Qty Production Units")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Remaining Quantity Production Units field.';
                }
                field("Finished Qty Production Units"; Rec."Finished Qty Production Units")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Favorable;
                    StyleExpr = StyleExprFinishedQtyFavorable;
                    ToolTip = 'Specifies the value of the Finished Quantity Production Units field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Unfavorable;
                    StyleExpr = StyleExprEndingDateUnfaborable;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field("Route Type"; Rec."Route Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Route Type field.';
                }
                field(YearWeek; Rec.YearWeek)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the YearWeek field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Product Line Code"; Rec."Product Line Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Product Line Code field.';
                }
                field("ABCD Category"; Rec."ABCD Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ABCD Category field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
        }
        area(Processing)
        {
            action(GetLines)
            {
                Caption = 'Fetch Lines';
                image = GetLines;
                ToolTip = 'Get transfer and production lines.';
                trigger OnAction()
                begin
                    FillControllingTable();
                end;
            }

            action(EmptyTable)
            {
                Caption = 'Empty Table';
                Image = Table;
                ToolTip = 'Removes all data from this table.';
                trigger OnAction()
                begin
                    Rec.DeleteAll();
                end;
            }
        }
    }

    var
        ShowFirmPo: Boolean;
        ShowReleasedPO: Boolean;
        ShowTransferLines: Boolean;
        StyleExprEndingDateUnfaborable: Boolean;
        StyleExprFinishedQtyFavorable: Boolean;
        DateFormulaEndingDate: Decimal;
        EnumGetBomDetails: enum EnumGetBOMDetails;
        EnumProductionOrderStatus: Enum "EnumProductionOrderStatus";

    trigger OnAfterGetRecord()
    begin
        StyleExprFinishedQtyFavorable := false;
        if Rec."Remaining Qty Production Units" < 0 then StyleExprFinishedQtyFavorable := true;
        StyleExprEndingDateUnfaborable := false;
        if Rec."Ending Date" < Today + DateFormulaEndingDate then StyleExprEndingDateUnfaborable := true;
    end;

    local procedure FillControllingTable()
    var
        WindowDialog: Dialog;
    begin
        WindowDialog.Open('Opdaterer Controllingtabel');
        Rec.DeleteAll();
        if ShowTransferLines then FillFromTransferlines(true);
        if ShowFirmPo then FillFromProductionLines(true, EnumProductionOrderStatus::"Firm Planned");
        if ShowReleasedPO then FillFromProductionLines(true, EnumProductionOrderStatus::Released);
        if Rec.FindFirst() then;
        WindowDialog.Close();
    end;

    local procedure FillFromProductionLines(ShowDialog: Boolean; PoStatus: enum "EnumProductionOrderStatus")
    var
        Items: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        WindowDialog: Dialog;
        QuantityProductionUnits: Decimal;
        BatchSize: Integer;
        Counter: Integer;
        LineNo: Integer;
        MaxCount: Integer;
        pct: Integer;
        DynYearWeek: Text[10];
        MaterialTxt: Text[100];
        RouteType: Text[100];
        WindowText: text[50];
        Text000Lbl: Label 'Firmed Production Order Lines #1', Comment = '#1 = Counter';
        Text001Lbl: Label 'Released Production Order Lines #1', Comment = '#1 = Counter';
        Text002Lbl: Label 'Count';
        Text003Lbl: Label 'Processed';

    begin

        ProdOrderLine.Reset();
        ProdOrderLine.SetFilter(Status, '%1', PoStatus);
        LineNo := GetLastLineNo(Rec);
        if ProdOrderLine.FindSet() then begin
            MaxCount := ProdOrderLine.Count;
            if ShowDialog then begin
                if PoStatus = PoStatus::"Firm Planned" then WindowDialog.Open(Text000Lbl, WindowText);
                if PoStatus = PoStatus::Released then WindowDialog.Open(Text001Lbl, WindowText);
            end;

            WindowText := Text002Lbl + ' ' + Format(MaxCount) + ' ' + Text003Lbl + ' 0' + '%';
            if ShowDialog then WindowDialog.Update();

            repeat
                Counter += 1;

                BatchSize := MaxCount div 10; // Update every 10% to reduce frequency
                if Counter mod BatchSize = 0 then begin
                    pct := round((100 / MaxCount) * Counter, 1);

                    WindowText := Text002Lbl + ' ' + Format(MaxCount) + ' ' + Text003Lbl + ' ' + Format(pct) + '%';
                    if ShowDialog then WindowDialog.Update();
                end;

                // Construct Year-Week
                DynYearWeek := FomatYearWeek(ProdOrderLine."Ending Date");

                //BOM LOOKUP
                QuantityProductionUnits := LookupBOM(ProdOrderLine."Item No.");

                //Get Material (0)
                MaterialTxt := GetBOMDetailsProdOrderLine(ProdOrderLine, EnumGetBomDetails::Material);
                RouteType := GetBOMDetailsProdOrderLine(ProdOrderLine, EnumGetBomDetails::"Operation Type");


                Rec.Init();
                LineNo += 1;
                Rec."Line No." := LineNo;
                Rec."Order Type" := Rec."Order Type"::"Firm PO";
                if ProdOrderLine.Status = ProdOrderLine.Status::Released then
                    Rec."Order Type" := Rec."Order Type"::"Released PO";
                Rec."Document No." := ProdOrderLine."Prod. Order No.";
                Rec."No." := ProdOrderLine."Item No.";
                Rec.Description := ProdOrderLine.Description;
                Rec.Quantity := ProdOrderLine.Quantity;
                Rec."Finished Quantity" := ProdOrderLine."Finished Quantity";
                Rec."Remaining Quantity" := Rec.Quantity - Rec."Finished Quantity";

                Rec."Quantity Production Units" := Rec.Quantity * QuantityProductionUnits;
                Rec."Remaining Qty Production Units" := Rec."Remaining Quantity" * QuantityProductionUnits;
                Rec."Finished Qty Production Units" := Rec."Finished Quantity" * QuantityProductionUnits;

                if ProdOrderLine."Ending Date" <> 0D then begin
                    Rec."Starting Date" := ProdOrderLine."Starting Date";
                    Rec."Ending Date" := ProdOrderLine."Ending Date";
                    Rec."Due Date" := ProdOrderLine."Due Date";
                end;
                Rec.Material := MaterialTxt;
                Rec."Route Type" := RouteType;
                Rec.YearWeek := DynYearWeek;
                if Items.Get(ProdOrderLine."Item No.") then begin
                    Rec."Gen. Prod. Posting Group" := Items."Gen. Prod. Posting Group";
                    Rec."Product Line Code" := CopyStr(Items."Product Line Code", 1, 20);
                    Rec."ABCD Category" := Items."ABCD Category";
                end;

                if Rec.Insert(true) then;
            until ProdOrderLine.Next() = 0;
            if ShowDialog then WindowDialog.Close();
        end;
    end;

    local procedure FillFromTransferlines(ShowDialog: Boolean)
    var
        Items: Record Item;
        TransferLines: Record "Transfer Line";
        WindowDialog: Dialog;
        QuantityProductionUnits: Decimal;
        BatchSize: Integer;
        counter: Integer;
        LineNo: Integer;
        MaxCount: Integer;
        pct: Integer;
        DynYearWeek: Text[10];
        MaterialTxt: Text[100];
        RouteType: Text[100];
        WindowText: text[50];
        Text000Lbl: Label 'Transfer Order Lines #1', Comment = '#1 = Counter';
        Text002Lbl: Label 'Count';
        Text003Lbl: Label 'Processed';

    begin
        TransferLines.Reset();
        TransferLines.SetFilter("Transfer-from Code", 'RYOM');
        TransferLines.SetFilter("Transfer-to Code", 'AUNING');
        LineNo := GetLastLineNo(Rec);
        if TransferLines.FindSet() then begin
            MaxCount := TransferLines.Count;


            if ShowDialog then WindowDialog.Open(Text000Lbl, WindowText);
            repeat
                Counter += 1;

                BatchSize := MaxCount div 10; // Update every 10% to reduce frequency
                if Counter mod BatchSize = 0 then begin
                    pct := round((100 / MaxCount) * Counter, 1);

                    WindowText := Text002Lbl + ' ' + Format(MaxCount) + ' ' + Text003Lbl + ' ' + Format(pct) + '%';
                    if ShowDialog then WindowDialog.Update();
                end;

                // Construct Year-Week
                DynYearWeek := FomatYearWeek(TransferLines."Shipment Date");

                //BOM LOOKUP
                QuantityProductionUnits := LookupBOM(TransferLines."Item No.");

                //Get Material (0)
                MaterialTxt := GetBOMDetailsTransferLine(TransferLines, EnumGetBomDetails::Material);
                RouteType := GetBOMDetailsTransferLine(TransferLines, EnumGetBomDetails::"Operation Type");
                //end;

                Rec.Init();
                LineNo += 1;
                Rec."Line No." := LineNo;
                Rec."Order Type" := Rec."Order Type"::"Transfer Order";
                Rec."Document No." := TransferLines."Document No.";
                Rec."No." := TransferLines."Item No.";
                Rec.Description := TransferLines.Description;
                Rec.Quantity := TransferLines.Quantity;
                Rec."Finished Quantity" := TransferLines."Quantity Shipped";
                Rec."Remaining Quantity" := Rec.Quantity - Rec."Finished Quantity";

                Rec."Quantity Production Units" := Rec.Quantity * QuantityProductionUnits;
                Rec."Remaining Qty Production Units" := Rec."Remaining Quantity" * QuantityProductionUnits;
                Rec."Finished Qty Production Units" := Rec."Finished Quantity" * QuantityProductionUnits;

                if TransferLines."Shipment Date" <> 0D then begin
                    Rec."Starting Date" := TransferLines."Shipment Date";
                    Rec."Ending Date" := TransferLines."Shipment Date";
                    Rec."Due Date" := TransferLines."Shipment Date";
                end;
                Rec.Material := MaterialTxt;
                Rec."Route Type" := RouteType;
                Rec.YearWeek := DynYearWeek;
                if Items.Get(TransferLines."Item No.") then begin
                    Rec."Gen. Prod. Posting Group" := Items."Gen. Prod. Posting Group";
                    Rec."Product Line Code" := CopyStr(Items."Product Line Code", 1, 20);
                    Rec."ABCD Category" := Items."ABCD Category";
                end;

                if Rec.Insert(true) then;
            until TransferLines.Next() = 0;
            if ShowDialog then WindowDialog.Close();
        end;
    end;

    local procedure GetBOMDetailsTransferLine(TransferLine: Record "Transfer Line"; ExitType: Enum EnumGetBOMDetails): Text[50]
    begin

        // MATERIAL
        if ExitType = ExitType::Material then begin
            if TransferLine."Item No." = '00001' then exit('ALU');
            exit('STEEL');
        end;
        //ROUTE TYPE = MACHINE CENTER
        if ExitType = ExitType::"Operation Type" then
            exit('');

    end;

    local procedure GetBOMDetailsProdOrderLine(ProdOrderLine: Record "Prod. Order Line"; ExitType: Enum EnumGetBOMDetails): Text[50]
    var
        //Items: Record Item;
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin

        // MATERIAL
        ProdOrderComponent.Reset();
        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        if ProdOrderComponent.FindFirst() then
            if ExitType = ExitType::Material then begin
                ProdOrderComponent.SetFilter("Item No.", '00001');
                if not ProdOrderComponent.IsEmpty() then exit('ALU');
                exit('STEEL');
            end;
        // key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")

        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        if ProdOrderRoutingLine.FindFirst() then
            //ROUTE TYPE
            if ExitType = ExitType::"Operation Type" then begin
                //ProdOrderRoutingLine.SetFilter(Type, '%1|%2', ProdOrderRoutingLine.Type::"Machine Center",ProdOrderRoutingLine.Type::"Work Center");

                //INDUKTION AFDREJER2
                ProdOrderRoutingLine.SetFilter("No.", '16');
                if not ProdOrderRoutingLine.IsEmpty() then exit(CopyStr(ProdOrderRoutingLine.Description, 1, 50));

                //INDUKTION AFDREJER3
                ProdOrderRoutingLine.SetFilter("No.", '18');
                if not ProdOrderRoutingLine.IsEmpty() then exit(CopyStr(ProdOrderRoutingLine.Description, 1, 50));

                //Blankpolering
                ProdOrderRoutingLine.SetFilter("No.", '25');
                if not ProdOrderRoutingLine.IsEmpty() then exit(CopyStr(ProdOrderRoutingLine.Description, 1, 50));

                //Børstning
                ProdOrderRoutingLine.SetFilter("No.", '27');
                if not ProdOrderRoutingLine.IsEmpty() then exit(CopyStr(ProdOrderRoutingLine.Description, 1, 50));

                exit('');
            end;
    end;


    local procedure GetLastLineNo(var RecProdControllingLinesTMP: Record "ProdControllingLinesTMP"): Integer;
    var
    begin
        If RecProdControllingLinesTMP.FindLast() then exit(RecProdControllingLinesTMP."Line No.");
    end;

    local procedure LookupBOM(ItemNo: Code[20]): Decimal
    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
    begin
        exit(ScanpanMiscellaneous.GetItemSetMultiplier(ItemNo));
    end;

    local procedure FomatYearWeek(DatoToConvert: Date): text[10]
    var
        CalcYearWeek: Text[10];
        Padding: Text[10];
    begin

        if DatoToConvert = 0D then
            exit('');

        Padding := Format(Date2DWY(DatoToConvert, 3));
        CalcYearWeek := Padding;
        Padding := Format(Date2DWY(DatoToConvert, 2));
        Padding := PadStr('', 2 - StrLen(Padding), '0') + Padding;
        CalcYearWeek += '-' + Padding;

        exit(CalcYearWeek);
    end;
}
