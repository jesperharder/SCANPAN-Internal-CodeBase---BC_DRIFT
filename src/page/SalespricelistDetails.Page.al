/// <summary>
/// Page "SCANPAN_Salespricelist_Card" (ID 50011).
/// 2025.03             Jesper Harder       107.1       Salesprice Card
/// </summary>
page 50011 SalespricelistDetails
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = Basic, Suite;
    Caption = 'SCANPAN Salespricelist';
    PageType = Document;
    Permissions =
        tabledata Customer = R,
        tabledata "Customer Price Group" = R,
        tabledata "Gen. Product Posting Group" = R,
        tabledata "Item Category" = R,
        tabledata Language = R,
        tabledata "NOTO Item Categories" = R;
    RefreshOnActivate = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Selector1)
                {
                    Caption = 'Pricelists';

                    field(LanguageSelected; LanguageSelected)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item translation';
                        Importance = Standard;
                        TableRelation = Language.Code where(Code = filter('DEU|DAN|ENU|NOR|FIN|FRA|NLD|SVE|BEL'));
                        ToolTip = 'Selcect the translated Item language.';
                        trigger OnValidate()
                        var
                        begin
                            FillTempTable();
                        end;
                    }
                    field(CustomerPriceGroup; CustomerPriceGroup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Price Group';
                        Importance = Standard;
                        TableRelation = "Customer Price Group";
                        ToolTip = 'Selects the Customer Price Group for the Salesprice List';

                        trigger OnValidate()
                        var
                        begin
                            CustomerPriceGroup := CustomerPriceGroupGet(CustomerPriceGroup);
                            FillTempTable();
                        end;
                    }
                    field(ItemInSortiment; ItemInSortiment)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Items In Sortiment';
                        Importance = Additional;
                        ToolTip = 'Shows Items in sortiment.';
                        trigger OnValidate()
                        begin
                            FillTempTable();
                        end;
                    }
                }
                group(Selector2)
                {
                    Caption = 'Filters';

                    field(GenProdPostingGroup; GenProdPostingGroup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Product Posting Group';
                        Importance = Additional;
                        TableRelation = "Gen. Product Posting Group".Code where(Code = filter('INTERN|EKSTERN|BRUND'));
                        ToolTip = 'Sets filter on Gen. Product Posting Group.';
                        trigger OnValidate()
                        begin
                            FillTempTable();
                        end;
                    }
                    field(ItemProductLineCode; ItemProductLineCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Product Categories';
                        Importance = Additional;
                        TableRelation = "NOTO Item Categories".Code where("Category Code" = filter('ProductLineCode'));
                        ToolTip = 'Sets filter on Item Product Categories';
                        trigger OnValidate()
                        begin
                            FillTempTable();
                        end;
                    }
                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Category Code';
                        Importance = Additional;
                        TableRelation = "Item Category".Code;
                        ToolTip = 'Sets filter on Item Category Code';
                    }
                    field(ItemUnitsFilter; ItemUnitsFilter)
                    {
                        Caption = 'Units Filter';
                        Editable = true;
                        TableRelation = "Unit of Measure";
                        ToolTip = 'Specifies the value of the Unit of Measure Filter field.';
                        trigger OnValidate()
                        var
                        begin
                            FillTempTable();
                        end;
                    }

                }
            }
            group("CustomerItems")
            {
                Caption = 'Customer Items';

                group("CustomerItemNo")
                {
                    Caption = 'Customer Item No.';

                    /*
                     field(oVat; oVat)
                     {
                         Caption = 'Select VAT type';
                         OptionCaption = 'Manually type VAT,Zero VAT,Austria,Finland,Denmark,Norway';
                         ToolTip = 'Choose the VAT percentage to be used in report price calculations';
                         ApplicationArea = Basic, Suite;

                         trigger OnValidate()
                         var
                         begin
                             tVat := '';
                             case oVat of
                                 0: //Selvvalgt
                                     tVat := '0';
                                 1: //Ingen moms
                                     tVat := '0';
                                 2: //Østrig
                                     tVat := '20';
                                 3: //Finland
                                     tVat := '23';
                                 4: //Danmark
                                     tVat := '25';
                                 5: //Norge
                                     tVat := '25';
                             end;
                             Evaluate(dvat, tVat);
                         end;
                     }
                     field(tVat; tVat)
                     {
                         Caption = 'VAT percentage';
                         ToolTip = 'Type VAT or validate the VAT percentage.';

                         trigger OnValidate()
                         var
                         begin
                             Evaluate(dVat, tVat);
                         end;
                     }
                     */
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer';
                        Importance = Standard;
                        TableRelation = Customer."No.";
                        ToolTip = 'If selected, show Customer Item number.';

                        trigger OnValidate()
                        var
                        begin
                            CustomerName := CopyStr(CustomerGet(), 1, 20);
                            if CustomerNo <> '' then FillTempTable();
                        end;
                    }
                    field(CustomerName; CustomerName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Name';
                        Enabled = false;
                        Importance = Additional;
                        ToolTip = 'Shows the selected customer name.';
                    }
                }
            }
            group("PricelistLines")
            {
                Caption = 'Pricelist Lines';

                part(SalespricelistLines; SalespricelistDetailsSubPage)
                {
                    ApplicationArea = Basic, Suite;
                    UpdatePropagation = Both;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Lines")
            {
                Caption = 'Update Lines';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Refreshes the pricelist lines.';
                trigger OnAction()
                begin
                    UpdateSubPage();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ItemInSortiment := true;
    end;

    var
        //TABLES
        Customers: Record Customer;
        CustomerPriceGroups: Record "Customer Price Group";

        ItemInSortiment: Boolean;

        CustomerNo: code[20];
        CustomerPriceGroup: Code[20];
        GenProdPostingGroup, ItemCategoryCode, ItemProductLineCode : Code[20];
        LanguageSelected: Code[20];

        CustomerName: Text[120];
        ItemUnitsFilter: code[50];

    local procedure CustomerGet(): Text;
    var
    begin
        Customers.Reset();
        If Customers.Get(CustomerNo) then begin
            CustomerPriceGroup := Customers."Customer Price Group";
            Exit(Customers.Name);
        end;
    end;

    local procedure CustomerPriceGroupGet(MyCustomerPriceGroup: Code[20]): code[20]
    var
    begin
        CustomerPriceGroups.Reset();
        if CustomerPriceGroups.Get(MyCustomerPriceGroup) then
            exit(CustomerPriceGroups.Code);
    end;

    local procedure FillTempTable()
    begin
        if (CustomerPriceGroup <> '') and (LanguageSelected <> '') then
            CurrPage.SalespricelistLines.Page.FillTempTable(
                                                                CustomerPriceGroup,
                                                                GenProdPostingGroup,
                                                                ItemProductLineCode,
                                                                LanguageSelected,
                                                                ItemInSortiment,
                                                                CustomerNo,
                                                                ItemUnitsFilter);
    end;

    local procedure UpdateSubPage()
    begin
        FillTempTable();
    end;
}
