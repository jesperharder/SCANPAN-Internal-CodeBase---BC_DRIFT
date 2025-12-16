


/// <summary>
/// PageExtension "NOTOTransferOrderLinesExtSC" (ID 50050) extends Record NOTO Transfer Order Lines.
/// 2025.11             Jesper Harder       118.1       Added Filter View to NOTO TransferOrderLines
/// </summary>
pageextension 50050 NOTOTransferOrderLinesExtSC extends "NOTO Transfer Order Lines"
{
    layout
    {
        addlast(General)
        {
            field(DynYearWeek; DynYearWeek)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the DynYearWeek field.';
            }
        }
    }

    views
    {
        addFirst
        {
            // 118.1
            view(SPNOpenFromRYOM)
            {
                Caption = 'Open from RYOM';
                Filters = where(
                    "Transfer-from Code" = const('RYOM'),
                    "Transfer-to Code" = const('AUNING'),
                    Status = const(Open)
                );
            }
        }
    }

    var
        DynYearWeek: Text[8];

    trigger OnAfterGetRecord()
    var
        Padding: Text[10];
    begin
        DynYearWeek := '';
        if Rec."Shipment Date" <> 0D then begin
            Padding := Format(Date2DWY(Rec."Shipment Date", 3));
            DynYearWeek := Padding;
            Padding := Format(Date2DWY(Rec."Shipment Date", 2));
            Padding := PadStr('', 2 - StrLen(Padding), '0') + Padding;
            DynYearWeek += '-' + Padding;
        end;
    end;
}

