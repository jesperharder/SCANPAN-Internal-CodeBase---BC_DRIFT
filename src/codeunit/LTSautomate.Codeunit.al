/// <summary>
/// Codeunit LTSautomate (ID 50005).
/// </summary>
///
/// <remarks>
///
/// 2023.08             Jesper Harder               044     LTS Export Invoice Warehouse
///
/// </remarks>
codeunit 50005 LTSautomate
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ErrorTextLbl: Label 'This codeunit must run from Job Queue.';
        ErrorParameterLbl: Label 'Please specify Parameter String\IMPORT = Export all Purchase Invoices\EXPORT = Export new Sales Invoices to LTS and mark them sent.\WAREHOUSE = Export Warehouse status to LTS.';
    begin
        if Rec."Object ID to Run" = 0 then
            //running outside job queue
                Error(ErrorTextLbl)
        else
            //running from job queue
            //Parameter := CopyStr(rec."Parameter String", StrPos(Rec."Parameter String", ':') + 1, StrLen(rec."Parameter String"));
            case Rec."Parameter String" of
                'IMPORT':
                    ExportPurchaseInvoiceToLTS();
                'EXPORT':
                    ExportSalesInvoicesToLTS();
                'WAREHOUSE':
                    ExportWarehouseToLTS();
                else
                    Error(ErrorParameterLbl);
            end;
    end;

    local procedure ExportPurchaseInvoiceToLTS()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        NOTOLTSInboundExport: Report "NOTO LTS Inbound Export";
    begin
        PurchInvHeader.Reset();
        //LTSInboundExport.SetSkipTollSystemSentCheck();
        //PurchInvHeader.SetFilter("Posting Date", '12-07-2023..');

        //13.10.2023 
        //PurchInvHeader.SetFilter("Toll System Sent NOTO", '%1', false);
        PurchInvHeader.SetFilter("Toll System Checked", '%1', false);
        PurchInvHeader.SetFilter("Drop Shipment", '%1', false);
        //
        PurchInvHeader.SetAutoCalcFields("Drop Shipment");
        PurchInvHeader.FindSet();
        NOTOLTSInboundExport.SetTableView(PurchInvHeader);
        NOTOLTSInboundExport.Run();
    end;

    local procedure ExportSalesInvoicesToLTS()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        NOTOLTSOutboundExport: Report "NOTO LTS Outbound Export";
    begin
        SalesInvoiceHeader.Reset();

        //13.10.2023 
        //SalesInvoiceHeader.SetFilter("Toll System Sent NOTO", '%1', false);
        SalesInvoiceHeader.SetFilter("Toll System Checked", '%1', false);
        SalesInvoiceHeader.SetFilter("Drop Shipment", '%1', false);
        //
        SalesInvoiceHeader.SetAutoCalcFields("Drop Shipment");
        SalesInvoiceHeader.FindSet();
        //LTSOutboundExport.SetSkipTollSystemSentCheck();
        NOTOLTSOutboundExport.SetTableView(SalesInvoiceHeader);
        NOTOLTSOutboundExport.Run();
    end;

    local procedure ExportWarehouseToLTS()
    var
        Location: Record Location;
        NOTOLTSWarehouseExport: Report "NOTO LTS Warehouse Export";
    begin
        Location.Reset();
        Location.SetRange("LTS Export NOTO", true);
        NOTOLTSWarehouseExport.SetTableView(Location);
        NOTOLTSWarehouseExport.Run();
    end;
}