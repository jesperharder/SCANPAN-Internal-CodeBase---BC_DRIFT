table 50030 "Prod. Dashboard User Pref."
{
    Caption = 'Production Dashboard User Preference';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(3; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            DataClassification = SystemMetadata;
        }
        field(10; "User ID"; Text[250])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(20; "Use Current Date"; Boolean)
        {
            Caption = 'Use Current Date';
            DataClassification = CustomerContent;
        }
        field(21; "Date Filter"; Text[2048])
        {
            Caption = 'Date Filter';
            DataClassification = CustomerContent;
        }
        field(22; "Period Type"; Enum "PeriodType")
        {
            Caption = 'Period Type';
            DataClassification = CustomerContent;
        }
        field(23; "Period Length"; Integer)
        {
            Caption = 'Period Length';
            DataClassification = CustomerContent;
        }
        field(24; "Production Date Selection"; Enum EnumProductionDateSelection)
        {
            Caption = 'Production Date Selection';
            DataClassification = CustomerContent;
        }
        field(30; "Chart Type"; Enum "Business Chart Type")
        {
            Caption = 'Chart Type';
            DataClassification = CustomerContent;
        }
        field(31; "Chart Data Type"; Enum EnumChartDataType)
        {
            Caption = 'Chart Data Type';
            DataClassification = CustomerContent;
        }
        field(32; "Combined Chart"; Boolean)
        {
            Caption = 'Combined Chart';
            DataClassification = CustomerContent;
        }
        field(40; Simulated; Boolean)
        {
            Caption = 'Simulated';
            DataClassification = CustomerContent;
        }
        field(41; Planned; Boolean)
        {
            Caption = 'Planned';
            DataClassification = CustomerContent;
        }
        field(42; "Firm Planned"; Boolean)
        {
            Caption = 'Firm Planned';
            DataClassification = CustomerContent;
        }
        field(43; Released; Boolean)
        {
            Caption = 'Released';
            DataClassification = CustomerContent;
        }
        field(44; Finished; Boolean)
        {
            Caption = 'Finished';
            DataClassification = CustomerContent;
        }
        field(100; "Visible Foundry"; Boolean)
        {
            Caption = 'Visible Foundry';
            DataClassification = CustomerContent;
        }
        field(101; "Visible All Presses"; Boolean)
        {
            Caption = 'Visible All Presses';
            DataClassification = CustomerContent;
        }
        field(102; "Visible Press 1"; Boolean)
        {
            Caption = 'Visible Press 1';
            DataClassification = CustomerContent;
        }
        field(103; "Visible Press 2"; Boolean)
        {
            Caption = 'Visible Press 2';
            DataClassification = CustomerContent;
        }
        field(104; "Visible Press 3"; Boolean)
        {
            Caption = 'Visible Press 3';
            DataClassification = CustomerContent;
        }
        field(105; "Visible Press 4"; Boolean)
        {
            Caption = 'Visible Press 4';
            DataClassification = CustomerContent;
        }
        field(106; "Visible Press 5"; Boolean)
        {
            Caption = 'Visible Press 5';
            DataClassification = CustomerContent;
        }
        field(107; "Visible Press 6"; Boolean)
        {
            Caption = 'Visible Press 6';
            DataClassification = CustomerContent;
        }
        field(108; "Visible Press 7"; Boolean)
        {
            Caption = 'Visible Press 7';
            DataClassification = CustomerContent;
        }
        field(109; "Visible Press 8"; Boolean)
        {
            Caption = 'Visible Press 8';
            DataClassification = CustomerContent;
        }
        field(120; "Visible Processing"; Boolean)
        {
            Caption = 'Visible Processing';
            DataClassification = CustomerContent;
        }
        field(121; "Visible Coating 1"; Boolean)
        {
            Caption = 'Visible Coating 1';
            DataClassification = CustomerContent;
        }
        field(122; "Visible Coating 2"; Boolean)
        {
            Caption = 'Visible Coating 2';
            DataClassification = CustomerContent;
        }
        field(123; "Visible Lathe 1"; Boolean)
        {
            Caption = 'Visible Lathe 1';
            DataClassification = CustomerContent;
        }
        field(124; "Visible Lathe 2"; Boolean)
        {
            Caption = 'Visible Lathe 2';
            DataClassification = CustomerContent;
        }
        field(125; "Visible Lathe 3"; Boolean)
        {
            Caption = 'Visible Lathe 3';
            DataClassification = CustomerContent;
        }
        field(126; "Visible Polishing"; Boolean)
        {
            Caption = 'Visible Polishing';
            DataClassification = CustomerContent;
        }
        field(127; "Visible Scrubbing"; Boolean)
        {
            Caption = 'Visible Scrubbing';
            DataClassification = CustomerContent;
        }
        field(140; "Visible Packaging"; Boolean)
        {
            Caption = 'Visible Packaging';
            DataClassification = CustomerContent;
        }
        field(141; "Visible Packaging Chart"; Boolean)
        {
            Caption = 'Visible Packaging Chart';
            DataClassification = CustomerContent;
        }
        field(142; "Visible Installing Handle"; Boolean)
        {
            Caption = 'Visible Installing Handle';
            DataClassification = CustomerContent;
        }
        field(143; "Visible Riveting"; Boolean)
        {
            Caption = 'Visible Riveting';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "User Security ID", "Company Name", "Page ID")
        {
            Clustered = true;
        }
    }
}
