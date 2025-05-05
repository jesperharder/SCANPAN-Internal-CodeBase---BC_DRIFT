



report 50015 "CalculateInventory"
{
    AdditionalSearchTerms = 'SCANPAN INVENTORY CALCULATE';
    Caption = 'Scanpan Calculate Inventory';
    UsageCategory = Tasks;
    ApplicationArea = Basic, Suite;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE(Type = CONST(Inventory), Blocked = CONST(false));
            RequestFilterFields = "No.", "Location Filter", "Bin Filter", "Date Filter";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No."),
                                "Variant Code" = FIELD("Variant Filter"),
                                "Location Code" = FIELD("Location Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    ItemVariant: Record "Item Variant";
                    ByBin: Boolean;
                    ExecuteLoop: Boolean;
                    InsertTempSKU: Boolean;
                    IsHandled: Boolean;
                begin
                    if not GetLocation("Location Code") then
                        CurrReport.Skip();

                    if ColumnDim <> '' then
                        TransferDim("Dimension Set ID");

                    if not "Drop Shipment" then
                        ByBin := Location."Bin Mandatory" and not Location."Directed Put-away and Pick";

                    IsHandled := false;
                    OnAfterGetRecordItemLedgEntryOnBeforeUpdateBuffer(Item, "Item Ledger Entry", ByBin, IsHandled);
                    if IsHandled then
                        CurrReport.Skip();

                    if not SkipCycleSKU("Location Code", "Item No.", "Variant Code") then
                        if ByBin then begin
                            if not TempStockkeepingUnitSKU.Get("Location Code", "Item No.", "Variant Code") then begin
                                InsertTempSKU := false;
                                if "Variant Code" = '' then
                                    InsertTempSKU := true
                                else
                                    if ItemVariant.Get("Item No.", "Variant Code") then
                                        InsertTempSKU := true;
                                if InsertTempSKU then begin
                                    TempStockkeepingUnitSKU."Item No." := "Item No.";
                                    TempStockkeepingUnitSKU."Variant Code" := "Variant Code";
                                    TempStockkeepingUnitSKU."Location Code" := "Location Code";
                                    TempStockkeepingUnitSKU.Insert();
                                    ExecuteLoop := true;
                                end;
                            end;
                            if ExecuteLoop then begin
                                WarehouseEntry.SetRange("Item No.", "Item No.");
                                WarehouseEntry.SetRange("Location Code", "Location Code");
                                WarehouseEntry.SetRange("Variant Code", "Variant Code");
                                if WarehouseEntry.Find('-') then
                                    if WarehouseEntry."Entry No." <> OldWarehouseEntry."Entry No." then begin
                                        OldWarehouseEntry := WarehouseEntry;
                                        repeat
                                            WarehouseEntry.SetRange("Bin Code", WarehouseEntry."Bin Code");
                                            if not ItemBinLocationIsCalculated(WarehouseEntry."Bin Code") then begin
                                                WarehouseEntry.CalcSums("Qty. (Base)");
                                                UpdateBuffer(WarehouseEntry."Bin Code", WarehouseEntry."Qty. (Base)", false);
                                            end;
                                            WarehouseEntry.Find('+');
                                            Item.CopyFilter("Bin Filter", WarehouseEntry."Bin Code");
                                        until WarehouseEntry.Next() = 0;
                                    end;
                            end;
                        end else
                            UpdateBuffer('', Quantity, true);
                end;

                trigger OnPreDataItem()
                begin
                    WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code");
                    Item.CopyFilter("Bin Filter", WarehouseEntry."Bin Code");

                    if ColumnDim = '' then
                        TempDimensionBuffer.SetRange("Table ID", DATABASE::Item)
                    else
                        TempDimensionBuffer.SetRange("Table ID", DATABASE::"Item Ledger Entry");
                    TempDimensionBuffer.SetRange("Entry No.");
                    TempDimensionBuffer.DeleteAll();

                    OnItemLedgerEntryOnAfterPreDataItem("Item Ledger Entry", Item);
                end;
            }
            dataitem("Warehouse Entry"; "Warehouse Entry")
            {
                DataItemLink = "Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Filter"), "Location Code" = FIELD("Location Filter");

                trigger OnAfterGetRecord()
                begin
                    if not "Item Ledger Entry".IsEmpty() then
                        CurrReport.Skip();   // Skip if item has any record in Item Ledger Entry.

                    Clear(TempInventoryBuffer);
                    TempInventoryBuffer."Item No." := "Item No.";
                    TempInventoryBuffer."Location Code" := "Location Code";
                    TempInventoryBuffer."Variant Code" := "Variant Code";

                    GetLocation("Location Code");
                    if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                        TempInventoryBuffer."Bin Code" := "Bin Code";

                    OnBeforeQuantityOnHandBufferFindAndInsert(TempInventoryBuffer, "Warehouse Entry");
                    if not TempInventoryBuffer.Find() then
                        TempInventoryBuffer.Insert();   // Insert a zero quantity line.
                end;

                trigger OnPreDataItem()
                begin
                    "Warehouse Entry".SetRange("Registering Date", 0D, Item.GetRangeMax("Date Filter"));
                end;
            }
            dataitem(ItemWithNoTransaction; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                begin
                    if IncludeItemWithNoTransactionBoolean then
                        UpdateQuantityOnHandBuffer(Item."No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OnBeforeItemOnAfterGetRecord(Item);
                if not HideValidationDialog then
                    Window.Update();
                TempStockkeepingUnitSKU.DeleteAll();
            end;

            trigger OnPostDataItem()
            begin
                CalcPhysInvQtyAndInsertItemJnlLine();
            end;

            trigger OnPreDataItem()
            var
                ItemJnlTemplate: Record "Item Journal Template";
                ItemJnlBatch: Record "Item Journal Batch";
            begin
                if PostingDateDate = 0D then
                    Error(Text000Lbl);

                ItemJnlTemplate.Get(ItemJournalLine."Journal Template Name");
                ItemJnlBatch.Get(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");

                OnPreDataItemOnAfterGetItemJnlTemplateAndBatch(ItemJnlTemplate, ItemJnlBatch);

                if NextDocNo = '' then begin
                    if ItemJnlBatch."No. Series" <> '' then begin
                        ItemJournalLine.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
                        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalLine."Journal Batch Name");
                        if not ItemJournalLine.FindFirst() then
                            NextDocNo := NoSeriesManagement.GetNextNo(ItemJnlBatch."No. Series", PostingDateDate, false);
                        ItemJournalLine.Init();
                    end;
                    if NextDocNo = '' then
                        Error(Text001Lbl);
                end;

                NextLineNo := 0;

                if not HideValidationDialog then
                    Window.Open(Text002Lbl, "No.");

                if not SkipDim then
                    SelectedDimension.GetSelectedDim(CopyStr(UserId, 1, 50), 3, REPORT::"Calculate Inventory", '', TempSelectedDimension);

                TempInventoryBuffer.Reset();
                TempInventoryBuffer.DeleteAll();

                OnAfterItemOnPreDataItem(Item, ZeroQty, IncludeItemWithNoTransactionBoolean);
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
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDateDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';

                        trigger OnValidate()
                        begin
                            ValidatePostingDate();
                        end;
                    }
                    field(DocumentNo; NextDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }
                    field(ItemsNotOnInventory; ZeroQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Items Not on Inventory.';
                        ToolTip = 'Specifies if journal lines should be created for items that are not on inventory, that is, items where the value in the Qty. (Calculated) field is 0.';

                        trigger OnValidate()
                        begin
                            if not ZeroQty then
                                IncludeItemWithNoTransactionBoolean := false;
                        end;
                    }
                    field(IncludeItemWithNoTransaction; IncludeItemWithNoTransactionBoolean)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Item without Transactions';
                        ToolTip = 'Specifies if journal lines should be created for items that are not on inventory and are not used in any transactions.';

                        trigger OnValidate()
                        begin
                            if not IncludeItemWithNoTransactionBoolean then
                                exit;
                            if not ZeroQty then
                                Error(ItemNotOnInventoryErr);
                        end;
                    }
                    field(ByDimensions; ColumnDim)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'By Dimensions';
                        Editable = false;
                        ToolTip = 'Specifies the dimensions that you want the batch job to consider.';

                        trigger OnAssistEdit()
                        begin
                            DimensionSelectionBuffer.SetDimSelectionMultiple(3, REPORT::"Calculate Inventory", ColumnDim);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateDate = 0D then
                PostingDateDate := WorkDate();
            ValidatePostingDate();
            ColumnDim := DimensionSelectionBuffer.GetDimSelectionText(3, REPORT::"Calculate Inventory", '');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if SkipDim then
            ColumnDim := ''
        else
            DimensionSelectionBuffer.CompareDimText(3, REPORT::"Calculate Inventory", '', ColumnDim, Text003Lbl);
        ZeroQtySave := ZeroQty;
    end;

    var
        TempDimensionBuffer: Record "Dimension Buffer" temporary;
        TempDimensionBufferOut: Record "Dimension Buffer" temporary;
        DimensionSelectionBuffer: Record "Dimension Selection Buffer";
        DimensionSetEntry: Record "Dimension Set Entry";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        TempInventoryBuffer: Record "Inventory Buffer" temporary;
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        Location: Record Location;
        SelectedDimension: Record "Selected Dimension";
        TempSelectedDimension: Record "Selected Dimension" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        TempStockkeepingUnitSKU: Record "Stockkeeping Unit" temporary;
        OldWarehouseEntry: Record "Warehouse Entry";
        WarehouseEntry: Record "Warehouse Entry";
        DimensionBufferManagement: Codeunit "Dimension Buffer Management";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        AdjustPosQty: Boolean;
        IncludeItemWithNoTransactionBoolean: Boolean;
        ItemTrackingSplit: Boolean;
        SkipDim: Boolean;
        ZeroQty: Boolean;
        ZeroQtySave: Boolean;
        PhysInvtCountCode: Code[10];
        NextDocNo: Code[20];
        PostingDateDate: Date;
        NegQty: Decimal;
        PosQty: Decimal;
        Window: Dialog;
        NextLineNo: Integer;
        ItemNotOnInventoryErr: Label 'Items Not on Inventory.';
        Text000Lbl: Label 'Enter the posting date.';
        Text001Lbl: Label 'Enter the document no.';
        Text002Lbl: Label 'Processing items    #1##########', Comment = '#1 = Item No. being processed.';
        Text003Lbl: Label 'Retain Dimensions';
        CycleSourceType: Option " ",Item,SKU;
        ColumnDim: Text[250];

    protected var
        HideValidationDialog: Boolean;

    procedure SetItemJnlLine(var NewItemJnlLine: Record "Item Journal Line")
    begin
        ItemJournalLine := NewItemJnlLine;
    end;

    local procedure ValidatePostingDate()
    begin
        ItemJournalBatch.Get(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        if ItemJournalBatch."No. Series" = '' then
            NextDocNo := ''
        else begin
            NextDocNo := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", PostingDateDate, false);
            Clear(NoSeriesManagement);
        end;
    end;

    procedure InsertItemJnlLine(ItemNo: Code[20]; VariantCode2: Code[10]; DimEntryNo2: Integer; BinCode2: Code[20]; Quantity2: Decimal; PhysInvQuantity: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Bin: Record Bin;
        DimValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        NoBinExist: Boolean;
    begin
        OnBeforeFunctionInsertItemJnlLine(ItemNo, VariantCode2, DimEntryNo2, BinCode2, Quantity2, PhysInvQuantity);

        with ItemJournalLine do begin
            if NextLineNo = 0 then begin
                LockTable();
                SetRange("Journal Template Name", "Journal Template Name");
                SetRange("Journal Batch Name", "Journal Batch Name");
                if FindLast() then
                    NextLineNo := "Line No.";

                SourceCodeSetup.Get();
            end;
            NextLineNo := NextLineNo + 10000;

            if (Quantity2 <> 0) or ZeroQty then begin
                if (Quantity2 = 0) and Location."Bin Mandatory" and not Location."Directed Put-away and Pick"
                then
                    if not Bin.Get(Location.Code, BinCode2) then
                        NoBinExist := true;

                OnInsertItemJnlLineOnBeforeInit(ItemJournalLine);

                Init();
                "Line No." := NextLineNo;
                Validate("Posting Date", PostingDateDate);
                if PhysInvQuantity >= Quantity2 then
                    Validate("Entry Type", "Entry Type"::"Positive Adjmt.")
                else
                    Validate("Entry Type", "Entry Type"::"Negative Adjmt.");
                Validate("Document No.", NextDocNo);
                Validate("Item No.", ItemNo);
                Validate("Variant Code", VariantCode2);
                Validate("Location Code", Location.Code);
                if not NoBinExist then
                    Validate("Bin Code", BinCode2)
                else
                    Validate("Bin Code", '');
                Validate("Source Code", SourceCodeSetup."Phys. Inventory Journal");
                "Qty. (Phys. Inventory)" := PhysInvQuantity;
                "Phys. Inventory" := true;
                Validate("Qty. (Calculated)", Quantity2);
                "Posting No. Series" := ItemJournalBatch."Posting No. Series";
                "Reason Code" := ItemJournalBatch."Reason Code";

                "Phys Invt Counting Period Code" := PhysInvtCountCode;
                "Phys Invt Counting Period Type" := CycleSourceType;

                if Location."Bin Mandatory" then
                    "Dimension Set ID" := 0;
                "Shortcut Dimension 1 Code" := '';
                "Shortcut Dimension 2 Code" := '';

                ItemLedgEntry.Reset();
                ItemLedgEntry.SetCurrentKey("Item No.");
                ItemLedgEntry.SetRange("Item No.", ItemNo);
                if ItemLedgEntry.FindLast() then
                    "Last Item Ledger Entry No." := ItemLedgEntry."Entry No."
                else
                    "Last Item Ledger Entry No." := 0;

                OnBeforeInsertItemJnlLine(ItemJournalLine, TempInventoryBuffer);
                Insert(true);
                OnAfterInsertItemJnlLine(ItemJournalLine);

                if Location.Code <> '' then
                    if Location."Directed Put-away and Pick" then
                        ReserveWarehouse(ItemJournalLine);

                if ColumnDim = '' then
                    DimEntryNo2 := CreateDimFromItemDefault();

                if DimensionBufferManagement.GetDimensions(DimEntryNo2, TempDimensionBufferOut) then begin
                    TempDimensionSetEntry.Reset();
                    TempDimensionSetEntry.DeleteAll();
                    if TempDimensionBufferOut.Find('-') then begin
                        repeat
                            DimValue.Get(TempDimensionBufferOut."Dimension Code", TempDimensionBufferOut."Dimension Value Code");
                            TempDimensionSetEntry."Dimension Code" := TempDimensionBufferOut."Dimension Code";
                            TempDimensionSetEntry."Dimension Value Code" := TempDimensionBufferOut."Dimension Value Code";
                            TempDimensionSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
                            if TempDimensionSetEntry.Insert() then;
                            "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimensionSetEntry);
                            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID",
                              "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                            Modify();
                        until TempDimensionBufferOut.Next() = 0;
                        TempDimensionBufferOut.DeleteAll();
                    end;
                end;
            end;
        end;

        OnAfterFunctionInsertItemJnlLine(ItemNo, VariantCode2, DimEntryNo2, BinCode2, Quantity2, PhysInvQuantity, ItemJournalLine);
    end;

    local procedure InsertQuantityOnHandBuffer(ItemNo: Code[20]; LocationCode: Code[10]; VariantCode: Code[10])
    begin
        with TempInventoryBuffer do begin
            Reset();
            SetRange("Item No.", ItemNo);
            SetRange("Location Code", LocationCode);
            SetRange("Variant Code", VariantCode);
            if not FindFirst() then begin
                Reset();
                Init();
                "Item No." := ItemNo;
                "Location Code" := LocationCode;
                "Variant Code" := VariantCode;
                "Bin Code" := '';
                "Dimension Entry No." := 0;
                Insert(true);
            end;
        end;
    end;

    local procedure ReserveWarehouse(ItemJournalLine: Record "Item Journal Line")
    var
        ReservationEntry: Record "Reservation Entry";
        WarehouseEntry1: Record "Warehouse Entry";
        WarehouseEntry2: Record "Warehouse Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OrderLineNo: Integer;
        EntryType: Option "Negative Adjmt.","Positive Adjmt.";
    begin
        with ItemJournalLine do begin
            WarehouseEntry1.SetCurrentKey(
                "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code",
                "Lot No.", "Serial No.", "Entry Type");
            WarehouseEntry1.SetRange("Item No.", "Item No.");
            WarehouseEntry1.SetRange("Bin Code", Location."Adjustment Bin Code");
            WarehouseEntry1.SetRange("Location Code", "Location Code");
            WarehouseEntry1.SetRange("Variant Code", "Variant Code");
            if "Entry Type" = "Entry Type"::"Positive Adjmt." then
                EntryType := EntryType::"Negative Adjmt.";
            if "Entry Type" = "Entry Type"::"Negative Adjmt." then
                EntryType := EntryType::"Positive Adjmt.";
            OnAfterWhseEntrySetFilters(WarehouseEntry1, ItemJournalLine);
            WarehouseEntry1.SetRange("Entry Type", EntryType);
            if WarehouseEntry1.Find('-') then
                repeat
                    WarehouseEntry1.SetTrackingFilterFromWhseEntry(WarehouseEntry1);
                    WarehouseEntry1.CalcSums("Qty. (Base)");

                    WarehouseEntry2.SetCurrentKey(
                        "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code",
                        "Lot No.", "Serial No.", "Entry Type");
                    WarehouseEntry2.CopyFilters(WarehouseEntry1);
                    case EntryType of
                        EntryType::"Positive Adjmt.":
                            WarehouseEntry2.SetRange("Entry Type", WarehouseEntry2."Entry Type"::"Negative Adjmt.");
                        EntryType::"Negative Adjmt.":
                            WarehouseEntry2.SetRange("Entry Type", WarehouseEntry2."Entry Type"::"Positive Adjmt.");
                    end;
                    OnReserveWarehouseOnAfterWhseEntry2SetFilters(ItemJournalLine, WarehouseEntry1, WarehouseEntry2, EntryType);
                    WarehouseEntry2.CalcSums("Qty. (Base)");
                    if Abs(WarehouseEntry2."Qty. (Base)") > Abs(WarehouseEntry1."Qty. (Base)") then
                        WarehouseEntry1."Qty. (Base)" := 0
                    else
                        WarehouseEntry1."Qty. (Base)" := WarehouseEntry1."Qty. (Base)" + WarehouseEntry2."Qty. (Base)";

                    if WarehouseEntry1."Qty. (Base)" <> 0 then begin
                        if "Order Type" = "Order Type"::Production then
                            OrderLineNo := "Order Line No.";
                        ReservationEntry.CopyTrackingFromWhseEntry(WarehouseEntry1);
                        CreateReservEntry.CreateReservEntryFor(
                            DATABASE::"Item Journal Line", "Entry Type".AsInteger(), "Journal Template Name", "Journal Batch Name", OrderLineNo,
                            "Line No.", "Qty. per Unit of Measure",
                            Abs(WarehouseEntry1.Quantity), Abs(WarehouseEntry1."Qty. (Base)"), ReservationEntry);
                        if WarehouseEntry1."Qty. (Base)" < 0 then             // only Date on positive adjustments
                            CreateReservEntry.SetDates(WarehouseEntry1."Warranty Date", WarehouseEntry1."Expiration Date");
                        CreateReservEntry.CreateEntry(
                            "Item No.", "Variant Code", "Location Code", Description, 0D, 0D, 0, "Reservation Status"::Prospect);
                    end;
                    WarehouseEntry1.Find('+');
                    WarehouseEntry1.ClearTrackingFilter();
                until WarehouseEntry1.Next() = 0;
        end;
    end;

    procedure InitializeRequest(NewPostingDate: Date; DocNo: Code[20]; ItemsNotOnInvt: Boolean; InclItemWithNoTrans: Boolean)
    begin
        PostingDateDate := NewPostingDate;
        NextDocNo := DocNo;
        ZeroQty := ItemsNotOnInvt;
        IncludeItemWithNoTransactionBoolean := InclItemWithNoTrans and ZeroQty;
        if not SkipDim then
            ColumnDim := DimensionSelectionBuffer.GetDimSelectionText(3, REPORT::"Calculate Inventory", '');
    end;

    local procedure TransferDim(DimSetID: Integer)
    begin
        DimensionSetEntry.SetRange("Dimension Set ID", DimSetID);
        if DimensionSetEntry.Find('-') then
            repeat
                if TempSelectedDimension.Get(
                     UserId, 3, REPORT::"Calculate Inventory", '', DimensionSetEntry."Dimension Code")
                then
                    InsertDim(DATABASE::"Item Ledger Entry", DimSetID, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code");
            until DimensionSetEntry.Next() = 0;
    end;


    local procedure CalcWhseQty(AdjmtBin: Code[20]; var PosQuantity: Decimal; var NegQuantity: Decimal)
    var
        WhseItemTrackingSetup: Record "Item Tracking Setup";
        WarehouseEntry1: Record "Warehouse Entry";
        WarehouseEntry2: Record "Warehouse Entry";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        NoWhseEntry: Boolean;
        NoWhseEntry2: Boolean;
        WhseQuantity: Decimal;
    begin
        AdjustPosQty := false;
        with TempInventoryBuffer do begin
            ItemTrackingManagement.GetWhseItemTrkgSetup("Item No.", WhseItemTrackingSetup);
            ItemTrackingSplit := WhseItemTrackingSetup.TrackingRequired();
            WarehouseEntry1.SetCurrentKey(
              "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code",
              "Lot No.", "Serial No.", "Entry Type");

            WarehouseEntry1.SetRange("Item No.", "Item No.");
            WarehouseEntry1.SetRange("Location Code", "Location Code");
            WarehouseEntry1.SetRange("Variant Code", "Variant Code");

            //Fix datefilter
            WarehouseEntry1.SetRange("Registering Date", 0D, Item.GetRangeMax("Date Filter"));

            WarehouseEntry1.CalcSums("Qty. (Base)");
            WhseQuantity := WarehouseEntry1."Qty. (Base)";
            WarehouseEntry1.SetRange("Bin Code", AdjmtBin);

            if WhseItemTrackingSetup."Serial No. Required" then begin
                WarehouseEntry1.SetRange("Entry Type", WarehouseEntry1."Entry Type"::"Positive Adjmt.");
                WarehouseEntry1.CalcSums("Qty. (Base)");
                PosQuantity := WhseQuantity - WarehouseEntry1."Qty. (Base)";
                WarehouseEntry1.SetRange("Entry Type", WarehouseEntry1."Entry Type"::"Negative Adjmt.");
                WarehouseEntry1.CalcSums("Qty. (Base)");
                NegQuantity := WhseQuantity - WarehouseEntry1."Qty. (Base)";
                WarehouseEntry1.SetRange("Entry Type", WarehouseEntry1."Entry Type"::Movement);
                WarehouseEntry1.CalcSums("Qty. (Base)");
                if WarehouseEntry1."Qty. (Base)" <> 0 then
                    if WarehouseEntry1."Qty. (Base)" > 0 then
                        PosQuantity := PosQuantity + WhseQuantity - WarehouseEntry1."Qty. (Base)"
                    else
                        NegQuantity := NegQuantity - WhseQuantity - WarehouseEntry1."Qty. (Base)";


                WarehouseEntry1.SetRange("Entry Type", WarehouseEntry1."Entry Type"::"Positive Adjmt.");
                if WarehouseEntry1.Find('-') then begin
                    repeat
                        WarehouseEntry1.SetRange("Serial No.", WarehouseEntry1."Serial No.");

                        WarehouseEntry2.Reset();
                        WarehouseEntry2.SetCurrentKey(
                          "Item No.", "Bin Code", "Location Code", "Variant Code",
                          "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type");

                        WarehouseEntry2.CopyFilters(WarehouseEntry1);
                        WarehouseEntry2.SetRange("Entry Type", WarehouseEntry2."Entry Type"::"Negative Adjmt.");
                        WarehouseEntry2.SetRange("Serial No.", WarehouseEntry1."Serial No.");
                        if WarehouseEntry2.Find('-') then
                            repeat
                                PosQuantity := PosQuantity + 1;
                                NegQuantity := NegQuantity - 1;
                                NoWhseEntry := WarehouseEntry1.Next() = 0;
                                NoWhseEntry2 := WarehouseEntry2.Next() = 0;
                            until NoWhseEntry2 or NoWhseEntry
                        else
                            AdjustPosQty := true;

                        if not NoWhseEntry and NoWhseEntry2 then
                            AdjustPosQty := true;

                        WarehouseEntry1.Find('+');
                        WarehouseEntry1.SetRange("Serial No.");
                    until WarehouseEntry1.Next() = 0;
                end;
            end else begin
                if WarehouseEntry1.Find('-') then
                    repeat
                        WarehouseEntry1.SetRange("Lot No.", WarehouseEntry1."Lot No.");
                        OnCalcWhseQtyOnAfterLotRequiredWhseEntrySetFilters(WarehouseEntry1);
                        WarehouseEntry1.CalcSums("Qty. (Base)");
                        if WarehouseEntry1."Qty. (Base)" <> 0 then begin
                            if WarehouseEntry1."Qty. (Base)" > 0 then
                                NegQuantity := NegQuantity - WarehouseEntry1."Qty. (Base)"
                            else
                                PosQuantity := PosQuantity + WarehouseEntry1."Qty. (Base)";
                        end;
                        WarehouseEntry1.Find('+');
                        WarehouseEntry1.SetRange("Lot No.");
                        OnCalcWhseQtyOnAfterLotRequiredWhseEntryClearFilters(WarehouseEntry1);
                    until WarehouseEntry1.Next() = 0;
                if PosQuantity <> WhseQuantity then
                    PosQuantity := WhseQuantity - PosQuantity;
                if NegQuantity <> -WhseQuantity then
                    NegQuantity := WhseQuantity + NegQuantity;
            end;
        end;
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure InitializePhysInvtCount(PhysInvtCountCode2: Code[10]; CountSourceType2: Option " ",Item,SKU)
    begin
        PhysInvtCountCode := PhysInvtCountCode2;
        CycleSourceType := CountSourceType2;
    end;

    local procedure SkipCycleSKU(LocationCode: Code[10]; ItemNo: Code[20]; VariantCode: Code[10]): Boolean
    var
        SKU: Record "Stockkeeping Unit";
    begin
        if CycleSourceType = CycleSourceType::Item then
            if SKU.ReadPermission then
                if SKU.Get(LocationCode, ItemNo, VariantCode) then
                    exit(true);
        exit(false);
    end;

    procedure GetLocation(LocationCode: Code[10]): Boolean
    begin
        if LocationCode = '' then begin
            Clear(Location);
            exit(true);
        end;

        if Location.Code <> LocationCode then
            if not Location.Get(LocationCode) then
                exit(false);

        exit(true);
    end;

    local procedure UpdateBuffer(BinCode: Code[20]; NewQuantity: Decimal; CalledFromItemLedgerEntry: Boolean)
    var
        DimEntryNo: Integer;
    begin
        with TempInventoryBuffer do begin
            if not HasNewQuantity(NewQuantity) then
                exit;
            if BinCode = '' then begin
                if ColumnDim <> '' then
                    TempDimensionBuffer.SetRange("Entry No.", "Item Ledger Entry"."Dimension Set ID");
                DimEntryNo := DimensionBufferManagement.FindDimensions(TempDimensionBuffer);
                if DimEntryNo = 0 then
                    DimEntryNo := DimensionBufferManagement.InsertDimensions(TempDimensionBuffer);
            end;
            if RetrieveBuffer(BinCode, DimEntryNo) then begin
                Quantity := Quantity + NewQuantity;
                OnUpdateBufferOnBeforeModify(TempInventoryBuffer, CalledFromItemLedgerEntry);
                Modify;
            end else begin
                Quantity := NewQuantity;
                OnUpdateBufferOnBeforeInsert(TempInventoryBuffer, CalledFromItemLedgerEntry);
                Insert;
            end;
        end;
    end;

    local procedure RetrieveBuffer(BinCode: Code[20]; DimEntryNo: Integer): Boolean
    begin
        with TempInventoryBuffer do begin
            Reset;
            "Item No." := "Item Ledger Entry"."Item No.";
            "Variant Code" := "Item Ledger Entry"."Variant Code";
            "Location Code" := "Item Ledger Entry"."Location Code";
            "Dimension Entry No." := DimEntryNo;
            "Bin Code" := BinCode;
            OnRetrieveBufferOnBeforeFind(TempInventoryBuffer, "Item Ledger Entry");
            exit(Find);
        end;
    end;

    local procedure HasNewQuantity(NewQuantity: Decimal): Boolean
    begin
        exit((NewQuantity <> 0) or ZeroQty);
    end;

    local procedure ItemBinLocationIsCalculated(BinCode: Code[20]): Boolean
    begin
        with TempInventoryBuffer do begin
            Reset;
            SetRange("Item No.", "Item Ledger Entry"."Item No.");
            SetRange("Variant Code", "Item Ledger Entry"."Variant Code");
            SetRange("Location Code", "Item Ledger Entry"."Location Code");
            SetRange("Bin Code", BinCode);
            exit(Find('-'));
        end;
    end;

    procedure SetSkipDim(NewSkipDim: Boolean)
    begin
        SkipDim := NewSkipDim;
    end;

    local procedure UpdateQuantityOnHandBuffer(ItemNo: Code[20])
    var
        Location: Record Location;
        ItemVariant: Record "Item Variant";
    begin
        ItemVariant.SetRange("Item No.", Item."No.");
        Item.CopyFilter("Variant Filter", ItemVariant.Code);
        Item.CopyFilter("Location Filter", Location.Code);
        Location.SetRange("Use As In-Transit", false);
        if (Item.GetFilter("Location Filter") <> '') and Location.FindSet then
            repeat
                if (Item.GetFilter("Variant Filter") <> '') and ItemVariant.FindSet then
                    repeat
                        InsertQuantityOnHandBuffer(ItemNo, Location.Code, ItemVariant.Code);
                    until ItemVariant.Next() = 0
                else
                    InsertQuantityOnHandBuffer(ItemNo, Location.Code, '');
            until Location.Next() = 0
        else
            if (Item.GetFilter("Variant Filter") <> '') and ItemVariant.FindSet then
                repeat
                    InsertQuantityOnHandBuffer(ItemNo, '', ItemVariant.Code);
                until ItemVariant.Next() = 0
            else
                InsertQuantityOnHandBuffer(ItemNo, '', '');
    end;

    local procedure CalcPhysInvQtyAndInsertItemJnlLine()
    begin
        with TempInventoryBuffer do begin
            Reset;
            if FindSet then begin
                repeat
                    PosQty := 0;
                    NegQty := 0;

                    GetLocation("Location Code");
                    if Location."Directed Put-away and Pick" then
                        CalcWhseQty(Location."Adjustment Bin Code", PosQty, NegQty);

                    if (NegQty - Quantity <> Quantity - PosQty) or ItemTrackingSplit then begin
                        if PosQty = Quantity then
                            PosQty := 0;
                        if (PosQty <> 0) or AdjustPosQty then
                            InsertItemJnlLine(
                              "Item No.", "Variant Code", "Dimension Entry No.",
                              "Bin Code", Quantity, PosQty);

                        if NegQty = Quantity then
                            NegQty := 0;
                        if NegQty <> 0 then begin
                            if ((PosQty <> 0) or AdjustPosQty) and not ItemTrackingSplit then begin
                                NegQty := NegQty - Quantity;
                                Quantity := 0;
                                ZeroQty := true;
                            end;
                            if NegQty = -Quantity then begin
                                NegQty := 0;
                                AdjustPosQty := true;
                            end;
                            InsertItemJnlLine(
                              "Item No.", "Variant Code", "Dimension Entry No.",
                              "Bin Code", Quantity, NegQty);

                            ZeroQty := ZeroQtySave;
                        end;
                    end else begin
                        PosQty := 0;
                        NegQty := 0;
                    end;

                    OnCalcPhysInvQtyAndInsertItemJnlLineOnBeforeCheckIfInsertNeeded(TempInventoryBuffer);
                    if (PosQty = 0) and (NegQty = 0) and not AdjustPosQty then
                        InsertItemJnlLine(
                          "Item No.", "Variant Code", "Dimension Entry No.",
                          "Bin Code", Quantity, Quantity);
                until Next() = 0;
                DeleteAll();
            end;
        end;
    end;

    local procedure CreateDimFromItemDefault() DimEntryNo: Integer
    var
        DefaultDimension: Record "Default Dimension";
    begin
        with DefaultDimension do begin
            SetRange("No.", TempInventoryBuffer."Item No.");
            SetRange("Table ID", DATABASE::Item);
            SetFilter("Dimension Value Code", '<>%1', '');
            if FindSet then
                repeat
                    InsertDim(DATABASE::Item, 0, "Dimension Code", "Dimension Value Code");
                until Next() = 0;
        end;

        DimEntryNo := DimensionBufferManagement.InsertDimensions(TempDimensionBuffer);
        TempDimensionBuffer.SetRange("Table ID", DATABASE::Item);
        TempDimensionBuffer.DeleteAll();
    end;

    local procedure InsertDim(TableID: Integer; EntryNo: Integer; DimCode: Code[20]; DimValueCode: Code[20])
    begin
        with TempDimensionBuffer do begin
            Init;
            "Table ID" := TableID;
            "Entry No." := EntryNo;
            "Dimension Code" := DimCode;
            "Dimension Value Code" := DimValueCode;
            if Insert() then;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordItemLedgEntryOnBeforeUpdateBuffer(var Item: Record Item; ItemLedgEntry: Record "Item Ledger Entry"; var ByBin: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterItemOnPreDataItem(var Item: Record Item; ZeroQty: Boolean; IncludeItemWithNoTransaction: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterWhseEntrySetFilters(var WarehouseEntry: Record "Warehouse Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnItemLedgerEntryOnAfterPreDataItem(var ItemLedgerEntry: Record "Item Ledger Entry"; var Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertItemJnlLineOnBeforeInit(var ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeItemOnAfterGetRecord(var Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFunctionInsertItemJnlLine(ItemNo: Code[20]; VariantCode2: Code[10]; DimEntryNo2: Integer; BinCode2: Code[20]; Quantity2: Decimal; PhysInvQuantity: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; var InventoryBuffer: Record "Inventory Buffer");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeQuantityOnHandBufferFindAndInsert(var InventoryBuffer: Record "Inventory Buffer"; WarehouseEntry: Record "Warehouse Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFunctionInsertItemJnlLine(ItemNo: Code[20]; VariantCode2: Code[10]; DimEntryNo2: Integer; BinCode2: Code[20]; Quantity2: Decimal; PhysInvQuantity: Decimal; var ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcPhysInvQtyAndInsertItemJnlLineOnBeforeCheckIfInsertNeeded(InventoryBuffer: Record "Inventory Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcWhseQtyOnAfterLotRequiredWhseEntryClearFilters(var WarehouseEntry: Record "Warehouse Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcWhseQtyOnAfterLotRequiredWhseEntrySetFilters(var WarehouseEntry: Record "Warehouse Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreDataItemOnAfterGetItemJnlTemplateAndBatch(var ItemJournalTemplate: Record "Item Journal Template"; var ItemJournalBatch: Record "Item Journal Batch")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRetrieveBufferOnBeforeFind(var InventoryBuffer: Record "Inventory Buffer"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReserveWarehouseOnAfterWhseEntry2SetFilters(var ItemJournalLine: Record "Item Journal Line"; var WarehouseEntry: Record "Warehouse Entry"; var WhseEntry2: Record "Warehouse Entry"; EntryType: Option)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateBufferOnBeforeInsert(var InventoryBuffer: Record "Inventory Buffer"; CalledFromItemLedgerEntry: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateBufferOnBeforeModify(var InventoryBuffer: Record "Inventory Buffer"; CalledFromItemLedgerEntry: Boolean)
    begin
    end;
}

