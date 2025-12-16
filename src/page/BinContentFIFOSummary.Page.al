///<summary>
/// 2025.11             Jesper Harder       117.1       Created new page for viewing bin content FIFO information, including oldest entry date, average age in days, and number of FIFO layers.
///</summary>

page 50055 "Bin Content FIFO Summary"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bin Content";
    Caption = 'Bin Content FIFO Summary';
    AdditionalSearchTerms = 'SCANPAN, FIFO Summary, FIFO Info, FIFO Information, Bin FIFO, Bin FIFO Summary';
    Editable = false;
    SourceTableView = where(Quantity = filter(> 0));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location where the bin is located.';
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the zone code within the location.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin code where the items are stored.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number stored in the bin.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    ToolTip = 'Specifies the total quantity of the item in the bin.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure for the item quantity.';
                }
                field("Oldest Entry Date"; OldestEntryDate)
                {
                    ApplicationArea = All;
                    Caption = 'Oldest FIFO Entry';
                    ToolTip = 'Specifies the posting date of the oldest remaining item ledger entry (FIFO layer) for this item at this location.';
                }
                field("Avg Age Days"; AvgAgeDays)
                {
                    ApplicationArea = All;
                    Caption = 'Avg Age (Days)';
                    StyleExpr = AgeStyle;
                    ToolTip = 'Specifies the weighted average age in days of all FIFO layers for this item. Color indicates age: green (<90 days), yellow (90-180 days), red (>180 days).';
                }
                field("FIFO Layers"; FIFOLayers)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Layers';
                    Style = StrongAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the number of FIFO layers (open item ledger entries) for this item at this location. Choose the field to view layer details.';

                    trigger OnDrillDown()
                    begin
                        ShowFIFOLayerDetails();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowFIFOLayers)
            {
                ApplicationArea = All;
                Caption = 'Show FIFO Layers';
                Image = EntriesList;
                ToolTip = 'Show detailed FIFO layers for selected bin.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowFIFOLayerDetails();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateFIFOInfo();
    end;

    local procedure CalculateFIFOInfo()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQty: Decimal;
        WeightedAge: Decimal;
    begin
        Clear(OldestEntryDate);
        Clear(AvgAgeDays);
        FIFOLayers := 0;
        TotalQty := 0;
        WeightedAge := 0;

        // Use Item Ledger Entries to get remaining quantities
        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Open", "Variant Code", "Unit of Measure Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');

        if ItemLedgerEntry.FindSet() then begin
            OldestEntryDate := ItemLedgerEntry."Posting Date";
            repeat
                FIFOLayers += 1;
                TotalQty += ItemLedgerEntry."Remaining Quantity";
                WeightedAge += (Today - ItemLedgerEntry."Posting Date") * ItemLedgerEntry."Remaining Quantity";
            until ItemLedgerEntry.Next() = 0;

            if TotalQty <> 0 then
                AvgAgeDays := Round(WeightedAge / TotalQty, 1);
        end;

        SetAgeStyle();
    end;

    local procedure SetAgeStyle()
    begin
        case true of
            AvgAgeDays > 180:
                AgeStyle := 'Unfavorable';
            AvgAgeDays > 90:
                AgeStyle := 'Attention';
            else
                AgeStyle := 'Favorable';
        end;
    end;

    local procedure ShowFIFOLayerDetails()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        FIFOLayerDetailsPage: Page "FIFO Layer Details";
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Open", "Variant Code", "Unit of Measure Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');

        FIFOLayerDetailsPage.SetTableView(ItemLedgerEntry);
        FIFOLayerDetailsPage.SetBinInfo(Rec."Location Code", Rec."Bin Code", Rec."Item No.");
        FIFOLayerDetailsPage.RunModal();
    end;

    var
        OldestEntryDate: Date;
        AvgAgeDays: Integer;
        FIFOLayers: Integer;
        AgeStyle: Text;
}