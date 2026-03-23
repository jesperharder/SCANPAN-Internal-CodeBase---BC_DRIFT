table 50039 ClaimProductUsageReason
{
    Caption = 'Claim Product Usage Reason';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ProductUsage; Code[20])
        {
            Caption = 'Product Usage';
            DataClassification = CustomerContent;
            TableRelation = "NOTO Item Categories".Code where("Category Code" = const(ProductUsage));

            trigger OnValidate()
            begin
                if ProductUsage = '' then
                    Error('Product Usage must not be blank.');
            end;
        }
        field(10; ReturnReasonCode; Code[10])
        {
            Caption = 'Return Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Return Reason".Code;

            trigger OnValidate()
            begin
                if ReturnReasonCode = '' then
                    Error('Return Reason Code must not be blank.');
            end;
        }
        field(20; Sorting; Integer)
        {
            Caption = 'Sorting';
            DataClassification = CustomerContent;
        }
        field(30; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(40; ReturnReasonDescription; Text[100])
        {
            Caption = 'Return Reason Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Return Reason".Description where(Code = field(ReturnReasonCode)));
            Editable = false;
        }
        field(50; ProductUsageDescription; Text[100])
        {
            Caption = 'Product Usage Description';
            FieldClass = FlowField;
            CalcFormula = lookup("NOTO Item Categories".Description where(Code = field(ProductUsage), "Category Code" = const(ProductUsage)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; ProductUsage, ReturnReasonCode)
        {
            Clustered = true;
        }
        key(SortingKey; ProductUsage, Sorting, ReturnReasonCode)
        {
        }
    }
}
