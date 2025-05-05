/// <summary>
/// Page WebServiceOrderFormItems (ID 50031).
/// </summary>
///
/// <remarks>
///
/// 2023.04.18                  Jesper Harder                   024     SalesOrderForm WebServices used in Excel Sales Order Forms.
///
/// </remarks>
page 50031 "WebServiceOrderFormItems"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = 'WebServices Sales Orderform Items';
    Editable = false;
    PageType = List;
    Permissions =
        tabledata Item = R,
        tabledata "Item Translation" = R,
        tabledata "Price List Line" = R;
    SourceTable = "Price List Line";
    SourceTableView = where("Ending Date" = filter(''),
                             "Asset Type" = const(Item),
                             "Source Group" = const(Customer),
                             "Source Type" = const("Customer Price Group"),
                             "Minimum Quantity" = filter('0|1')
                             //, "Asset No." = filter('28001203')
                             );
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(repeater1)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the product that the price applies to.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the unique identifier of the source of the price on the price list line.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the currency code of the price.';
                }
                field(DescriptionItem; DescriptionItem)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(DescriptionDAN; DescriptionDAN)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionDAN';
                    ToolTip = 'Specifies the value of the DescriptionDAN field.';
                }
                field(DescriptionSVE; DescriptionSVE)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionSVE';
                    ToolTip = 'Specifies the value of the DescriptionSVE field.';
                }
                field(DescriptionENU; DescriptionENU)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionENU';
                    ToolTip = 'Specifies the value of the DescriptionENU field.';
                }
                field(DescriptionDEU; DescriptionDEU)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionDEU';
                    ToolTip = 'Specifies the value of the DescriptionDEU field.';
                }
                field(DescriptionFRA; DescriptionFRA)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionFRA';
                    ToolTip = 'Specifies the value of the DescriptionFRA field.';
                }
                field(DescriptionBEL; DescriptionBEL)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionBEL';
                    ToolTip = 'Specifies the value of the DescriptionBEL field.';
                }
                field(DescriptionNLD; DescriptionNLD)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionNLD';
                    ToolTip = 'Specifies the value of the DescriptionNLD field.';
                }
                field(DescriptionNOR; DescriptionNOR)
                {
                    ApplicationArea = all;
                    Caption = 'DescriptionBEL';
                    ToolTip = 'Specifies the value of the DescriptionBEL field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date from which the price or the line discount is valid.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date to which the price or the line discount is valid.';
                }
                field(MinimumQuantity1; MinimumQuantity1)
                {
                    ApplicationArea = all;
                    Caption = 'Minimum Quantity';
                    ToolTip = 'Specifies the value of the Minimum Quantity field.';
                }
                field(UnitPrice1; UnitPrice1)
                {
                    ApplicationArea = all;
                    Caption = 'Unitprice Starting Price';
                    ToolTip = 'Specifies the value of the Unitprice Starting Price field.';
                }
                field(MinimumQuantity2; MinimumQuantity2)
                {
                    ApplicationArea = all;
                    Caption = 'Minimum Quantity Master';
                    ToolTip = 'Specifies the value of the Minimum Quantity Master field.';
                }
                field(UnitPrice2; UnitPrice2)
                {
                    ApplicationArea = all;
                    Caption = 'Unitprice Package Price';
                    ToolTip = 'Specifies the value of the Unitprice Package Price field.';
                }
            }
        }
    }
    var
        PriceListLine: Record "Price List Line";
        MinimumQuantity1: Decimal;
        MinimumQuantity2: Decimal;
        UnitPrice1: Decimal;
        UnitPrice2: Decimal;
        DescriptionBEL: Text[100];
        DescriptionDAN: Text[100];
        DescriptionDEU: Text[100];
        DescriptionENU: Text[100];
        DescriptionFRA: Text[100];
        DescriptionItem: text[100];
        DescriptionNLD: Text[100];
        DescriptionNOR: Text[100];
        DescriptionSVE: Text[100];

    trigger OnAfterGetRecord()
    begin
        MinimumQuantity1 := Rec."Minimum Quantity";
        if MinimumQuantity1 = 0 then MinimumQuantity1 := 1;

        DescriptionItem := GetItemTranslation(Rec."Asset No.", '');
        DescriptionDAN := GetItemTranslation(Rec."Asset No.", 'DAN');
        DescriptionSVE := GetItemTranslation(Rec."Asset No.", 'SVE');
        DescriptionENU := GetItemTranslation(Rec."Asset No.", 'ENU');
        DescriptionDEU := GetItemTranslation(Rec."Asset No.", 'DEU');
        DescriptionFRA := GetItemTranslation(Rec."Asset No.", 'FRA');
        DescriptionBEL := GetItemTranslation(Rec."Asset No.", 'BEL');
        DescriptionNLD := GetItemTranslation(Rec."Asset No.", 'NLD');
        DescriptionNOR := GetItemTranslation(Rec."Asset No.", 'NOR');

        UnitPrice1 := Rec."Unit Price";

        PriceListLine.SetFilter("Minimum Quantity", '>%1', 1);
        PriceListLine.SetFilter("Ending Date", '%1', Rec."Ending Date");
        PriceListLine.SetFilter("Asset Type", '%1', Rec."Asset Type");
        PriceListLine.SetFilter("Source Group", '%1', Rec."Source Group");
        PriceListLine.SetFilter("Source Type", '%1', Rec."Source Type");
        PriceListLine.SetFilter("Source No.", '%1', Rec."Source No.");
        PriceListLine.SetFilter("Currency Code", '%1', Rec."Currency Code");
        PriceListLine.SetFilter("Asset No.", Rec."Asset No.");

        MinimumQuantity2 := 0;
        UnitPrice2 := 0;
        if PriceListLine.FindFirst() then begin
            MinimumQuantity2 := PriceListLine."Minimum Quantity";
            UnitPrice2 := PriceListLine."Unit Price";
        end;

        if MinimumQuantity2 < MinimumQuantity1 then begin
            MinimumQuantity2 := MinimumQuantity1;
            UnitPrice2 := UnitPrice1;
        end;
    end;

    local procedure GetItemTranslation(ItemNo: code[20]; LangCode: code[20]): Text[100]
    var
        ItemTranslation: Record "Item Translation";
        Item: Record Item;
    begin
        if ItemTranslation.Get(ItemNo, '', LangCode) then Exit(ItemTranslation.Description);
        if Item.Get(ItemNo) then Exit(Item.Description);
    end;
}

