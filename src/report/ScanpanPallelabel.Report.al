#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{
    assembly("ForNav.Reports.6.3.0.2250")
    {
        type(ForNav.Report_6_3_0_2250; ForNavReport50004_v6_3_0_2250) { }
    }
} // Reports ForNAV Autogenerated code - do not delete or modify -->

/// <summary>
/// 50004 "Scanpan Pallelabel"
/// </summary>
Report 50004 "Scanpan Pallelabel"
{
    RDLCLayout = './src/report/layout/Pallelabel(ForNAV5004).rdlc';
    DefaultLayout = RDLC;

    Caption = 'Scanpan Palletlabel';
    AdditionalSearchTerms = 'Scanpan';

    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 25;
            DataItemTableView = sorting(Number);
            column(ReportForNavId_1; 1) { } // Autogenerated by ForNav - Do not delete
            column(ItemNo; ItemNoCode)
            {
                IncludeCaption = false;
            }
            column(ItemDescription; ItemDescriptionText)
            {
                IncludeCaption = false;
            }
            column(ItemUnitOfMeasure; ItemUnitOfMeasureCode)
            {
                IncludeCaption = false;
            }
            column(BarCode; BarCodeCode)
            {
                IncludeCaption = false;
            }
            column(PONo; PONoCode)
            {
                IncludeCaption = false;
            }
            column(ItemUnitQuantity; ItemUnitQuantityInt)
            {
                IncludeCaption = false;
            }
            column(txtAntalSlump; txtAntalSlump)
            {
                IncludeCaption = false;
            }
            column(AntalSlump; AntalSlumpInt)
            {
                IncludeCaption = false;
            }
            column(LabelPrintQuantity; LabelPrintQuantityInt)
            {
                IncludeCaption = false;
            }
            column(TotalCalculatedItemQuantity; TotalCalculatedItemQuantityInt)
            {
                IncludeCaption = false;
            }
            column(LabelsCounter; LabelsCounter)
            {
                IncludeCaption = false;
            }
            trigger OnPreDataItem();
            begin
                Integer.SetRange(Number, 1, LabelPrintQuantityInt);
                if LabelPrintQuantityInt = 0 then Error(LabelsQtyToPrintLbl);
                if LabelPrintQuantityInt > 25 then Error(MaxPrintOutLbl);
                if BarCodeCode = '' then Error(SelectItemUnitLbl);

                txtAntalSlump := '';
                //Fix Slump
                if AntalSlumpInt <> 0 then begin
                    txtAntalSlump := 'sp:' + Format(AntalSlumpInt);
                    ItemUnitQuantityInt := AntalSlumpInt;
                    ItemUnitOfMeasureCode := 'STK'
                end
            end;
        }
    }
    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                group(scanpan)
                {
                    Caption = 'Scanpan';

                    /*					 field(NoOfCopies; NoOfCopies)
										{
											Caption = 'No. Of Copies';
											ToolTip = 'Angiv antal kopier til udskrift.';
											ApplicationArea = Basic;
										}
					 */
                    field(ItemSelected; ItemSelectedCode)
                    {
                        Caption = 'Varenummer';
                        ToolTip = 'Vælg varenummer';
                        ApplicationArea = Basic;
                        TableRelation = Item."No.";

                        trigger OnValidate()
                        var

                        begin
                            ItemUnitOfMeasureCode := '';
                            AntalKolliInt := 0;
                            AntalSlumpInt := 0;
                            txtAntalSlump := '';
                            PONoCode := '';
                            ItemNoCode := ItemSelectedCode;
                            BarCodeCode := '';
                            lblUnitAntalSlump := 0;
                            ItemGet;
                            calc();
                        end;

                        //LookupPageId = 31;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                        //ItemRec: Record Item;
                        begin
                            ItemUnitOfMeasureCode := '';
                            //NoOfCopies := 222;
                            ItemRec.Reset();
                            ItemRec.SETFILTER("Gen. Prod. Posting Group", 'INTERN');
                            if page.RunModal(Page::"Item List", ItemRec) = Action::LookupOK then ItemSelectedCode := ItemRec."No.";
                            ItemNoCode := ItemRec."No.";
                            ItemGet();
                            calc();
                        end;
                    }
                    field(ItemUnitOfMeasure; ItemUnitOfMeasureCode)
                    {
                        Caption = 'Enhed';
                        ToolTip = 'Vælg vareenhed';
                        ApplicationArea = Basic;
                        TableRelation = "Item Unit Of Measure"."Code";

                        trigger OnValidate()
                        begin
                            LookupItemUnit();
                            calc();
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                        //ItemCrossReference: Record "Item Reference";
                        begin
                            //RequestPageItemUnitOfMeasure := 'mig selv';
                            //NoOfCopies := 111;
                            //RequestPageItemUnitOfMeasure_Record.SETRANGE("Item No.", ItemSelected);
                            LookupItemUnit;
                            calc();
                        end;
                    }
                    field(AntalKolli; AntalKolliInt)
                    {
                        Caption = 'Antal kolli';
                        ToolTip = 'Angiv antal kolli (palle eller lign.).';
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        var
                        begin
                            if AntalKolliInt > 25 then error(MaxPrintOutLbl);
                            if AntalSlumpInt <> 0 then begin
                                ItemUnitOfMeasureCode := '';
                                BarCodeCode := '';
                            end;

                            AntalSlumpInt := 0;
                            txtAntalSlump := '';
                            LabelPrintQuantityInt := AntalKolliInt;
                            calc();
                        end;
                    }
                    field(AntalSlump; AntalSlumpInt)
                    {
                        Caption = 'Restantal stk';
                        ToolTip = 'Angiv et restantal i stk. Antal der ikke passer til et pallemønster.';
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        var

                        begin
                            txtAntalSlump := '::' + Format(AntalSlumpInt, 0) + '::';
                            AntalKolliInt := 0;
                            LabelPrintQuantityInt := 1;
                            //Tilpas stregkode og antal
                            ItemUnitQuantityInt := 1;

                            ItemCrossReference.RESET;
                            ItemCrossReference.SETRANGE("Item No.", ItemSelectedCode);
                            ItemCrossReference.SETRANGE("Reference Type", ItemCrossReference."Reference Type"::"Bar Code");
                            ItemCrossReference.SETFILTER("Reference Type No.", '<>%1', 'EAN');
                            ItemCrossReference.SETFILTER("Unit of Measure", ItemBaseUnit);

                            ItemUnitOfMeasureCode := ItemBaseUnit;

                            BarCodeCode := 'xxx';
                            If ItemCrossReference.FindFirst() then
                                BarCodeCode := ItemCrossReference."Reference No.";
                            calc();
                        end;

                    }
                    field(PONo; PONoCode)
                    {
                        Caption = 'Produktionsordre';
                        ToolTip = 'Vælg tilhørende produktionsordre';
                        ApplicationArea = Basic;
                        TableRelation = "Prod. Order Line";

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            myInt: Integer;
                        begin

                            //PONR
                            PL.RESET;
                            PL.SETRANGE(PL.Status, PL.Status::Released);
                            PL.SETFILTER(PL."Location Code", '%1|%2|%3', 'AUNING', 'EXP', 'RYOM');
                            PL.SETRANGE(PL."Line No.", 10000);
                            PL.SETFILTER("Item No.", ItemNoCode);
                            PL.SETCURRENTKEY(Status, "Starting Date", "Item No.");
                            IF page.RUNMODAL(0, PL) = ACTION::LookupOK THEN BEGIN
                                PONoCode := PL."Prod. Order No.";
                                //Antal := PL."Last label printed";
                                //TotalCalculatedItemQuantitySlumpPrintet := PL."Total AntalSlump on labels";
                                Calc;
                            END;
                        end;

                    }
                    /*					 field(PoAntalOrdreIfilter; PoAntalOrdreIfilter)
										{
											Caption = 'Antal produktionsordre i filter';
											ToolTip = 'Viser antal produktionsordre indenfor valgte varenummerfilter.';
											Editable = false;
										}
					 */
                }
                group(SelectedStatus)
                {
                    Caption = 'Valgt til udskrift';
                    Editable = false;

                    field(ItemNo; ItemNoCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Varenummer';
                        ToolTip = 'Varenummer til label';
                    }
                    field(ItemDescription; ItemDescriptionText)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Beskrivelse';
                        ToolTip = 'Varebeskrivelse til label';
                    }
                    field(BarCode; BarCodeCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stregkode';
                        ToolTip = 'Stregkode til label';
                    }
                    field(ItemUnitQuantity; ItemUnitQuantityInt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Antal pr. enhed';
                        ToolTip = 'Antal pr. valgte vareehed';
                    }
                    field(TotalCalculatedItemQuantity; TotalCalculatedItemQuantityInt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Total antal valgt';
                        ToolTip = 'Samlet antal der er valgt til udskrift(er)';
                    }
                    field(LabelPrintQuantity; LabelPrintQuantityInt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Antal labels til udskrift';
                        ToolTip = 'Så mange label udskrives';
                    }


                }
                group(Options)
                {
                    field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = All;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                        ToolTip = 'Opens the ForNAV designer when the "Preview" button is pressed';

                        trigger OnValidate()
                        begin
                            ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
                            CurrReport.RequestOptionsPage.Close();
                        end;
                    }
                }
            }

        }
        trigger OnOpenPage()
        begin
            ReportForNavOpenDesigner := false;
            //JH
            if NoOfCopies = 0 then NoOfCopies := 666;
        end;
    }

    trigger OnInitReport();
    begin
        ;


        ;
        ReportsForNavInit;
    end;

    trigger OnPreReport();
    begin
        ;
        //Language
        //CurrReport.LANGUAGE := Language.GetLanguageID('ENU');
        ;
        ReportsForNavPre;
    end;

    trigger OnPostReport();
    begin
        ;
        ReportForNav.Post;
    end;

    var
        //VARIABLES
        LabelsQtyToPrintLbl: label 'Vælg et antal labels til udskrift.';
        MaxPrintOutLbl: Label 'Du må ikke vælge mere end 25 antal labels pr. udskrift.';
        SelectItemUnitLbl: Label 'Der er ikke valgt vareenhed.';

        LabelsCounter: Integer;
        NoOfCopies: Integer;
        AntalKolliInt: Integer;
        AntalSlumpInt: Integer;
        txtAntalSlump: Code[20];
        TotalCalculatedItemQuantityInt: Integer;
        lblUnits: Integer;
        LabelPrintQuantityInt: Integer;
        ItemNoCode: Code[20];
        ItemBaseUnit: Code[20];
        ItemDescriptionText: Text[250];
        ItemSelectedCode: Code[20];
        ItemUnitOfMeasureCode: Code[20];
        ItemUnitQuantityInt: Integer;
        BarCodeCode: Code[50];
        lblUnitAntalSlump: Decimal;
        PoAntalOrdreIfilter: Integer;
        PONoCode: Code[20];


        TextLabel: Text[20];

        //RECORDS
        Item: Record Item;
        ItemRec: Record Item;

        ItemCrossReference: Record "Item Reference";


        test: Record "Item Reference";


        IUM: Record "Item Unit Of Measure";
        PL: Record "Prod. Order Line";

    local procedure LookupItemUnit();
    var
    begin
        ItemCrossReference.RESET;
        ItemCrossReference.SETRANGE("Item No.", ItemSelectedCode);
        ItemCrossReference.SETRANGE("Reference Type", ItemCrossReference."Reference Type"::"Bar Code");
        ItemCrossReference.SETFILTER("Reference Type No.", '<>%1', 'EAN');
        ItemCrossReference.SETFILTER("Unit of Measure", '<>%1&<>%2&<>%3&<>%4', 'KARTON', 'STK', 'SET', 'SÆT');
        IF page.RUNMODAL(0, ItemCrossReference) = ACTION::LookupOK THEN BEGIN
            ItemUnitOfMeasureCode := ItemCrossReference."Unit of Measure";
            BarCodeCode := ItemCrossReference."Reference No.";

            IUM.RESET;
            IUM.SETRANGE("Item No.", ItemSelectedCode);
            IUM.SETRANGE(Code, ItemUnitOfMeasureCode);
            IF IUM.FINDFIRST THEN
                ItemUnitQuantityInt := IUM."Qty. per Unit of Measure";
        END;


    end;

    local procedure calc();
    var
    begin
        TotalCalculatedItemQuantityInt := AntalSlumpInt;
        if AntalKolliInt > 0 then TotalCalculatedItemQuantityInt := AntalKolliInt * ItemUnitQuantityInt;
    end;

    local procedure ItemGet()
    var
    Begin
        IF Item.GET(ItemNoCode) THEN begin
            ItemDescriptionText := Item.Description;
            ItemBaseUnit := Item."Base Unit of Measure";
        end
        ELSE
            ItemDescriptionText := '';

        PoAntalOrdreIfilter := 0;
        //PONR
        PL.RESET;
        PL.SETRANGE(PL.Status, PL.Status::Released);
        PL.SETFILTER(PL."Location Code", '%1|%2|%3', 'AUNING', 'EXP', 'RYOM');
        PL.SETRANGE(PL."Line No.", 10000);
        PL.SETFILTER("Item No.", ItemNoCode);
        IF PL.FINDSET THEN PoAntalOrdreIfilter := PL.COUNT;
    End;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        [WithEvents]
        ReportForNav: DotNet ForNavReport50004_v6_3_0_2250;
        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;

    local procedure ReportsForNavInit();
    var
        ApplicationSystemConstants: Codeunit "Application System Constants";
        addInFileName: Text;
        tempAddInFileName: Text;
        path: DotNet Path;
        ReportForNavObject: Variant;
    begin
        addInFileName := ApplicationPath() + 'Add-ins\ReportsForNAV_6_3_0_2250\ForNav.Reports.6.3.0.2250.dll';
        if not File.Exists(addInFileName) then begin
            tempAddInFileName := path.GetTempPath() + '\Microsoft Dynamics NAV\Add-Ins\' + ApplicationSystemConstants.PlatformFileVersion() + '\ForNav.Reports.6.3.0.2250.dll';
            if not File.Exists(tempAddInFileName) then
                Error('Please install the ForNAV DLL version 6.3.0.2250 in your service tier Add-ins folder under the file name "%1"\\If you already have the ForNAV DLL on the server, you should move it to this folder and rename it to match this file name.', addInFileName);
        end;
        ReportForNavObject := ReportForNav.GetLatest(CurrReport.OBJECTID, CurrReport.Language, SerialNumber, UserId, CompanyName);
        ReportForNav := ReportForNavObject;
        ReportForNav.Init();
    end;

    local procedure ReportsForNavPre();
    begin
        ReportForNav.OpenDesigner := ReportForNavOpenDesigner;
        if not ReportForNav.Pre() then CurrReport.Quit();
    end;

    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
