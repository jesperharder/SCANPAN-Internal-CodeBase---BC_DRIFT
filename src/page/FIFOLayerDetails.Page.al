///<summary>
/// 2025.11             Jesper Harder       117.1       Created new page for viewing bin content FIFO information, including oldest entry date, average age in days, and number of FIFO layers.
///</summary>

page 50056 "FIFO Layer Details"
{
    PageType = List;
    SourceTable = "Item Ledger Entry";
    Caption = 'FIFO Layer Details';
    AdditionalSearchTerms = 'SCANPAN, FIFO Layer Detail, FIFO Layers. FIFO Layer, Detail';
    Editable = false;
    SourceTableView = where("Remaining Quantity" = filter(> 0));

    layout
    {
        area(Content)
        {
            group(HeaderInfo)
            {
                Caption = 'Bin Information';

                field(LocationCodeHeader; LocationCode)
                {
                    ApplicationArea = All;
                    Caption = 'Location';
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the location code for the selected bin content.';
                }
                /*
                                field(BinCodeHeader; BinCode)
                                {
                                    ApplicationArea = All;
                                    Caption = 'Bin';
                                    Editable = false;
                                    Style = Strong;
                                    ToolTip = 'Specifies the bin code for the selected bin content.';
                                }
                */
                field(ItemNoHeader; ItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the item number for which FIFO layers are displayed.';
                }
                field(TotalRemainingQty; TotalRemaining)
                {
                    ApplicationArea = All;
                    Caption = 'Total Remaining Qty';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total remaining quantity across all FIFO layers for this item at this location.';
                }
            }
            repeater(FIFOLayers)
            {
                Caption = 'FIFO Layers (Oldest First)';

                field("Layer No."; LayerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Layer';
                    ToolTip = 'Specifies the FIFO layer number, where 1 is the oldest layer.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date of the original receipt for this FIFO layer.';
                    Style = Attention;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item ledger entry number for this FIFO layer.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of item ledger entry (e.g., Purchase, Sale, Positive Adjustment).';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number that created this item ledger entry.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    ToolTip = 'Specifies the remaining quantity in this FIFO layer that has not yet been consumed.';
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoiced quantity for this item ledger entry.';
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the actual cost amount for the remaining quantity in this FIFO layer.';
                }
                field("Unit Cost"; UnitCost)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    DecimalPlaces = 2 : 5;
                    ToolTip = 'Specifies the calculated unit cost for this FIFO layer (Cost Amount / Remaining Quantity).';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the lot number assigned to this FIFO layer, if item tracking is used.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the serial number assigned to this FIFO layer, if item tracking is used.';
                }
                field("Age Days"; AgeDays)
                {
                    ApplicationArea = All;
                    Caption = 'Age (Days)';
                    StyleExpr = AgeStyle;
                    ToolTip = 'Specifies the age in days since the posting date. Color indicates age: green (<90 days), yellow (90-180 days), red (>180 days).';
                }
                field("Cumulative Qty"; CumulativeQty)
                {
                    ApplicationArea = All;
                    Caption = 'Cumulative Qty';
                    ToolTip = 'Specifies the running total of remaining quantity in FIFO order from oldest to newest layer.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowItemLedgerEntry)
            {
                ApplicationArea = All;
                Caption = 'Show Entry';
                Image = EntriesList;
                ToolTip = 'Open the full item ledger entry for the selected FIFO layer.';

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    ItemLedgerEntry.Get(Rec."Entry No.");
                    Page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
                end;
            }
            action(ShowBinContent)
            {
                ApplicationArea = Warehouse;
                Caption = 'Show Bin Content';
                Image = Bin;
                ToolTip = 'Open the bin contents list for the current item and location.';

                trigger OnAction()
                var
                    BinContent: Record "Bin Content";
                begin
                    BinContent.SetRange("Item No.", ItemNo);
                    BinContent.SetRange("Location Code", LocationCode);
                    BinContent.SetRange("Bin Code", BinCode);
                    Page.Run(Page::"Bin Contents List", BinContent);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Ensure FIFO sorting
        Rec.SetCurrentKey("Item No.", "Location Code", "Open", "Variant Code", "Unit of Measure Code", "Posting Date");
        CalculateTotalRemaining();
    end;

    trigger OnAfterGetRecord()
    begin
        LayerNo += 1;
        CalculateUnitCost();
        CalculateAge();
        CalculateCumulative();
        SetAgeStyle();
    end;

    local procedure CalculateTotalRemaining()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TotalRemaining := 0;
        ItemLedgerEntry.CopyFilters(Rec);
        if ItemLedgerEntry.FindSet() then
            repeat
                TotalRemaining += ItemLedgerEntry."Remaining Quantity";
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure CalculateUnitCost()
    begin
        if Rec."Remaining Quantity" <> 0 then
            UnitCost := Rec."Cost Amount (Actual)" / Rec."Remaining Quantity"
        else
            UnitCost := 0;
    end;

    local procedure CalculateAge()
    begin
        AgeDays := Today - Rec."Posting Date";
    end;

    local procedure CalculateCumulative()
    begin
        CumulativeQty += Rec."Remaining Quantity";
    end;

    local procedure SetAgeStyle()
    begin
        case true of
            AgeDays > 180:
                AgeStyle := 'Unfavorable';
            AgeDays > 90:
                AgeStyle := 'Attention';
            else
                AgeStyle := 'Favorable';
        end;
    end;

    procedure SetBinInfo(NewLocationCode: Code[10]; NewBinCode: Code[20]; NewItemNo: Code[20])
    begin
        LocationCode := NewLocationCode;
        BinCode := NewBinCode;
        ItemNo := NewItemNo;
    end;

    var
        LocationCode: Code[10];
        BinCode: Code[20];
        ItemNo: Code[20];
        LayerNo: Integer;
        UnitCost: Decimal;
        AgeDays: Integer;
        CumulativeQty: Decimal;
        TotalRemaining: Decimal;
        AgeStyle: Text;
}