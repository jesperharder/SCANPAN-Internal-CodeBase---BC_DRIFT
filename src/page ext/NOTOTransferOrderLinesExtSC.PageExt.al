


/// <summary>
/// PageExtension "NOTOTransferOrderLinesExtSC" (ID 50050) extends Record NOTO Transfer Order Lines.
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

