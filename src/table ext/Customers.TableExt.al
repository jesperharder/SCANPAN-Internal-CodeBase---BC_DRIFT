



/// <summary>
/// TableExtension "SCANPAN_Customer" (ID 50004) extends Record Customer.
/// 
/// 2023.01.23          Jesper Harder       0193        Extends Customer table with lookup to Bank, to be used in bank-address information on printouts
/// 2023.01.27          Jesper Harder       0193        Extends Customer table with Claims Code + User
/// 2023.11             Jesper Harder       059         PO Number City, break lookup for Web Customers
/// 2024.09             Jesper Harder       080         Self-insured limit check with warning on sales order.
/// 2024.10             Jesper Harder       090         Field for Claims, allow reporting quantity
/// 
/// </summary>
tableextension 50004 "Customers" extends Customer
{
    fields
    {
        field(50000; Bank; Code[20])
        {
            Caption = 'Bank';
            DataClassification = AccountData;
            TableRelation = "Bank Account";
        }
        field(50001; ClaimsCode; code[20])
        {
            Caption = 'Claims Code';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50002; ClaimsUser; code[20])
        {
            Caption = 'Claims User';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50003; UseSalesNoSeries; code[20])
        {
            Caption = 'Use alternative Sales Order No.Series';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
        field(50004; "ShowCountryCode"; boolean)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Reserved for future use.';
            Caption = 'Show Country Code on Invoice';
            DataClassification = SystemMetadata;
        }
        field(50005; "Self-Insured (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Self-Insured Limit (LCY)';
        }

        // 090
        field(50006; "Allow Claims Quantity"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow Claims Quantity';
        }
    }
}
