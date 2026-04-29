table 50028 ClaimReturnReasonTranslation
{
    Caption = 'Claim Return Reason Translation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ReturnReasonCode; Code[10])
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
        field(10; LanguageCode; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = CustomerContent;
            TableRelation = Language.Code where(Code = filter('ENG | DAN | NOR | DEU | FRA'));

            trigger OnValidate()
            begin
                LanguageCode := UpperCase(LanguageCode);
                if LanguageCode = '' then
                    Error('Language Code must not be blank.');

                if not IsSupportedClaimsLanguage(LanguageCode) then
                    Error('Language Code must be one of ENG, DAN, NOR, DEU or FRA.');
            end;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Description = '' then
                    Error('Description must not be blank.');
            end;
        }
        field(30; ReturnReasonBaseDescription; Text[100])
        {
            Caption = 'Return Reason Base Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Return Reason".Description where(Code = field(ReturnReasonCode)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; ReturnReasonCode, LanguageCode)
        {
            Clustered = true;
        }
    }

    local procedure IsSupportedClaimsLanguage(LanguageCodeValue: Code[10]): Boolean
    begin
        case UpperCase(LanguageCodeValue) of
            'ENG', 'DAN', 'NOR', 'DEU', 'FRA':
                exit(true);
            else
                exit(false);
        end;
    end;
}
