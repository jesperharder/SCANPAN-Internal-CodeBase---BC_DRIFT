/// <summary>
/// Page ProdControllingPanPlan (ID 50030).
/// </summary>
///
/// <remarks>
///
/// 2023.04.10      Jesper Harder               022     Porting the PanPlan project to AL/Code.
///
/// </remarks>
///

page 50030 "ProdControllingPanPlan"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'SCANPAN Production Controlling PanPlan';
    PageType = List;
    Permissions =
        tabledata Item = R,
        tabledata "Item Ledger Entry" = R,
        tabledata "Prod. Order Component" = R,
        tabledata "Prod. Order Line" = R,
        tabledata ProdControllingPanPlan = RIMD,
        tabledata "Purchase Line" = R,
        tabledata "Transfer Line" = R;
    SourceTable = ProdControllingPanPlan;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Productionorders)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Order Number field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Order Status field.';
                }
                field("Status Text"; Rec."Status Text")
                {
                    ToolTip = 'Specifies the value of the Status Text field.';
                }
                field("Order Item No."; Rec."Order Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Order Item Description"; Rec."Order Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Order Unit"; Rec."Order Unit")
                {
                    ToolTip = 'Specifies the value of the Order Unit field.';
                }
                field("Bom Item No."; Rec."Bom Item No.")
                {
                    ToolTip = 'Specifies the value of the Bom Item No. field.';
                }
                field("Bom Description"; Rec."Bom Description")
                {
                    ToolTip = 'Specifies the value of the Bom Description field.';
                }
                field("Bom Unit"; Rec."Bom Unit")
                {
                    ToolTip = 'Specifies the value of the Bom Unit field.';
                }
                field("Bom Item Category Code"; Rec."Bom Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("PO Item No. Level"; Rec."PO Item No. Level")
                {
                    ToolTip = 'Specifies the value of the LevelOfProduction Level field.';
                }
                field("Bom Item No. Level"; Rec."Bom Item No. Level")
                {
                    ToolTip = 'Specifies the value of the LevelOfProduction BomLevel field.';
                }
                field("Bom Sorting"; Rec."Bom Sorting")
                {
                    ToolTip = 'Specifies the value of the Bom Sorting field.';
                }
                field("Sorting"; Rec."Sorting")
                {
                    ToolTip = 'Specifies the value of the Sorting field.';
                }
                field("Warehouse Quantity"; Rec."Warehouse Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    ToolTip = 'Specifies the value of the Order Quantity field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Scrap percentage"; Rec."Scrap percentage")
                {
                    ToolTip = 'Specifies the value of the Scrap field.';
                }
                field("Bom Expected Quantity"; Rec."Bom Expected Quantity")
                {
                    ToolTip = 'Specifies the value of the Expected field.';
                }
                field("Bom Remaining Quantity"; Rec."Bom Remaining Quantity")
                {
                    ToolTip = 'Specifies the value of the Bom Remaining field.';
                }
            }
        }
    }

    trigger OnInit()
    begin
        BuildPanPlanInputData(Rec);
    end;

    /// <summary>
    /// BuildPanPlanInputData.
    /// </summary>
    /// <param name="RecProdControllingPanPlan">Record ProdControllingPanPlan.</param>
    procedure BuildPanPlanInputData(var RecProdControllingPanPlan: Record ProdControllingPanPlan)
    var
        Item: Record Item;
        ItemPOL: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ProdOrderComponent: Record "Prod. Order Component";

        ProdOrderLine: Record "Prod. Order Line";
        TempProdControllingPanPlan: Record ProdControllingPanPlan temporary;
        PurchaseLine: Record "Purchase Line";
        TransferLine: Record "Transfer Line";
        Quantity: Decimal;
        EnumOrderStatus: enum EnumProductionOrderStatus;
        LineNo: Integer;
        LineNoTempTable: Integer;
    begin
        ProdOrderLine.SetFilter(Status, '%1|%2|%3',
                                EnumOrderStatus::Planned,
                                EnumOrderStatus::Planned,
                                EnumOrderStatus::Released);

        item.SetFilter("Inventory Posting Group", 'INTERN|MELLEM|MELLEM RÅ|RV-KROPPE|RV-ALU');
        item.SetFilter("Prod. Group Code", '<>%1', 'PAP');

        if ProdOrderLine.FindSet() then
            repeat
                ItemPOL.Get(ProdOrderLine."Item No.");

                ProdOrderComponent.SetFilter("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                if ProdOrderComponent.FindSet() then begin
                    repeat
                        item.SetFilter("No.", ProdOrderComponent."Item No.");
                        Quantity := 0;
                        if item.FindFirst() then begin
                            ItemLedgerEntry.SetFilter("Item No.", ProdOrderComponent."Item No.");
                            ItemLedgerEntry.CalcSums(Quantity);
                            Quantity := ItemLedgerEntry.Quantity;

                            LineNo += 1;
                            RecProdControllingPanPlan."Line No." := LineNo;
                            RecProdControllingPanPlan."Order No." := ProdOrderLine."Prod. Order No.";
                            RecProdControllingPanPlan."Start Date" := ProdOrderLine."Starting Date";
                            RecProdControllingPanPlan."End Date" := ProdOrderLine."Ending Date";
                            RecProdControllingPanPlan."Remaining Quantity" := ProdOrderLine."Remaining Qty. (Base)";

                            RecProdControllingPanPlan.Status := ProdOrderLine.Status.AsInteger();
                            RecProdControllingPanPlan."Status Text" := CopyStr(EnumProductionOrderStatusLoop(ProdOrderLine.Status.AsInteger()), 1, 30);
                            RecProdControllingPanPlan."Order Item No." := ProdOrderLine."Item No.";
                            RecProdControllingPanPlan."Order Item Description" := ItemPOL.Description;
                            RecProdControllingPanPlan."Order Unit" := ItemPOL."Base Unit of Measure";
                            RecProdControllingPanPlan."Bom Item No." := item."No.";
                            RecProdControllingPanPlan."Bom Description" := item.Description;
                            RecProdControllingPanPlan."Bom Unit" := item."Base Unit of Measure";
                            RecProdControllingPanPlan."Bom Item Category Code" := Item."Item Category Code";
                            case ItemPOL."Prod. Group Code" of
                                'KROP':
                                    RecProdControllingPanPlan."PO Item No. Level" := '0';
                                '1':
                                    RecProdControllingPanPlan."PO Item No. Level" := '1';
                                '6':
                                    RecProdControllingPanPlan."PO Item No. Level" := '6';
                                '2':
                                    RecProdControllingPanPlan."PO Item No. Level" := '2';
                                '3':
                                    RecProdControllingPanPlan."PO Item No. Level" := '3';
                                else
                                    RecProdControllingPanPlan."PO Item No. Level" := 'FV';
                            end;

                            case item."Prod. Group Code" of
                                'KROP':
                                    RecProdControllingPanPlan."Bom Item No. Level" := '0';
                                '1':
                                    RecProdControllingPanPlan."Bom Item No. Level" := '1';
                                '6':
                                    RecProdControllingPanPlan."Bom Item No. Level" := '6';
                                '2':
                                    RecProdControllingPanPlan."Bom Item No. Level" := '2';
                                '3':
                                    RecProdControllingPanPlan."Bom Item No. Level" := '3';
                                else
                                    RecProdControllingPanPlan."Bom Item No. Level" := 'FV';
                            end;

                            case item."Prod. Group Code" of
                                'KROP':
                                    RecProdControllingPanPlan."Bom Sorting" := '0';
                                '1':
                                    RecProdControllingPanPlan."Bom Sorting" := '1';
                                '6':
                                    RecProdControllingPanPlan."Bom Sorting" := '6';
                                '2':
                                    RecProdControllingPanPlan."Bom Sorting" := '2';
                                '3':
                                    RecProdControllingPanPlan."Bom Sorting" := '3';
                                else
                                    RecProdControllingPanPlan."Bom Sorting" := 'FV';
                            end;

                            RecProdControllingPanPlan."Warehouse Quantity" := Quantity;
                            RecProdControllingPanPlan."Order Quantity" := ProdOrderLine."Quantity (Base)";
                            RecProdControllingPanPlan."Remaining Quantity" := ProdOrderLine."Remaining Qty. (Base)";
                            RecProdControllingPanPlan."Scrap percentage" := ProdOrderLine."Scrap %";
                            RecProdControllingPanPlan."Bom Expected Quantity" := ProdOrderComponent."Expected Qty. (Base)";
                            RecProdControllingPanPlan."Bom Remaining Quantity" := ProdOrderComponent."Remaining Qty. (Base)";
                            if RecProdControllingPanPlan.Insert() then;
                        end;
                    until ProdOrderComponent.Next() = 0;

                    //Now fill transferlines and purchselines
                    Item.Reset();
                    TempProdControllingPanPlan.DeleteAll();
                    LineNoTempTable := 0;
                    Item.SetFilter("Inventory Posting Group", 'RV-KROPPE', 'RV-ALU');
                    if ProdOrderComponent.FindSet() then
                        repeat
                            if Item.get(ProdOrderComponent."Item No.") then begin
                                //TransferLine
                                Quantity := 0;
                                TransferLine.SetFilter("Item No.", Item."No.");
                                TransferLine.SetFilter("Transfer-to Code", 'RYOM');
                                TransferLine.SetFilter("Outstanding Qty. (Base)", '<>0');
                                if TransferLine.FindSet() then
                                    repeat
                                        Quantity := TransferLine."Outstanding Qty. (Base)";
                                        //Insert or Update
                                        TempProdControllingPanPlan.SetFilter("Bom Item No.", Item."No.");
                                        TempProdControllingPanPlan.SetFilter("Start Date", '%1', TransferLine."Receipt Date");
                                        if TempProdControllingPanPlan.FindFirst() then begin
                                            TempProdControllingPanPlan."Bom Expected Quantity" += Quantity;
                                            if TempProdControllingPanPlan.Modify() then;
                                        end else begin
                                            TempProdControllingPanPlan.Init();
                                            LineNoTempTable += 1;
                                            TempProdControllingPanPlan."Line No." := LineNoTempTable;
                                            TempProdControllingPanPlan."Bom Item No." := Item."No.";
                                            TempProdControllingPanPlan."Bom Description" := Item.Description;
                                            TempProdControllingPanPlan."Start Date" := TransferLine."Receipt Date";
                                            TempProdControllingPanPlan."Bom Expected Quantity" := Quantity;
                                            if TempProdControllingPanPlan.Insert() then;
                                        end;
                                    until TransferLine.Next() = 0;

                                //PurchaseLine
                                Quantity := 0;
                                PurchaseLine.SetFilter("Document Type", '%1', PurchaseLine."Document Type"::Order);
                                PurchaseLine.SetFilter(Type, '%1', PurchaseLine.Type::Item);
                                PurchaseLine.SetFilter("No.", Item."No.");
                                PurchaseLine.SetFilter("Location Code", 'RYOM');
                                PurchaseLine.SetFilter("Outstanding Qty. (Base)", '<>0');
                                if PurchaseLine.FindSet() then
                                    repeat
                                        Quantity := PurchaseLine."Outstanding Qty. (Base)";
                                        //Insert or Update
                                        TempProdControllingPanPlan.SetFilter("Bom Item No.", Item."No.");
                                        TempProdControllingPanPlan.SetFilter("Start Date", '%1', PurchaseLine."Expected Receipt Date");
                                        if TempProdControllingPanPlan.FindFirst() then begin
                                            TempProdControllingPanPlan."Bom Expected Quantity" += Quantity;
                                            if TempProdControllingPanPlan.Modify() then;
                                        end else begin
                                            TempProdControllingPanPlan.Init();
                                            LineNoTempTable += 1;
                                            TempProdControllingPanPlan."Line No." := LineNoTempTable;
                                            TempProdControllingPanPlan."Bom Item No." := Item."No.";
                                            TempProdControllingPanPlan."Bom Description" := Item.Description;
                                            TempProdControllingPanPlan."Start Date" := PurchaseLine."Expected Receipt Date";
                                            TempProdControllingPanPlan."Bom Expected Quantity" := Quantity;
                                            if TempProdControllingPanPlan.Insert() then;
                                        end;
                                    until PurchaseLine.Next() = 0;
                            end;
                        until ProdOrderComponent.Next() = 0;
                    //fill result into rec dataset
                    if not TempProdControllingPanPlan.IsEmpty then begin
                        TempProdControllingPanPlan.FindSet();
                        repeat
                            LineNo += 1;
                            RecProdControllingPanPlan."Line No." := LineNo;
                            RecProdControllingPanPlan.Status := 5;
                            RecProdControllingPanPlan."Status Text" := CopyStr(EnumProductionOrderStatusLoop(5), 1, 30);
                            RecProdControllingPanPlan."Order Item No." := TempProdControllingPanPlan."Bom Item No.";
                            RecProdControllingPanPlan."Order Item Description" := TempProdControllingPanPlan."Bom Description";
                            RecProdControllingPanPlan."Start Date" := TempProdControllingPanPlan."Start Date";
                            RecProdControllingPanPlan."Order Quantity" := TempProdControllingPanPlan."Order Quantity";
                            if RecProdControllingPanPlan.Insert() then;
                        until TempProdControllingPanPlan.Next() = 0;
                    end;
                end;
            until ProdOrderLine.Next() = 0;
    end;

    local procedure EnumProductionOrderStatusLoop(EnumValueID: Integer): Text
    //Credit to; https://stefanmaron.com/2021/04/19/code-review-loop-over-an-enum/
    var
        EnumType: Enum EnumProductionOrderStatus;
    begin
        foreach EnumType in Enum::"Sales Document Type".Ordinals() do
            if EnumType.AsInteger() = EnumValueID then exit(Format(EnumType));
    end;
}

