






/// <summary>
/// PageExtension ItemCrossReferenceEntries (ID 50096) extends Record Item Cross Reference Entries.
/// </summary>
#pragma warning disable AL0432
pageextension 50096 "ItemCrossReferenceEntries" extends "Item Cross Reference Entries"
#pragma warning restore AL0432
{
    Caption = 'Depreciated Item Cross Reference Entries';

    trigger OnOpenPage()
    var
        MsgLbl: Label 'This page is obsolete and replaced by Item Reference feature.';
    begin
        if GuiAllowed then Message(MsgLbl);
    end;
}