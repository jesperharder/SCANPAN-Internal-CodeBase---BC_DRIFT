/// <summary>
/// Page SCANPAN Create Item Barcode (ID 50000).
/// </summary>
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
///
/// </remarks>

page 50000 "CreateMultipleBarcodes"
{
    AdditionalSearchTerms = 'Scanpan, Barcode';
    ApplicationArea = Basic, Suite;
    Caption = 'Create Multiple Item Barcode';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    PageType = List;
    Permissions =
        tabledata BarCodesTmpSC = RIMD,
        tabledata Item = R;
    PromotedActionCategories = 'New,Item,Barcode,Item Reference';
    SourceTable = BarCodesTmpSC;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(WhatItem)
            {
                Caption = 'Barcodes';
                field(SelectedItemNo; SelectedItemNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item to assign barcode';
                    TableRelation = item."No.";
                    ToolTip = 'Choose the Item to assign barcodes';

                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                    begin
                        if ItemRec.get(SelectedItemNo) then ScanpanMiscellaneousCU.fillBarcodeTable(Rec, SelectedItemNo);
                    end;
                }
            }
            repeater(Control1)
            {
                Caption = 'General';
                field("Item No"; "Item No")
                { ToolTip = 'Item No.'; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                { ToolTip = 'Unit of Measure Code.'; }
                field("Num Barcodes"; Rec."Num Barcodes")
                { ToolTip = 'Type Numberic Barcode.'; }
                field("Create Now EAN"; "Create Now EAN")
                { ToolTip = 'Check this to Create EAN code.'; }
                field("Create Now UPC"; "Create Now UPC")
                { ToolTip = 'Check this to Create UPC code.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("CreateSelectedBarcode")
            {
                ApplicationArea = all;
                Caption = 'Create Barcodes';
                Image = BarCode;
                ToolTip = 'Creates barcode from selected in the list.';
                trigger OnAction()
                var
                    hasSelected: Boolean;
                begin
                    Rec.SetRange("Create Now EAN", true);
                    if Rec.FindSet() then begin
                        hasSelected := true;
                        repeat
                            ScanpanMiscellaneousCU.CreateUOMBarcode(Rec."Item No", Rec."Unit of Measure Code", true);
                        until Rec.Next() = 0;
                    end;

                    Rec.Reset();
                    Rec.SetRange("Create Now UPC", true);
                    if Rec.FindSet() then begin
                        hasSelected := true;
                        repeat
                            ScanpanMiscellaneousCU.CreateUOMBarcode(Rec."Item No", Rec."Unit of Measure Code", false);
                        until Rec.Next() = 0;
                    end;

                    Rec.Reset();
                    if hasSelected = true then
                        Rec.DeleteAll()
                    else
                        message(Text011Lbl);
                end;
            }
            action("UpdateGTIN")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update all Items GTIN';
                Image = "Action";
                ToolTip = 'Updates all Items GTIN from Item Reference';

                trigger OnAction()
                var
                    ScanpanMisc: Codeunit ScanpanMiscellaneous;
                begin
                    ScanpanMisc.UpdateAllItemsWithGTIN();
                end;
            }
        }
    }

    var
        ScanpanMiscellaneousCU: Codeunit ScanpanMiscellaneous;
        SelectedItemNo: text[20];
        Text011Lbl: LAbel 'There is no selection to Create.';
}
