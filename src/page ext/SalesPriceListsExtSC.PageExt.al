


/// <summary>
/// PageExtension "SalesPriceListsExtSC" (ID 50030) extends Record Sales Price Lists.
/// </summary>
/// 
/// <remarks>
/// 2023.1              Jesper Harder               0193                      Extends page - Adds saved filter 'ActiveSalesPriceLists'
/// </remarks>

pageextension 50030 SalesPriceListsExtSC extends "Sales Price Lists"
{
    layout
    {
        addfirst(Control1)
        {
            field(Code1; Rec.Code)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unique identifier of the price list.';
            }
        }


    }
    actions
    {
        addlast(Processing)
        {
            group("SCANPAN")
            {
                Caption = 'Scanpan';
                ToolTip = 'Added Scanpan functions.';
                action("Salespricelist output")
                {
                    Caption = 'Salespricelist Output';
                    ToolTip = 'Create Salespricelist output based on filters.';
                    ApplicationArea = Basic, Suite;
                    Image = "Report";
                    RunObject = page "SalespricelistDetails";
                }
                action("Pricelist Item Source Data")
                {
                    Caption = 'WebService Pricelist Source Data';
                    ToolTip = 'Base for extracting Item Data to external calculation.';
                    ApplicationArea = Basic, Suite;
                    Image = PriceAdjustment;
                    RunObject = page "WebServiceSalesPriceListSource";
                }

            }
        }
    }
    views
    {
        addfirst
        {
            view(ActiveSalesPriceLists)
            {
                Caption = 'Active Sales Price Lists';
                OrderBy = ascending("Starting Date");
                Filters = where("Ending Date" = filter('>d|'''''), "Starting Date" = filter('<d'), "Amount Type" = filter('Pris'));
                Visible = true;
            }
        }

    }

    /*
        trigger OnOpenPage()
        var
            UserPersonalization: Record "User Personalization";
        begin
            UserPersonalization.Get(UserSecurityId());

            If UserPersonalization."Profile ID" = '_SALG' then begin
                //Rec.SetCurrentKey("Ending Date");
                Rec.SetFilter("Starting Date", '<%1', Today);
                Rec.SetFilter(Rec."Ending Date", '>%1|%2', Today, 0D);
                Rec.SetRange(Rec."Amount Type", Rec."Amount Type"::Price);

                Rec.FindFirst();
            end;
        end;
    */
}
