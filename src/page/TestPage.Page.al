


/// <summary>
/// Page TestDateTool (ID 50023).
/// </summary>
page 50023 "TestPage"
{

    AdditionalSearchTerms = 'Scanpan';
    Caption = 'Testpage';
    UsageCategory = None;

    trigger OnOpenPage()
    begin
        TestCU.DeleteFullyInvoicedPurchaseOrders();
        //error('stop');

        //testingAscii();
    end;

    var

        TestCU: Codeunit TEST_CU;
        VATVIESDeclarationTaxAuth: Report "VAT- VIES Declaration Tax Auth"; //19;


    local procedure testingAscii()
    var
        StringConversionManagement: Codeunit StringConversionManagement;
        //cc: Codeunit contini
        GetReceiptLines: page "Get Receipt Lines";
        myText: text;
        myNewText: Text;
    begin
        myText := 'Meidän tilinumero   ';
        myNewText := StringConversionManagement.WindowsToASCII(myText);
        Message(myNewText);
    end;




}