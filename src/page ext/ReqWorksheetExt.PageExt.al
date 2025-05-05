

pageextension 50043 ReqWorksheetExt extends "Req. Worksheet"
{
    /// <summary>
    /// PageExtension "ReqWorksheetExtSC" (ID 50043) extends Record Req. Worksheet.
    /// </summary>
    /// 
    /// <remarks>
    /// 
    /// 2023.03.08          Jesper Harder       0193        Toggle Action Selection
    /// 2025.02             Jesper Harder       105.01      Purchase Planning with warning for blocked Items
    /// </remarks>      

    layout
    {
        modify("Price Calculation Method") { Visible = false; }

        moveafter("Unit of Measure Code"; "Due Date")
        moveafter("Unit of Measure Code"; "Vendor No.")
        modify("Unit of Measure Code")
        {
            Width = 2;
        }
        modify("Original Quantity")
        {
            Width = 9;
        }
        modify("Vendor No.")
        {
            Width = 4;
        }
        moveafter("Due Date"; "Replenishment System")


    }


    actions
    {
        /// 2025.02
        modify("CalculatePlan")
        {
            Visible = false;
        }

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
                    var
                    begin
                        ScanpanMiscellaneous.ToggleActionMessage(Rec, false);
                    end;
                }
            }
        }

        /// 2025.02
        addafter(CalculatePlan)
        {
            action(CalculatePlanScanpan)
            {
                ApplicationArea = Planning;
                Caption = 'Scanpan Calculate Plan';
                Ellipsis = true;
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';

                trigger OnAction()
                var
                    CalculatePlan: Report "CalculatePlanReqWksh";
                begin
                    CalculatePlan.SetTemplAndWorksheet(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                    CalculatePlan.RunModal();
                    Clear(CalculatePlan);
                end;
            }
        }
    }

    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
}
