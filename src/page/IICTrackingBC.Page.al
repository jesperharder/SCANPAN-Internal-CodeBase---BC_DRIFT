



/// <summary>
/// Page "SCANPANIICTracking" (ID 50022).
/// </summary>
/// 
/// <remarks>
/// 
/// 2023.03.22                        Jesper Harder                           012     IIC tracking Norway Denmark.
/// 
/// </remarks>      
/// 

page 50022 "IICTracking_BC"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = 'Inter Company Infomation Tracking';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite;
    SourceTable = IICTrackingTmpSC;

    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. (NO) field.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. (NO) field.';
                }
                field("Sell-To Customer Name (NO)"; Rec."Sell-To Customer Name (NO)")
                {
                    ToolTip = 'Specifies the value of the Sell-To Customer Name (NO) field.';
                }
                field("Sales Shipment No. (NO)"; Rec."Sales Shipment No. (NO)")
                {
                    ToolTip = 'Specifies the value of the Sales Shipment No. (NO) field.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Order No. (NO) field.';
                }
                field("Sales Shipment No. (DK)"; Rec."Sales Shipment No. (DK)")
                {
                    ToolTip = 'Specifies the value of the Sales Shipment No. (DK) field.';
                }
                field("Sales Ship Posting Date (DK)"; Rec."Sales Ship Posting Date (DK)")
                {
                    ToolTip = 'Specifies the value of the Sales Shipment Posting Date (DK) field.';
                }
            }
        }
    }

    var


    trigger OnInit()
    var
    begin
        FillTable(Rec);
    end;




    local procedure FillTable(var RecIICTrackingTmpSC: Record IICTrackingTmpSC)
    var
        SalesInvoiceHeaderNO: Record "Sales Invoice Header";
        SalesShipmentHeaderNO: Record "Sales Shipment Header";
        SalesShipmentLineNO: Record "Sales Shipment Line";

        SalesInvoiceHeaderDK: Record "Sales Invoice Header";
        SalesShipmentHeaderDK: Record "Sales Shipment Header";
        SalesShipmentLineDK: Record "Sales Shipment Line";



        LineNo: Integer;
        CompanyNameNO: text[50];
        CompanyNameDK: text[50];
    begin
        CompanyNameNO := 'SCANPAN Norge';
        SalesInvoiceHeaderNO.ChangeCompany(CompanyNameNO);
        SalesShipmentHeaderNO.ChangeCompany(CompanyNameNO);
        SalesShipmentLineNO.ChangeCompany(CompanyNameNO);

        CompanyNameDK := 'SCANPAN Danmark';
        SalesInvoiceHeaderDK.ChangeCompany(CompanyNameDK);
        SalesShipmentHeaderDK.ChangeCompany(CompanyNameDK);
        SalesShipmentLineDK.ChangeCompany(CompanyNameDK);

        SalesInvoiceHeaderNO.SetAscending("No.", false);
        SalesInvoiceHeaderNO.FindSet();
        repeat
            SalesShipmentHeaderNO.SetFilter("Order No.", SalesInvoiceHeaderNO."Order No.");
            SalesShipmentHeaderNO.FindSet();
            repeat
                RecIICTrackingTmpSC.Init();
                LineNo += 1;
                RecIICTrackingTmpSC."Line No." := LineNo;
                RecIICTrackingTmpSC.Company := CopyStr(SalesInvoiceHeaderNO.CurrentCompany, 1, 50);
                RecIICTrackingTmpSC."Invoice No." := SalesInvoiceHeaderNO."No.";
                RecIICTrackingTmpSC."Sell-to Customer No." := SalesInvoiceHeaderNO."Sell-to Customer No.";
                RecIICTrackingTmpSC."Sell-To Customer Name (NO)" := SalesInvoiceHeaderNO."Sell-to Customer Name";

                RecIICTrackingTmpSC."Sales Shipment No. (NO)" := SalesShipmentHeaderNO."No.";
                SalesShipmentLineNO.SetFilter("Document No.", SalesShipmentHeaderNO."No.");
                SalesShipmentLineNO.FindFirst();
                RecIICTrackingTmpSC."Purchase Order No." := SalesShipmentLineNO."Purchase Order No.";

                SalesShipmentHeaderDK.SetFilter("External Document No.", RecIICTrackingTmpSC."Purchase Order No.");
                if SalesShipmentHeaderDK.FindFirst() then begin
                    RecIICTrackingTmpSC."Sales Shipment No. (DK)" := SalesShipmentHeaderDK."No.";
                    RecIICTrackingTmpSC."Sales Ship Posting Date (DK)" := SalesShipmentHeaderDK."Posting Date";
                end;

                If RecIICTrackingTmpSC.Insert() then;
            until SalesShipmentHeaderNO.Next() = 0;
        until SalesInvoiceHeaderNO.Next() = 0;
        If RecIICTrackingTmpSC.FindFirst() then;
    end;
}
