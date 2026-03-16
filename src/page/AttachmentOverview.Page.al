page 50095 "Attachment Overview"
{
    PageType = List;
    SourceTable = "Document Attachment";
    SourceTableTemporary = true;
    Caption = 'Attachment Overview';
    UsageCategory = Tasks;
    ApplicationArea = All;

    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Input)
            {
                Caption = 'Input';
                field(PostedDocType; PostedDocType)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Doc Type';
                    ToolTip = 'Vælg typen af bogført dokument. Bruges sammen med nummeret til at hente vedhæftede filer.';
                }
                field(PostedDocNo; PostedDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Doc No.';
                    ToolTip = 'Indtast nummer på den bogførte faktura/kreditnota. Tryk Enter for at hente vedhæftninger.';
                    trigger OnValidate()
                    var
                        IsEmpty: Boolean;
                    begin
                        IsEmpty := (PostedDocNo = '');
                        if not IsEmpty then
                            LoadForPosted(PostedDocType, PostedDocNo)
                        else begin
                            // Clear the result if user clears the input
                            Rec.DeleteAll();
                            Clear(ProcessedSalesHeaderNos);
                            Clear(ProcessedSalesLineKeys);
                            CurrPage.Update(false);
                        end;
                    end;
                }
            }

            repeater(Result)
            {
                Editable = false;
                Caption = 'Result';
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unikt ID for vedhæftningen (fra "Document Attachment").';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Kildetabel for vedhæftningen (f.eks. Sales Invoice Header/Line, Sales Header/Line).';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Kildepostens nummer (f.eks. dokumentnr. eller salgsordre).';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Linjenummeret, hvis vedhæftningen er knyttet til en linje.';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Navnet på filen uden filendelse.';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Filendelsen (f.eks. pdf, jpg).';
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Filtypen registreret i vedhæftningen.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Dato hvor filen blev vedhæftet.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Dokumenttypen fra kilden (hvis relevant).';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Load)
            {
                ApplicationArea = All;
                Caption = 'Load Attachments';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Hent vedhæftninger for det valgte bogførte dokument. Samme effekt som at trykke Enter i feltet "Posted Doc No.".';
                trigger OnAction()
                begin
                    if PostedDocNo = '' then
                        Error('Please enter a posted document number.');
                    LoadForPosted(PostedDocType, PostedDocNo);
                end;
            }

            action(OpenAttachment)
            {
                ApplicationArea = All;
                Caption = 'Open Selected';
                Image = Attach;
                ToolTip = 'Download den valgte vedhæftning til din enhed.';
                trigger OnAction()
                begin
                    OpenCurrentAttachment();
                end;
            }
        }
    }

    var
        PostedDocType: Option "Invoice","Credit Memo";
        PostedDocNo: Code[20];
        ProcessedSalesHeaderNos: List of [Code[20]];
        ProcessedSalesLineKeys: Dictionary of [Text, Boolean];

    local procedure LoadForPosted(PostedType: Option "Invoice","Credit Memo"; DocNo: Code[20])
    var
        SIL: Record "Sales Invoice Line";
        SCML: Record "Sales Cr.Memo Line";
        TempAtt: Record "Document Attachment" temporary;
    begin
        Rec.DeleteAll();
        Clear(ProcessedSalesHeaderNos);
        Clear(ProcessedSalesLineKeys);

        case PostedType of
            PostedType::Invoice:
                begin
                    Clear(TempAtt);
                    GetAttachmentsFromPostedHeader(DATABASE::"Sales Invoice Header", DocNo, TempAtt);
                    InsertIntoPageBuffer(TempAtt);

                    SIL.SetRange("Document No.", DocNo);
                    if SIL.FindSet(true, false) then
                        repeat
                            Clear(TempAtt);
                            GetAttachmentsFromPostedLine(DATABASE::"Sales Invoice Line", SIL."Document No.", SIL."Line No.", TempAtt);
                            InsertIntoPageBuffer(TempAtt);

                            if SIL."Order No." <> '' then begin
                                Clear(TempAtt);
                                GetAttachmentsFromSalesHeader(SIL."Order No.", TempAtt);
                                InsertIntoPageBuffer(TempAtt);

                                Clear(TempAtt);
                                GetAttachmentsFromSalesLine(SIL."Order No.", SIL."Order Line No.", TempAtt);
                                InsertIntoPageBuffer(TempAtt);
                            end;
                        until SIL.Next() = 0;
                end;

            PostedType::"Credit Memo":
                begin
                    Clear(TempAtt);
                    GetAttachmentsFromPostedHeader(DATABASE::"Sales Cr.Memo Header", DocNo, TempAtt);
                    InsertIntoPageBuffer(TempAtt);

                    SCML.SetRange("Document No.", DocNo);
                    if SCML.FindSet(true, false) then
                        repeat
                            Clear(TempAtt);
                            GetAttachmentsFromPostedLine(DATABASE::"Sales Cr.Memo Line", SCML."Document No.", SCML."Line No.", TempAtt);
                            InsertIntoPageBuffer(TempAtt);

                            if SCML."Order No." <> '' then begin
                                Clear(TempAtt);
                                GetAttachmentsFromSalesHeader(SCML."Order No.", TempAtt);
                                InsertIntoPageBuffer(TempAtt);

                                Clear(TempAtt);
                                GetAttachmentsFromSalesLine(SCML."Order No.", SCML."Order Line No.", TempAtt);
                                InsertIntoPageBuffer(TempAtt);
                            end;
                        until SCML.Next() = 0;
                end;
        end;

        CurrPage.Update(false);
    end;

    local procedure GetAttachmentsFromPostedHeader(TableId: Integer; DocNo: Code[20]; var TempAtt: Record "Document Attachment" temporary)
    var
        DocAtt: Record "Document Attachment";
    begin
        DocAtt.SetRange("Table ID", TableId);
        DocAtt.SetRange("No.", DocNo);
        if DocAtt.FindSet(true, false) then
            repeat
                TempAtt := DocAtt;
                TempAtt.Insert();
            until DocAtt.Next() = 0;
    end;

    local procedure GetAttachmentsFromPostedLine(TableId: Integer; DocNo: Code[20]; LineNo: Integer; var TempAtt: Record "Document Attachment" temporary)
    var
        DocAtt: Record "Document Attachment";
    begin
        DocAtt.SetRange("Table ID", TableId);
        DocAtt.SetRange("No.", DocNo);
        DocAtt.SetRange("Line No.", LineNo);
        if DocAtt.FindSet(true, false) then
            repeat
                TempAtt := DocAtt;
                TempAtt.Insert();
            until DocAtt.Next() = 0;
    end;

    local procedure GetAttachmentsFromSalesHeader(SalesHeaderNo: Code[20]; var TempAtt: Record "Document Attachment" temporary)
    var
        DocAtt: Record "Document Attachment";
    begin
        if SalesHeaderNo = '' then
            exit;

        if ProcessedSalesHeaderNos.Contains(SalesHeaderNo) then
            exit;
        ProcessedSalesHeaderNos.Add(SalesHeaderNo);

        DocAtt.SetRange("Table ID", DATABASE::"Sales Header"); // 36
        DocAtt.SetRange("No.", SalesHeaderNo);
        if DocAtt.FindSet(true, false) then
            repeat
                TempAtt := DocAtt;
                TempAtt.Insert();
            until DocAtt.Next() = 0;
    end;

    local procedure GetAttachmentsFromSalesLine(SalesOrderNo: Code[20]; SalesOrderLineNo: Integer; var TempAtt: Record "Document Attachment" temporary)
    var
        DocAtt: Record "Document Attachment";
        keyTxt: Text;
        exists: Boolean;
    begin
        if (SalesOrderNo = '') or (SalesOrderLineNo = 0) then
            exit;

        keyTxt := StrSubstNo('%1|%2', SalesOrderNo, Format(SalesOrderLineNo));
        exists := false;
        if ProcessedSalesLineKeys.ContainsKey(keyTxt) then
            exists := ProcessedSalesLineKeys.Get(keyTxt);
        if exists then
            exit;

        ProcessedSalesLineKeys.Add(keyTxt, true);

        DocAtt.SetRange("Table ID", DATABASE::"Sales Line"); // 37
        DocAtt.SetRange("No.", SalesOrderNo);
        DocAtt.SetRange("Line No.", SalesOrderLineNo);
        if DocAtt.FindSet(true, false) then
            repeat
                TempAtt := DocAtt;
                TempAtt.Insert();
            until DocAtt.Next() = 0;
    end;

    local procedure InsertIntoPageBuffer(var TempAtt: Record "Document Attachment" temporary)
    var
        Already: Boolean;
    begin
        if TempAtt.FindSet() then
            repeat
                Already := Rec.Get(
                    TempAtt."Table ID",
                    TempAtt."No.",
                    TempAtt."Document Type",
                    TempAtt."Line No.",
                    TempAtt.ID);

                if not Already then begin
                    Rec := TempAtt;
                    Rec.Insert(); // unique in temp
                end;
            until TempAtt.Next() = 0;
    end;

    local procedure OpenCurrentAttachment()
    var
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
        InS: InStream;
        FullFileName: Text;
    begin
        if Rec.ID = 0 then
            exit;

        if not Rec."Document Reference ID".HasValue() then
            Error('No file is attached on this line.');

        FullFileName := Rec."File Name";
        if Rec."File Extension" <> '' then
            FullFileName := StrSubstNo('%1.%2', FullFileName, Rec."File Extension");

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutS);
        Rec."Document Reference ID".ExportStream(OutS);
        TempBlob.CreateInStream(InS);
        DownloadFromStream(InS, '', '', '', FullFileName);
    end;
}
