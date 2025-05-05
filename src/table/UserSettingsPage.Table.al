

 

table 50022 "UserSettingsPage"
{
    /// <summary>
    /// Table UserSetupPages (ID 50022).
    /// </summary>
    /// <remarks>
    /// 2023.11             Jesper Harder       057         Page Part - Graphs sorting parts
    /// 2024.11             Jesper Harder       095         Look up production orders from Chart Dashboard
    /// </remarks>


    Caption = 'User Save Settings';
    DataClassification = ToBeClassified;

    Permissions = tabledata "UserSettingsPage" = rimd;

    fields
    {
        field(1; "UserID"; text[250])
        {

        }
        field(2; "PageID"; Text[50])
        {

        }
        field(20; "Text50_1"; Text[50])
        {

        }
        field(21; "Text50_2"; text[2048])
        {

        }
        field(22; "Text50_3"; Text[50])
        {

        }
        field(30; "Boolean_1"; boolean)
        {

        }
        field(40; "Integer_1"; Integer)
        {

        }
        field(41; "Integer_2"; Integer)
        {

        }
        field(42; "Simulated"; boolean)
        { }
        field(43; "Planned"; boolean)
        { }
        field(44; "Firm Planned"; boolean)
        { }
        field(45; "Released"; boolean)
        { }
        field(46; "Finished"; boolean)
        { }
        field(47; ProductionDateSelection; Enum EnumProductionDateSelection)
        { }

        field(100; "EnumPeriodFormat"; Enum "PeriodType")
        {

        }
        field(101; "EnumChartDataType"; Enum EnumChartDataType)
        { }
        field(102; "EnumBusinessChartType"; enum "Business Chart Type")
        { }

        field(200; "ChartVisibilityAll"; Boolean)
        { }
        field(201; "ChartVisibility1"; Boolean)
        { }
        field(202; "ChartVisibility2"; Boolean)
        { }
        field(203; "ChartVisibility3"; Boolean)
        { }
        field(204; "ChartVisibility4"; Boolean)
        { }
        field(205; "ChartVisibility5"; Boolean)
        { }
        field(206; "ChartVisibility6"; Boolean)
        { }
        field(207; "ChartVisibility7"; Boolean)
        { }
        field(208; "ChartVisibility8"; Boolean)
        { }
        field(209; "VisibleFoundry"; Boolean)
        { }


        field(210; "Visible09"; Boolean)
        { }
        field(211; "Visible15"; Boolean)
        { }
        field(212; "Visible10"; Boolean)
        { }
        field(213; "Visible16"; Boolean)
        { }
        field(214; "Visible18"; Boolean)
        { }
        field(215; "Visible25"; Boolean)
        { }
        field(216; "Visible27"; Boolean)
        { }
        field(217; "VisiblePA"; Boolean)
        { }
        field(218; "VisibleSK"; Boolean)
        { }
        field(219; "VisibleNI"; Boolean)
        { }
        field(220; "VisibleProcessing"; Boolean)
        { }
        field(221; "VisiblePackaging"; Boolean)
        { }
    }

    keys
    {
        key(PK; UserID)
        {
            Clustered = true;
        }
        key(Key1; PageID)
        {

        }
    }
}