




pageextension 50119 "InvtReceipts" extends "Invt. Receipts"
{
    Caption = 'Inventory Reciepts (do not use)';

    trigger OnOpenPage()
    begin
        CurrPage.Close();
    end;
}