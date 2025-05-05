


/// <summary>
/// Page "SCANPAN_Salesprice_SubPage" (ID 50012).
/// 2025.03             Jesper Harder       107.1       Salesprice Card
/// </summary>
page 50012 SalespricelistDetailsSubPage
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Salesprice Line SubPage';
    Editable = false;
    PageType = ListPart;
    Permissions =
        tabledata Item = R,

        tabledata "Item Reference" = R,

        tabledata "Item Translation" = R,
        tabledata "Item Unit of Measure" = R,
        tabledata "Price List Line" = R;
    SourceTable = SalespriceListTMP;
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(LineNo; Rec.LineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the linenumbers in the list.';
                    Visible = false;
                }
                /*
                field(ItemImage; Rec.ItemImage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Pictura of the product.';
                }
                */
                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item number of the product that the price applies to.';
                }
                field(CustomerItemNo; Rec.CustomerItemNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer ItemNo.';
                    Visible = SetCustomerItemFieldVisible;
                }
                field(BarCode; Rec.BarCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Barcode.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Description.';
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Colli Quantity.';
                }
                field(ColliCode; Rec.ColliCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Colli Code.';
                    Visible = false;
                }
                field(ItemUnitCode; Rec.ItemUnitCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Unit Code field.', Comment = '%';
                }
                field(ItemUnitQuantity; Rec.ItemUnitQuantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ItemUnitQuantity field.', Comment = '%';
                }

                field(GrossWeightUnitMeasure; GrossWeightUnitMeasure)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Weight from the Unit of Measure.';
                    Visible = false;
                }
                field(NetPrice; Rec.NetPrice)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Net Price.';
                }
                field(GrossPrice; Rec.GrossPrice)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Price.';
                }
                field(CustomerPriceGroup; Rec.CustomerPriceGroup)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer Pricegroup.';
                    Visible = false;
                }
                field(GenProdPostingGroup; Rec.GenProdPostingGroup)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gen. Prod. Posting group.';
                    Visible = false;
                }
                field(ItemProductLineCode; Rec.ItemProductLineCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Product Line Code.';
                    Visible = false;
                }
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Translation Code.';
                    Visible = false;
                }
                field(PricelistCode; Rec.PricelistCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Pricelist Code.';
                    Visible = false;
                }


            }


        }

    }


    actions
    {
        area(Processing)
        {
            group("Page")
            {
                Caption = 'Page';

                /*
                                action(EditInExcel)
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'Edit in Excel';
                                    Image = Excel;
                                    Promoted = true;
                                    PromotedCategory = Category8;
                                    PromotedIsBig = true;
                                    PromotedOnly = true;
                                    Visible = true;
                                    ToolTip = 'Send the data in the sub page to an Excel file for analysis or editing';
                                    AccessByPermission = System "Allow Action Export To Excel" = X;

                                    trigger OnAction()
                                    var
                                        ODataUtility: Codeunit ODataUtility;
                                    begin
                                        ODataUtility.EditWorksheetInExcel('Sales_Order_Line', CurrPage.ObjectId(false), StrSubstNo('Document_No eq ''%1'''));
                                    end;

                                }
                  */
            }
        }

    }


    trigger OnOpenPage()
    var
    begin
        Rec.SetCurrentKey(GenProdPostingGroup, ItemProductLineCode, ItemNo);
        Rec.SetAscending(GenProdPostingGroup, true);
        Rec.SetAscending(ItemProductLineCode, true);
        Rec.SetAscending(ItemNo, true);
    end;


    var

        SetCustomerItemFieldVisible: Boolean;


    /// <summary>
    /// FillTempTable.
    /// </summary>
    /// <param name="CustomerPriceGropup">code[20].</param>
    /// <param name="MyGenProdPostingGroup">Code[20].</param>
    /// <param name="MyItemProductLineCode">Code[20].</param>
    /// <param name="MyLanguageCode">code[20].</param>
    /// <param name="ItemInSortiment">Boolean.</param>
    /// <param name="CustomerForItemNumber">code[20].</param>
    procedure FillTempTable(
                                CustomerPriceGropup: code[20];
                                MyGenProdPostingGroup: Code[20];
                                MyItemProductLineCode: Code[20];
                                MyLanguageCode: code[20];
                                ItemInSortiment: Boolean;
                                CustomerForItemNumber: code[20];
                                ItemUnitsFilter: Text[50])
    var
        Items: Record Item;
        PricelistLines: Record "Price List Line";
        MyDialog: Dialog;
        CounterPct, MyLineNo, MaxRecords, RecCounter : Integer;
        Text000Lbl: Label 'Working precentage #1', Comment = '#1 = Percentages.';
        EnumItemUnitOfMeasure: Enum EnumItemUnitOfMeasure;
        EnumItemCrossReferenceTypes: Enum "EnumItemReferenceTypes";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        MyLineNo := 0;
        Rec.DeleteAll(false);
        Commit();

        Items.SetFilter("Gen. Prod. Posting Group", MyGenProdPostingGroup);
        Items.SetFilter("Product Line Code", MyItemProductLineCode);


        PricelistLines.SetRange(Status, PricelistLines.Status::Active);
        PricelistLines.SetFilter("Ending Date", '%1', 0D);
        PricelistLines.SetRange("Source Type", PricelistLines."Source Type"::"Customer Price Group");
        PricelistLines.SetFilter("Source No.", CustomerPriceGropup);
        if ItemInSortiment = true then PricelistLines.SetFilter("Item in Sortiment", '%1', ItemInSortiment);

        if Items.FindSet() then begin
            MyDialog.Open(Text000Lbl, CounterPct);
            MaxRecords := Items.Count;
            repeat
                RecCounter += 1;
                CounterPct := Round((100 / MaxRecords) * RecCounter, 1, '=');
                PricelistLines.SetFilter("Asset No.", Items."No.");
                if PricelistLines.FindSet() then
                    repeat
                        MyDialog.Update();

                        Rec.Init();
                        MyLineNo += 1;
                        Rec.LineNo := MyLineNo;

                        Rec.ItemNo := PricelistLines."Asset No.";
                        if CustomerForItemNumber <> '' then begin
                            Rec.CustomerItemNo := CustomerItemNoGet(CustomerForItemNumber, Items."No.");
                            SetCustomerItemFieldVisible := True;
                        end Else
                            SetCustomerItemFieldVisible := False;

                        Rec.ItemImage := Items.Picture;
                        Rec.Description := CopyStr(ItemDescriptionGet(Items."No.", MyLanguageCode), 1, 200);
                        Rec.BarCode := BarcodeGet(Items."No.", EnumItemCrossReferenceTypes::Barcode);

                        If Evaluate(Rec.Colli, ItemUnitsGetColli(Items."No.", Items."Base Unit of Measure", EnumItemUnitOfMeasure::Colli)) then
                            Evaluate(Rec.Colli, ItemUnitsGetColli(Items."No.", Items."Base Unit of Measure", EnumItemUnitOfMeasure::Colli));

                        Rec.ColliCode := ItemUnitsGetColli(Items."No.", Items."Base Unit of Measure", EnumItemUnitOfMeasure::ColliCode);


                        Rec.NetWeightItemCard := Items."Net Weight";
                        Rec.GrossWeightItemCard := Items."Gross Weight";

                        If Evaluate(Rec.GrossWeightUnitMeasure, ItemUnitsGet(Rec.ItemNo, Items."Base Unit of Measure", EnumItemUnitOfMeasure::Colli)) then
                            Evaluate(Rec.GrossWeightUnitMeasure, ItemUnitsGet(Rec.ItemNo, Items."Base Unit of Measure", EnumItemUnitOfMeasure::Colli));

                        Rec.PricelistCode := PricelistLines."Price List Code";
                        Rec.CustomerPriceGroup := CopyStr(PricelistLines."Source No.", 1, 20);
                        Rec.GenProdPostingGroup := Items."Gen. Prod. Posting Group";
                        Rec.ItemProductLineCode := CopyStr(Items."Product Line Code", 1, 20);
                        Rec.LanguageCode := MyLanguageCode;

                        // Add ItemUnitFilter (e.g., Pallets)
                        if ItemUnitsFilter <> '' then begin
                            Rec.ItemUnitCode := 'N/A';

                            if PricelistLines.IsAssetItem() then begin
                                ItemUnitOfMeasure.Reset();
                                ItemUnitOfMeasure.SetFilter("Item No.", PricelistLines."Asset No.");
                                ItemUnitOfMeasure.SetFilter(Code, ItemUnitsFilter);
                                if ItemUnitOfMeasure.FindFirst() then begin
                                    Rec.ItemUnitCode := ItemUnitOfMeasure.Code;
                                    Rec.ItemUnitQuantity := ItemUnitOfMeasure."Qty. per Unit of Measure";
                                end;
                            end;
                        end;


                        //Price
                        Rec.NetPrice := PricelistLines."Unit Price";
                        Rec.GrossPrice := PricelistLines."Unit List Price";

                        Rec.Insert();
                    until PricelistLines.Next() <= 0;

            Until Items.Next() <= 0;
            Rec.Reset();
            If Not Rec.IsEmpty then Rec.FindFirst();
            MyDialog.Close();
        end;
    end;

    local procedure BarcodeGet(MyItemNo: Code[20]; GetType: Enum "EnumItemReferenceTypes"): code[50];
    var

        ItemReference: Record "Item Reference";

    begin
        ItemReference.Reset();
        ItemReference.SetFilter("Item No.", MyItemNo);
        ItemReference.SETRANGE("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SETFILTER("Reference Type No.", '<>%1', 'EAN');
        ItemReference.SETFILTER("Unit of Measure", '%1|%2|%3', 'STK', 'SET', 'SÆT');
        if ItemReference.FindFirst() then begin
            if GetType = GetType::Barcode then exit(ItemReference."Reference No.");
            if GetType = GetType::"Item Unit" then exit(ItemReference."Unit of Measure");
        end;
    end;

    local procedure CustomerItemNoGet(CustNo: code[20]; MyItemNo: Code[20]): Code[50]
    var

        ItemReference: Record "Item Reference";

    begin
        ItemReference.Reset();
        ItemReference.SetFilter("Item No.", MyItemNo);
        ItemReference.SETRANGE("Reference Type", ItemReference."Reference Type"::Customer);
        ItemReference.SETFILTER("Reference Type No.", CustNo);

        if ItemReference.FindFirst() then
            exit(ItemReference."Reference No.");
    end;

    local procedure ItemDescriptionGet(MyItemNo: code[20]; MyLanguageCode: Code[20]): Text
    var
        Items: Record Item;
        ItemTranslation: Record "Item Translation";
    begin
        ItemTranslation.SetFilter("Item No.", MyItemNo);
        ItemTranslation.SetFilter("Language Code", MyLanguageCode);
        if ItemTranslation.FindFirst() then exit(ItemTranslation.Description + ItemTranslation."Description 2");
        if Items.Get(MyItemNo) then exit(Items.Description);
    end;

    local procedure ItemUnitsGet(MyItemNo: code[20]; ItemUnit: code[20]; GetType: Enum EnumItemUnitOfMeasure): Code[20];
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitOfMeasure.Reset();
        ItemUnitOfMeasure.SetFilter("Item No.", MyItemNo);
        ItemUnitOfMeasure.SetFilter(Code, ItemUnit);
        if ItemUnitOfMeasure.FindFirst() then
            if GetType = GetType::Weight then exit(Format(ItemUnitOfMeasure.Weight, 0, '<Precision,2:2><Standard Format,2>'));


    end;

    local procedure ItemUnitsGetColli(MyItemNo: code[20]; ItemBaseUnit: code[20]; GetType: Enum EnumItemUnitOfMeasure): code[20];
    var
        Items: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        MyColliCode: code[20];
        ColliQty: Integer;
    begin
        ItemBaseUnit := ''; //Unused from overlay
        ItemUnitOfMeasure.Reset();
        Items.Reset();

        Items.SetFilter("No.", MyItemNo);
        If Items.FindFirst() then begin
            ItemUnitOfMeasure.SetFilter(Code, Items."Base Unit of Measure");
            if (GetType = GetType::Colli) and (ItemUnitOfMeasure.FindFirst()) then ColliQty := ItemUnitOfMeasure."Qty. per Unit of Measure";
            if (GetType = GetType::Colli) and (ItemUnitOfMeasure.FindFirst()) then MyColliCode := ItemUnitOfMeasure.Code;
        end;

        ItemUnitOfMeasure.SetFilter("Item No.", MyItemNo);
        ItemUnitOfMeasure.SetFilter(Code, 'MASTER');
        if (GetType = GetType::Colli) and (ItemUnitOfMeasure.FindFirst()) then ColliQty := ItemUnitOfMeasure."Qty. per Unit of Measure";
        if (GetType = GetType::ColliCode) and (ItemUnitOfMeasure.FindFirst()) then MyColliCode := ItemUnitOfMeasure.Code;

        ItemUnitOfMeasure.SetFilter(Code, 'INNER');
        if (GetType = GetType::Colli) and (ItemUnitOfMeasure.FindFirst()) then ColliQty := ItemUnitOfMeasure."Qty. per Unit of Measure";
        if (GetType = GetType::ColliCode) and (ItemUnitOfMeasure.FindFirst()) then MyColliCode := ItemUnitOfMeasure.Code;

        Items.SetFilter("Gen. Prod. Posting Group", 'INTERN');
        Items.SetFilter("Packing Method", '00');
        Items.SetFilter("No.", MyItemNo);
        If Items.FindFirst() then begin
            ItemUnitOfMeasure.SetFilter(Code, Items."Base Unit of Measure");
            if (GetType = GetType::Colli) and (ItemUnitOfMeasure.FindFirst()) then ColliQty := ItemUnitOfMeasure."Qty. per Unit of Measure";
            if (GetType = GetType::ColliCode) and (ItemUnitOfMeasure.FindFirst()) then MyColliCode := ItemUnitOfMeasure.Code;
        end;

        IF GetType = GetType::Colli then Exit(FORMAT(ColliQty));
        IF GetType = GetType::ColliCode then Exit(MyColliCode);

    end;


}
