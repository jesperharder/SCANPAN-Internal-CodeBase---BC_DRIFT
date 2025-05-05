

///
/// 2024.05             Jesper Harder       067         Add fields to facilitate Datawarehouse fields
/// 
tableextension 50032 "CountryRegion" extends "Country/Region"
{
    fields
    {
        //067
        field(50000; "SalesMarket"; Code[20])
        {
            Caption = 'Sales Market';
            TableRelation = "Country/Region".Code;
        }
        field(50001; "Market Type"; Text[30])
        {
            Caption = 'Market Type (Removed)';
            ObsoleteState = Removed;
            ObsoleteReason = 'This field has been removed.';
        }
        field(50002; "Channel Type"; Text[30])
        {
            Caption = 'Channel Type (Removed)';
            ObsoleteState = Removed;
            ObsoleteReason = 'This field has been removed.';

        }

        field(50003; "Market Types"; enum CountryMarketType)
        {
            Caption = 'Market Type';
        }
        field(50004; "Channel Types"; enum CountrySalesChannelEnum)
        {
            Caption = 'Channel Type';
        }
    }
}