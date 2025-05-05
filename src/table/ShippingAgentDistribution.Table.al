table 50026 "ShippingAgentDistribution"
{
    /// <summary>
    /// 2024.10 Jesper Harder 092 Add FilterFields on Invoice Pick Posted Sales Shipments TrackAndTrace on SalesInvoiceLines, page to handle Dachser dispatch PostNo series 
    /// </summary>

    Caption = 'Shipping Agent Distribution Center';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Shipping Agent Code"; Code[20]) // Primary key part 1
        {
            Caption = 'Shipping Agent Code';
            DataClassification = ToBeClassified;

            // TableRelation to bind this field to "Shipping Agent"."Code"
            TableRelation = "Shipping Agent".Code;
        }
        field(2; "Code"; Code[20]) // Primary key part 2
        {
            Caption = 'Distribution Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Country Code"; Code[10]) // Primary key part 3
        {
            Caption = 'Country Code';
            DataClassification = ToBeClassified;

            // TableRelation to bind this field to "Country/Region"."Code"
            TableRelation = "Country/Region".Code;
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; Range; Text[100])
        {
            Caption = 'Range';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                StartValue: Integer;
                EndValue: Integer;
                SeparatorPos: Integer;
                StartText: Text;
                EndText: Text;
                TextInvalidFormatLbl: Label 'Invalid range format. Use a single number or the syntax "start..end", e.g., "1000" or "1000..2000".';
                TextInvalidStartLbl: Label 'Invalid start value in the range. Please enter a valid integer.';
                TextInvalidEndLbl: Label 'Invalid end value in the range. Please enter a valid integer.';
                TextInvalidOrderLbl: Label 'The start value must be less than the end value in the range.';
            begin
                SeparatorPos := StrPos(Range, '..');

                if SeparatorPos = 0 then begin
                    // Single number case
                    if not Evaluate(StartValue, Range) then
                        Error(TextInvalidFormatLbl);
                end else begin
                    // Range case with 'start..end' format
                    StartText := CopyStr(Range, 1, SeparatorPos - 1);
                    EndText := CopyStr(Range, SeparatorPos + 2);

                    // Validate start and end as integers
                    if not Evaluate(StartValue, StartText) then
                        Error(TextInvalidStartLbl);

                    if not Evaluate(EndValue, EndText) then
                        Error(TextInvalidEndLbl);

                    // Ensure start is less than end
                    if StartValue >= EndValue then
                        Error(TextInvalidOrderLbl);
                end;
            end;
        }
    }

    keys
    {
        // Composite primary key using "Shipping Agent Code", "Code", "Country Code", and "Range"
        key(PK; "Shipping Agent Code", "Code", "Country Code", Range)
        {
            Clustered = true;
        }
    }
}
