



tableextension 50021 "CDO E-Mail Recipient" extends "CDO E-Mail Recipient"
{

    fields
    {
        field(50000; "Customer Name"; text[100])
        {
            Caption = 'Customer Name';

            FieldClass = FlowField;
            CalcFormula = lookup(
                Customer.Name where("No." = field("No.")));
        }
        field(50001; "Customer Country/Region Code"; code[20])
        {
            Caption = 'Customer Country/Region Code';
            FieldClass = FlowField;
            CalcFormula = lookup(
                    Customer."Country/Region Code" where("No." = field("No.")));
        }
        field(50002; "Customer SalesPerson"; code[20])
        {
            Caption = 'Customer SalesPerson Code';
            FieldClass = FlowField;
            CalcFormula = lookup(
                    Customer."Salesperson Code" where("No." = field("No.")));
        }
    }
}