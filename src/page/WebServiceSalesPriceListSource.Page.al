/// <summary>
/// Page PriceListSource (ID 50028).
/// </summary>
///
/// <remarks>
///
/// 2023.03.30                  Jesper Harder               020     PriceList Source Data Code start.
///
/// </remarks>
page 50028 "WebServiceSalesPriceListSource"
{
    AdditionalSearchTerms = 'Scanpan, Webservice';
    Caption = 'WebSevice Sales Pricelist Source Data';
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("Inventory Posting Group" = filter('INTERN|EKSTERN|BRUND'));
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions =
        tabledata Item = R,

        tabledata "Item Reference" = R,

        tabledata "Item Translation" = R,
        tabledata "Item Unit of Measure" = R,
        tabledata "Price List Line" = R;

    layout
    {
        area(Content)
        {
            repeater(pricelistsource)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
                field(ItemDescriptionDAN; ItemDescriptionDAN)
                {
                    Caption = 'Item Description (DAN)';
                    ToolTip = 'Item Description translated to Danish.';
                }
                field(ItemDescriptionENU; ItemDescriptionENU)
                {
                    Caption = 'Item Description (ENU)';
                    ToolTip = 'Item Description translated to English US.';
                }
                field(ItemDescriptionNOR; ItemDescriptionNOR)
                {
                    Caption = 'Item Description (NOR)';
                    ToolTip = 'Item Description translated to Norweigan.';
                }

                field(BarCode; BarCode)
                {
                    Caption = 'Barcode';
                    ToolTip = 'Item Barcode No.';
                }
                field(ItemBaseUnitOfMeasure; ItemBaseUnitOfMeasure)
                {
                    Caption = 'Item Base Unit of Measure';
                    ToolTip = 'Item Base Unit of Measure.';
                }
                field(InnerQuantity; InnerQuantity)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Inner Quantity';
                    ToolTip = 'Inner Quantity.';
                }
                field(MasterQuantity; MasterQuantity)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Master Quantity';
                    ToolTip = 'Master Quantity.';
                }
                field(ItemUnitCost; ItemUnitCost)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Item Unit Cost';
                    ToolTip = 'Item Unit Cost from Item Card.';
                }
                field(ItemIndirectCostPct; ItemIndirectCostPct)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Item Indirect Cost pct';
                    ToolTip = 'Item Indirect Cost pct.';
                }
                field(PurchasePrice; PurchasePrice)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Item Purchase Price';
                    ToolTip = 'Maximum Purchase Price from Open Ending Date.';
                }
                field(PurchasePriceCurency; PurchasePriceCurency)
                {
                    Caption = 'Purchase Price Currency';
                    ToolTip = 'Purchase Pricelist Currency for hte Item.';
                }
            }
        }
    }

    var
        ItemIndirectCostPct: Decimal;
        ItemUnitCost: Decimal;
        MasterQuantity: Decimal;
        InnerQuantity: Decimal;
        PurchasePrice: Decimal;
        EnumGetItem: Enum EnumGetItem;
        EnumGetItemPurchasePrice: Enum EnumGetItemPurchasePrice;
        EnumItemUnitOfMeasureCode: Enum EnumItemUnitOfMeasureCode;
        PurchasePriceCurency: Text[5];
        BarCode: Text[50];
        ItemBaseUnitOfMeasure: text[20];
        ItemDescriptionDAN: Text[100];
        ItemDescriptionENU: Text[100];
        ItemDescriptionNOR: Text[100];

    trigger OnAfterGetRecord()
    var
    begin
        BarCode := GetBarcode(Rec."No.");
        MasterQuantity := GetMeasureQuantity(Rec."No.", EnumItemUnitOfMeasureCode::Master);
        InnerQuantity := GetMeasureQuantity(Rec."No.", EnumItemUnitOfMeasureCode::Inner);
        Evaluate(ItemUnitCost, GetItem(Rec."No.", EnumGetItem::"Unit Cost"));
        Evaluate(ItemIndirectCostPct, GetItem(Rec."No.", EnumGetItem::"Indirect Unit Cost %"));
        ItemBaseUnitOfMeasure := CopyStr(GetItem(Rec."No.", EnumGetItem::"Base Unit of Measure"), 1, 20);
        Evaluate(PurchasePrice, GetItemPurchasePrice(Rec."No.", EnumGetItemPurchasePrice::"Direct Unit Cost"));
        PurchasePriceCurency := CopyStr(GetItemPurchasePrice(Rec."No.", EnumGetItemPurchasePrice::"Currency Code"), 1, 5);
        ItemDescriptionDAN := GetItemDescriptionTranslation(Rec."No.", 'DAN');
        ItemDescriptionENU := GetItemDescriptionTranslation(Rec."No.", 'ENU');
        ItemDescriptionNOR := GetItemDescriptionTranslation(Rec."No.", 'NOR');
    end;

    local procedure GetBarcode(ItemNo: code[20]): code[50]
    var

        ItemReference: Record "Item Reference";

        Items: Record Item;
    begin
        Items.Get(ItemNo);
        ItemReference.SetFilter("Item No.", Items."No.");
        ItemReference.SetFilter("Reference Type", '%1', ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetFilter("Unit of Measure", items."Base Unit of Measure");
        if ItemReference.FindFirst() then exit(ItemReference."Reference No.");
    end;

    local procedure GetItem(ItemNo: code[20]; ReturnType: Enum EnumGetItem): Text
    var
        Items: Record Item;
    begin
        if Items.Get(ItemNo) then begin
            if ReturnType = ReturnType::"Unit Cost" then exit(Format(Items."Unit Cost"));
            if ReturnType = ReturnType::"Indirect Unit Cost %" then exit(Format(Items."Indirect Cost %"));
            if ReturnType = ReturnType::"Base Unit of Measure" then exit(Items."Base Unit of Measure");
        end;
    end;

    local procedure GetItemDescriptionTranslation(ItemNo: Code[20]; LanguageCode: code[20]): text[100]
    var
        ItemTranslation: Record "Item Translation";
        Text000Lbl: Label 'Missing Translation';
    begin
        if ItemTranslation.Get(ItemNo, '', LanguageCode) then exit(ItemTranslation.Description);
        exit(Text000Lbl);
    end;

    local procedure GetItemPurchasePrice(ItemNo: Code[20]; ReturnType: Enum EnumGetItemPurchasePrice): Text
    var
        PriceListLines: Record "Price List Line";
        MyPurchasePrice: Decimal;
        Currency: Text[10];
    begin
        PriceListLines.SetFilter("Assign-to No.", '<>1469'); //Exept WEGROW
        PriceListLines.SetFilter("Price Type", '%1', PriceListLines."Price Type"::Purchase);
        PriceListLines.SetFilter("Asset Type", '%1', PriceListLines."Asset Type"::Item);
        PriceListLines.SetFilter("Asset No.", ItemNo);
        PriceListLines.SetFilter("Ending Date", '%1|>=%2', 0D, Today);
        if PriceListLines.FindSet() then
            repeat
                if PriceListLines."Direct Unit Cost" > MyPurchasePrice then MyPurchasePrice := PriceListLines."Direct Unit Cost";
                Currency := PriceListLines."Currency Code";
            until PriceListLines.Next() = 0;
        if ReturnType = ReturnType::"Direct Unit Cost" then exit(format(MyPurchasePrice));
        if ReturnType = ReturnType::"Currency Code" then exit(Currency);
    end;

    local procedure GetMeasureQuantity(ItemNo: code[20]; CodeType: Enum EnumItemUnitOfMeasureCode): Decimal
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if CodeType = CodeType::Master then
            if ItemUnitOfMeasure.Get(ItemNo, 'MASTER') then exit(ItemUnitOfMeasure."Qty. per Unit of Measure");
        if CodeType = CodeType::Inner then
            if ItemUnitOfMeasure.Get(ItemNo, 'INNER') then exit(ItemUnitOfMeasure."Qty. per Unit of Measure");
    end;
}
