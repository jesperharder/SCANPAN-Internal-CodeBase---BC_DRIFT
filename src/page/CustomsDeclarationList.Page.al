page 50199 "Customs Declaration List"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'Customs Declaration';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions =
        tabledata Item = R,
        tabledata "Item Reference" = R,
        tabledata "Item Translation" = R,
        tabledata "Item Unit of Measure" = R;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Scanpan)
            {
                Caption = 'Scanpan';

                field(TranslationLanguageCode; TranslationLanguageCode)
                {
                    ApplicationArea = All;
                    Caption = 'Item language code';
                    TableRelation = Language.Code;
                    ToolTip = 'Specifies which item translation language should be used for the descriptions. If no translation exists, the item description is used.';

                    trigger OnValidate()
                    begin
                        RefreshPageData();
                    end;
                }
                field(ExportLanguageOption; ExportLanguageOpt)
                {
                    ApplicationArea = All;
                    Caption = 'Export language';
                    OptionCaption = 'Dansk,English';
                    ToolTip = 'Specifies which language should be used for Excel column captions.';
                }
            }
            group(ItemFilters)
            {
                Caption = 'Filter: Item';

                field(FilterGenProdPostingGroup; FilterGenProdPostingGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Produktbogforingsgruppe';
                    ToolTip = 'Specifies a filter for general product posting groups.';

                    trigger OnValidate()
                    begin
                        ApplyItemFiltersAndRefresh();
                    end;
                }
                field(FilterProductUsage; FilterProductUsage)
                {
                    ApplicationArea = All;
                    Caption = 'Brugsgruppe';
                    ToolTip = 'Specifies a filter for product usage.';

                    trigger OnValidate()
                    begin
                        ApplyItemFiltersAndRefresh();
                    end;
                }
                field(FilterABCDCategory; FilterABCDCategory)
                {
                    ApplicationArea = All;
                    Caption = 'ABCD kategori';
                    ToolTip = 'Specifies a filter for ABCD category.';

                    trigger OnValidate()
                    begin
                        ApplyItemFiltersAndRefresh();
                    end;
                }
                field(FilterItemNo; FilterItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Nummer';
                    ToolTip = 'Specifies a filter for item numbers.';

                    trigger OnValidate()
                    begin
                        ApplyItemFiltersAndRefresh();
                    end;
                }
                field(FilterQuality; FilterQuality)
                {
                    ApplicationArea = All;
                    Caption = 'Kvalitet';
                    ToolTip = 'Specifies a filter for quality.';

                    trigger OnValidate()
                    begin
                        ApplyItemFiltersAndRefresh();
                    end;
                }
            }
            repeater(General)
            {
                Editable = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description; DisplayDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the translated item description when available, otherwise the item description.';
                }
                field("Sales Length"; ItemUnitMeasureSalesLength)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Length';
                    ToolTip = 'Specifies the sales unit length.';
                }
                field("Sales Width"; ItemUnitMeasureSalesWidth)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Width';
                    ToolTip = 'Specifies the sales unit width.';
                }
                field("Sales Height"; ItemUnitMeasureSalesHeight)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Height';
                    ToolTip = 'Specifies the sales unit height.';
                }
                field("Sales Reference No."; ItemReferenceSalesReferenceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Reference No.';
                    ToolTip = 'Specifies the sales unit reference number.';
                }
                field("Sales Net Weight"; ItemSalesNetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Net Weight';
                    ToolTip = 'Specifies the net weight from the item card.';
                }
                field("Sales Gross Weight"; ItemUnitMeasureSalesGrossWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Gross Weight';
                    ToolTip = 'Specifies the gross weight for the sales unit.';
                }
                field("Sales Cubage"; ItemUnitMeasureSalesCubage)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Cubage';
                    ToolTip = 'Specifies the cubage for the sales unit.';
                }
                field("Tariff No."; ItemSalesTariffNo)
                {
                    ApplicationArea = All;
                    Caption = 'Tariff No.';
                    ToolTip = 'Specifies the tariff number from the item card.';
                }
                field("Country/Region of Origin Code"; ItemSalesCountryOfOriginCode)
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region of Origin Code';
                    ToolTip = 'Specifies the country or region of origin code from the item card.';
                }
                field("Inner Quantity"; ItemUnitMeasureInnerQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Quantity';
                    ToolTip = 'Specifies the quantity per INNER unit of measure.';
                }
                field("Inner Length"; ItemUnitMeasureInnerLength)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Length';
                    ToolTip = 'Specifies the INNER unit length.';
                }
                field("Inner Width"; ItemUnitMeasureInnerWidth)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Width';
                    ToolTip = 'Specifies the INNER unit width.';
                }
                field("Inner Height"; ItemUnitMeasureInnerHeight)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Height';
                    ToolTip = 'Specifies the INNER unit height.';
                }
                field("Inner Reference No."; ItemCrossReferenceInnerReferenceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Reference No.';
                    ToolTip = 'Specifies the INNER unit reference number.';
                }
                field("Inner Gross Weight"; ItemUnitMeasureInnerGrossWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Gross Weight';
                    ToolTip = 'Specifies the INNER unit gross weight.';
                }
                field("Inner Cubage"; ItemUnitMeasureInnerCubage)
                {
                    ApplicationArea = All;
                    Caption = 'Inner Cubage';
                    ToolTip = 'Specifies the INNER unit cubage.';
                }
                field("Outer Quantity"; ItemUnitMeasureOuterQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Quantity';
                    ToolTip = 'Specifies the quantity per MASTER or OUTER unit of measure.';
                }
                field("Outer Length"; ItemUnitMeasureOuterLength)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Length';
                    ToolTip = 'Specifies the MASTER or OUTER unit length.';
                }
                field("Outer Width"; ItemUnitMeasureOuterWidth)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Width';
                    ToolTip = 'Specifies the MASTER or OUTER unit width.';
                }
                field("Outer Height"; ItemUnitMeasureOuterHeight)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Height';
                    ToolTip = 'Specifies the MASTER or OUTER unit height.';
                }
                field("Outer Reference No."; ItemReferenceOuterReferenceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Reference No.';
                    ToolTip = 'Specifies the MASTER or OUTER unit reference number.';
                }
                field("Outer Gross Weight"; ItemUnitMeasureOuterGrossWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Gross Weight';
                    ToolTip = 'Specifies the MASTER or OUTER unit gross weight.';
                }
                field("Outer Cubage"; ItemUnitMeasureOuterCubage)
                {
                    ApplicationArea = All;
                    Caption = 'Outer Cubage';
                    ToolTip = 'Specifies the MASTER or OUTER unit cubage.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ExportToExcel)
            {
                AccessByPermission = System "Allow Action Export To Excel" = X;
                ApplicationArea = All;
                Caption = 'Eksporter tolddeklaration';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Eksporterer den aktuelle tolddeklaration til Excel med den valgte kolonneraekkefoelge og rapportoversigt.';

                trigger OnAction()
                begin
                    ExportCurrentViewToExcel();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ExportLanguageOpt := ExportLanguageOpt::Danish;
        FilterGenProdPostingGroup := 'INTERN|EKSTERN';
        FilterProductUsage := 'ACCESSORIES|COOKING|CUTTING|OUTDOOR|PREPARATION|TABLE';
        FilterABCDCategory := 'A|A+|B';
        FilterItemNo := '';
        FilterQuality := '';
        Rec.SetCurrentKey("No.");
        ApplyItemFilters(Rec);
        if not Rec.IsEmpty() then
            Rec.FindFirst();
    end;

    trigger OnAfterGetRecord()
    begin
        LoadDisplayValues(Rec);
    end;

    var
        FilterGenProdPostingGroup: Text[250];
        FilterProductUsage: Text[250];
        FilterABCDCategory: Text[250];
        FilterItemNo: Text[250];
        FilterQuality: Text[250];
        TranslationLanguageCode: Code[10];
        ExportLanguageOpt: Option Danish,English;
        DisplayDescription: Text[100];
        ItemUnitMeasureSalesLength: Decimal;
        ItemUnitMeasureSalesWidth: Decimal;
        ItemUnitMeasureSalesHeight: Decimal;
        ItemReferenceSalesReferenceNo: Text[50];
        ItemSalesNetWeight: Decimal;
        ItemUnitMeasureSalesGrossWeight: Decimal;
        ItemUnitMeasureSalesCubage: Decimal;
        ItemSalesTariffNo: Code[20];
        ItemSalesCountryOfOriginCode: Code[20];
        ItemUnitMeasureInnerQuantity: Decimal;
        ItemUnitMeasureInnerLength: Decimal;
        ItemUnitMeasureInnerWidth: Decimal;
        ItemUnitMeasureInnerHeight: Decimal;
        ItemCrossReferenceInnerReferenceNo: Text[50];
        ItemUnitMeasureInnerGrossWeight: Decimal;
        ItemUnitMeasureInnerCubage: Decimal;
        ItemUnitMeasureOuterQuantity: Decimal;
        ItemUnitMeasureOuterLength: Decimal;
        ItemUnitMeasureOuterWidth: Decimal;
        ItemUnitMeasureOuterHeight: Decimal;
        ItemReferenceOuterReferenceNo: Text[50];
        ItemUnitMeasureOuterGrossWeight: Decimal;
        ItemUnitMeasureOuterCubage: Decimal;

    local procedure RefreshPageData()
    begin
        CurrPage.Update(false);
    end;

    local procedure ApplyItemFiltersAndRefresh()
    begin
        ApplyItemFilters(Rec);
        if not Rec.IsEmpty() then
            Rec.FindFirst();
        RefreshPageData();
    end;

    local procedure ApplyItemFilters(var ItemRecord: Record Item)
    begin
        ItemRecord.FilterGroup(0);

        ItemRecord.SetRange("No.");
        if FilterItemNo <> '' then
            ItemRecord.SetFilter("No.", FilterItemNo);

        ItemRecord.SetRange("Gen. Prod. Posting Group");
        if FilterGenProdPostingGroup <> '' then
            ItemRecord.SetFilter("Gen. Prod. Posting Group", FilterGenProdPostingGroup);

        ItemRecord.SetRange("Product Usage");
        if FilterProductUsage <> '' then
            ItemRecord.SetFilter("Product Usage", FilterProductUsage);

        ItemRecord.SetRange("ABCD Category");
        if FilterABCDCategory <> '' then
            ItemRecord.SetFilter("ABCD Category", FilterABCDCategory);

        ItemRecord.SetRange(Quality);
        if FilterQuality <> '' then
            ItemRecord.SetFilter(Quality, FilterQuality);
    end;

    local procedure LoadDisplayValues(ItemRecord: Record Item)
    begin
        ResetDisplayValues(ItemRecord);
        LoadTranslatedDescriptions(ItemRecord);
        LoadSalesValues(ItemRecord);
        LoadInnerValues(ItemRecord);
        LoadOuterValues(ItemRecord);
    end;

    local procedure ResetDisplayValues(ItemRecord: Record Item)
    begin
        DisplayDescription := ItemRecord.Description;

        Clear(ItemUnitMeasureSalesLength);
        Clear(ItemUnitMeasureSalesWidth);
        Clear(ItemUnitMeasureSalesHeight);
        Clear(ItemReferenceSalesReferenceNo);
        Clear(ItemSalesNetWeight);
        Clear(ItemUnitMeasureSalesGrossWeight);
        Clear(ItemUnitMeasureSalesCubage);
        Clear(ItemSalesTariffNo);
        Clear(ItemSalesCountryOfOriginCode);
        Clear(ItemUnitMeasureInnerQuantity);
        Clear(ItemUnitMeasureInnerLength);
        Clear(ItemUnitMeasureInnerWidth);
        Clear(ItemUnitMeasureInnerHeight);
        Clear(ItemCrossReferenceInnerReferenceNo);
        Clear(ItemUnitMeasureInnerGrossWeight);
        Clear(ItemUnitMeasureInnerCubage);
        Clear(ItemUnitMeasureOuterQuantity);
        Clear(ItemUnitMeasureOuterLength);
        Clear(ItemUnitMeasureOuterWidth);
        Clear(ItemUnitMeasureOuterHeight);
        Clear(ItemReferenceOuterReferenceNo);
        Clear(ItemUnitMeasureOuterGrossWeight);
        Clear(ItemUnitMeasureOuterCubage);
    end;

    local procedure LoadTranslatedDescriptions(ItemRecord: Record Item)
    var
        ItemTranslation: Record "Item Translation";
    begin
        if TranslationLanguageCode = '' then
            exit;

        ItemTranslation.SetRange("Item No.", ItemRecord."No.");
        ItemTranslation.SetRange("Language Code", TranslationLanguageCode);
        if not ItemTranslation.FindFirst() then
            exit;

        if ItemTranslation.Description <> '' then
            DisplayDescription := ItemTranslation.Description;
    end;

    local procedure LoadSalesValues(ItemRecord: Record Item)
    begin
        SetUnitValuesWithoutQuantity(ItemRecord, ItemRecord."Base Unit of Measure", ItemUnitMeasureSalesLength, ItemUnitMeasureSalesWidth, ItemUnitMeasureSalesHeight, ItemUnitMeasureSalesGrossWeight, ItemUnitMeasureSalesCubage);
        ItemReferenceSalesReferenceNo := FindReferenceNo(ItemRecord, ItemRecord."Base Unit of Measure");
        ItemSalesNetWeight := ItemRecord."Net Weight";
        ItemSalesTariffNo := ItemRecord."Tariff No.";
        ItemSalesCountryOfOriginCode := ItemRecord."Country/Region of Origin Code";
    end;

    local procedure LoadInnerValues(ItemRecord: Record Item)
    begin
        SetUnitValuesWithQuantity(ItemRecord, 'INNER', ItemUnitMeasureInnerQuantity, ItemUnitMeasureInnerLength, ItemUnitMeasureInnerWidth, ItemUnitMeasureInnerHeight, ItemUnitMeasureInnerGrossWeight, ItemUnitMeasureInnerCubage);
        ItemCrossReferenceInnerReferenceNo := FindReferenceNo(ItemRecord, 'INNER');
    end;

    local procedure LoadOuterValues(ItemRecord: Record Item)
    begin
        SetUnitValuesWithQuantity(ItemRecord, 'MASTER|OUTER', ItemUnitMeasureOuterQuantity, ItemUnitMeasureOuterLength, ItemUnitMeasureOuterWidth, ItemUnitMeasureOuterHeight, ItemUnitMeasureOuterGrossWeight, ItemUnitMeasureOuterCubage);
        ItemReferenceOuterReferenceNo := FindReferenceNo(ItemRecord, 'MASTER|OUTER');
    end;

    local procedure SetUnitValuesWithoutQuantity(ItemRecord: Record Item; UnitCodeFilter: Text[100]; var ItemLength: Decimal; var ItemWidth: Decimal; var ItemHeight: Decimal; var ItemWeight: Decimal; var ItemCubage: Decimal)
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitOfMeasure.SetRange("Item No.", ItemRecord."No.");
        ItemUnitOfMeasure.SetFilter(Code, UnitCodeFilter);
        if not ItemUnitOfMeasure.FindFirst() then
            exit;

        ItemLength := ItemUnitOfMeasure.Length;
        ItemWidth := ItemUnitOfMeasure.Width;
        ItemHeight := ItemUnitOfMeasure.Height;
        ItemWeight := ItemUnitOfMeasure.Weight;
        ItemCubage := ItemUnitOfMeasure.Cubage;
    end;

    local procedure SetUnitValuesWithQuantity(ItemRecord: Record Item; UnitCodeFilter: Text[100]; var ItemQuantity: Decimal; var ItemLength: Decimal; var ItemWidth: Decimal; var ItemHeight: Decimal; var ItemWeight: Decimal; var ItemCubage: Decimal)
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitOfMeasure.SetRange("Item No.", ItemRecord."No.");
        ItemUnitOfMeasure.SetFilter(Code, UnitCodeFilter);
        if not ItemUnitOfMeasure.FindFirst() then
            exit;

        ItemQuantity := ItemUnitOfMeasure."Qty. per Unit of Measure";
        ItemLength := ItemUnitOfMeasure.Length;
        ItemWidth := ItemUnitOfMeasure.Width;
        ItemHeight := ItemUnitOfMeasure.Height;
        ItemWeight := ItemUnitOfMeasure.Weight;
        ItemCubage := ItemUnitOfMeasure.Cubage;
    end;

    local procedure FindReferenceNo(ItemRecord: Record Item; UnitCodeFilter: Text[100]): Text[50]
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.SetRange("Item No.", ItemRecord."No.");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetFilter("Unit of Measure", UnitCodeFilter);
        if ItemReference.FindFirst() then
            exit(ItemReference."Reference No.");
    end;

    local procedure ExportCurrentViewToExcel()
    var
        ItemToExport: Record Item;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text;
        FriendlyFileName: Text;
    begin
        ItemToExport.CopyFilters(Rec);
        if not ItemToExport.FindSet() then
            exit;

        SheetName := SelectExportText('Toldangivelse', 'Customs Declaration');
        FriendlyFileName := SelectExportText('Tolddeklaration', 'Customs Declaration');

        AddExcelReportHeader(TempExcelBuffer, SheetName);
        AddExcelHeaderRow(TempExcelBuffer);

        repeat
            LoadDisplayValues(ItemToExport);
            AddExcelDataRow(TempExcelBuffer, ItemToExport);
        until ItemToExport.Next() = 0;

        TempExcelBuffer.CreateNewBook(SheetName);
        TempExcelBuffer.SetFriendlyFilename(FriendlyFileName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;

    local procedure AddExcelReportHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; ReportTitle: Text)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ReportTitle, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Virksomhed', 'Company'), CompanyName);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Genereret af', 'Generated by'), UserId);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Genereret', 'Generated at'), Format(CurrentDateTime));
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Produktbogf.gruppe', 'Gen. Prod. Posting Group'), FilterGenProdPostingGroup);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Brugsgruppe', 'Product Usage'), FilterProductUsage);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('ABCD kategori', 'ABCD Category'), FilterABCDCategory);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Nummer', 'Item No.'), FilterItemNo);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Kvalitet', 'Quality'), FilterQuality);
        AddExcelKeyValueRow(TempExcelBuffer, SelectExportText('Item sprogkode', 'Item language code'), TranslationLanguageCode);

        TempExcelBuffer.NewRow();
    end;

    local procedure AddExcelKeyValueRow(var TempExcelBuffer: Record "Excel Buffer" temporary; LabelText: Text; ValueText: Text)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(LabelText, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ValueText, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddExcelHeaderRow(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(SelectExportText('Vare', 'Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Beskrivelse', 'Description'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Laengde (mm) salgsvare', 'Length (mm) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bredde (mm) salgsvare', 'Width (mm) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Hoejde (mm) salgsvare', 'Height (mm) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Barcode salgsvare', 'BarCode Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Nettovaegt (kg) salgsvare', 'Net Weight (kg) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bruttovaegt (kg) salgsvare', 'Gross Weight (kg) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Volumen (m3) salgsvare', 'Volume (m3) Sales Item'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Toldtarifnummer', 'Customs Tariff No'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Oprindelsesland', 'Country of Origin'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Inner karton antal', 'Inner Box Quantity'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Laengde (mm) inner karton', 'Length (mm) Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bredde (mm) inner karton', 'Width (mm) Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Hoejde (mm) inner karton', 'Height (mm) Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Barcode inner karton', 'BarCode Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bruttovaegt (kg) inner karton', 'Gross Weight (kg) Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Volumen (m3) inner karton', 'Volume (m3) Inner Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Yderkarton antal', 'Outer Box Quantity'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Laengde (mm) yderkarton', 'Length (mm) Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bredde (mm) yderkarton', 'Width (mm) Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Hoejde (mm) yderkarton', 'Height (mm) Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Barcode yderkarton', 'BarCode Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Bruttovaegt (kg) yderkarton', 'Gross Weight (kg) Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SelectExportText('Volumen (m3) yderkarton', 'Volume (m3) Outer Box'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddExcelDataRow(var TempExcelBuffer: Record "Excel Buffer" temporary; ItemRecord: Record Item)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ItemRecord."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DisplayDescription, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemUnitMeasureSalesLength, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureSalesWidth, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureSalesHeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemReferenceSalesReferenceNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemSalesNetWeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureSalesGrossWeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureSalesCubage, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemSalesTariffNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemSalesCountryOfOriginCode, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerQuantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerLength, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerWidth, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerHeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemCrossReferenceInnerReferenceNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerGrossWeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureInnerCubage, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterQuantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterLength, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterWidth, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterHeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemReferenceOuterReferenceNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterGrossWeight, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ItemUnitMeasureOuterCubage, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure SelectExportText(DanishText: Text; EnglishText: Text): Text
    begin
        if ExportLanguageOpt = ExportLanguageOpt::English then
            exit(EnglishText);

        exit(DanishText);
    end;
}
