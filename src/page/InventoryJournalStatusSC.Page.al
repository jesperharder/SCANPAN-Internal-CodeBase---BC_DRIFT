




/// <summary>
/// Page InventoryJournalShelfSC (ID 50026).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.27      Jesper Harder               017     Inventory Journal StockStatus Add Code
/// 
/// </remarks>
page 50026 "InventoryJournalStatusSC"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = 'Inventory Journal Status';
    ApplicationArea = All;
    PageType = Worksheet;
    SourceTable = InventoryJournalStatus;
    SourceTableView = sorting("Ressource ID", "Shelf No.", "Item No.");
    UsageCategory = Lists;

    Editable = true;


    layout
    {

        area(Content)
        {
            group(filter1)
            {
                ShowCaption = false;

                field(JournalBatchName; JournalBatchName)
                {
                    Caption = 'Journal Batch Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';


                    //Item Journal Batch
                    trigger OnDrillDown()
                    var
                        ItemJournalBatch: Record "Item Journal Batch";
                    begin
                        if EmptyWorksheetYesNo() then begin

                            if Page.Runmodal(page::"Item Journal Batches", ItemJournalBatch) = Action::LookupOK then
                                JournalBatchName := ItemJournalBatch.Name;
                            ScanpanMiscellaneous.InventoryJournalFillITable(Rec, JournalBatchName);
                            CurrPage.Update(false);
                        end;
                    end;

                    trigger OnValidate()
                    var
                    begin
                        if EmptyWorksheetYesNo() then ScanpanMiscellaneous.InventoryJournalFillITable(Rec, JournalBatchName);
                        CurrPage.Update(false);
                    end;
                }
                field(RessourceID; RessourceID)
                {
                    Caption = 'Ressource ID';
                    ToolTip = 'Name of the ressource assigned to the task.';
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        InventoryJournalStatus: Record InventoryJournalStatus;
                        InventoryRessource: Record InventoryRessourceID;
                        LastID: Text[30];
                    begin
                        InventoryJournalStatus.FindSet();
                        if InventoryRessource.Insert() then;
                        repeat
                            InventoryRessource.Init();
                            if LastID <> InventoryJournalStatus."Ressource ID" then
                                InventoryRessource."Ressouce ID" := InventoryJournalStatus."Ressource ID";
                            LastID := InventoryRessource."Ressouce ID";
                            if InventoryRessource.Insert() then;
                        until InventoryJournalStatus.Next() = 0;

                        IF PAGE.RUNMODAL(page::InventoryRessources, InventoryRessource) = ACTION::LookupOK THEN
                            RessourceID := InventoryRessource."Ressouce ID";
                        Setfilters();
                    end;

                    trigger OnValidate()
                    begin
                        Setfilters();
                    end;


                }
            }
            repeater(control1)
            {
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';

                }
                field("Ressource ID"; Rec."Ressource ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ressource ID field.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Inventory Journal ID"; Rec."Inventory Journal ID")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory Journal ID field.';
                }
                field("Reported Quatity"; Rec."Reported Quatity")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reported Quantity field.';
                    trigger OnValidate()
                    var
                    begin
                        CalcInventorySums(Rec."Item No.");
                    end;
                }
                field("Base Quantity"; Rec."Base Quantity")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Quantity field.';
                }
                field("Difference Quatity"; Rec."Difference Quatity")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = ToggleDifferenceQuatity;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Difference Quantity field.';

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
            action(UpdateRessourceMap)
            {
                Caption = 'Update Ressource Shelf Map';
                ToolTip = 'Update the ressource shelfs mappings.';
                ApplicationArea = Basic, Suite;

                Image = InventoryCalculation;
                RunObject = Page InventoryMapShelfNoSC;
            }
            action("Transfer Result")
            {
                Caption = 'Transfer Status Result';
                ToolTip = 'Transfers the complete results from Inventory Status.';
                ApplicationArea = Basic, Suite;
                Image = Warning;
                trigger OnAction()
                begin
                    ScanpanMiscellaneous.InventoryJournalWriteBack(Rec, JournalBatchName);
                end;
            }

        }

    }

    var

        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        ToggleDifferenceQuatity: Boolean;
        //ItemJnlMgtCodeUnit: Codeunit ItemJnlManagement;
        //ItemJournalBatchRec: Record "Item Journal Batch";
        JournalBatchName: Code[10];
        RessourceID: Text[20];

    trigger OnInit()
    var

    begin
    end;

    trigger OnOpenPage()
    var
    begin
        if not Rec.IsEmpty then begin
            Rec.FindFirst();
            JournalBatchName := CopyStr(Rec."Inventory Journal ID", 1, 10);
        end;
        if Rec.FindFirst() then;
    end;

    trigger OnAfterGetRecord()
    begin
        ToggleDifferenceQuatity := false;
        if Rec."Difference Quatity" <> "Base Quantity" then
            ToggleDifferenceQuatity := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ToggleDifferenceQuatity := false;
        if Rec."Difference Quatity" <> "Base Quantity" then
            ToggleDifferenceQuatity := true;

    end;










    local procedure Setfilters()
    var
    begin
        Rec.SetRange("Ressource ID");
        if RessourceID <> '' then Rec.SetFilter("Ressource ID", RessourceID);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;



    local procedure CalcInventorySums(ItemNo: code[20]);
    var
        InventoryJournalStatus: Record InventoryJournalStatus;
        SaveView: Text;
        GotoLine: Integer;
        ReportedSum: Decimal;
    begin
        CurrPage.SaveRecord();
        InventoryJournalStatus.CopyFilters(Rec);
        GotoLine := Rec."Line No.";
        SaveView := Rec.GetView();
        Rec.Reset();
        Rec.SetFilter("Item No.", ItemNo);
        ReportedSum := 0;

        //find sum of all base qty for this linje
        Rec.FindSet();
        repeat
            ReportedSum += Rec."Reported Quatity";
        until Rec.Next() = 0;


        //find add reported sum to base sum to sum of all base qty for this linje
        Rec.Reset();
        Rec.SetFilter("Item No.", ItemNo);
        Rec.FindSet();
        repeat
            Rec."Difference Quatity" := ReportedSum - Rec."Base Quantity";
            Rec.Modify();
        until Rec.Next() = 0;
        //Rec.SetRange("Item No.");
        Rec.CopyFilters(InventoryJournalStatus);
        Rec.SetView(SaveView);
        Rec.Get(GotoLine);
        CurrPage.Update(false);

    end;


    local procedure EmptyWorksheetYesNo(): Boolean
    var
        Answer: Boolean;
        Text000Lbl: Label 'This will reset the worksheet. Are you sure?';
        Question: Text;
    begin
        Question := Text000Lbl;
        Answer := Dialog.Confirm(Question, false);
        Exit(Answer);
    end;
}

