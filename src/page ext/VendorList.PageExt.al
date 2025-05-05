


//From user adaptation
/// <summary>
/// PageExtension Vendor List (ID 50068) extends Record Vendor List.
/// </summary>
pageextension 50068 "Vendor List" extends "Vendor List"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Country/Region Code1"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the country/region of the address.';
            }
            field("Preferred Bank Account Code1"; Rec."Preferred Bank Account Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
            }
            field("Payment Method Code1"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
            }
        }

    }
}
