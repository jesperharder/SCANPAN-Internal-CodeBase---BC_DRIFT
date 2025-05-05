/// <summary>
/// TableExtension "SCANPAN_SalesLine" (ID 50002) extends Record Sales Line.
/// </summary>
///
/// <remarks>
///
/// 2023.01             Jesper Harder       0193        Added flowfield for ItemBarCode
/// 2023.03             Jesper Harder       004         Added flowfield for ABCD Category
/// 2023.03             Jesper Harder       015         Added Flowfield Tariff - SalesLine 27.3.2023
/// 2024.09             Jesper Harder       079         Show Alternative Delivery Address on Sales Orders page, item,reference,sales orders
///
/// </remarks>
tableextension 50002 "SalesLine" extends "Sales Line"
{
    fields
    {
        field(50000; "Item Cross-Reference No."; Code[50])
        {
            Description = 'Used to display Item Barcode Reference.';
            Caption = 'Item Cross-Reference No.';

            CalcFormula = lookup("Item Reference"."Reference No."
                                 where(
                                        "Item No." = field("No."),
                                        "Unit of Measure" = field("Unit of Measure Code"),
                                        "Reference Type" = const("Bar Code")));
            Editable = false;
            FieldClass = FlowField;
        }

        //Used in ExtSalesPerson
        field(50001; "Salesperson Code"; Code[20])
        {
            Description = 'Used in Ext Salesperson function';
            FieldClass = FlowField;
            Caption = 'Salesperson Code';
            CalcFormula = lookup(
                Customer."Salesperson Code" where("No." = field("Sell-to Customer No.")));
        }

        //Used in ExtSalesPerson
        field(50002; "Sell-To Customer Name"; Text[100])
        {
            Description = 'Used in Ext Salesperson function';
            FieldClass = FlowField;
            Caption = 'Sell-To Customer Name';
            CalcFormula = lookup(
                "Sales Header"."Sell-to Customer Name" where("Document Type" = field("Document Type"),
                                                             "No." = field("Document No.")));
        }

        //004
        field(50003; "ABCD Category"; code[20])
        {
            Description = '004 Used in sales line';
            FieldClass = FlowField;
            Caption = 'ABCD Category';
            CalcFormula = lookup(
                Item."ABCD Category" where("No." = field("No.")));
        }
        //015
        field(50004; "Tariff No."; code[20])
        {
            Description = '015 Used in sales/invoice linje';
            FieldClass = FlowField;
            Caption = 'Tariff No.';
            CalcFormula = lookup(
                    Item."Tariff No." where("No." = field("No.")));
            TableRelation = "Tariff Number"."No.";
        }
        field(50005; "Ship-to Code"; Text[100])
        {
            Description = 'Ship-to Code';
            FieldClass = FlowField;
            Caption = 'Ship-to Code';
            CalcFormula = lookup(
                "Sales Header"."Ship-to Code" where("Document Type" = field("Document Type"),
                                                             "No." = field("Document No.")));
        }
        field(50006; "Ship-to Name"; Text[100])
        {
            Description = 'Ship-to Name';
            FieldClass = FlowField;
            Caption = 'Ship-to Name';
            CalcFormula = lookup(
                "Sales Header"."Ship-to Name" where("Document Type" = field("Document Type"),
                                                             "No." = field("Document No.")));
        }
    }
    var
}