pageextension 50080 ProdBOMWhereUsed extends "Prod. BOM Where-Used"
{
    /// <summary>
    /// PageExtension ProdBOMWhereUsed (ID 50080) extends Record Prod. BOM Where-Used.
    /// Adds functionality to delete selected BOM items from the page and adjust BOM lines.
    /// </summary>
    ///
    /// <remarks>
    /// 2023.08             Jesper Harder       043         Batch Delete BOM item.
    /// 2024.10             Jesper Harder       087         Adjust Multiple BoM lines
    /// </remarks>

    layout
    {
        // No additional layout changes are required in this extension
    }

    actions
    {
        addfirst(Processing) // Add the action under the 'Processing' group
        {
            action(DeletePage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Item from Selected'; // Caption for the action button
                Image = DeleteExpiredComponents; // Icon associated with the action
                ToolTip = 'Delete BOM Item from Selected.'; // Tooltip to describe the action

                trigger OnAction()
                begin
                    DeleteSelectedFromBom(); // Call procedure to delete selected BOM items
                end;
            }

            // 087 Action to adjust multiple BOM lines
            action(AdjustBoMLines)
            {
                Caption = 'Adjust BoM Lines';
                ToolTip = 'Adjust the selected Bill of Material lines with new values.';
                ApplicationArea = All;
                Image = Action;

                trigger OnAction()
                var
                    UserInputPage: Page AdjustBoMlines;
                    BoMQuantityPer: Decimal;
                    Text000Lbl: Label 'Input Canceled'; // Label for status messages
                begin
                    // Run the page modally
                    if UserInputPage.RunModal() = Action::OK then begin
                        BoMQuantityPer := UserInputPage.ReturnQuantityPerFactor();
                        AdjustQuantityPerFromBom(BoMQuantityPer);
                    end else
                        Message(Text000Lbl);
                end;
            }
        }
    }

    // Declare a temporary record for storing "Where-Used Line" entries
    var
        TempWhereUsedLine: Record "Where-Used Line" temporary;

    // Trigger executed after each record is retrieved
    trigger OnAfterGetRecord()
    begin
        CopyRecToTempRec(); // Copy the current record to a temporary record
    end;

    // Local procedure to copy the current record to the temporary record
    local procedure CopyRecToTempRec()
    begin
        if not TempWhereUsedLine.Get(Rec."Entry No.") then begin
            TempWhereUsedLine.Init(); // Initialize the temporary record
            TempWhereUsedLine.TransferFields(Rec); // Copy fields from the current record to the temporary record
            TempWhereUsedLine."Production BOM No." := CopyStr(SetCaption(), 1, StrPos(SetCaption(), ' ')); // Extract BOM number
            TempWhereUsedLine.Insert(); // Insert the temporary record
        end;
    end;

    // 087 Local procedure to adjust selected BOM lines
    local procedure AdjustQuantityPerFromBom(ToFactorQuantityPer: Decimal)
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        Text000Lbl: Label 'BOM Item:'; // Label for status messages
        Text001Lbl: Label 'is adjusted from the following Production BOM:';
        Text002Lbl: Label 'Warning - You are about to adjust BOM Lines. Are you sure?';
        Text003Lbl: Label 'Please recalculate cost on the above Items.';
        StatusText: Text; // Used to build the status message
        OriginalStatus: Enum "BOM Status"; // Variable to store the original status
        FromQuantityPer: Decimal;
        NewQuantityPer: Decimal;
    begin
        if Dialog.Confirm(Text002Lbl, false) then begin
            // Set the filter to the currently selected lines in the page
            CurrPage.SetSelectionFilter(TempWhereUsedLine);
            if TempWhereUsedLine.FindSet() then begin
                // Initial Status Message
                Item.Get(TempWhereUsedLine."Production BOM No."); // Get the related Item
                StatusText := Text000Lbl + ' "' + Item."No." + ' ' + Item.Description + '", ' + Text001Lbl; // Build initial status message

                // Loop through the selected records
                repeat
                    if ProductionBOMHeader.Get(TempWhereUsedLine."Item No.") then
                        if ProductionBOMHeader.Status = ProductionBOMHeader.Status::Certified then begin
                            // Save current status
                            OriginalStatus := ProductionBOMHeader.Status;

                            // Set BOM status to "Under Development" to allow modification
                            ProductionBOMHeader.Status := ProductionBOMHeader.Status::"Under Development";
                            ProductionBOMHeader.Modify(true); // Modify the header and save changes

                            // Filter the Production BOM Lines by BOM No. and Item No.
                            ProductionBOMLine.SetRange("Production BOM No.", ProductionBOMHeader."No.");
                            ProductionBOMLine.SetRange("No.", Item."No.");
                            if ProductionBOMLine.FindSet() then
                                repeat

                                    FromQuantityPer := ProductionBOMLine."Quantity per";
                                    if ToFactorQuantityPer < 0 then
                                        // Ved negativ faktor, subtraher en procentdel af den oprindelige værdi
                                        NewQuantityPer := FromQuantityPer / Abs(ToFactorQuantityPer)
                                    else
                                        // Ved positiv faktor, gang mængden med faktoren
                                        NewQuantityPer := FromQuantityPer * ToFactorQuantityPer;

                                    // Round value to 4 digits
                                    NewQuantityPer := Round(NewQuantityPer, 0.0001, '>');
                                    // Valider og sæt den nye værdi
                                    ProductionBOMLine.Validate("Quantity per", NewQuantityPer);

                                    StatusText += '\' + ProductionBOMHeader."No." +
                                                    ' From Quantity Per value ' + Format(FromQuantityPer, 0, '<Precision,2:4><Standard Format,0>') +
                                                    ' Factor ' + Format(ToFactorQuantityPer, 0, '<Precision,2:4><Standard Format,0>') +
                                                    ' To ' + Format(NewQuantityPer, 0, '<Precision,2:4><Standard Format,0>');

                                    ProductionBOMLine.Modify(true);

                                until ProductionBOMLine.Next() = 0;

                            // Reset the BOM Status
                            ProductionBOMHeader.Status := OriginalStatus;
                            ProductionBOMHeader.Modify(true);
                        end;
                until TempWhereUsedLine.Next() = 0; // Repeat for all selected records

                // Add a final message to recalculate costs
                StatusText += '\\' + Text003Lbl;
                Message(StatusText); // Display the final status message
            end;
        end;
    end;

    // Local procedure to delete selected BOM lines
    local procedure DeleteSelectedFromBom()
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        Text000Lbl: Label 'BOM Item:'; // Label for status messages
        Text001Lbl: Label 'is removed from the following Production BOM:';
        Text002Lbl: Label 'Warning - You are about to delete BOM Lines. Are you sure?';
        Text003Lbl: Label 'Please recalculate cost on the above Items.';
        StatusText: Text; // Used to build the status message
    begin
        if Dialog.Confirm(Text002Lbl, false) then begin
            // Set the filter to the currently selected lines in the page
            CurrPage.SetSelectionFilter(TempWhereUsedLine);
            if TempWhereUsedLine.FindSet() then begin
                // Loop through the selected records
                repeat
                    Item.Get(TempWhereUsedLine."Production BOM No."); // Get the related Item
                    StatusText := Text000Lbl + ' "' + Item."No." + ' ' + Item.Description + '", ' + Text001Lbl; // Build initial status message

                    // Fetch and update the Production BOM Header
                    if ProductionBOMHeader.Get(TempWhereUsedLine."Item No.") then begin
                        ProductionBOMHeader.Status := ProductionBOMHeader.Status::"Under Development"; // Set status to "Under Development"
                        ProductionBOMHeader.Modify(true); // Modify the header and save changes

                        // Filter the Production BOM Lines by BOM No. and Item No.
                        ProductionBOMLine.SetRange("Production BOM No.", ProductionBOMHeader."No.");
                        ProductionBOMLine.SetRange("No.", Item."No.");
                        ProductionBOMLine.DeleteAll(true); // Delete all matching BOM lines

                        // Append the status text with details of the deleted lines
                        StatusText += '\' + ProductionBOMHeader."No." + '-' + ProductionBOMHeader.Description;

                        // Reset the BOM Status to "Certified"
                        ProductionBOMHeader.Status := ProductionBOMHeader.Status::Certified;
                        ProductionBOMHeader.Modify(true);
                    end;
                until TempWhereUsedLine.Next() = 0;

                // Add a final message to recalculate costs
                StatusText += '\\' + Text003Lbl;
                Message(StatusText); // Display the final status message
            end;
        end;
    end;
}