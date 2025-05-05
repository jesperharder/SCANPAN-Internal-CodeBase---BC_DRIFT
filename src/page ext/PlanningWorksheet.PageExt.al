

pageextension 50036 "PlanningWorksheet" extends "Planning Worksheet"
{
    /// <summary>
    /// PageExtension PlanningWorksheetExtSC (ID 50036) extends Record Planning Worksheet.
    /// 2025.04             Jesper Harder       108.1       Plannling Worksheet, add Bin Code
    /// </summary>

    layout
    {
        addafter(Description)
        {
            field("Location Code1"; Rec."Location Code")
            {
                ApplicationArea = All;
                Width = 6;
                ToolTip = 'Specifies a code for an inventory location where the items that are being ordered will be registered.';
            }
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bin where the items will be picked from or placed into.';
            }
        }
    }
    actions
    {
        addbefore("&Line")
        {
            group(scanpan)
            {
                Caption = 'SCANPAN';
                ToolTip = 'Scanpan tools.';

                action(ToggleActionMessage)
                {
                    ApplicationArea = Planning;
                    Caption = 'Toggle Action Messages';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = false;
                    ToolTip = 'Toggle Action Messages.';

                    trigger OnAction()
                    begin
                        ScanpanMiscellaneous.ToggleActionMessage(Rec, false);
                    end;

                }
                group("&Item Availability")
                {
                    Caption = '&Item Availability';

                    action("ItemEvent")
                    {
                        ApplicationArea = Planning;
                        Caption = 'Event (Shift+Ctrl+h)';
                        Image = "Event";
                        Promoted = true;
                        PromotedCategory = Category7;
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
                        ShortcutKey = 'Shift+Ctrl+h';
                        trigger OnAction()
                        begin
                            ItemAvailabilityFormsMgt.ShowItemAvailFromReqLine(Rec, ItemAvailabilityFormsMgt.ByEvent())
                        end;
                    }
                }
            }
        }
    }

    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        ItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";

}
