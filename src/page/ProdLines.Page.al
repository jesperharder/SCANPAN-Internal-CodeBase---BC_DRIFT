page 50063 ProdLines
{
    ///<remarks>
    /// 2024.11             Jesper Harder       095         Look up production orders from Chart Dashboard
    /// 2025.03             Jesper Harder       110.1       Added actions to sort date columns in Dashboard Production lines
    ///</remarks>

    AdditionalSearchTerms = 'Scanpan, Controlling, Production, Lines';
    ApplicationArea = All;
    Caption = 'Production Order Lines';
    PageType = List;
    SourceTable = "Prod. Order Line";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowCaption = false;
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related production order.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        ProductionOrder: Record "Production Order";
                    begin
                        ProductionOrder.Reset();
                        ProductionOrder.SetRange(Status, Rec.Status);
                        ProductionOrder.SetRange("No.", Rec."Prod. Order No.");

                        if Rec.Status = Rec.Status::Planned then
                            PAGE.Run(PAGE::"Planned Production Order", ProductionOrder);
                        if Rec.Status = Rec.Status::"Firm Planned" then
                            PAGE.Run(PAGE::"Firm Planned Prod. Order", ProductionOrder);
                        if Rec.Status = Rec.Status::Released then
                            PAGE.Run(PAGE::"Released Production Order", ProductionOrder);
                        if Rec.Status = Rec.Status::Finished then
                            PAGE.Run(PAGE::"Finished Production Order", ProductionOrder);

                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value that is copied from the corresponding field on the production order header.';
                    Editable = false;
                    // Use StyleExpr to dynamically apply styles
                    StyleExpr = StyleExpr; // GetStyleForStatus();
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the item that is to be produced.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the date when the produced item must be available. The date is copied from the header of the production order.';
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.';
                    Visible = false;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the value of the Description field on the item card. If you enter a variant code, the variant description is copied to this field instead.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies an additional description.';
                    Visible = false;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the production BOM that is the basis for creating the Prod. Order Component list for this line.';
                    Visible = false;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the routing used as the basis for creating the production order routing for this line.';
                    Visible = false;
                }
                field("Routing Version Code"; Rec."Routing Version Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the version number of the routing.';
                    Visible = false;
                }
                field("Production BOM Version Code"; Rec."Production BOM Version Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the version code of the production BOM.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location code, if the produced items should be stored in a specific location.';
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin that the produced item is posted to as output, and from where it can be taken to storage or cross-docked.';
                    Visible = false;
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the starting date and the starting time, which are combined in a format called "starting date-time".';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Starting Time"; StartingTime)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the entry''s starting time, which is retrieved from the production order routing.';
                    Visible = DateAndTimeFieldVisible;

                    trigger OnValidate()
                    begin
                        Validate("Starting Time", StartingTime);
                        CurrPage.Update(true);
                    end;
                }
                field("Starting Date"; StartingDate)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the entry''s starting date, which is retrieved from the production order routing.';
                    Visible = DateAndTimeFieldVisible;

                    trigger OnValidate()
                    begin
                        Validate("Starting Date", StartingDate);
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Date-Time"; "Ending Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the ending date and the ending time, which are combined in a format called "ending date-time".';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Time"; EndingTime)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the entry''s ending time, which is retrieved from the production order routing.';
                    Visible = DateAndTimeFieldVisible;

                    trigger OnValidate()
                    begin
                        Validate("Ending Time", EndingTime);
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Date"; EndingDate)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the entry''s ending date, which is retrieved from the production order routing.';
                    Visible = DateAndTimeFieldVisible;

                    trigger OnValidate()
                    begin
                        Validate("Ending Date", EndingDate);
                        CurrPage.Update(true);
                    end;
                }
                field("Scrap %"; "Scrap %")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the quantity to be produced if you manually fill in this line.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies how many units of this item have been reserved.';
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Finished Quantity"; "Finished Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how much of the quantity on this line has been produced.';
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the difference between the finished and planned quantities, or zero if the finished quantity is greater than the remaining quantity.';
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Cost Amount"; "Cost Amount")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the total cost on the line by multiplying the unit cost by the quantity.';
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }

    }

    actions
    {
        // 110.1
        area(Processing)
        {
            action(ToggleStartingDate)
            {
                ApplicationArea = All;
                Caption = 'Toggle Starting Date';
                Image = Change;
                ToolTip = 'Switch between ascending and descending sort order for starting date.';
                trigger OnAction()
                begin
                    SortAscending := not SortAscending;
                    SortDate('Starting Date');
                end;
            }
            action(ToggleEndingDate)
            {
                ApplicationArea = All;
                Caption = 'Toggle Ending Date';
                Image = Change;
                ToolTip = 'Switch between ascending and descending sort order for ending date.';
                trigger OnAction()
                begin
                    SortAscending := not SortAscending;
                    SortDate('Ending Date');
                end;
            }
            action(ToggleDueDate)
            {
                ApplicationArea = All;
                Caption = 'Toggle Due Date';
                Image = Change;
                ToolTip = 'Switch between ascending and descending sort order for due date.';
                trigger OnAction()
                begin
                    SortAscending := not SortAscending;
                    SortDate('Due Date');
                end;
            }
        }
    }




    trigger OnOpenPage()
    begin
        DateAndTimeFieldVisible := false;
        Rec.SetCurrentKey("Starting Date");
        Rec.Ascending(true);
    end;

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        ShowShortcutDimCode(ShortcutDimCode);
        DescriptionOnFormat();
        GetStartingEndingDateAndTime(StartingTime, StartingDate, EndingTime, EndingDate);

        StyleExpr := GetStyleForStatus();
    end;


    trigger OnDeleteRecord(): Boolean
    var
        ProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
    begin
        Commit();
        if not ProdOrderLineReserve.DeleteLineConfirm(Rec) then
            exit(false);
    end;

    trigger OnInit()
    begin
        DateAndTimeFieldVisible := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;


    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        [InDataSet]
        DescriptionIndent: Integer;
        StartingTime: Time;
        EndingTime: Time;
        StartingDate: Date;
        EndingDate: Date;
        DateAndTimeFieldVisible: Boolean;

        StyleExpr: Text;
        SortAscending: Boolean;

    protected var
        ShortcutDimCode: array[8] of Code[20];



    // 110.1
    local procedure SortDate(DateType: Text[30])
    begin

        case DateType of
            'Starting Date':
                Rec.SetCurrentKey("Starting Date");
            'Ending Date':
                Rec.SetCurrentKey("Ending Date");
            'Due Date':
                Rec.SetCurrentKey("Due Date");
        end;

        Rec.Ascending(SortAscending);
        CurrPage.Update(false);
    end;

    // A method to determine the style dynamically
    procedure GetStyleForStatus(): Text[30]
    begin
        case Rec.Status of
            "Production Order Status"::Finished:
                exit('Ambiguous');
            "Production Order Status"::Released:
                exit('Favorable');
            "Production Order Status"::"Firm Planned":
                exit('StandardAccent');
            else
                exit('Subordinate');
        end;

        /*
        The StyleExpr property accepts specific predefined style values, including:
            Standard: Default style
            StandardAccent: Blue
            Strong: Bold
            StrongAccent: Bold and Blue
            Attention: Italic and Red
            AttentionAccent: Italic and Blue
            Favorable: Bold and Green
            Unfavorable: Bold, Italic, and Red
            Ambiguous: Yellow
            Subordinate: Grey
        */
    end;

    procedure PageShowReservation()
    begin
        CurrPage.SaveRecord();
        ShowReservation();
    end;

    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetProdOrderLine(Rec);
        TrackingForm.RunModal;
    end;




    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := "Planning Level Code";
    end;

    local procedure ShowComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, Status);
        ProdOrderComp.SetRange("Prod. Order No.", "Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", "Line No.");

        PAGE.Run(PAGE::"Prod. Order Components", ProdOrderComp);
    end;

}





