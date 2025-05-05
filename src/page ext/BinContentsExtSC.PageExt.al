/// <summary>
/// PageExtension BinContentsExtSC (ID 50053) extends Record Bin Content.
/// </summary>
///
/// <remarks>///
///
///  2023.03.18                 Jesper Harder               009     Bin Content Added flowfield Inventory Posting Group, Product Line
///
/// </remarks>

pageextension 50053 "BinContentsExtSC" extends "Bin Contents"
{
    layout
    {
        addlast(Control37)
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Inventory Posting Group field.';
            }
            field("Product Line Code"; Rec."Product Line Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Product Line Code field.';
            }
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Transfer Order No. field.';
            }
        }

        addlast(Options)
        {
            group(scanpanfilter)
            {
                caption = 'Scanpan filter';
                ShowCaption = false;

                field(SetItemFilter; SetItemFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set AUNING Filters';
                    ToolTip = 'Sets filter to identify Items ready to transfer to AUNING.';
                    trigger OnValidate()
                    var
                    begin
                        SetAuningFilters();
                    end;
                }
                field(SetNotZeroFilter; SetNotZeroFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show only with Contents';
                    ToolTip = 'Sets filter to show only Bin with Contents.';
                    trigger OnValidate()
                    var
                    begin
                        SetContentsFilters();
                    end;
                }
                field(SetTransferOrdersFilter; SetTransferOrdersFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show only Transfer Orders';
                    ToolTip = 'Sets filter to show lines with Transfer Orders.';
                    trigger OnValidate()
                    var
                    begin
                        SetTransferOrdersFilters();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        SetItemFilter := false;
        SetAuningFilters();
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin

        SetItemFilter := true;
        if Rec.GetFilter("Inventory Posting Group") <> 'INTERN|EKSTERN|BRUND' then SetItemFilter := false;
        if Rec.GetFilter("Location Code") <> 'RYOM' then SetItemFilter := false;

        SetNotZeroFilter := true;
        if Rec.GetFilter("Quantity (Base)") <> '<>0' then SetNotZeroFilter := false;

        SetTransferOrdersFilter := true;
        if Rec.GetFilter("Transfer Order No.") = '' then SetTransferOrdersFilter := false;
    end;

    var
        SetItemFilter: Boolean;
        SetNotZeroFilter: Boolean;
        SetTransferOrdersFilter: Boolean;

    local procedure SetAuningFilters()
    var
    begin
        Rec.SetRange("Location Code");
        Rec.SetRange("Inventory Posting Group");
        if SetItemFilter then begin
            Rec.SetFilter("Inventory Posting Group", 'INTERN|EKSTERN|BRUND');
            Rec.SetFilter("Location Code", 'RYOM');
        end;
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure SetContentsFilters()
    var
    begin
        Rec.SetRange("Quantity (Base)");
        if SetNotZeroFilter then
            Rec.SetFilter("Quantity (Base)", '<>%1', 0);

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure SetTransferOrdersFilters()
    var
    begin
        Rec.SetRange("Transfer Order No.");
        if SetTransferOrdersFilter then
            Rec.SetFilter("Transfer Order No.", '<>%1', '');

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
