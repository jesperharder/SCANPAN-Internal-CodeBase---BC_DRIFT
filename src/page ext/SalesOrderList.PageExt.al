

pageextension 50011 "SalesOrderList" extends "Sales Order List"
{
    /// <summary>
    /// PageExtension SalesOrderList (ID 50011) extends Record Sales Order List.
    /// </summary>
    /// <remarks>
    /// 
    /// Version list
    /// 2022.12             Jesper Harder       0193        Added modifications
    /// 2023.03.23          Jesper Harder       013         Display DropShip Purchase Order No. On Sales Order List
    /// 2023.05.11          Jesper Harder       013         Display DropShip changed to customer 1916
    /// 2023.06.12          Jesper Harder       033         Warning ITI IIC Status Code
    /// 2024.12             Jesper Harder       103         Added field Ship-to City to SalesOrderList
    /// 
    /// </remarks>

    layout
    {
        //013
        addlast(Control1) { field("Drop Shipment Order No."; Rec."Drop Shipment Order No.") { Visible = true; ApplicationArea = All; ToolTip = 'Specifies the value of the Drop Shipment Order No. field.'; } }
        addafter("Sell-to Customer Name") { field("Old Customer No.1"; Rec."Old Customer No.") { ApplicationArea = All; ToolTip = 'Specifies the value of the Alternative Customer No. field.'; } }
        addafter("External Document No.") { field("Your Reference1"; Rec."Your Reference") { ApplicationArea = All; ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.'; } }

        // 103
        addafter("External Document No.") { field("Ship-to City"; Rec."Ship-to City") { ApplicationArea = All; ToolTip = 'Specifies the city of the shipping address.'; } }

        // 0193
        modify("Bill-to Name") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Document Date") { Visible = false; }
        modify("Amt. Ship. Not Inv. (LCY)") { Visible = false; }
        modify("Amt. Ship. Not Inv. (LCY) Base") { Visible = false; }
        modify("Amount Including VAT") { Visible = false; }
        modify(Amount) { Visible = false; }
        modify("ITI IIC Created By") { Visible = false; }
        modify("Completely Shipped") { Visible = false; }

        // 0193
        modify("Requested Delivery Date") { Visible = true; }

        // 0193
        moveafter("Your Reference1"; "Requested Delivery Date")

    }

    views
    {
        addfirst
        {
            view(WebOrders)
            {
                Caption = 'Show Web orders';
                OrderBy = Descending("No.");
                Filters = where("No." = filter('W*'));
            }
            view(HideWebOrders)
            {
                Caption = 'Hide Web orders';
                OrderBy = Descending("No.");
                Filters = where("No." = filter('<>W*'));
            }
            view(EDIorders)
            {
                Caption = 'Show EDI orders';
                OrderBy = Descending("No.");
                Filters = where(TRCUDF10 = filter('EDI'));
            }
            view(DropShip)
            {
                Caption = 'Show DropShip orders';
                OrderBy = Descending("No.");
                Filters = where("Sell-to Customer No." = filter('2112'));
            }
            view(ScanpanNorge)
            {
                Caption = 'Show Scanpan Norge orders';
                OrderBy = descending("No.");
                Filters = where("Sell-to Customer No." = filter('1010|8245'));
            }

        }
    }



    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        Rec.FindFirst();
    end;

    //033
    //too much nagging

}



