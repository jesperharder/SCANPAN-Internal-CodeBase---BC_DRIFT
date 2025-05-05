



/// <summary>
/// PageExtension WarehousePicks (ID 50078) extends Record Warehouse Picks.
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.07.18              Jesper Harder               038     WarehousePicks - Delete selected Lines  
/// 
/// </remarks>
pageextension 50078 "WarehousePicks" extends "Warehouse Picks"
{

    actions
    {
        addfirst(Processing)
        {
            action("DeleteSelectedLines")
            {
                Image = DeleteRow;
                Caption = 'Delete Selected Lines';
                ToolTip = 'Executes the DElete Selected Lines action.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    WarehouseActivityHeader: Record "Warehouse Activity Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectionFilter: text[200];
                    ConfirmLbl: Label 'Delete Selected Lines?';
                begin
                    WarehouseActivityHeader.Reset();
                    CurrPage.SetSelectionFilter(WarehouseActivityHeader);
                    RecRef.GetTable(WarehouseActivityHeader);
                    SelectionFilter := (SelectionFilterManagement.GetSelectionFilter(RecRef, WarehouseActivityHeader.FieldNo("No.")));
                    if Confirm(ConfirmLbl) then
                        DeleteActivityLines(WarehouseActivityHeader, SelectionFilter)
                    else
                        CurrPage.Update();
                end;
            }
        }
    }

    local procedure DeleteActivityLines(var WarehouseActivityHeader: Record "Warehouse Activity Header"; FilterStr: Text[200])
    var
        RecCount: Integer;
        Lbl: Label 'Lines deleted %1', Comment = '%1 = Number of lines deleted.';
    begin
        RecCount := WarehouseActivityHeader.Count;
        WarehouseActivityHeader.SetRange(Type, WarehouseActivityHeader.Type::Pick);
        WarehouseActivityHeader.SetFilter("No.", FilterStr);
        if WarehouseActivityHeader.FindSet() then
            WarehouseActivityHeader.DeleteAll(true);
        Message(Lbl, Format(RecCount - WarehouseActivityHeader.Count));
    end;
}