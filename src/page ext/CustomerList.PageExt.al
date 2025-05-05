

/// <summary>
/// PageExtension CustomerListExtSC (ID 50010) extends Record Customer List.
/// </summary>
/// 
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2022.12             Jesper Harder       0193        Name Visible True
/// </remarks>
pageextension 50010 "CustomerList" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("Country/Region Code1"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country/Region Code field.';
            }
        }

        modify("Name") { Visible = true; }
        modify("Name 2") { Visible = false; }
        moveafter(Name; "Old Customer No.")
        addafter("Name") { field("Search Name1"; Rec."Search Name") { ApplicationArea = All; ToolTip = 'Specifies an alternate name that you can use to search for a customer.'; } }

        addlast(Control1) { field(ClaimsUser; Rec.ClaimsUser) { ApplicationArea = All; ToolTip = 'Specifies the Claims Username used in Claims Web application.'; } }
        addlast(Control1) { field(ClaimsCode; Rec.ClaimsCode) { ApplicationArea = All; ToolTip = 'Specifies the Claims Code used in Claims Web application.'; } }
        //moveafter("No."; "Name 239160")
    }
    actions
    {
        addafter(Create)
        {
            action(EUVATXMLPORT)
            {
                Caption = 'EU VAT Export';
                Promoted = true;
                PromotedCategory = Process;
                Image = Export;
                ApplicationArea = All;
                ToolTip = 'Executes the EU VAT Export action.';
                trigger OnAction()
                begin
                    Xmlport.Run(50001, true, false)
                end;
            }
        }
    }
}


