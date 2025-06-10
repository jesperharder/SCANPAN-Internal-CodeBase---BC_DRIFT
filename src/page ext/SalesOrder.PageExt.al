
/// <summary>
/// PageExtension SalesOrderExtSC (ID 50012) extends Record Sales Order.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2022.12             Jesper Harder       0193        Added Scanpan Group, added SystemUser created, modified
/// 2023.06             Jesper Harder       032         Warning Imerco DropShip 
/// 2024.10             Jesper Harder       083         Delete BackOrders Norway
/// 2025.06             Jesper Harder       113.1       Copy field information in salesheader general to invoice section.
/// </remarks>

pageextension 50012 "SalesOrder" extends "Sales Order"
{
    layout
    {
        modify("No.") { Visible = false; }
        modify("Sell-to Customer No.") { Visible = true; }
        modify("Sell-to Customer Name") { QuickEntry = false; }
        modify("Sell-to Address") { QuickEntry = false; }
        modify("Sell-to Address 2") { QuickEntry = false; }
        modify("Sell-to Contact No.") { QuickEntry = false; }
        modify("OIOUBL-Sell-to Contact Role") { QuickEntry = false; }
        modify("Sell-to Phone No.") { QuickEntry = false; }
        modify("Sell-to E-Mail") { QuickEntry = false; }
        modify("Sell-to Contact")
        {
            QuickEntry = false;
            Visible = true;
        }
        modify("Document Date") { QuickEntry = false; }
        modify("Posting Date") { QuickEntry = false; }
        modify("Due Date") { QuickEntry = false; }
        modify("Campaign No.") { QuickEntry = false; }
        modify("Opportunity No.") { QuickEntry = false; }
        modify("Responsibility Center") { QuickEntry = false; }
        modify("Assigned User ID") { QuickEntry = false; }
        modify(WorkDescription) { QuickEntry = false; }
        modify(CDCDocuments) { QuickEntry = false; }
        modify("ITI IIC Document") { QuickEntry = false; }
        modify("ITI IIC Status Code") { QuickEntry = false; }
        modify("ITI IIC Created By") { QuickEntry = false; }
        modify("ITI IIC Buffer Document Exists") { QuickEntry = false; }
        modify("Del. SO's With Rem. Qty. NOTO") { QuickEntry = false; }
        modify("Calculate Freight") { QuickEntry = false; }
        modify("Freight Calculated") { QuickEntry = false; }
        modify("Use Barcode") { QuickEntry = false; }
        modify("Old Customer No.") { QuickEntry = false; }
        modify("Priority NOTO") { QuickEntry = false; }
        modify("External Document No.") { QuickEntry = true; }
        modify("Your Reference")
        {
            Importance = Promoted;
            QuickEntry = false;
        }
        modify("PaymentID")
        {
            Importance = Promoted;
            QuickEntry = false;
        }

        //Importance = Standard
        //Importance = Promoted
        //Importance = Additional 

        modify("Promised Delivery Date") { Visible = false; }
        modify("OIOUBL-Sell-to Contact E-Mail") { QuickEntry = false; }
        modify("OIOUBL-Sell-to Contact Phone No.") { QuickEntry = false; }
        modify("OIOUBL-Sell-to Contact Fax No.") { QuickEntry = false; }

        addafter(TRCTrueCommerce)
        {
            group(ScanpanGroup)
            {
                Caption = 'Scanpan';

                field(SystemCreatedAt1; SystemCreatedAt)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy1; Createdby)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SystemCreatedBy';
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemModifiedAt; SystemModifiedAt)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy1; ModifiedBy)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SystemModifiedBy';
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }


        //FACCTBOXES
        movefirst(factboxes; Control1906127307) //Salgslinjedetaljer
        moveafter(Control1906127307; Control1903720907) //Kundesalgsoversigt
        moveafter(Control1903720907; NOTOCommentLineFactbox) //Debitorbemærkning
        moveafter(NOTOCommentLineFactbox; Control1900316107) //Debitoroplysning
        moveafter(Control1900316107; CDOActions) //Doc. Output
        moveafter(CDOActions; CDOLog) //Doc. Output Log

        modify(CDOWarehouse) { Visible = false; }

        //SHIPITREMOVE
        /*
        modify("IDYS Tpt. Ord. Details Factbox") { Visible = false; }
        modify("IDYS Packages") { Visible = false; }
        */

        modify(Control1901314507) { Visible = false; }

    }

    actions
    {
        addlast(processing)
        {
            /// 113.1
            action(CopyFieldValuesToShippingAndBillingAction)
            {
                Caption = 'Copy Sell-to to Ship-to/Bill-to';
                ToolTip = 'Overrides current shipping and billing details with values from the Sell-to fields.';
                ApplicationArea = All;
                Image = Copy;

                trigger OnAction()
                begin
                    if not Confirm('This will overwrite existing shipping and billing information. Continue?', false) then
                        exit;

                    //Rec.Get(Rec."Document Type", Rec."No.");

                    // Tving leveringsmetoden til brugerdefineret
                    Rec.Validate("Ship-to Code", '');
                    ShipToOptions := ShipToOptions::"Custom Address";

                    // Evt. angiv brugerdefineret adresse her:
                    Rec.Validate("Ship-to Name", Rec."Sell-to Address");
                    Rec.Validate("Ship-to Address", Rec."Sell-to Address 2");
                    Rec.Validate("Ship-to Post Code", Rec."Sell-to Post Code");
                    Rec.Validate("Ship-to City", Rec."Sell-to City");
                    Rec.Validate("Ship-to Country/Region Code", Rec."Sell-to Country/Region Code");
                    Rec.Validate("Ship-to Contact", Rec."Sell-to Contact");


                    // Tving Faktureres Til til brugerdefineret
                    BillToOptions := BillToOptions::"Custom Address";

                    // Evt. angiv brugerdefineret faktureringsadresse her:
                    Rec.Validate("Bill-to Address", Rec."Sell-to Address");
                    Rec.Validate("Bill-to Address 2", Rec."Sell-to Address 2");
                    Rec.Validate("Bill-to Post Code", Rec."Sell-to Post Code");
                    Rec.Validate("Bill-to City", Rec."Sell-to City");
                    Rec.Validate("Bill-to Country/Region Code", Rec."Sell-to Country/Region Code");
                    Rec.Validate("Bill-to Contact", Rec."OIOUBL-Sell-to Contact E-Mail");
                    // Tilføj flere feltkopieringer her, fx:


                    Rec.Modify(true);
                    Message('Felterne blev kopieret.');
                end;
            }

            // 083
            /*
            action(HandleSalesOrderDeletionAction)
            {
                Caption = 'Delete BackOrders (Norway)';
                ToolTip = 'Deletes Sales Orders with atleast 1 delivery and marked for Backorder deletion.';
                ApplicationArea = All;
                Image = Delete;


                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
                begin
                    SalesHeader.Get(Rec."Document Type", Rec."No.");
                    ScanpanMiscellaneous.HandleSalesOrderDeletion(SalesHeader);
                end;
            }
            */
        }
    }

    var
        ScanpanMiscellaneous: Codeunit ScanpanMiscellaneous;
        CreatedBy: Text[100];
        ModifiedBy: Text[100];


    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        //032
        ScanpanMiscellaneous.WarningCheckImercoDropShip(Rec);

        CreatedBy := '';
        ModifiedBy := '';
        if User.Get(Rec.SystemCreatedBy) then CreatedBy := User."User Name";
        if User.Get(Rec.SystemModifiedBy) then ModifiedBy := User."User Name";
    end;
}