/*
SELECT
	COMP.OrderStatus
	,COMP.OrderStatusTxt
	,COMP.OrderNo
	,COMP.OrderItemNo
	,COMP.OrderDescription
	,COMP.OrderItemUnitOfMeasure
	,COMP.OrderStartingDate
	,COMP.OrderEndingDate
	,COMP.BomItemNo
	,COMP.BomItemDescription
	,COMP.BomUnitOfMeasure
	,COMP.BomCategoryCode
	,COMP.PlanLevel
	,COMP.NiveauSorting
	,COMP.BomPlanLevel
	,COMP.BomNiveauSorting

	,FPOrderReceiptQty
	+RelOrderReceiptQty
	+QtyonSalesOrder
	+Inventory
	+[ScheduledNeedQty]
	+[QtyinTransit]
	+[TransOrdReceiptQty]
	+[TransOrdShipmentQty]
	+[QtyOnPurchOrder]
	as BomWarehouseQuantity

	,COMP.OrderQuantity
	,COMP.OrderRemainingQuantity
	,COMP.OrderScrapQuantityPCT
	,COMP.BomExpectedQuantity
	,COMP.BomRemainingQuantity
	,'---------------'
	,FPOrderReceiptQty
	,RelOrderReceiptQty
	,[ScheduledNeedQty]
	,QtyonSalesOrder
	,Inventory
	,[QtyinTransit]
	,[TransOrdReceiptQty]
	,[TransOrdShipmentQty]
	,[QtyOnPurchOrder]

FROM (SELECT
	POL.Status as OrderStatus
	,CASE POL.Status
	WHEN 0 THEN 'Simulering'
	WHEN 1 THEN 'Planlagt'
	WHEN 2 THEN 'Fastlagt'
	WHEN 3 THEN 'Frigivet'
	WHEN 4 THEN 'Færdig'
	END as OrderStatusTxt
	,POL.[Prod_ Order No_] as OrderNo
	,POL.[Item No_] as OrderItemNo
	,POL.Description as OrderDescription
	,POL.[Unit of Measure Code] as OrderItemUnitOfMeasure
	----
	,CAST(POL.[Starting Date] as DATE) as OrderStartingDate
	,CAST(POL.[Ending Date] as DATE) as OrderEndingDate
	----
	,ITM.No_ as BomItemNo
	,ITM.Description as BomItemDescription
	,PC.[Unit of Measure Code] as BomUnitOfMeasure
	,ITM.[Item Category Code] as BomCategoryCode
	,CASE POLITM.[Product Group Code]
		WHEN 'KROP' THEN '0'
		WHEN '1' THEN '1'
		WHEN '6' THEN '6'
		WHEN '2' THEN '2'
		WHEN '3' THEN '3'
	ELSE 'FV' END as PlanLevel
	,CASE POLITM.[Product Group Code]
		WHEN 'KROP' THEN -1
		WHEN '1' THEN 0
		WHEN '6' THEN 1
		WHEN '2' THEN 2
		WHEN '3' THEN 3
	ELSE 4 END as NiveauSorting
	,CASE ITM.[Product Group Code]
		WHEN 'KROP' THEN '0'
		WHEN '1' THEN '1'
		WHEN '6' THEN '6'
		WHEN '2' THEN '2'
		WHEN '3' THEN '3'
	ELSE 'FV' END as BomPlanLevel
	,CASE ITM.[Product Group Code]
		WHEN 'KROP' THEN -1
		WHEN '1' THEN 0
		WHEN '6' THEN 1
		WHEN '2' THEN 2
		WHEN '3' THEN 3
	ELSE 4 END as BomNiveauSorting

-----
	,CAST(IL.Quantity as DECIMAL(18,0)) as BomWarehouseQuantity
-----
	,CAST(POL.Quantity as DECIMAL(18,0)) as OrderQuantity
	,CAST(POL.[Remaining Quantity] as DECIMAL(18,0)) as OrderRemainingQuantity
	,CAST(POL.[Scrap %] as DECIMAL(18,1)) as OrderScrapQuantityPCT
	,CAST(PC.[Expected Quantity] as DECIMAL(18,0)) as BomExpectedQuantity
	,CAST(PC.[Remaining Quantity] as DECIMAL(18,0)) as BomRemainingQuantity
-----

,'------------------------' as otherfields
--Warehouse Inventory
	,CAST(ISNULL((SELECT SUM(LG.Quantity) AS Inventory FROM [SCANPAN A_S$Item Ledger Entry] AS LG
	WHERE IL.[Item No_] = LG.[Item No_] AND LG.[Location Code] = 'RV'
	),0) as INT) AS Inventory
--PlannedOrderReceipt [PlannedOrderReceiptQty]
	,CAST(ISNULL((SELECT SUM(POL1.[Remaining Quantity]) AS [PlannedOrderReceiptQty] FROM [SCANPAN A_S$Prod_ Order Line] AS POL1
	WHERE		POL1.[Item No_] = IL.[Item No_] AND POL1.[Status] = 1 AND POL1.[Due Date] < POL.[Starting Date]
	),0) as INT) AS [PlannedOrderReceiptQty]
	--GrossRequirement - [QtyonSalesOrder]
		,CAST(ISNULL((SELECT -SUM(SL.[Outstanding Quantity]) FROM dbo.[SCANPAN A_S$Sales Line] AS SL
		WHERE	SL.[Document Type] = 1 AND SL.[Type] = 2 AND SL.[No_] = IL.[Item No_] AND SL.[Drop Shipment] = 0 AND SL.[Shipment Date] < POL.[Starting Date]
		),0) as int) as [QtyonSalesOrder]
	--ScheduledReceipt - [RelOrderReceiptQty]
		,CAST(ISNULL((SELECT SUM(POL1.[Remaining Quantity]) FROM dbo.[SCANPAN A_S$Prod_ Order Line] AS POL1
		WHERE	POL1.[Item No_] = IL.[Item No_] AND POL1.[Status] = 3 AND POL1.[Due Date]<POL.[Starting Date]
		),0) as int) AS [RelOrderReceiptQty]
	--ScheduledReceipt [FPOrderReceiptQty]
		,CAST(ISNULL((SELECT SUM(POL1.[Remaining Quantity]) FROM dbo.[SCANPAN A_S$Prod_ Order Line] AS POL1
		WHERE	POL1.[Item No_] = IL.[Item No_] AND POL1.[Status] = 2 AND POL1.[Due Date]<POL.[Starting Date]
		),0) as INT) AS [FPOrderReceiptQty]
	--GrossRequirement - [ScheduledNeedQty]
		,CAST(ISNULL((SELECT -SUM(POC.[Remaining Qty_ (Base)]) FROM dbo.[SCANPAN A_S$Prod_ Order Component] AS POC
		WHERE	POC.[Status] in(1,2,3) AND POC.[Item No_] = IL.[Item No_] AND POC.[Due Date]  < POL.[Starting Date]
		),0) as int) as [ScheduledNeedQty]
	--ScheduledReceipt - [QtyinTransit]
		,CAST(ISNULL((SELECT SUM([Qty_ in Transit (Base)]) FROM dbo.[SCANPAN A_S$Transfer Line] AS TL
		WHERE	TL.[Item No_] = IL.[Item No_] AND TL.[Receipt Date] < POL.[Starting Date]
		),0) as INT) as [QtyinTransit]

	--ScheduledReceipt - [TransOrdReceiptQty]
		,CAST(ISNULL((SELECT SUM([Outstanding Quantity]) FROM dbo.[SCANPAN A_S$Transfer Line] AS TL
		WHERE  	TL.[Transfer-to Code] = 'RV' AND TL.[Item No_] = IL.[Item No_] AND TL.[Receipt Date] < POL.[Starting Date]
		),0) as int) as [TransOrdReceiptQty]
	--GrossRequirement - [TransOrdShipmentQty]
		--,CAST(ISNULL((SELECT -SUM(TL.[Outstanding Quantity]) FROM dbo.[SCANPAN A_S$Transfer Line] AS TL
		--WHERE	TL.[Transfer-from Code] <> 'RV' AND TL.[Item No_] = IL.[Item No_] AND TL.[Shipment Date] < POL.[Starting Date]
		--),0) as int) as [TransOrdShipmentQty]
		,0 as [TransOrdShipmentQty]

	--ScheduledReceipt - [QtyOnPurchOrder]
		,CAST(ISNULL(
		(SELECT SUM(PULIN.[Outstanding Quantity]) FROM dbo.[SCANPAN A_S$Purchase Line] AS PULIN
		WHERE	PULIN.[Location Code] = 'RV' AND PULIN.[Document Type] = 1 AND PULIN.[Type] = 2 AND PULIN.[No_] = IL.[Item No_] AND PULIN.[Drop Shipment] = 0 AND PULIN.[Expected Receipt Date]  < POL.[Starting Date]
		),0) as int) as [QtyOnPurchOrder]

--,'----- ITEM' as delim
--,ITM.*

FROM	[SCANPAN A_S$Prod_ Order Line] POL
		left join [SCANPAN A_S$Item] POLITM on POL.[Item No_] = POLITM.No_
		left join [SCANPAN A_S$Prod_ Order Component] PC on POL.[Prod_ Order No_] = PC.[Prod_ Order No_]
		left join [SCANPAN A_S$Item] ITM on PC.[Item No_] = ITM.No_
		left join (SELECT [Item No_], cast(sum([Quantity]) as decimal(18,0)) as Quantity
					FROM [NAVDATABASE].[dbo].[_JH_Item_Ledger] GROUP BY [Item No_]
					) as IL on PC.[Item No_] = IL.[Item No_]

WHERE 0=0
and ITM.[Gen_ Prod_ Posting Group] in('INTERN','MELLEM','MELLEM RÅ','RV-KROPPE','RV-ALU')
and ITM.[Product Group Code] not in('PAP') --,'0','1','2','6','3')
and POL.[Status] in (1,2,3)
) as COMP
--WHERE 0=0
----and COMP.OrderStatus = 3
----and OrderItemNo = ''
----and OrderNo = '133733'
--ORDER BY OrderNo  --NiveauSorting

UNION ALL

SELECT
	[Status] as OrderStatus
	,CAST([Status] as VARCHAR) + ' - Tilgang' as OrderStatusTxt
	,null as OrderNo
	,OrderItemNo
	,OrderItemDescription
	,null as OrderItemUnitOfMeasure
	,OrderStartingDate as OrderStartingDate
	,null as OrderEndingDate
	,null as BomItemNo
	,null as BomItemDescription
	,null as BomUnitOfMeasure
	,null as BomCategoryCode
	,null as PlanLevel
	,null as NiveauSorting
	,null as BomPlanLevel
	,null as BomNiveauSorting

	,null as BomWarehouseQuantity

	,sum(OutstandingQuantity) as OrderQuantity
	,null as OrderRemainingQuantity
	,null as OrderScrapQuantityPCT
	,null as BomExpectedQuantity
	,null as BomRemainingQuantity
	,'---------------'
	,null as FPOrderReceiptQty
	,null as RelOrderReceiptQty
	,null as [ScheduledNeedQty]
	,null as QtyonSalesOrder
	,null as Inventory
	,null as [QtyinTransit]
	,null as [TransOrdReceiptQty]
	,null as [TransOrdShipmentQty]
	,null as [QtyOnPurchOrder]

FROM (
SELECT
		'5' as [Status]
		,ITEMS.ItemNo as OrderItemNo
		,ITEMS.Description as OrderItemDescription
		,CAST(TL.[Outstanding Quantity] as decimal(18,0)) as OutstandingQuantity
		,CAST(TL.[Receipt Date] as date) as OrderStartingDate
FROM (SELECT DISTINCT POC.[Item No_] as ItemNo, ITM.Description FROM [SCANPAN A_S$Prod_ Order Component] POC
			join [SCANPAN A_S$Item] ITM on POC.[Item No_] = ITM.No_
										and Status in(1,2,3)
										and ITM.[Gen_ Prod_ Posting Group] in('RV-KROPPE','RV-ALU')
	) as ITEMS
	left join [SCANPAN A_S$Transfer Line] AS TL on ITEMS.ItemNo = TL.[Item No_] and TL.[Transfer-to Code] = 'RV'
WHERE TL.[Outstanding Quantity] <>0

UNION ALL

SELECT
		'5' as [Status]
		,ITEMS.ItemNo as OrderItemNo
		,ITEMS.Description as OrderItemDescription
		,CAST(PULIN.[Outstanding Quantity] as decimal(18,0)) as OutstandingQuantity
		,CAST(PULIN.[Expected Receipt Date] as date) as OrderStartingDate

FROM (SELECT DISTINCT POC.[Item No_] as ItemNo, ITM.Description FROM [SCANPAN A_S$Prod_ Order Component] POC
			join [SCANPAN A_S$Item] ITM on POC.[Item No_] = ITM.No_
										and Status in(1,2,3)
										and ITM.[Gen_ Prod_ Posting Group] in('RV-KROPPE','RV-ALU')
	) as ITEMS
	left join [SCANPAN A_S$Purchase Line] AS PULIN on ITEMS.ItemNo = PULIN.No_  and PULIN.[Location Code] = 'RV'
										AND PULIN.[Document Type] = 1 AND PULIN.[Type] = 2 AND PULIN.[Drop Shipment] = 0
WHERE PULIN.[Outstanding Quantity] <>0
) as ItemStatus
GROUP BY 	[Status]
	,OrderItemNo
	,OrderItemDescription
	,OrderStartingDate

*/