/*
SELECT	SP.[Asset ID]
		, SP.[Source No_]
		, SP.[Currency Code]
		, IT.Description  AS Description
		, IT.[Language Code]
		, SP.[Starting Date]
		, SP.[Ending Date]
		, CASE WHEN MIN(SP.[Minimum Quantity]) = 0 THEN 1 ELSE MIN(SP.[Minimum Quantity]) END as [Minimum Quantity]
		, MAX(SP.[Unit Price]) as [Unit Price]
		, CASE WHEN MAX(SP.[Minimum Quantity]) = 0 THEN 1 ELSE MAX(SP.[Minimum Quantity]) END AS SP2_MinQty
		, MIN(SP.[Unit Price]) AS SP2_UnitPrice

FROM	[SCANPAN Danmark$Price List Line$437dbf0e-84ff-417a-965d-ed2bb9650972] as SP
		INNER JOIN [SCANPAN Danmark$Item Translation$437dbf0e-84ff-417a-965d-ed2bb9650972] AS IT
			ON SP.[Asset ID] = IT.[Item No_]

WHERE	0=0
		AND IT.[Language Code] = 'DEU'
		AND SP.[Source No_] = 'RRP'
		AND SP.[Currency Code] = 'EUR'
		AND SP.[Ending Date] = CONVERT(DATETIME, '1753-01-01 00:00:00', 102)
		--AND [Asset Type] = 10
		--AND [Source Group] = 11
--AND SP.[Item No_] in('65002000','65002003','68002800','68002803','53002000','53002003')
*/
/*
GROUP BY	SP.[Asset ID]
			, SP.[Source No_]
			,SP.[Currency Code]
			, IT.Description
			, IT.[Language Code]
			, SP.[Starting Date]
			, SP.[Ending Date]
*/
