page 50043 ClaimProductUsageLookup
{
    PageType = List;
    SourceTable = "NOTO Item Categories";
    ApplicationArea = All;
    Caption = 'Claim Product Usage Lookup';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting(Code) where("Category Code" = const(ProductUsage));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CategoryCode; Rec."Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Category Code';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Product Usage';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
